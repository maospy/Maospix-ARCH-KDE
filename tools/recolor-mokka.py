#!/usr/bin/env python3
"""Genera el tema Maospix a partir de Garuda Mokka (GPL-3) y Catppuccin KDE (MIT).

Uso: python3 -I tools/recolor-mokka.py RUTA_GARUDA_MOKKA RUTA_CATPPUCCIN_KDE
Cambia colores y nombres; conserva formas, márgenes y estilo.
"""
import gzip, re, shutil, sys
from pathlib import Path

MOKKA, CATP = Path(sys.argv[1]), Path(sys.argv[2])
OUT = Path(__file__).resolve().parent.parent / "packages/maospix-arch-kde-theme/rootfs"

# Catppuccin Mocha/Macchiato -> paleta MAOSPIX (la del preset de Maospix-Niri)
MAP = {
    "1e1e2e": "0f1524", "181825": "0a0f1a", "11111b": "070b14",   # base, mantle, crust
    "313244": "1f2a42", "45475a": "28344f", "585b70": "3a4868",   # superficies
    "6c7086": "6c7a99", "7f849c": "8290b0", "9399b2": "98a5c4",   # overlays
    "a6adc8": "b4c0dc", "bac2de": "c9d3ee", "cdd6f4": "e6ecff",   # textos
    "cba6f7": "4fd8e8", "b4befe": "b393f5",                       # acento cian, secundario violeta
    "89b4fa": "88a8d8", "74c7ec": "4fd8e8", "89dceb": "8fe6f0", "94e2d5": "8fe6f0",
    "f38ba8": "f2878f", "eba0ac": "f2878f", "a6e3a1": "8fd6a0", "f9e2af": "f0d58a",
    "fab387": "f5b08a", "ffb380": "f5b08a", "f5c2e7": "d68cf5", "f2cdcd": "ffb3ad", "f5e0dc": "ffd0cb",
    "8aadf4": "88a8d8", "8bd5ca": "4fd8e8", "a6da95": "8fd6a0", "ed8796": "f2878f",
    "eed49f": "f0d58a", "f5a97f": "f5b08a", "f5bde6": "b393f5",
    "3daee9": "4fd8e8", "3daee6": "4fd8e8", "93cee9": "8fe6f0",   # azul Breeze
}
rgb = lambda h: tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))
RGB = {rgb(a): rgb(b) for a, b in MAP.items()}
HEX_RE = re.compile(r"#([0-9a-fA-F]{6})(?![0-9a-fA-F])")
HEX8_RE = re.compile(r"#([0-9a-fA-F]{2})([0-9a-fA-F]{6})(?![0-9a-fA-F])")
DEC_RE = re.compile(r"(?<![\d.,])(\d{1,3})(,\s*)(\d{1,3})(,\s*)(\d{1,3})(?![\d.])")


def recolor(t, decimals):
    t = HEX8_RE.sub(lambda m: "#" + m[1] + MAP.get(m[2].lower(), m[2]), t)
    t = HEX_RE.sub(lambda m: "#" + MAP.get(m[1].lower(), m[1]), t)
    if decimals:                       # nunca en SVG: serían coordenadas
        def d(m):
            n = RGB.get((int(m[1]), int(m[3]), int(m[5])))
            return f"{n[0]}{m[2]}{n[1]}{m[4]}{n[2]}" if n else m[0]
        t = DEC_RE.sub(d, t)
    return t


def rename(s):
    for a, b in (("MokkaMauve", "Maospix"), ("Catppuccin-Mocha-Mauve", "la paleta MAOSPIX"), ("CatppuccinMocha-Classic", "Maospix"), ("Catppuccin Mocha Classic", "Maospix"),
                 ("CatppuccinMocha", "Maospix"), ("Mokka", "Maospix"), ("mokka", "maospix")):
        s = s.replace(a, b)
    return s


def put(src, rel):
    if src.suffix in (".svgzORI", ".svgzBKP") or " copy" in src.name:
        return
    dst = OUT / rename(str(rel))
    dst.parent.mkdir(parents=True, exist_ok=True)
    b = src.read_bytes()
    if src.suffix in (".png", ".jpg"):
        return                          # capturas y logos de Garuda: no se copian
    gz = b[:2] == b"\x1f\x8b"
    text = (gzip.decompress(b) if gz else b).decode()
    text = recolor(text, decimals=src.suffix not in (".svg", ".svgz"))
    if not str(rel).endswith(".md"):
        text = rename(text)
    if src.suffix in (".svg", ".svgz") and "</svg>" in text:   # Mokka trae basura tras </svg> en tabbar
        text = text[:text.index("</svg>") + 6] + "\n"
    out = text.encode()
    dst.write_bytes(gzip.compress(out, 9, mtime=0) if gz else out)


if False:  # no borrar: rootfs tiene también paneles, iconos y fondos
    shutil.rmtree(OUT)
for d in ("usr/share/Kvantum/Mokka", "usr/share/plasma/desktoptheme/Mokka"):
    for f in (MOKKA / d).rglob("*"):
        if f.is_file():
            put(f, f.relative_to(MOKKA))
for f in ("usr/share/color-schemes/Mokka.colors", "usr/share/konsole/Mokka.colorscheme",
          "usr/share/org.kde.syntax-highlighting/themes/Mokka.theme",
          "etc/skel/.config/gtk-3.0/colors.css", "etc/skel/.config/gtk-4.0/colors.css"):
    put(MOKKA / f, Path(f))
presets = Path("usr/share/plasma/plasmoids/luisbocanegra.panel.colorizer/contents/ui/presets")
for f in (MOKKA / presets).glob("Mokka */settings.json"):
    put(f, f.relative_to(MOKKA))
aur = CATP / "Resources/Aurorae/CatppuccinMocha-Classic"
for f in aur.iterdir():
    put(f, Path("usr/share/aurorae/themes/Maospix") / f.name)
put(CATP / "Resources/Aurorae/Common/Catppuccin-Classicrc", Path("usr/share/aurorae/themes/Maospix/Maospixrc"))

left = {}
for f in OUT.rglob("*"):
    if f.is_file():
        b = f.read_bytes()
        t = (gzip.decompress(b) if b[:2] == b"\x1f\x8b" else b).decode(errors="ignore")
        for k in MAP:
            if re.search("#" + k + r"(?![0-9a-f])", t, re.I):
                left.setdefault(k, []).append(f.name)
        if re.search("garuda|mokka|catppuccin", t, re.I) and f.suffix not in (".md",):
            left.setdefault("nombre", []).append(str(f.relative_to(OUT)))
print("archivos:", sum(1 for f in OUT.rglob("*") if f.is_file()))
print("restos:", left or "ninguno")
