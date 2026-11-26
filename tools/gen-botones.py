#!/usr/bin/env python3
"""Botones de ventana estilo Windows (sin colores) para el tema Aurorae Maospix."""
import pathlib
A = pathlib.Path(__file__).resolve().parent.parent / "packages/maospix-arch-kde-theme/rootfs/usr/share/aurorae/themes/Maospix"
W, H = 40, 28
S = 'fill="none" stroke="{c}" stroke-width="1.2" stroke-linecap="square" stroke-linejoin="miter"'
G = {
    "minimize": '<path d="M15.5 14.5h9" {s}/>',
    "maximize": '<rect x="15.5" y="9.5" width="9" height="9" {s}/>',
    "restore": '<rect x="15.5" y="11.5" width="7" height="7" {s}/><path d="M17.5 11.5v-2h7v7h-2" {s}/>',
    "close": '<path d="M15.7 9.7l8.6 8.6M24.3 9.7l-8.6 8.6" {s}/>',
}
# estado: (color del símbolo, opacidad del fondo gris)
E = [("active", "#e6ecff", 0), ("hover", "#ffffff", .14), ("pressed", "#ffffff", .24), ("inactive", "#8290b0", 0),
     ("hover-inactive", "#ffffff", .14), ("pressed-inactive", "#ffffff", .24), ("deactivated", "#3a4868", 0), ("deactivated-inactive", "#3a4868", 0)]
for n, g in G.items():
    o = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{(W+10)*len(E)}" height="{H}" viewBox="0 0 {(W+10)*len(E)} {H}">']
    for i, (e, c, f) in enumerate(E):
        o.append(f'<g id="{e}-center" transform="translate({i*(W+10)},0)"><rect width="{W}" height="{H}" rx="6" fill="#e6ecff" fill-opacity="{f}"/>{g.format(s=S.format(c=c))}</g>')
    (A / f"{n}.svg").write_text("\n".join(o + ["</svg>\n"]))
