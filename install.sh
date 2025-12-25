#!/bin/bash
# Omarchy Dotfiles Install Script
# Automated setup for new systems

set -e

echo "🚀 Installing Omarchy Dotfiles..."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo -e "${RED}❌ GNU Stow not found!${NC}"
    echo "Install it: sudo pacman -S stow"
    exit 1
fi

# Get script directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

echo -e "${BLUE}📁 Dotfiles directory: $DOTFILES_DIR${NC}"

# User configs (stow to ~/)
USER_CONFIGS=(
    "alacritty"
    "btop"
    "cava"
    "fastfetch"
    "fcitx5"
    "gtk"
    "hyprland"
    "lazygit"
    "mako"
    "nvim"
    "omarchy"
    "spicetify"
    "starship"
    "tmux"
    "vencord"
    "waybar"
    "zsh"
)

# System configs (need sudo, stow to /)
SYSTEM_CONFIGS=(
    "intel-undervolt"
    "tlp"
    "sddm"
    "plymouth"
    "mkinitcpio"
)

# Stow user configs
echo -e "\n${BLUE}📦 Installing user configs...${NC}"
for config in "${USER_CONFIGS[@]}"; do
    if [ -d "$config" ]; then
        echo "  → Stowing $config"
        stow -t ~ "$config" 2>/dev/null || echo -e "${RED}    ⚠️  $config failed (may already exist)${NC}"
    fi
done

# Stow system configs (needs sudo)
echo -e "\n${BLUE}🔧 Installing system configs (sudo required)...${NC}"
cd system-configs

for config in "${SYSTEM_CONFIGS[@]}"; do
    if [ -d "$config" ]; then
        echo "  → Stowing $config (sudo)"
        sudo stow -t / "$config" 2>/dev/null || echo -e "${RED}    ⚠️  $config failed${NC}"
    fi
done

cd "$DOTFILES_DIR"

# Game launcher config (user-level)
if [ -d "system-configs/honkers-railway-launcher" ]; then
    echo "  → Stowing honkers-railway-launcher"
    cd system-configs
    stow -t ~ honkers-railway-launcher 2>/dev/null || echo -e "${RED}    ⚠️  honkers failed${NC}"
    cd "$DOTFILES_DIR"
fi

# Enable services
echo -e "\n${BLUE}⚙️  Enabling system services...${NC}"
sudo systemctl enable --now intel-undervolt 2>/dev/null && echo "  ✅ intel-undervolt" || echo "  ⚠️  intel-undervolt service not found"
sudo systemctl enable --now tlp 2>/dev/null && echo "  ✅ TLP" || echo "  ⚠️  TLP service not found"

# Rebuild initramfs if mkinitcpio changed
if [ -f "/etc/mkinitcpio.conf" ]; then
    echo -e "\n${BLUE}🔨 Rebuilding initramfs...${NC}"
    read -p "Rebuild initramfs now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo mkinitcpio -P
    fi
fi

echo -e "\n${GREEN}✅ Dotfiles installation complete!${NC}"
echo -e "${BLUE}📝 Next steps:${NC}"
echo "  1. Restart shell (or 'source ~/.zshrc')"
echo "  2. Reboot to apply system configs"
echo "  3. Configure Spicetify: spicetify backup apply"
echo "  4. Configure fcitx5: fcitx5-configtool"
