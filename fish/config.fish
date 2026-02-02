# =========================
# CONFIGURACIÓN GENERAL
# =========================

# Quita el saludo inicial de fish
set -g fish_greeting ""

# Iniciar Starship
starship init fish | source

zoxide init fish | source

# =========================
# ALIASES
# =========================

# SUDO HELIX
alias shx="sudo helix -c $HOME/.config/helix/config.toml"

# SSH
alias ssh-testgithub="ssh -T git@github.com"

# =========================
# FUNCTIONS
# =========================

# Yazi con cd automático
function yy
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and test -n "$cwd"; and test "$cwd" != "$PWD"
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# SSH
function gen-ssh
    read -P "Ingresa tu correo: " email
    ssh-keygen -t ed25519 -C "$email"
end

# REFLECTOR
function update-mirrors
    echo "🔄 Actualizando mirrors..."
    sudo reflector --country MX,US \
        --age 24 --latest 20 --protocol https --number 5 \
        --sort rate --save /etc/pacman.d/mirrorlist
    and echo "✅ Mirrors actualizados"
    and sudo pacman -Syyu
    and echo "📦 Sistema actualizado con éxito"
end
