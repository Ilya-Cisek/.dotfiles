#VPN
alias start_vpn="sudo openvpn --config /etc/openvpn/client/swings_krlv_pass.ovpn --daemon"
alias stop_vpn="sudo killall openvpn"

# pacman wrapper
alias yeet="paru"

#systemctl
alias stcl="sudo systemctl"

#kitty ssh
alias kssh="kitten ssh "

# #git
# alias gts="git status"


#
alias x="xclip -o"
alias dtfls="dotfiles"

# 
alias lg="lazygit"

# alias va="source .venv/bin/activate"

#dotfiles
alias lgdot='lazygit --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'

#nvim withot plugins
alias pvim="nvim --clean"

#Ai agent
alias agent="set_proxy && codex resume"
