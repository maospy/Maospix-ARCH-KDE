#!/usr/bin/env python3
"""Fondos neón retro oscuros de Maospix. Uso: build/venv/bin/python tools/gen-neon.py DESTINO [escala]
escala 1 = 1920x1080 (boceto), 2 = 3840x2160. Requiere rsvg-convert."""
import io, math, random, subprocess, sys
from pathlib import Path
from PIL import Image, ImageChops, ImageFilter

R = Path(__file__).resolve().parent.parent
OUT = Path(sys.argv[1]); K = float(sys.argv[2]) if len(sys.argv) > 2 else 1
W, H, CX, CY = 1920, 1080, 960, 540
C, V, P, M = "#4fd8e8", "#b393f5", "#ff5fc8", "#8a4dff"   # cian, violeta, rosa neón, morado
DEF = f'''<defs>
<filter id="g" x="-50%" y="-50%" width="200%" height="200%" filterUnits="objectBoundingBox"><feGaussianBlur stdDeviation="7" result="a"/><feGaussianBlur in="SourceGraphic" stdDeviation="2" result="b"/><feMerge><feMergeNode in="a"/><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter>
<filter id="G" x="-20" y="-20" width="{W+40}" height="{H+40}" filterUnits="userSpaceOnUse"><feGaussianBlur stdDeviation="22" result="a"/><feGaussianBlur in="SourceGraphic" stdDeviation="6" result="b"/><feMerge><feMergeNode in="a"/><feMergeNode in="a"/><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter>
<filter id="B" x="-100" y="-100" width="{W+200}" height="{H+200}" filterUnits="userSpaceOnUse"><feGaussianBlur stdDeviation="70"/></filter>
<filter id="b" x="-100" y="-100" width="{W+200}" height="{H+200}" filterUnits="userSpaceOnUse"><feGaussianBlur stdDeviation="14"/></filter>
<linearGradient id="cielo" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#04050b"/><stop offset=".45" stop-color="#0a0b1c"/><stop offset=".72" stop-color="#1b1038"/><stop offset="1" stop-color="#070812"/></linearGradient>
<linearGradient id="sol" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="{C}"/><stop offset=".45" stop-color="{V}"/><stop offset="1" stop-color="{P}"/></linearGradient>
<radialGradient id="vi" cx=".5" cy=".5" r=".75"><stop offset=".45" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".72"/></radialGradient>
</defs>'''


def estrellas(n, ymax, semilla):
    r = random.Random(semilla); o = []
    for _ in range(n):
        y = ymax * r.random() ** 1.4
        o.append(f'<circle cx="{r.uniform(0,W):.1f}" cy="{y:.1f}" r="{r.choice((.6,.8,.8,1.1,1.5))}" fill="{r.choice(("#fff","#fff",C,V))}" opacity="{r.uniform(.15,.75):.2f}"/>')
    return "".join(o)


def piso(hz, col1, col2, paso=120, n=16):
    """Cuadrícula en perspectiva desde el horizonte hz."""
    o = [f'<defs><linearGradient id="pf" x1="0" y1="{hz}" x2="0" y2="{H}" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="{col1}"/><stop offset="1" stop-color="{col2}"/></linearGradient><linearGradient id="ps" x1="0" y1="{hz}" x2="0" y2="{H}" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="#140a2c"/><stop offset=".5" stop-color="#070916"/><stop offset="1" stop-color="#04050b"/></linearGradient></defs><rect x="0" y="{hz}" width="{W}" height="{H-hz}" fill="url(#ps)"/>']
    d = "".join(f"M{CX} {hz}L{CX+i*paso*6:.0f} {hz+(H-hz)*1.9:.0f}" for i in range(-46, 47))
    d2 = "".join(f"M0 {y:.1f}H{W}" for y in (hz + (H - hz) * (i / n) ** 2.3 for i in range(1, n + 1)))
    o.append(f'<defs><linearGradient id="pm" x1="0" y1="{hz}" x2="0" y2="{H}" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="#000"/><stop offset=".16" stop-color="#fff"/><stop offset="1" stop-color="#777"/></linearGradient><mask id="mk"><rect y="{hz}" width="{W}" height="{H-hz}" fill="url(#pm)"/></mask></defs>')
    o.append(f'<g mask="url(#mk)"><g stroke="url(#pf)" fill="none" stroke-width="1.5" opacity=".75" filter="url(#G)"><path d="{d}"/><path d="{d2}"/></g></g>')
    return "".join(o)


