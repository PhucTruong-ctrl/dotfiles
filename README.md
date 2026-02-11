# Dotfiles

Personal configuration files for [Omarchy](https://omarchy.org/) (Arch Linux + Hyprland), managed with [GNU Stow](https://www.gnu.org/software/stow/).

## System

| Component | Details |
|-----------|---------|
| OS | Arch Linux ([Omarchy](https://omarchy.org/) 3.3.3) |
| WM | Hyprland 0.53.3 (Wayland) |
| Shell | Zsh + Starship |
| Terminal | Alacritty |
| Editor | Neovim (LazyVim) |
| Bar | Waybar |
| GPU | NVIDIA MX330 + Intel Iris Plus G1 (hybrid) |
| CPU | Intel i5-1035G1 |

## Structure

```
dotfiles/
├── alacritty/          # Terminal emulator
├── btop/               # System monitor
├── cava/               # Audio visualizer
├── fastfetch/          # System info
├── fcitx5/             # Input method (Vietnamese)
├── hypr/               # Hyprland compositor (all configs)
├── keyboards/          # Custom keyboard layouts (VIA/QMK, not stowed)
├── lazygit/            # Git TUI
├── nvim/               # Neovim (LazyVim)
├── omarchy/            # Omarchy branding overrides
├── opencode/           # OpenCode AI agent config
├── pywal/              # Pywal templates
├── spicetify/          # Spotify theming
├── starship/           # Shell prompt
├── system-configs/     # System-level configs (sudo required)
│   ├── honkers-railway-launcher/  # Honkai Star Rail (Wine)
│   ├── intel-undervolt/           # CPU/GPU undervolt (-50mV)
│   ├── mkinitcpio/                # Initramfs
│   ├── plymouth/                  # Boot splash
│   ├── sddm/                     # Display manager (auto-login)
│   └── tlp/                      # Power management
├── tmux/               # Terminal multiplexer
├── vencord/            # Discord client mod
├── waybar/             # Status bar
└── zsh/                # Shell config
```

## Install

```bash
sudo pacman -S stow
git clone git@github.com:PhucTruong-ctrl/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Or deploy individually:

```bash
cd ~/dotfiles
stow -t ~ hypr         # Hyprland configs
stow -t ~ zsh          # Shell config
stow -t ~ nvim         # Neovim
```

## Hyprland

All Hyprland configuration lives in the `hypr/` stow package, deployed to `~/.config/hypr/`:

| File | Purpose |
|------|---------|
| `hyprland.conf` | Main config (sources all others) |
| `hyprland_nvidia.conf` | NVIDIA hybrid GPU + gaming window rules |
| `autostart.conf` | Startup applications |
| `bindings.conf` | Keybindings |
| `monitors.conf` | Display configuration |
| `input.conf` | Keyboard, mouse, touchpad |
| `looknfeel.conf` | Gaps, borders, animations |
| `envs.conf` | Environment variables |
| `hypridle.conf` | Idle behavior (screen off, lock, suspend) |
| `hyprlock.conf` | Lock screen appearance |
| `hyprsunset.conf` | Night light |

### NVIDIA Gaming

`hyprland_nvidia.conf` includes optimizations for hybrid GPU gaming:

- Software cursor (`cursor:no_hardware_cursors`) — fixes Wayland cursor stutter
- Direct scanout disabled (`render:direct_scanout = 0`) — fixes hybrid dGPU-to-iGPU copy stutter
- NVIDIA anti-flicker (`opengl:nvidia_anti_flicker`)
- Tearing window rules for HSR, Minecraft, Steam (`immediate on`)
- GPU forced to max performance on boot via `nvidia-settings`

### Honkai Star Rail

`system-configs/honkers-railway-launcher/` contains the launcher config:

- **Wine:** Spritz Wine TKG 10.15-8 (miHoYo-patched)
- **DXVK:** Async shader compilation (`DXVK_ASYNC=1`)
- **Frame pacing:** `WINE_ALERT_SIMULATE_SCHED_QUANTUM=1` (Unity engine fix)
- **GPU:** Max performance + `__GL_THREADED_OPTIMIZATIONS=1`
- **FPS cap:** DXVK-level limiter (`DXVK_FRAME_RATE=60`)
- **HUD:** MangoHud (per-game only, not global)

## System Configs

Requires `sudo`, stowed to `/`:

| Package | Path | Purpose |
|---------|------|---------|
| `intel-undervolt` | `/etc/intel-undervolt.conf` | CPU/GPU/Cache undervolt (-50mV) |
| `tlp` | `/etc/tlp.conf` | Power management |
| `sddm` | `/etc/sddm.conf.d/` | Auto-login |
| `plymouth` | `/etc/plymouth/` | Boot splash |
| `mkinitcpio` | `/etc/mkinitcpio.conf` | Initramfs config |

```bash
cd ~/dotfiles/system-configs
sudo stow -t / intel-undervolt tlp sddm plymouth mkinitcpio
stow -t ~ honkers-railway-launcher
sudo systemctl enable --now intel-undervolt tlp
```

## Updating

```bash
cd ~/dotfiles
stow -R -t ~ hypr zsh waybar    # Re-stow after editing

cd system-configs
sudo stow -R -t / tlp            # Re-stow system configs

cd ~/dotfiles
stow -D -t ~ nvim                # Remove a config
```

## License

Personal configurations — use at your own risk.
