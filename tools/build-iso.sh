#!/usr/bin/env bash
# Construye la ISO sin root. Uso: ./tools/build-iso.sh N   (N = número de prueba; avance: ./tools/progreso.sh)
set -uo pipefail
export LC_ALL=C
P="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"; C="$P/build/cache"; W="$P/work"
[[ "${1:-}" =~ ^[0-9]+$ ]] || { echo "Falta el número de prueba, ej.: ./tools/build-iso.sh 4" >&2; exit 1; }
export MAOSPIX_PRUEBA="$1"
compgen -G "$P/out/maospix-arch-kde-prueba$1-*.iso" >/dev/null && { echo "Ya existe la ISO de la prueba $1 en out/" >&2; exit 1; }
test -r "$P/repo/x86_64/maospix.db.tar.gz" || { echo 'Primero: ./tools/build-packages.sh' >&2; exit 1; }
mkdir -p "$C" "$P/out" "$P/build/dl"/{root,db}
du -sb "$C" | cut -f1 > "$P/build/dl/base"
echo "Registro en build/iso.log"; exec >"$P/build/iso.log" 2>&1
sed -e "s|@MAOSPIX_REPO@|file://$P/repo/x86_64|" -e "s|/etc/pacman.d/mirrorlist|$P/build/mirrorlist|" \
    -e "s|^ParallelDownloads.*|ParallelDownloads = 3\nDisableDownloadTimeout\nCacheDir = $C|" \
    "$P/archiso/pacman.conf.in" > "$P/build/pacman.conf"
us=(unshare --fork --pid --mount --map-auto --map-root-user)

# 1) Descarga previa con reintentos: lo ya bajado queda en build/cache.
mapfile -t pk < <(grep -vE '^\s*(#|$)' "$P/archiso/packages.x86_64")
ok=0
for i in 1 2 3 4 5 6 7 8; do
  echo "=== descarga, intento $i ($(date +%T))"
  if "${us[@]}" pacman -Syw --noconfirm --config "$P/build/pacman.conf" --root "$P/build/dl/root" \
      --dbpath "$P/build/dl/db" --cachedir "$C" --disable-sandbox "${pk[@]}"; then ok=1; break; fi
  sleep 20
done
(( ok )) || { echo "ERROR: no se pudo completar la descarga"; exit 1; }

# 2) mkarchiso con esa caché; reintenta solo si falló al instalar paquetes.
for i in 1 2 3; do
  [[ -d "$W" ]] && unshare --map-auto --map-root-user rm -rf "$W"
  echo "=== mkarchiso, intento $i ($(date +%T))"; marca=$(wc -l < "$P/build/iso.log")
  mkarchiso -v -C "$P/build/pacman.conf" -w "$W" -o "$P/out" "$P/archiso" && exit 0
  tail -n +"$marca" "$P/build/iso.log" | grep -qE 'failed (retrieving|to synchronize)' || exit 1
  sleep 20
done
exit 1