def linea(hz, col):
    return f'<rect x="0" y="{hz-40}" width="{W}" height="80" fill="{col}" opacity=".28" filter="url(#b)"/><path d="M0 {hz}H{W}" stroke="#fff" stroke-width="1.6" opacity=".85"/><path d="M0 {hz}H{W}" stroke="{col}" stroke-width="4" opacity=".7" filter="url(#G)"/>'


def sol(cx, cy, r, cortes=9, op=1):
    ys = []
    for i in range(cortes):
        y = cy - r * .08 + (r * 1.08) * (i / cortes); ys.append(f'<rect x="{cx-r}" y="{y:.1f}" width="{2*r}" height="{4+i*r*.0135:.1f}" fill="#000"/>')
    return (f'<defs><mask id="ms"><rect x="{cx-r-9}" y="{cy-r-9}" width="{2*r+18}" height="{2*r+18}" fill="#fff"/>{"".join(ys)}</mask></defs>'
            f'<circle cx="{cx}" cy="{cy}" r="{r*1.12}" fill="{M}" opacity=".5" filter="url(#B)"/><circle cx="{cx}" cy="{cy}" r="{r}" fill="url(#sol)" mask="url(#ms)" opacity="{op}"/>')


def hexa(r, rot=90, cx=CX, cy=CY):
    return [(cx + r * math.cos(math.radians(rot + 60 * i)), cy + r * math.sin(math.radians(rot + 60 * i))) for i in range(6)]


def camino(p, cerrar=True):
    return "M" + "L".join(f"{x:.1f} {y:.1f}" for x, y in p) + ("Z" if cerrar else "")


def tubo(d, col, w=6):
    return f'<path d="{d}" fill="none" stroke="{col}" stroke-width="{w}" stroke-linejoin="round" stroke-linecap="round" filter="url(#G)"/><path d="{d}" fill="none" stroke="#fff" stroke-width="{w*.32}" stroke-linejoin="round" stroke-linecap="round" opacity=".92"/>'


def horizonte():
    hz = 742; r = 372
    rayas = "".join(f'<rect x="{CX-r-10}" y="{CY+60+i*34}" width="{2*r+20}" height="{5+i*2.2}" fill="#000"/>' for i in range(9))
    s = f'<rect width="{W}" height="{H}" fill="url(#cielo)"/>{estrellas(330,hz-30,4)}<ellipse cx="{CX}" cy="{hz-40}" rx="900" ry="200" fill="{M}" opacity=".32" filter="url(#B)"/>'
    s += f'<defs><mask id="mr"><rect width="{W}" height="{hz}" fill="#fff"/>{rayas}</mask></defs><circle cx="{CX}" cy="{CY}" r="{r}" fill="none" stroke="url(#sol)" stroke-width="9" filter="url(#G)"/><g mask="url(#mr)"><circle cx="{CX}" cy="{CY}" r="{r-5}" fill="#0a0818" opacity=".9"/><circle cx="{CX}" cy="{CY}" r="{r-24}" fill="none" stroke="{V}" stroke-width="1.5" opacity=".5"/></g>'
    rnd = random.Random(9)
    def sierra(y0, amp, col, op, sem):
        rr = random.Random(sem); p = [(-20, hz)]; x = -20
        while x < W + 60:
            lejos = min(1, max(.06, (abs(x - CX) - 330) / 520)); p.append((x, y0 - amp * lejos * rr.uniform(.35, 1))); x += rr.uniform(46, 96)
        p.append((W + 60, hz)); d = camino(p)
        return f'<path d="{d}" fill="#080916"/><path d="{camino(p[1:-1],False)}" fill="none" stroke="{col}" stroke-width="2" opacity="{op}" filter="url(#G)"/>' + "".join(f'<path d="M{a:.0f} {b:.0f}L{a+rr.uniform(-40,40):.0f} {hz}" stroke="{col}" stroke-width=".8" opacity="{op*.35}"/>' for a, b in p[1:-1])
    s += sierra(hz, 200, V, .55, 3) + sierra(hz, 112, P, .8, 12) + piso(hz, P, C) + linea(hz, P)
    return s, 600


