#!/usr/bin/env python3
"""Genera los wallpapers de identidad MAOSPIX-Niri (3840x2160).

Misma familia que Maospix KDE: Maospix, Nord, Negro y Grafito (colores sólidos
con cuadrícula suave), con el logo neón de Niri, "NIRI" y el lema.

Uso: python3 tools/gen-wallpapers.py   (desde la raíz del repo)
Salida: assets/wallpapers/generated/maospix-niri-*.png
"""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
LOGO = ROOT / "assets/branding/maospix-logo-neon.png"
FONTS = ROOT / "upstream/inir-src/assets/fonts/montserrat"
OUT = ROOT / "assets/wallpapers/generated"
W, H = 3840, 2160

CYAN = (79, 216, 232)
VIOLET = (179, 147, 245)

# nombre: (color de fondo, color de cuadrícula, brillo cian/violeta 0..1)
VARIANTES = {
    "maospix": ((15, 21, 36), (32, 44, 68), 1.0),
    "nord": ((46, 58, 76), (62, 76, 98), 0.55),
    "negro": ((7, 9, 13), (20, 26, 34), 0.8),
    "grafito": ((43, 44, 49), (58, 59, 66), 0.45),
}


def fondo(bg, grid, glow):
    im = Image.new("RGB", (W, H), bg)
    d = ImageDraw.Draw(im)
    step = 80
    for x in range(0, W, step):
        d.line([(x, 0), (x, H)], fill=grid, width=2)
    for y in range(0, H, step):
        d.line([(0, y), (W, y)], fill=grid, width=2)
    # la cuadrícula se desvanece hacia los bordes (viñeta) para no cansar la vista
    mask = Image.new("L", (W, H), 0)
    ImageDraw.Draw(mask).ellipse((-W * 0.1, -H * 0.3, W * 1.1, H * 1.3), fill=255)
    mask = mask.filter(ImageFilter.GaussianBlur(500))
    im = Image.composite(im, Image.new("RGB", (W, H), bg), mask)

    # halos de color de la marca: cian detrás del logo, violeta abajo a la derecha
    for (cx, cy, r, col, a) in ((960, 1080, 900, CYAN, 70), (3300, 1900, 1100, VIOLET, 55)):
        layer = Image.new("RGB", (W, H), col)
        m = Image.new("L", (W, H), 0)
        ImageDraw.Draw(m).ellipse((cx - r, cy - r, cx + r, cy + r), fill=int(a * glow))
        im = Image.composite(layer, im, m.filter(ImageFilter.GaussianBlur(r * 0.6)))
    return im


def texto_espaciado(d, xy_centro, txt, font, fill, espacio):
    anchos = [d.textlength(c, font=font) for c in txt]
    total = sum(anchos) + espacio * (len(txt) - 1)
    x = xy_centro[0] - total / 2
    for c, w in zip(txt, anchos):
        d.text((x, xy_centro[1]), c, font=font, fill=fill, anchor="lm")
        x += w + espacio


def marca(im):
    cx = 960                           # centro del bloque (tercio izquierdo)
    logo = Image.open(LOGO).convert("RGBA")
    lh = 760
    logo = logo.resize((lh, lh), Image.LANCZOS)
    ly = 1080 - 560
    # brillo del logo
    glow = Image.new("RGBA", logo.size, CYAN + (0,))
    glow.putalpha(logo.getchannel("A").point(lambda a: a * 0.55))
    glow = glow.filter(ImageFilter.GaussianBlur(40))
    im.paste(glow, (cx - lh // 2, ly), glow)
    im.paste(logo, (cx - lh // 2, ly), logo)

    # "NIRI" con degradado cian -> violeta
    big = ImageFont.truetype(str(FONTS / "Montserrat-Bold.ttf"), 210)
    y = ly + lh + 130
    m = Image.new("L", (W, H), 0)
    texto_espaciado(ImageDraw.Draw(m), (cx, y), "NIRI", big, 255, 60)
    grad = Image.new("RGB", (W, H))
    gd = ImageDraw.Draw(grad)
    x0, x1 = cx - 420, cx + 420
    for x in range(x0, x1):
        t = (x - x0) / (x1 - x0)
        gd.line([(x, 0), (x, H)], fill=tuple(int(CYAN[i] * (1 - t) + VIOLET[i] * t) for i in range(3)))
    gd.rectangle((0, 0, x0, H), fill=CYAN)
    gd.rectangle((x1, 0, W, H), fill=VIOLET)
    halo = Image.new("RGB", (W, H), CYAN)
    im.paste(halo, (0, 0), m.filter(ImageFilter.GaussianBlur(28)).point(lambda a: a * 0.5))
    im.paste(grad, (0, 0), m)

    small = ImageFont.truetype(str(FONTS / "Montserrat-Medium.ttf"), 54)
    texto_espaciado(ImageDraw.Draw(im), (cx, y + 190), "ARCH  |  NIRI  |  LIBRE", small, (180, 192, 220), 14)
    return im


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for nombre, (bg, grid, glow) in VARIANTES.items():
        im = marca(fondo(bg, grid, glow))
        dst = OUT / f"maospix-niri-{nombre}.png"
        im.save(dst, optimize=True)
        print(dst)


if __name__ == "__main__":
    main()
