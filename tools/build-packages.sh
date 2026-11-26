#!/usr/bin/env bash
# Compila los paquetes en build/chroot (sin root) y arma el repo local.
# Uso: ./tools/build-packages.sh [paquete...]
set -uo pipefail
P="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"; C="$P/build/chroot"; R="$P/repo/x86_64"
todos=(maospix-arch-kde-theme maospix-arch-kde-settings maospix-plymouth-theme ckbcomp plasma6-applets-window-title plasma6-applets-panel-colorizer kwin-effect-rounded-corners-git yay-bin paru-bin brave-bin calamares libcava caelestia-kde)
(( $# )) && todos=("$@")
mkdir -p "$R"; fallos=(); chmod u+w "$C"; rm -f "$C/etc/resolv.conf"; cat /etc/resolv.conf > "$C/etc/resolv.conf"
cat > "$P/build/dentro.sh" <<'D'
#!/bin/bash
set -e
id builder >/dev/null 2>&1 || useradd -m builder
rm -rf /build; cp -r /src /build; chown -R builder: /build; cd /build; rm -f *.pkg.tar.*
runuser -u builder -- env PKGDEST=/build/salida MAKEFLAGS=-j3 OPTIONS='' makepkg --nodeps --force --noconfirm
D
for n in "${todos[@]}"; do
  echo "==> $n"; unshare --map-auto --map-root-user rm -rf "$C/src" "$C/build"; mkdir -p "$C/src"
  cp -r "$P/packages/$n/." "$C/src/"; mkdir -p "$C/src/salida"; cp "$P/build/dentro.sh" "$C/src/dentro.sh"
  if arch-chroot -N -r "$C" bash /src/dentro.sh > "$P/build/log-$n.txt" 2>&1; then
    f="$(find "$C/build/salida" -name '*.pkg.tar.zst' ! -name '*-debug-*' | head -1)"
    rm -f "$R/$n"-[0-9]*.pkg.tar.zst; cp "$f" "$R/" && echo "    ok: $(basename "$f")"
  else echo "    FALLÓ (build/log-$n.txt)"; tail -8 "$P/build/log-$n.txt"; fallos+=("$n"); fi
done
rm -f "$R"/maospix.{db,files}*; repo-add -q -R "$R/maospix.db.tar.gz" "$R"/*.pkg.tar.zst
echo "Fallos: ${fallos[*]:-ninguno}"; (( ${#fallos[@]} == 0 ))
