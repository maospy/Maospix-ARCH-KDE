#!/usr/bin/env bash
# Muestra solo el porcentaje de la construcción de la ISO.
# Uso: ./tools/progreso.sh        (se actualiza solo; Ctrl+C para salir)
#      ./tools/progreso.sh --una  (una línea y termina)
P="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"; L="$P/build/iso.log"; B="$P/build"
N=13                                  # paquetes propios
PESO=(30 20 25 5 18 2)                # paquetes, descarga, instalación, arranque, compresión, cierre
TITULO=("Compilando paquetes propios" "Descargando paquetes de Arch" "Instalando en la imagen" "Preparando arranque" "Comprimiendo la imagen" "Generando el archivo .iso")

num() { [[ "$1" =~ ^[0-9]+$ ]] && echo "$1" || echo 0; }
pct() { (( $2 > 0 )) && { local v=$(( $1 * 100 / $2 )); (( v > 99 )) && v=99; echo "$v"; } || echo 0; }

estado() {  # imprime: etapa porcentaje_de_etapa
  local iso c n t a
  iso="$(ls -t "$P"/out/*.iso 2>/dev/null | head -1)"
  if [[ ! -f "$L" ]]; then
    n=$(ls "$P"/repo/x86_64/*.pkg.tar.zst 2>/dev/null | wc -l); (( n > N )) && n=$N
    c="$(grep -oE '\[[0-9]+/[0-9]+\]' "$B/log-calamares.txt" 2>/dev/null | tail -1 | tr -d '[]')"
    if (( n == N - 1 )) && [[ -n "$c" ]]; then echo "0 $(( (n * 100 + $(pct "${c%/*}" "${c#*/}")) / N ))"
    else echo "0 $(pct "$n" "$N")"; fi; return
  fi
  if grep -q 'Creating ISO image' "$L"; then echo "5 50"; return; fi
  if grep -q 'Creating SquashFS image' "$L"; then
    a="$(sed -n '/Creating SquashFS image/,$p' "$L" | tr '\r' '\n' | grep -oE '[0-9]+%' | tail -1 | tr -d '%')"
    if [[ -z "$a" ]]; then     # sin barra en el log: se estima por tamaño
      local sfs root; sfs=$(num "$(find "$P/work" -maxdepth 6 -name airootfs.sfs -printf '%s' -quit 2>/dev/null)")
      root=$(num "$(du -sb "$P/work/x86_64/airootfs" 2>/dev/null | cut -f1)"); a=$(pct "$sfs" $(( root * 42 / 100 )))
    fi; echo "4 $a"; return
  fi
  if grep -qE 'Setting up (SYSLINUX|systemd-boot|GRUB)|Preparing kernel' "$L"; then echo "3 50"; return; fi
  t=$(num "$(grep -oE 'Paquetes \([0-9]+\)|Packages \([0-9]+\)' "$L" | tail -1 | tr -dc 0-9)")
  n=$(grep -cE '(^|[) ])(instalando|installing) ' "$L")
  if (( n > 0 )); then echo "2 $(pct "$n" "$t")"; return; fi
  # descarga: MB reales de build/cache frente al total que anunció pacman
  t="$(grep -m1 -oE '(Total Download Size|Tamaño total de la descarga): +[0-9.,]+' "$L" | grep -oE '[0-9.,]+$' | cut -d. -f1)"
  n=$(( ( $(num "$(du -sb "$B/cache" 2>/dev/null | cut -f1)") - $(num "$(cat "$B/dl/base" 2>/dev/null)") ) / 1048576 )); (( n < 0 )) && n=0
  echo "1 $(pct "$n" "$(num "$t")")"
}

linea() {
  local e p base=0 i total
  if pgrep -f 'cadena.sh|build-iso.sh|build-packages.sh|mkarchiso' >/dev/null; then VIVO=1; else VIVO=0; fi
  read -r e p < <(estado)
  for (( i=0; i<e; i++ )); do (( base += PESO[i] )); done
  total=$(( base + PESO[e] * p / 100 ))
  if (( ! VIVO )); then
    if grep -q 'Done!' <(tail -5 "$L" 2>/dev/null) && compgen -G "$P/out/*.iso" >/dev/null; then MSG="100%  ISO lista: $(ls -t "$P"/out/*.iso | head -1)"; FIN=0; return; fi
    MSG="${total}%  DETENIDO en: ${TITULO[e]} (no hay proceso corriendo; mira build/iso.log)"; FIN=1; return
  fi
  MSG="$(printf '%3d%%  [%s%s] %s (%d%% de esta etapa)' "$total" "$(printf '%*s' $((total/5)) '' | tr ' ' '#')" "$(printf '%*s' $((20-total/5)) '' | tr ' ' '-')" "${TITULO[e]}" "$p")"; FIN=2
}

if [[ "${1:-}" == --una ]]; then linea; echo "$MSG"; exit 0; fi
while :; do linea; printf '\r\033[K%s' "$MSG"; (( FIN == 2 )) || { echo; exit "$FIN"; }; sleep 3; done
