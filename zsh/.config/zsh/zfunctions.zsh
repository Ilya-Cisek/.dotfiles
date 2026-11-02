# yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

#zellij tab naming
zellij_tab_name_update() {
    if [[ -n $ZELLIJ ]]; then
        local current_dir=$PWD
        if [[ $current_dir == $HOME ]]; then
            current_dir="~"
        else
            current_dir=${current_dir##*/}
        fi
        command nohup zellij action rename-tab $current_dir >/dev/null 2>&1
    fi
}

zellij_tab_name_update
chpwd_functions+=(zellij_tab_name_update)


# mkdir and cd 
function mkcd() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: mkcd <directory_name>"
        return 1
    fi
    
    mkdir -p "$1" && cd "$1"
}

# fzf widget for neovim
fzf-nvim-widget() {
  local file

  file=$(
    find . -maxdepth 4 -type f \
      -not -path '*/.git/*' \
      -not -path '*/env/*' \
      | fzf \
          --height=40% \
          --layout=reverse \
          --preview-window=:hidden
  )

  if [[ -n "$file" ]]; then
    zle reset-prompt
    BUFFER="${EDITOR:-nvim} ${(q)file}"
    CURSOR=$#BUFFER
    zle accept-line
  else
    zle reset-prompt
  fi
}

zle -N fzf-nvim-widget
bindkey '\eo' fzf-nvim-widget


# Find my country
function whereami() {
  local ip
  ip=$(curl -fsS ipinfo.io/ip) || return 1
  geoiplookup "$ip"
}

function set_proxy() {
  export http_proxy="http://127.0.0.1:7897"
  export https_proxy="http://127.0.0.1:7897"
  export all_proxy="socks5h://127.0.0.1:7897"
}


# Activate or create Python virtual environment
function va() {
    local venv_dir=".venv"
    local answer

    # Если окружение существует — просто активируем
    if [[ -f "$venv_dir/bin/activate" ]]; then
        source "$venv_dir/bin/activate"
        return
    fi

    # Предлагаем создать окружение
    printf "Virtual environment %s does not exist. Create it? [Y/n] " "$venv_dir"
    read -r answer

    case "$answer" in
        ""|y|Y|yes|YES)
            ;;
        *)
            echo "Cancelled."
            return 1
            ;;
    esac

    python3 -m venv "$venv_dir" || {
        echo "Failed to create virtual environment."
        return 1
    }

    source "$venv_dir/bin/activate" || return 1

    # Обновляем базовые инструменты сборки
    python -m pip install --upgrade pip setuptools wheel || return 1

    # Устанавливаем зависимости
    if [[ -f "requirements.txt" ]]; then
        echo "Installing dependencies from requirements.txt..."
        python -m pip install -r requirements.txt
    elif [[ -f "pyproject.toml" ]]; then
        echo "Installing project from pyproject.toml..."
        python -m pip install -e .
    else
        echo "No requirements.txt or pyproject.toml found."
        return 0
    fi
}


# man in nvim
mann() {
    /usr/bin/man "$@" | col -b | nvim -R -c 'set ft=man nomod nolist' -
}


