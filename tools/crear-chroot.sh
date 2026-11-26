#!/usr/bin/env bash
# Crea build/chroot (sin root) para compilar los paquetes. Requiere Arch con arch-install-scripts, archiso y subuid/subgid.
set -uo pipefail
P="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"; B="$P/build"; C="$B/chroot"; mkdir -p "$C" "$B/cache" "$P/repo/x86_64" "$P/out"
[[ -f "$B/mirrorlist" ]] || cp "$P/archiso/airootfs/etc/pacman.d/mirrorlist" "$B/mirrorlist"
cat > "$B/pacman-chroot.conf" <<C1
[options]
HoldPkg = pacman glibc
Architecture = auto
ParallelDownloads = 3
DisableDownloadTimeout
SigLevel = Required DatabaseOptional
[core]
Include = $B/mirrorlist
[extra]
Include = $B/mirrorlist
C1
pk=(base base-devel git cmake extra-cmake-modules ninja meson kwin libplasma plasma-workspace vulkan-headers kcoreaddons kpmcore libpwquality python python-toml python-dbus
    qt6-declarative qt6-svg qt6-tools qt6-translations qt6-shadertools qt6-multimedia qt6-5compat qt6-imageformats qt6-wayland yaml-cpp libglvnd squashfs-tools rsync gettext perl
    quickshell matugen networkmanager-qt pulseaudio-qt libqalculate aubio protobuf avahi kwindowsystem kguiaddons kglobalaccel kconfig libpipewire ddcutil brightnessctl
    fftw iniparser jq sdl2-compat portaudio sndio libpulse autoconf-archive)
ok=0
for i in 1 2 3 4 5 6; do
  if pacstrap -N -C "$B/pacman-chroot.conf" -G -M "$C" "${pk[@]}"; then ok=1; break; fi; sleep 5
done
(( ok )) || { echo "ERROR: no se pudo crear el chroot" >&2; exit 1; }
chmod u+w "$C"; cp "$B/mirrorlist" "$C/etc/pacman.d/mirrorlist"; cat /etc/resolv.conf > "$C/etc/resolv.conf"
arch-chroot -N -r "$C" bash -c 'pacman-key --init && pacman-key --populate archlinux' || exit 1
# Caelestia necesita libcava instalada en el chroot.
"$P/tools/build-packages.sh" libcava || exit 1
cp "$P"/repo/x86_64/libcava-[0-9]*.pkg.tar.zst "$C/root/" && arch-chroot -N -r "$C" bash -c 'pacman -U --noconfirm --disable-sandbox /root/libcava-*.zst'
echo "Listo: ahora ./tools/build-packages.sh"
