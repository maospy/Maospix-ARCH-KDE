#!/usr/bin/env bash
# Uso: ./tools/probar-qemu.sh bios|uefi [disco] [headless]   (disco = sin ISO, arranca lo instalado)
set -euo pipefail
P="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"; m="${1:-bios}"
iso="$(ls -t "$P"/out/*.iso | head -1)"; d="$P/build/vm-$m.qcow2"; rm -f "$P/build/qmp-$m.sock"
[[ -f "$d" ]] || qemu-img create -q -f qcow2 "$d" 30G
fw=(); if [[ $m == uefi ]]; then
  [[ -f "$P/build/vars.fd" ]] || cp /usr/share/edk2/x64/OVMF_VARS.4m.fd "$P/build/vars.fd"
  fw=(-drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd -drive if=pflash,format=raw,file="$P/build/vars.fd")
fi
disp=gtk; [[ " $* " == *" headless "* ]] && disp=none
cd=(-cdrom "$iso" -boot d); [[ " $* " == *" disco "* ]] && cd=(-boot c)
exec qemu-system-x86_64 -name "Maospix-$m" -machine q35,accel=kvm -cpu host -smp 2 -m 3072 "${fw[@]}" \
  -drive file="$d",if=virtio,format=qcow2 "${cd[@]}" -device virtio-vga,xres=1366,yres=768 -display $disp \
  -nic user,model=virtio-net-pci -device qemu-xhci -device usb-tablet -audiodev none,id=a -serial file:"$P/build/serial-$m.log" \
  -qmp unix:"$P/build/qmp-$m.sock",server,nowait
