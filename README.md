# My automated dotfiles setup

## Requirements

### 1. JetBrainsMono Nerd Font

Required for icons and glyphs to render correctly across all terminal and editor configs.

> [!NOTE]
> If you use `install.sh`, the font is installed automatically. The commands below are for manual installation only.

**macOS:**

```bash
brew install --cask font-jetbrains-mono-nerd-font
```

**Linux:**

```bash
wget -O /tmp/JetBrainsMono.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
sudo mkdir -p /usr/share/fonts/JetBrainsNerdFont
sudo unzip /tmp/JetBrainsMono.zip -d /usr/share/fonts/JetBrainsNerdFont
sudo fc-cache -fv
```

### 2. Packages

Run `install.sh` — it detects your OS and installs everything automatically:

```bash
chmod +x install.sh
./install.sh
```

Supported systems and what the script uses:

| OS | Package manager | Notes |
|---|---|---|
| macOS | Homebrew | [`leaves/leaves.txt`](leaves/leaves.txt) |
| Arch Linux | pacman | [`leaves/packages-arch.txt`](leaves/packages-arch.txt) |
| Fedora | dnf | [`leaves/packages-fedora.txt`](leaves/packages-fedora.txt) |
| Ubuntu | apt | [`leaves/packages-ubuntu.txt`](leaves/packages-ubuntu.txt) |

On Fedora and Ubuntu, packages not available in official repos (starship, lazygit, eza, yazi) are installed automatically from their official release channels.

---

## Automated Setup

`setup.sh` backs up your existing config and symlinks everything using GNU Stow.

What it does:
- Backs up any existing files/directories in `~/.config/` that would conflict (renamed to `.bak`)
- Backs up zsh files in `$HOME` (`.zshrc`, `.zlogin`, `.zprofile`, `.zshenv`)
- Creates `~/.zshenv` with `ZDOTDIR=$HOME/.config/zsh`
- Generates platform-specific config files for Alacritty (window decorations) and Ghostty (titlebar style)
- Symlinks all config directories into `~/.config/` via `stow`

> [!CAUTION]
> Read the script before running it so you know what gets moved.

```bash
chmod +x setup.sh
./setup.sh
```

**Update symlinks** after adding new configs:

```bash
./setup.sh --restow
```

**Revert everything** and restore backups:

```bash
./setup.sh --unstow
```

To exclude a config from being symlinked, add `--ignore=<dirName>` to `.stowrc`.

---

## Manual Setup

### Step 1 — Clone the repo

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

### Step 2 — Install the font

See the [font section](#1-jetbrainsmono-nerd-font) above.

### Step 3 — Install packages

Either run `install.sh` (recommended) or install manually using the appropriate list for your distro from the `leaves/` directory:

```bash
# macOS
brew install $(cat leaves/leaves.txt | tr '\n' ' ')

# Arch
sudo pacman -S --needed $(cat leaves/packages-arch.txt | tr '\n' ' ')

# Fedora
sudo dnf install -y $(cat leaves/packages-fedora.txt | tr '\n' ' ')

# Ubuntu
sudo apt install -y $(cat leaves/packages-ubuntu.txt | tr '\n' ' ')
```

> [!NOTE]
> On Fedora and Ubuntu, starship, lazygit, eza, and yazi are not in the package lists above — install them manually or use `install.sh` which handles them automatically.

### Step 4 — Symlink configs

Run `setup.sh` for the full automated setup, or use stow directly:

```bash
# Symlink everything
stow .

# Symlink a single config
stow --target ~/.config --dotfiles <dirName>
```

### Step 5 — Restart your shell

```bash
exec zsh
```

---

## Optional: ThinkPad X230 Fan Control

For quieter operation on a ThinkPad X230, `thinkfan-setup.sh` installs and configures [thinkfan](https://github.com/vmatare/thinkfan) with a silent fan curve.

> [!NOTE]
> Linux only. Supported on Arch, Fedora, and Ubuntu.

```bash
chmod +x thinkfan-setup.sh
./thinkfan-setup.sh
```

What it does:
- Installs `thinkfan` via the appropriate package manager
- Enables fan control in the `thinkpad_acpi` kernel module (`/etc/modprobe.d/thinkpad_acpi.conf`)
- Resolves the coretemp hwmon sensor path dynamically
- Writes a silent curve to `/etc/thinkfan.yaml` — fan off at idle, ramps up gradually, full speed from 75°C
- Validates the config and enables the `thinkfan` systemd service

Safe to rerun — stops the running service and backs up the existing config before applying changes.

**Monitor fan speed:**

```bash
cat /proc/acpi/ibm/fan
```

**Check service status:**

```bash
systemctl status thinkfan
```
