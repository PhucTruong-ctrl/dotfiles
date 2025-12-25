#!/bin/bash
# Update Vencord Discord theme with pywal colors

# Read pywal colors
COLOR0=$(sed -n '1p' ~/.cache/wal/colors)
COLOR1=$(sed -n '2p' ~/.cache/wal/colors)
COLOR2=$(sed -n '3p' ~/.cache/wal/colors)
COLOR3=$(sed -n '4p' ~/.cache/wal/colors)
COLOR4=$(sed -n '5p' ~/.cache/wal/colors)
COLOR5=$(sed -n '6p' ~/.cache/wal/colors)
COLOR7=$(sed -n '8p' ~/.cache/wal/colors)
COLOR8=$(sed -n '9p' ~/.cache/wal/colors)
WALLPAPER=$(cat ~/.cache/wal/wal 2>/dev/null || echo "")

# Generate theme directly (not from template)
cat > ~/.config/Vencord/themes/ClearVision.theme.css << EOF
/**
 * @name ClearVision V7 (Pywal Auto-themed)
 * @author ClearVision Team + Pywal
 * @version 7.0.1-pywal
 */
@import url("https://clearvision.github.io/ClearVision-v7/main.css");
@import url("https://clearvision.github.io/ClearVision-v7/betterdiscord.css");

:root {
  --main-color: $COLOR4;
  --hover-color: $COLOR5;
  --success-color: $COLOR2;
  --danger-color: $COLOR1;
  --online-color: $COLOR2;
  --idle-color: $COLOR3;
  --dnd-color: $COLOR1;
  --streaming-color: $COLOR5;
  --offline-color: $COLOR8;
  --background-shading-percent: 85%;
  --background-image: url(file://$WALLPAPER);
  --background-position: center;
  --background-size: cover;
  --background-attachment: fixed;
  --background-filter: blur(8px) brightness(0.5) saturate(1.1);
  --user-popout-image: var(--background-image);
  --user-popout-position: center;
  --user-popout-size: cover;
  --user-popout-filter: blur(5px) brightness(0.6);
  --user-modal-image: var(--background-image);
  --user-modal-filter: blur(5px) brightness(0.6);
  --home-icon: url(https://clearvision.github.io/icons/discord.svg);
  --main-font: "gg sans", "Noto Sans", Helvetica, Arial, sans-serif;
  --code-font: "JetBrains Mono", Consolas, monospace;
}

.theme-dark {
  --background-shading: rgba(0, 0, 0, 0.5);
  --card-shading: rgba(0, 0, 0, 0.3);
  --popout-shading: rgba(0, 0, 0, 0.65);
  --input-shading: rgba(255, 255, 255, 0.05);
  --normal-text: $COLOR7;
  --muted-text: $COLOR8;
}
EOF

echo "✅ Vencord theme updated!"
echo "Colors: Main=$COLOR4, Hover=$COLOR5"
