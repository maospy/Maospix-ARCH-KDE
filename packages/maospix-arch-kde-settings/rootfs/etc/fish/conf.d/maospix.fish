# Maospix-ARCH-KDE: sin saludo de fish; fastfetch al abrir una terminal.
set -g fish_greeting
if status is-interactive; and test "$SHLVL" -le 1; and command -q fastfetch
    # Espera a que el mosaico fije el tamaño de la ventana (como mucho ~1 s).
    set -l antes (stty size 2>/dev/null)
    for i in 1 2 3 4 5 6 7 8 9
        sleep 0.1
        if test "$(stty size 2>/dev/null)" != "$antes"
            sleep 0.2
            break
        end
    end
    fastfetch
end
