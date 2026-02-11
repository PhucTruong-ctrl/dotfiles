# --- CẤU HÌNH CƠ BẢN ---
# History (Lưu lại lịch sử gõ lệnh)
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY

# --- KÍCH HOẠT THÁNH KHÍ (Mấy gói mày vừa cài) ---
# 1. Kích hoạt Starship (Giao diện đẹp)
eval "$(starship init zsh)"

# 2. Kích hoạt Zoxide (Cd thông minh)
eval "$(zoxide init zsh)"

# --- ALIAS (Lệnh tắt - Dùng cái này mới pro) ---
# Thay lệnh ls cũ bằng eza (đẹp, có icon)
alias ls='eza --icons --group-directories-first'
alias ll='eza -al --icons --group-directories-first'
alias tree='eza --tree --icons'

# Thay lệnh cat bằng bat (xem code có màu)
alias cat='bat'

# Lệnh tắt cho Git (mày sẽ dùng nhiều)
alias g='git'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gst='git status'

# Lệnh tắt hệ thống
alias c='clear'
alias q='exit'
alias edit='nvim ~/.zshrc' # Gõ edit là sửa config luôn
alias reload='source ~/.zshrc' # Gõ reload là cập nhật config

# --- TMUX AUTO START (Tùy chọn) ---
# Nếu mày muốn mở terminal là vào tmux luôn thì bỏ comment dòng dưới
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   exec tmux
# fi
#

export PATH="$HOME/.local/bin:$PATH"

# opencode
export PATH=/home/phuctruong/.opencode/bin:$PATH

# bun completions
[ -s "/home/phuctruong/.bun/_bun" ] && source "/home/phuctruong/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

PATH="/home/phuctruong/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/phuctruong/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/phuctruong/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/phuctruong/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/phuctruong/perl5"; export PERL_MM_OPT;
export PATH="/opt/brew/bin:$PATH"
