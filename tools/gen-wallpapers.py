#!/usr/bin/env python3
"""Fondos 4K de Maospix-ARCH-KDE: la familia de Maospix-Niri reinterpretada al estilo suave de Mokka.
Uso: build/venv/bin/python tools/gen-wallpapers.py"""
import json
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter, ImageFont

R = Path(__file__).resolve().parent.parent
OUT = R / "packages/maospix-arch-kde-theme/rootfs/usr/share/wallpapers"
W, H = 3840, 2160
CYAN, VIOLET, PINK = (79, 216, 232), (179, 147, 245), (214, 140, 245)
VAR = {  # fondo, puntos, halos (x, y, radio, color, fuerza)
    "Maospix": ((15, 21, 36), (92, 116, 160), [(1920, 1060, 1000, CYAN, 40), (3350, 1850, 1200, VIOLET, 50), (3500, 150, 800, PINK, 18)]),
    "Maospix-Violeta": ((24, 18, 44), (116, 98, 168), [(1920, 1060, 1000, VIOLET, 54), (3350, 1850, 1200, PINK, 40), (3400, 200, 900, CYAN, 22)]),
    "Maospix-Nord": ((46, 58, 76), (104, 124, 154), [(1920, 1060, 1150, CYAN, 40), (3350, 1850, 1250, VIOLET, 44)]),
    "Maospix-Negro": ((7, 9, 13), (62, 74, 98), [(1920, 1060, 1100, CYAN, 46), (3350, 1850, 1200, VIOLET, 52)]),
    "Maospix-Grafito": ((43, 44, 49), (98, 100, 110), [(1920, 1060, 1150, CYAN, 30), (3350, 1850, 1250, VIOLET, 34)]),
}
F = lambda n, s: ImageFont.truetype(str(R / f"assets/fonts/Montserrat-{n}.ttf"), s)


def blur(m, r):
    """Desenfoque grande a 1/8 de tamaño: igual a la vista y mucho más rápido."""
    s = m.resize((m.width // 8, m.height // 8), Image.BILINEAR).filter(ImageFilter.GaussianBlur(r / 8))
    return s.resize(m.size, Image.BICUBIC)


def fondo(bg, dot, halos):
    im = Image.new("RGB", (W, H), bg)
    for cx, cy, r, col, a in halos:
        m = Image.new("L", (W, H), 0)
        ImageDraw.Draw(m).ellipse((cx - r, cy - r, cx + r, cy + r), fill=a)
        im.paste(Image.new("RGB", (W, H), col), (0, 0), blur(m, r * 0.55))
    # ondas redondeadas al pie: el toque suave de Mokka
    for i, (y, col, a) in enumerate(((1660, VIOLET, 12), (1800, CYAN, 10), (1940, VIOLET, 15))):
        m = Image.new("L", (W, H), 0)
        ImageDraw.Draw(m).ellipse((-900 + i * 420, y, W + 500 + i * 300, y + 2100), fill=a)
        im.paste(Image.new("RGB", (W, H), col), (0, 0), m.filter(ImageFilter.GaussianBlur(2)))
    # cuadrícula de Niri convertida en puntos, desvanecida hacia los bordes
    g = Image.new("L", (W, H), 0)
    d = ImageDraw.Draw(g)
    for x in range(40, W, 80):
        for y in range(40, H, 80):
            d.ellipse((x - 3, y - 3, x + 3, y + 3), fill=255)
    v = Image.new("L", (W, H), 0)
    ImageDraw.Draw(v).ellipse((0, -300, W, H - 100), fill=255)
    g = Image.composite(g, Image.new("L", (W, H), 0), blur(v, 420))
    im.paste(Image.new("RGB", (W, H), dot), (0, 0), g)
    return im


def texto(d, cx, y, t, f, fill, esp):
    w = [d.textlength(c, font=f) for c in t]
    x = cx - (sum(w) + esp * (len(t) - 1)) / 2
    for c, a in zip(t, w):
        d.text((x, y), c, font=f, fill=fill, anchor="lm")
        x += a + esp


def marca(im):
    """Logo + nombre + lema en una capa; se centra por su caja real, al píxel."""
    logo = Image.open(R / "assets/branding/maospix-logo-neon.png").convert("RGBA")
    logo = logo.crop(logo.getchannel("A").point(lambda a: 255 if a > 40 else 0).getbbox())
    logo = logo.resize((round(logo.width * 720 / logo.height), 720), Image.LANCZOS)
    capa = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    cx, y = W // 2, 400
    capa.paste(logo, (cx - logo.width // 2, y), logo)
    m = Image.new("L", (W, H), 0)
    texto(ImageDraw.Draw(m), cx, y + 900, "ARCH KDE", F("Bold", 168), 255, 34)
    g = Image.new("RGB", (W, H), VIOLET)
    gd = ImageDraw.Draw(g)
    a, b = cx - 560, cx + 560
    for i in range(0, b):
        t = min(max((i - a) / (b - a), 0), 1)
        gd.line([(i, 0), (i, H)], fill=tuple(int(CYAN[k] * (1 - t) + VIOLET[k] * t) for k in range(3)))
    capa.paste(g, (0, 0), m)
    texto(ImageDraw.Draw(capa), cx, y + 1070, "ARCH  |  PLASMA  |  LIBRE", F("Medium", 50), (190, 201, 228, 255), 14)
    caja = capa.getchannel("A").point(lambda v: 255 if v > 40 else 0).getbbox()
    pieza = capa.crop(caja)
    x, y = (W - pieza.width) // 2, (H - pieza.height) // 2
    m = Image.new("L", (W, H), 0)
    m.paste(pieza.getchannel("A"), (x, y))
    im.paste(Image.new("RGB", (W, H), CYAN), (0, 0), blur(m, 70).point(lambda v: int(v * 0.45)))
    im.paste(pieza, (x, y), pieza)
    print("  bloque", pieza.size, "centro", (x + pieza.width / 2, y + pieza.height / 2))


def guardar(nombre, im, ext="png"):
    d = OUT / nombre / "contents/images"
    d.mkdir(parents=True, exist_ok=True)
    for viejo in d.iterdir():
        viejo.unlink()
    f = d / f"3840x2160.{ext}"
    im.save(f, optimize=True) if ext == "png" else im.save(f, quality=90)
    (OUT / nombre / "metadata.json").write_text(json.dumps({"KPlugin": {"Authors": [{"Name": "MAOSPIX"}], "Id": nombre, "License": "CC-BY-SA-4.0", "Name": nombre.replace("-", " ")}}, indent=4) + "\n")
    print(nombre, f.stat().st_size // 1024, "KB")


for n, v in VAR.items():
    im = fondo(*v)
    marca(im)
    guardar(n, im)
guardar("Maospix-Montanas", Image.open(R / "assets/wallpapers/source/maospix-v2-mountain-dawn-v2-4k.png").convert("RGB"), "jpg")

# Fondo del greeter: sin marca, el logo lo pone la tarjeta.
s = R / "packages/maospix-arch-kde-theme/rootfs/usr/share/sddm/themes/maospix/background.png"
fondo(*VAR["Maospix"]).resize((1920, 1080), Image.LANCZOS).save(s, optimize=True)
