#!/bin/bash

set -e

# ── OS detection ──────────────────────────────────────────────────────────────

detect_os() {
  if [[ -f /etc/os-release ]]; then
    local id
    id=$(grep "^ID=" /etc/os-release | cut -d= -f2 | tr -d '"')
    case "$id" in
      arch)   echo "arch" ;;
      fedora) echo "fedora" ;;
      ubuntu) echo "ubuntu" ;;
      *)      echo "unsupported:$id" ;;
    esac
  else
    echo "unsupported"
  fi
}

# ── Install thinkfan ──────────────────────────────────────────────────────────

install_thinkfan() {
  if command -v thinkfan &>/dev/null; then
    echo "thinkfan already installed, skipping."
    return
  fi

  local os="$1"
  case "$os" in
    arch)
      if ! command -v paru &>/dev/null; then
        echo "paru not found. Install paru first (run install.sh) or install thinkfan manually from AUR."
        exit 1
      fi
      paru -S thinkfan
      ;;
    fedora)
      sudo dnf install -y thinkfan
      ;;
    ubuntu)
      sudo apt update
      sudo apt install -y thinkfan
      ;;
  esac
}

# ── Enable thinkpad_acpi fan control ─────────────────────────────────────────

setup_modprobe() {
  echo "Enabling thinkpad_acpi fan control..."
  echo "options thinkpad_acpi fan_control=1" \
    | sudo tee /etc/modprobe.d/thinkpad_acpi.conf > /dev/null

  # Reload module so the option takes effect without a reboot.
  # rmmod may fail if the module is in use — fall back to asking for reboot.
  if sudo rmmod thinkpad_acpi 2>/dev/null && sudo modprobe thinkpad_acpi; then
    echo "thinkpad_acpi reloaded."
  else
    echo "Could not reload thinkpad_acpi (module in use). Reboot for fan control to activate."
  fi
}

# ── Find coretemp hwmon path ──────────────────────────────────────────────────

find_hwmon_path() {
  local base="/sys/devices/platform/coretemp.0/hwmon"

  if [[ ! -d "$base" ]]; then
    echo "ERROR: $base not found. Is coretemp loaded? Try: sudo modprobe coretemp" >&2
    exit 1
  fi

  local path
  path=$(find "$base" -maxdepth 1 -name "hwmon*" -type d | head -1)

  if [[ -z "$path" ]]; then
    echo "ERROR: No hwmon entry found under $base." >&2
    exit 1
  fi

  echo "$path"
}

# ── Write thinkfan config ─────────────────────────────────────────────────────

write_config() {
  local hwmon_path="$1"
  local config="/etc/thinkfan.yaml"

  if [[ -f "$config" ]]; then
    echo "Backing up existing $config to $config.bak..."
    sudo cp "$config" "$config.bak"
  fi

  echo "Writing $config..."
  sudo tee "$config" > /dev/null <<EOF
sensors:
  - hwmon: $hwmon_path
    indices: [1, 2, 3]

fans:
  - tpacpi: /proc/acpi/ibm/fan

# Silent curve — fan off at idle, ramps slowly, safety auto above 83°C.
# Overlapping ranges are intentional: they add hysteresis to prevent
# the fan from oscillating when temperature hovers around a threshold.
levels:
  - [0,      0,  52]
  - [1,     50,  57]
  - [2,     55,  62]
  - [3,     60,  67]
  - [4,     65,  72]
  - [5,     70,  78]
  - [7,     75,  85]
  - ["auto", 83, 32767]
EOF
}

# ── Enable service ────────────────────────────────────────────────────────────

enable_service() {
  echo "Validating config (dry run)..."
  sudo thinkfan -n -c /etc/thinkfan.yaml || {
    echo "ERROR: thinkfan config validation failed. Check /etc/thinkfan.yaml." >&2
    exit 1
  }

  echo "Enabling and starting thinkfan service..."
  sudo systemctl enable --now thinkfan
  echo "Service status:"
  systemctl status thinkfan --no-pager
}

# ── Main ──────────────────────────────────────────────────────────────────────

OS=$(detect_os)

if [[ "$OS" == unsupported* ]]; then
  echo "Unsupported OS: ${OS#unsupported:}"
  echo "Supported: Arch, Fedora, Ubuntu"
  exit 1
fi

if [[ "$(uname)" == "Darwin" ]]; then
  echo "This script is for Linux only."
  exit 1
fi

install_thinkfan "$OS"
setup_modprobe

HWMON_PATH=$(find_hwmon_path)
echo "Found hwmon at: $HWMON_PATH"

write_config "$HWMON_PATH"
enable_service

echo ""
echo "Done! Fan curve active. Monitor with: cat /proc/acpi/ibm/fan"
