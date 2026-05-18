#!/bin/bash
# ThinkPad X230 fan control setup using thinkfan.
# Supports Arch (AUR via paru), Fedora (dnf), Ubuntu (apt).
# Safe to rerun — stops existing service, backs up old config.

set -e

# ── Stop existing thinkfan ───────────────────────────────────────────────────
# Needed on rerun: thinkfan holds /proc/acpi/ibm/fan open while running,
# which would cause the config write to race with the active daemon.

stop_thinkfan() {
  if systemctl is-active --quiet thinkfan; then
    echo "Stopping running thinkfan service..."
    sudo systemctl stop thinkfan
  fi
}

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
# thinkfan is in AUR on Arch (not in official repos), standard repos on Fedora/Ubuntu.

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

# ── Enable thinkpad_acpi fan control ──────────────────────────────────────────
# By default thinkpad_acpi loads with fan_control=0, making /proc/acpi/ibm/fan
# read-only. Writing the modprobe option and reloading the module unlocks it.
# If rmmod fails (module busy), a reboot is needed to apply the option.

setup_modprobe() {
  echo "Enabling thinkpad_acpi fan control..."
  echo "options thinkpad_acpi fan_control=1" \
    | sudo tee /etc/modprobe.d/thinkpad_acpi.conf > /dev/null

  if sudo rmmod thinkpad_acpi 2>/dev/null && sudo modprobe thinkpad_acpi; then
    echo "thinkpad_acpi reloaded."
  else
    echo "Could not reload thinkpad_acpi (module in use). Reboot for fan control to activate."
  fi
}

# ── Find coretemp hwmon path ──────────────────────────────────────────────────
# The X230 exposes CPU core temps via coretemp at a sysfs hwmon path.
# The hwmon index (hwmon0, hwmon1, …) is assigned at boot and can vary,
# so we resolve it at runtime instead of hardcoding it.

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
# Uses YAML format (thinkfan 1.x+). Each level entry is [fan_level, low_temp, high_temp].
# Overlapping low/high bounds between adjacent levels create hysteresis — the fan
# won't switch back down until temp drops well below the point it switched up,
# preventing rapid oscillation around a threshold.

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
    indices: [1, 2, 3]  # CPU package + core temps

fans:
  - tpacpi: /proc/acpi/ibm/fan

# Silent curve for ThinkPad X230.
# Fan levels 0–7 map to the firmware speed steps; 7 is maximum.
# Format: [level, low_°C, high_°C]
levels:
  - [0,  0,  60]   # off at idle
  - [1, 57,  65]
  - [2, 63,  70]
  - [3, 68,  75]
  - [4, 73,  80]
  - [5, 78,  85]
  - [7, 83, 32767]  # max from 83°C onwards
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

if [[ "$(uname)" == "Darwin" ]]; then
  echo "This script is for Linux only."
  exit 1
fi

OS=$(detect_os)

if [[ "$OS" == unsupported* ]]; then
  echo "Unsupported OS: ${OS#unsupported:}"
  echo "Supported: Arch, Fedora, Ubuntu"
  exit 1
fi

stop_thinkfan
install_thinkfan "$OS"
setup_modprobe

HWMON_PATH=$(find_hwmon_path)
echo "Found hwmon at: $HWMON_PATH"

write_config "$HWMON_PATH"
enable_service

echo ""
echo "Done! Fan curve active. Monitor with: cat /proc/acpi/ibm/fan"
