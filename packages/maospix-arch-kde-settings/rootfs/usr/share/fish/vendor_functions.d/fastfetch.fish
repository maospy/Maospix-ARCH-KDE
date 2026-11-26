# Maospix-ARCH-KDE: fastfetch con el escudo. En Konsole y kitty locales usa la imagen; en SSH, TTY u otra, texto.
function fastfetch --wraps fastfetch --description 'fastfetch con logo MAOSPIX'
    for a in $argv
        if string match -qr -- '^(-l|--logo|-c|--config)' $a
            command fastfetch $argv
            return
        end
    end
    # Terminal angosta (en mosaico): solo los datos, sin logo.
    set -l ancho (stty size 2>/dev/null | string split " ")[2]   # $COLUMNS puede estar viejo al abrir
    if test -n "$ancho"; and test "$ancho" -lt 100
        command fastfetch --logo none $argv
    else if set -q KONSOLE_VERSION; and not set -q SSH_CONNECTION
        command fastfetch --logo-type iterm --logo /usr/share/maospix-arch-kde/fastfetch/logo.png --logo-width 38 --logo-height 19 $argv
    else if set -q KITTY_WINDOW_ID; and not set -q SSH_CONNECTION
        command fastfetch --logo-type kitty-direct --logo /usr/share/maospix-arch-kde/fastfetch/logo.png --logo-width 38 --logo-height 19 $argv
    else
        command fastfetch $argv
    end
end