def letrero():
    r = random.Random(7); bw, bh = 96, 38; o = []
    for j in range(-1, H // bh + 2):
        for i in range(-1, W // bw + 2):
            t = r.uniform(.0, 1); o.append(f'<rect x="{i*bw+(bw/2 if j%2 else 0)+2}" y="{j*bh+2}" width="{bw-4}" height="{bh-4}" rx="2.5" fill="rgb({int(13+7*t)},{int(14+7*t)},{int(26+12*t)})"/>')
    s = f'<rect width="{W}" height="{H}" fill="#05060c"/>{"".join(o)}'
    s += f'<defs><radialGradient id="l1" cx="{CX}" cy="{CY}" r="760" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="{M}" stop-opacity=".5"/><stop offset=".42" stop-color="{M}" stop-opacity=".3"/><stop offset="1" stop-color="{M}" stop-opacity="0"/></radialGradient><radialGradient id="l2" cx="{CX-420}" cy="{CY+60}" r="560" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="{C}" stop-opacity=".26"/><stop offset="1" stop-color="{C}" stop-opacity="0"/></radialGradient><radialGradient id="l3" cx="{CX+420}" cy="{CY-40}" r="560" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="{P}" stop-opacity=".28"/><stop offset="1" stop-color="{P}" stop-opacity="0"/></radialGradient></defs>'
    s += "".join(f'<rect width="{W}" height="{H}" fill="url(#l{i})" style="mix-blend-mode:screen"/>' for i in (1, 2, 3))
    h1, h2 = hexa(455), hexa(412)
    # sombra de los tubos sobre la pared
    s += f'<path d="{camino([(x+8,y+14) for x,y in h1])}" fill="none" stroke="#000" stroke-width="12" opacity=".55" filter="url(#b)"/>'
    m = lambda a, b, t: (a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t)
    iz = [m(h1[5], h1[0], .86), *[h1[0], h1[1], h1[2], h1[3]]]
    iz = [m(h1[0], h1[1], .06), h1[1], h1[2], m(h1[2], h1[3], .94)]; de = [m(h1[3], h1[4], .06), h1[4], h1[5], m(h1[5], h1[0], .94)]
    s += tubo(camino(iz, False), C, 8) + tubo(camino(de, False), P, 8)
    s += tubo(camino([m(h2[1], h2[2], .12), m(h2[1], h2[2], .88)], False), V, 4) + tubo(camino([m(h2[4], h2[5], .12), m(h2[4], h2[5], .88)], False), V, 4)
    for dx, col in ((-1, C), (1, P)):      # trazos laterales tipo letrero de los 80
        for k, (a, b) in enumerate(((520, 800), (560, 740), (600, 690))):
            y = CY - 34 + k * 34; s += tubo(f"M{CX+dx*a} {y}H{CX+dx*b}", col, 5)
    for x, y in (h1[0], h1[3]):
        s += f'<path d="M{x} {y}V{H if y>CY else 0}" stroke="#03040a" stroke-width="5"/><circle cx="{x}" cy="{y}" r="9" fill="#0b0d18" stroke="#2b3350" stroke-width="2"/>'
    return s, 600


def edificios(base, sem, hmin, hmax, col, wmin=50, wmax=120, luz=.22, hueco=None):
    r = random.Random(sem); x = -20; o = []
    while x < W + 20:
        w = r.uniform(wmin, wmax); h = r.uniform(hmin, hmax)
        if hueco: h *= .42 + .58 * min(1, abs(x + w / 2 - hueco) / 620)
        y = base - h; o.append(f'<rect x="{x:.0f}" y="{y:.0f}" width="{w+1:.0f}" height="{h+2:.0f}" fill="{col}"/>')
        if r.random() < .35: o.append(f'<path d="M{x+w/2:.0f} {y:.0f}v-{r.uniform(20,60):.0f}" stroke="{col}" stroke-width="3"/>')
        lc = r.choice((C, P, V, "#ffd9a0"))
        for yy in range(int(y) + 12, int(base) - 10, 17):
            for xx in range(int(x) + 9, int(x + w) - 10, 14):
                if r.random() < luz: o.append(f'<rect x="{xx}" y="{yy}" width="6" height="8" fill="{lc if r.random()<.75 else "#cfd8ff"}" opacity="{r.uniform(.25,.85):.2f}"/>')
        if luz and r.random() < .22:
            e = r.choice((C, P, V)); o.append(f'<path d="M{x+w-5:.0f} {y+14:.0f}v{h*.55:.0f}" stroke="{e}" stroke-width="3" filter="url(#g)"/>')
        x += w + r.choice((0, 0, 4, 14))
    return "".join(o)


def gato(cx, base, e):
    """Silueta propia: gatito sentado de espaldas, con orejas como las del escudo."""
    p = lambda x, y: f"{cx+x*e:.1f} {base+y*e:.1f}"
    d = f"M{p(-46,0)}C{p(-64,-60)} {p(-44,-112)} {p(-30,-128)}C{p(-46,-146)} {p(-46,-166)} {p(-42,-180)}L{p(-40,-222)}L{p(-14,-196)}C{p(-5,-199)} {p(5,-199)} {p(14,-196)}L{p(40,-222)}L{p(42,-180)}C{p(46,-166)} {p(46,-146)} {p(30,-128)}C{p(44,-112)} {p(64,-60)} {p(46,0)}Z"
    cola = f"M{p(44,-6)}C{p(112,2)} {p(120,-62)} {p(84,-74)}"
    return (f'<path d="{d}" fill="#05060d"/><path d="{cola}" fill="none" stroke="#05060d" stroke-width="{17*e}" stroke-linecap="round"/>'
            f'<path d="{d}" fill="none" stroke="{C}" stroke-width="2.4" opacity=".9" filter="url(#G)"/>')


def ciudad():
    hz = 800
    s = f'<rect width="{W}" height="{H}" fill="url(#cielo)"/>{estrellas(260,560,21)}<ellipse cx="{CX}" cy="{hz-60}" rx="1000" ry="230" fill="{M}" opacity=".4" filter="url(#B)"/>'
    s += sol(CX, 520, 270) + edificios(hz, 5, 120, 360, "#150d2b", 60, 130, .07, CX) + f'<rect y="{hz-260}" width="{W}" height="260" fill="{P}" opacity=".10" filter="url(#B)"/>' + edificios(hz, 11, 70, 400, "#080916", 60, 140, .2, CX)
    # reflejo en el asfalto mojado
    s += f'<defs><linearGradient id="rf" x1="0" y1="{hz}" x2="0" y2="{H}" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="#fff" stop-opacity=".5"/><stop offset="1" stop-color="#fff" stop-opacity="0"/></linearGradient><mask id="mf"><rect y="{hz}" width="{W}" height="{H-hz}" fill="url(#rf)"/></mask></defs><rect y="{hz}" width="{W}" height="{H-hz}" fill="#05060d"/><g mask="url(#mf)"><g transform="matrix(1,0,0,-.72,0,{hz*1.72:.0f})" filter="url(#b)" opacity=".85">{edificios(hz,11,70,400,"#080916",60,140,.2,CX)}</g><ellipse cx="{CX}" cy="{hz}" rx="250" ry="230" fill="url(#sol)" opacity=".5" filter="url(#b)"/></g>'
    r = random.Random(3)
    s += "".join(f'<path d="M{CX+r.gauss(0,160):.0f} {y:.0f}h{r.uniform(40,190):.0f}" stroke="{r.choice((P,V,C))}" stroke-width="1.6" opacity="{r.uniform(.15,.5):.2f}"/>' for y in [hz + 8 + i * 6.5 for i in range(38)])
    s += linea(hz, V) + gato(CX, hz + 2, 1.05)
    return s, 190


def ondas():
    s = f'<rect width="{W}" height="{H}" fill="url(#cielo)"/>{estrellas(300,460,33)}<ellipse cx="1180" cy="560" rx="780" ry="260" fill="{M}" opacity=".36" filter="url(#B)"/>' + sol(1180, 500, 205)
    n = 26
    for j in range(n):
        t = j / (n - 1); y0 = 560 + 560 * t ** 1.5; amp = 26 + 120 * t; p = []
        for x in range(-20, W + 41, 20):
            u = x / W; v = math.sin(u * 5.2 + t * 2.6) * .6 + math.sin(u * 11.3 - t * 4.1 + 1.2) * .3 + math.sin(u * 2.1 + 2 + t) * .55
            p.append((x, y0 - amp * v))
        col = (C, V, P)[min(2, int(t * 3))]; d = camino(p, False)
        s += f'<path d="{d}L{W+40} {H+40}L-20 {H+40}Z" fill="#05060e" fill-opacity=".86"/><path d="{d}" fill="none" stroke="{col}" stroke-width="{1.1+1.7*t:.2f}" opacity="{.45+.45*t:.2f}" filter="url(#G)"/>'
    return s, 190


def render(nombre, f):
    s, logo = f()
    svg = f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" width="{W*K:.0f}" height="{H*K:.0f}">{DEF}{s}<rect width="{W}" height="{H}" fill="url(#vi)"/></svg>'
    b = subprocess.run(["rsvg-convert", "--unlimited"], input=svg.encode(), stdout=subprocess.PIPE, check=True).stdout
    im = Image.open(io.BytesIO(b)).convert("RGB")
    r = Image.effect_noise(im.size, 4)      # grano mínimo: evita bandas en los degradados oscuros
    im = ImageChops.add(im, Image.merge("RGB", (r, r, r)), 1, -128)
    if logo:
        l = Image.open(R / "assets/branding/maospix-logo-neon.png").convert("RGBA"); l = l.crop(l.getchannel("A").point(lambda a: 255 if a > 40 else 0).getbbox())
        e = 1 if logo > 400 else .35
        h = round(logo * K); l = l.resize((round(l.width * h / l.height), h), Image.LANCZOS)
        if logo > 400:
            x, y = (im.width - l.width) // 2, (im.height - l.height) // 2
        else:   # abajo a la derecha: libre de barras, reloj y widgets; el margen aguanta el recorte 16:10
            x, y = im.width - l.width - round(165 * K), im.height - l.height - round(70 * K)
            q = (im.width // 8, im.height // 8); f = Image.new("L", im.size, 0); f.paste(l.getchannel("A"), (x, y))
            f = f.resize(q).filter(ImageFilter.GaussianBlur(46 * K / 8)).resize(im.size, Image.BICUBIC).point(lambda v: min(225, int(v * 1.5)))
            im.paste(Image.new("RGB", im.size, (5, 6, 14)), (0, 0), f)
        for rad, col, a in ((60 * e, (138, 77, 255), .75), (18 * e, (79, 216, 232), .55)):
            g = Image.new("L", im.size, 0); g.paste(l.getchannel("A"), (x, y)); q = (im.width // 4, im.height // 4)
            g = g.resize(q).filter(ImageFilter.GaussianBlur(rad * K / 4)).resize(im.size, Image.BICUBIC).point(lambda v: int(v * a))
            im.paste(Image.new("RGB", im.size, col), (0, 0), g)
        im.paste(l, (x, y), l)
    im.save(OUT / f"{nombre}.png", optimize=False); print(nombre, im.size, flush=True)


if __name__ == "__main__":
    OUT.mkdir(parents=True, exist_ok=True)
    T = {"Maospix-Neon-Horizonte": horizonte, "Maospix-Neon-Letrero": letrero, "Maospix-Neon-Ciudad": ciudad, "Maospix-Neon-Ondas": ondas}
    for n in (sys.argv[3:] or T):
        render(n, T[n])
