# 🏠 Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## 📁 Structure

```
dotfiles/
├── hypr/               # Hyprland window manager (old config?)
├── hyprland/           # Hyprland window manager (current)
├── keyboards/          # Custom keyboard configs (VIA/QMK)
├── nvim/               # Neovim editor
├── starship/           # Starship prompt
├── system-configs/     # System optimization (TLP, undervolt, game)
├── tmux/               # Tmux terminal multiplexer
├── wallpapers/         # Desktop wallpapers collection
├── waybar/             # Waybar status bar
└── zsh/                # Zsh shell configuration
```

## 🚀 Installation

### Prerequisites
```bash
sudo pacman -S stow
```

### Deploy All Configs
```bash
cd ~/dotfiles

# User configs (stow from dotfiles root)
stow hyprland nvim starship tmux waybar zsh

# System configs (stow from system-configs/)
cd system-configs
sudo stow -t / intel-undervolt tlp
stow -t ~ honkers-railway-launcher
cd ..
```

### Deploy Specific Config
```bash
cd ~/dotfiles
stow nvim      # Only neovim
stow zsh       # Only zsh
```

## 📦 Packages Overview

### 🪟 **hyprland/** - Window Manager
Hyprland wayland compositor configuration.

**Path:** `~/.config/hypr/`

**Key Features:**
- Tiling window management
- Custom keybindings
- Monitor configuration

---

### ✏️ **nvim/** - Text Editor
Neovim configuration with plugins and LSP.

**Path:** `~/.config/nvim/`

---

### ⌨️ **keyboards/** - Custom Keyboards
VIA/QMK keyboard layouts and configurations.

**Items:**
- `bioi_samice/` - Custom keyboard layout JSON files

**Not stowed** (reference files only)

---

### 🌟 **starship/** - Shell Prompt
Starship cross-shell prompt configuration.

**Path:** `~/.config/starship.toml`

**Features:**
- Git branch/status display
- Python virtualenv indicator
- Custom prompt styling

---

### 🔧 **system-configs/** - Performance & Thermal
System-level optimization configurations.

**Includes:**

#### `intel-undervolt/` - CPU/GPU Undervolt
**Path:** `/etc/intel-undervolt.conf`

**Settings:**
- CPU: -50mV
- iGPU: -50mV
- CPU Cache: -50mV

**Effect:** Giảm nhiệt 2-4°C, giảm điện năng 5-10%

**Service:** `intel-undervolt.service`

#### `tlp/` - Thermal Management
**Path:** `/etc/tlp.conf`

**Mode:** Performance (cân bằng performance + nhiệt)

**Service:** `tlp.service`

#### `honkers-railway-launcher/` - Game Optimization
**Path:** `~/.local/share/honkers-railway-launcher/config.json`

**Features:**
- NVIDIA GPU offload (Prime)
- DXVK frame limiter (55 FPS)
- Vulkan ICD override
- Shader caching

**For:** Honkai Star Rail on Linux/Wine

**Installation:**
```bash
cd ~/dotfiles/system-configs

# System configs (need sudo)
sudo stow -t / intel-undervolt tlp

# User config
stow -t ~ honkers-railway-launcher

# Enable services
sudo systemctl enable --now intel-undervolt tlp
```

---

### 🖥️ **tmux/** - Terminal Multiplexer
Tmux configuration with custom keybindings.

**Path:** `~/.config/tmux/`

---

### 🎨 **wallpapers/** - Desktop Backgrounds
Curated wallpaper collection.

**Path:** `~/Wallpapers/`

**Themes:**
- Catppuccin (mocha, latte)
- Flexoki
- Everforest
- Gruvbox
- Kanagawa
- Rose Pine
- Abstract/Minimal

**Not stowed** (copy manually or symlink individual files)

---

### 📊 **waybar/** - Status Bar
Waybar configuration for Wayland.

**Path:** `~/.config/waybar/`

**Features:**
- System tray
- Workspace indicators
- System stats (CPU, RAM, temp)
- Custom styling

---

### 🐚 **zsh/** - Shell Configuration
Zsh shell configuration.

**Path:** `~/.zshrc`

**Features:**
- Custom aliases
- Plugin management
- Starship prompt integration

---

## 🔄 Updating Configs

### After Editing Dotfiles
```bash
cd ~/dotfiles

# Re-stow (overwrites existing symlinks)
stow -R nvim zsh waybar

# For system configs
cd system-configs
sudo stow -R -t / intel-undervolt tlp
```

### Removing Config
```bash
cd ~/dotfiles
stow -D nvim  # Unlink neovim config
```

## 📝 Configuration Notes

### Duplicate hypr/hyprland
- `hypr/` - Old/backup config?
- `hyprland/` - Current active config

**Recommended:** Verify which one is active, remove unused one.

### test.py
Orphan file at root - consider removing or documenting purpose.

## 🛠️ System Info

**Hardware:**
- CPU: Intel i5-1035G1 (Ice Lake)
- GPU: NVIDIA GeForce MX330 + Intel Iris Plus G1
- Laptop: Hybrid graphics (Intel + NVIDIA)

**Software:**
- OS: Arch Linux
- WM: Hyprland (Wayland)
- Shell: Zsh + Starship
- Editor: Neovim
- Terminal: Tmux

## 🎯 Optimizations Applied

### Thermal Management
- **intel-undervolt:** -50mV CPU/GPU/Cache (stable)
- **TLP:** Performance mode with thermal limits

### Gaming
- **NVIDIA Driver:** 470.256.02 (legacy proprietary)
- **DXVK:** 1.10.3 (downgraded for 470xx compatibility)
- **Wine:** Spritz-Wine-TkG 10.15 (custom build)

**Target:** Honkai Star Rail @ 50-55 FPS stable

---

## 📚 Resources

- [GNU Stow Tutorial](https://www.gnu.org/software/stow/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Arch Wiki - Dotfiles](https://wiki.archlinux.org/title/Dotfiles)

## 📄 License

Personal configurations - use at your own risk.
