#!/usr/bin/env python3
"""
Tender Cartography — Illustration Sheet for EE和粽子
4 refined line-art illustrations in a 2x2 grid
Second pass: pristine, museum-quality refinement
"""

from PIL import Image, ImageDraw, ImageFont
import math
import os

# Canvas setup
W, H = 1600, 1600
HALF = W // 2
BG = (250, 249, 245)       # #faf9f5
INK = (20, 20, 19)         # #141413
INK_LIGHT = (176, 174, 165) # #b0aea5
ORANGE = (217, 119, 87)    # #d97757
ORANGE_FAINT = (217, 119, 87, 14)
GREEN = (120, 140, 93)     # #788c5d
GREEN_FAINT = (120, 140, 93, 14)

STROKE = 2
STROKE_FINE = 1

img = Image.new('RGBA', (W, H), BG + (255,))
draw = ImageDraw.Draw(img, 'RGBA')

# Load font
font_dir = os.path.expanduser("~/.claude/skills/canvas-design/canvas-fonts/")
try:
    font_label = ImageFont.truetype(os.path.join(font_dir, "Jura-Light.ttf"), 20)
    font_tiny = ImageFont.truetype(os.path.join(font_dir, "Jura-Light.ttf"), 14)
except:
    font_label = ImageFont.load_default()
    font_tiny = ImageFont.load_default()

# Divider lines (barely visible)
draw.line([(HALF, 80), (HALF, H-80)], fill=INK_LIGHT + (25,), width=1)
draw.line([(80, HALF), (W-80, HALF)], fill=INK_LIGHT + (25,), width=1)

# ============================================================
# Helpers
# ============================================================
def smooth_curve(draw, points, fill, width=STROKE, steps=20):
    """Draw smooth Catmull-Rom curve through control points."""
    if len(points) < 2:
        return
    all_pts = []
    for i in range(len(points)):
        p0 = points[max(0, i-1)]
        p1 = points[i]
        p2 = points[min(len(points)-1, i+1)]
        p3 = points[min(len(points)-1, i+2)]
        for t_step in range(steps):
            t = t_step / steps
            t2 = t*t; t3 = t2*t
            x = 0.5*(2*p1[0]+(-p0[0]+p2[0])*t+(2*p0[0]-5*p1[0]+4*p2[0]-p3[0])*t2+(-p0[0]+3*p1[0]-3*p2[0]+p3[0])*t3)
            y = 0.5*(2*p1[1]+(-p0[1]+p2[1])*t+(2*p0[1]-5*p1[1]+4*p2[1]-p3[1])*t2+(-p0[1]+3*p1[1]-3*p2[1]+p3[1])*t3)
            all_pts.append((x, y))
    all_pts.append(points[-1])
    for i in range(len(all_pts)-1):
        draw.line([all_pts[i], all_pts[i+1]], fill=fill, width=width)

def draw_circle(draw, cx, cy, r, fill=None, outline=INK, width=STROKE):
    draw.ellipse([cx-r, cy-r, cx+r, cy+r], fill=fill, outline=outline, width=width)

def draw_heart(draw, cx, cy, size, fill=None, outline=INK, width=STROKE_FINE):
    pts = []
    for deg in range(360):
        t = math.radians(deg)
        x = size * math.sin(t)**3
        y = -size * (13*math.cos(t)-5*math.cos(2*t)-2*math.cos(3*t)-math.cos(4*t))/16
        pts.append((cx+x, cy+y))
    pts.append(pts[0])
    if fill:
        draw.polygon(pts, fill=fill)
    for i in range(len(pts)-1):
        draw.line([pts[i], pts[i+1]], fill=outline, width=width)

def draw_zongzi(draw, cx, cy, scale=1.0, fill_color=None, outline_color=ORANGE, width=STROKE):
    """Draw a proper zongzi (triangle/pyramid with rounded bottom)."""
    pts = []
    # Triangular shape: pointed top, wide rounded bottom
    for deg in range(360):
        t = math.radians(deg)
        # Base triangle shape with rounded corners
        # Top vertex at 0°, bottom-left at 240°, bottom-right at 120°
        r = scale * 100
        # Create a rounded triangle
        x_raw = math.sin(t)
        y_raw = -math.cos(t)

        # Superellipse-triangle hybrid
        # Triangle: higher power on top, softer on bottom
        if deg <= 180:
            # Right side
            squeeze = 0.65 + 0.35 * math.sin(t)
        else:
            squeeze = 0.65 + 0.35 * math.sin(t)

        # Triangular modification — pointed top, wide bottom
        top_pull = max(0, math.cos(t))  # strongest at top (0°)
        bottom_expand = max(0, -math.cos(t))  # strongest at bottom (180°)

        r_mod = r * (0.7 + 0.1 * bottom_expand - 0.25 * top_pull**2)
        # Make sides slightly concave for elegance
        side_factor = abs(math.sin(t))
        r_mod *= (0.95 + 0.05 * (1 - side_factor**0.5))

        x = cx + r_mod * math.sin(t)
        y = cy + r_mod * (-math.cos(t)) * (0.75 + 0.25 * (1 - top_pull))
        # Shift down to center visually
        y += scale * 15
        pts.append((x, y))

    if fill_color:
        draw.polygon(pts, fill=fill_color)
    for i in range(len(pts)-1):
        draw.line([pts[i], pts[i+1]], fill=outline_color, width=width)
    draw.line([pts[-1], pts[0]], fill=outline_color, width=width)
    return pts

# ============================================================
# PANEL 1 — TOP LEFT: Mother cradling baby
# ============================================================
p1x, p1y = 400, 370  # panel center

# Mom — flowing continuous line portrait
# Hair flowing from left
hair = [
    (p1x-80, p1y-120), (p1x-100, p1y-160), (p1x-80, p1y-200),
    (p1x-40, p1y-230), (p1x+10, p1y-240), (p1x+60, p1y-230),
    (p1x+90, p1y-200), (p1x+100, p1y-160), (p1x+85, p1y-120)
]
smooth_curve(draw, hair, INK, STROKE)

# Hair detail — a single flowing strand
hair_strand = [(p1x-85, p1y-130), (p1x-95, p1y-80), (p1x-90, p1y-40)]
smooth_curve(draw, hair_strand, INK, STROKE_FINE)
hair_strand2 = [(p1x-75, p1y-125), (p1x-80, p1y-90), (p1x-82, p1y-50)]
smooth_curve(draw, hair_strand2, INK_LIGHT + (120,), STROKE_FINE)

# Face — jaw line
face = [
    (p1x-70, p1y-120), (p1x-75, p1y-70), (p1x-60, p1y-25),
    (p1x-20, p1y+5), (p1x+20, p1y+5), (p1x+55, p1y-20),
    (p1x+75, p1y-65), (p1x+80, p1y-120)
]
smooth_curve(draw, face, INK, STROKE)

# Closed eyes (gentle crescents — the signature "happy mom" look)
leye = [(p1x-40, p1y-75), (p1x-30, p1y-82), (p1x-18, p1y-78)]
smooth_curve(draw, leye, INK, STROKE)
reye = [(p1x+15, p1y-78), (p1x+27, p1y-85), (p1x+38, p1y-80)]
smooth_curve(draw, reye, INK, STROKE)

# Soft smile
smile = [(p1x-18, p1y-40), (p1x, p1y-33), (p1x+18, p1y-38)]
smooth_curve(draw, smile, INK, STROKE_FINE)

# Neck
neck_l = [(p1x-25, p1y+5), (p1x-30, p1y+30)]
smooth_curve(draw, neck_l, INK, STROKE)
neck_r = [(p1x+25, p1y+5), (p1x+30, p1y+30)]
smooth_curve(draw, neck_r, INK, STROKE)

# Shoulders flowing into arms
shoulder_l = [(p1x-30, p1y+30), (p1x-70, p1y+50), (p1x-120, p1y+80), (p1x-140, p1y+120)]
smooth_curve(draw, shoulder_l, INK, STROKE)
shoulder_r = [(p1x+30, p1y+30), (p1x+70, p1y+50), (p1x+120, p1y+80), (p1x+140, p1y+120)]
smooth_curve(draw, shoulder_r, INK, STROKE)

# Arms curving inward to hold baby
arm_l = [(p1x-140, p1y+120), (p1x-120, p1y+160), (p1x-80, p1y+190), (p1x-40, p1y+200)]
smooth_curve(draw, arm_l, INK, STROKE)
arm_r = [(p1x+140, p1y+120), (p1x+120, p1y+160), (p1x+80, p1y+190), (p1x+40, p1y+200)]
smooth_curve(draw, arm_r, INK, STROKE)

# Baby zongzi nestled in arms — orange, triangular-ish
baby_body = [
    (p1x, p1y+100), (p1x-30, p1y+130), (p1x-45, p1y+160),
    (p1x-35, p1y+190), (p1x, p1y+200), (p1x+35, p1y+190),
    (p1x+45, p1y+160), (p1x+30, p1y+130), (p1x, p1y+100)
]
# Faint fill
from PIL import ImageDraw as ID2
smooth_curve(draw, baby_body, ORANGE, STROKE)

# Baby tiny face
draw_circle(draw, p1x-12, p1y+148, 3, fill=ORANGE, outline=None)
draw_circle(draw, p1x+12, p1y+148, 3, fill=ORANGE, outline=None)
baby_smile = [(p1x-8, p1y+162), (p1x, p1y+168), (p1x+8, p1y+164)]
smooth_curve(draw, baby_smile, ORANGE, STROKE_FINE)

# Tiny bamboo leaf on baby's head
leaf_baby1 = [(p1x-2, p1y+100), (p1x-12, p1y+82), (p1x-8, p1y+72)]
smooth_curve(draw, leaf_baby1, GREEN, STROKE_FINE)
leaf_baby2 = [(p1x+2, p1y+100), (p1x+10, p1y+80), (p1x+12, p1y+70)]
smooth_curve(draw, leaf_baby2, GREEN, STROKE_FINE)

# Tiny heart floating
draw_heart(draw, p1x+80, p1y-30, 6, outline=ORANGE, width=STROKE_FINE)

# Panel number
draw.text((370, 680), "01", fill=INK_LIGHT + (80,), font=font_tiny)

# ============================================================
# PANEL 2 — TOP RIGHT: Zongzi mascot (the star)
# ============================================================
p2x, p2y = HALF + 400, 340

# Main zongzi body — proper zongzi shape:
# A zongzi is a tetrahedron wrapped in bamboo leaf.
# From the front it looks like a TRIANGLE: pointed top, wide flat bottom.
# The shape is taller than wide, like an inverted triangle with rounded corners.

# Define the 3 vertices of the triangle
top = (p2x, p2y - 130)        # apex
bl = (p2x - 95, p2y + 80)     # bottom-left
br = (p2x + 95, p2y + 80)     # bottom-right

# Build rounded triangle using cubic bezier-like curves between vertices
# with control points pulled inward for slight concavity on sides
zpts = []

# Helper: interpolate with rounding
def rounded_triangle_pts(v0, v1, v2, corner_r=0.18, steps=40):
    """Generate points for a rounded triangle."""
    vertices = [v0, v1, v2]
    pts = []
    n = len(vertices)
    for i in range(n):
        p_prev = vertices[(i-1) % n]
        p_curr = vertices[i]
        p_next = vertices[(i+1) % n]

        # Points near current vertex, pulled toward neighbors
        to_prev = (p_prev[0]-p_curr[0], p_prev[1]-p_curr[1])
        to_next = (p_next[0]-p_curr[0], p_next[1]-p_curr[1])

        start = (p_curr[0]+to_prev[0]*corner_r, p_curr[1]+to_prev[1]*corner_r)
        end = (p_curr[0]+to_next[0]*corner_r, p_curr[1]+to_next[1]*corner_r)

        # Arc from start to end around corner
        for s in range(steps):
            t = s / steps
            # Quadratic bezier through the corner
            x = (1-t)**2 * start[0] + 2*(1-t)*t * p_curr[0] + t**2 * end[0]
            y = (1-t)**2 * start[1] + 2*(1-t)*t * p_curr[1] + t**2 * end[1]
            pts.append((x, y))

        # Straight edge from end to next start
        next_v = vertices[(i+1) % n]
        next_next = vertices[(i+2) % n]
        to_curr_from_next = (p_curr[0]-next_v[0], p_curr[1]-next_v[1])
        to_nn = (next_next[0]-next_v[0], next_next[1]-next_v[1])
        edge_end = (next_v[0]+to_curr_from_next[0]*corner_r, next_v[1]+to_curr_from_next[1]*corner_r)

        for s in range(steps):
            t = s / steps
            x = end[0] + (edge_end[0]-end[0])*t
            y = end[1] + (edge_end[1]-end[1])*t
            pts.append((x, y))

    pts.append(pts[0])
    return pts

zpts = rounded_triangle_pts(top, bl, br, corner_r=0.22, steps=30)

# Faint warm fill
draw.polygon(zpts, fill=ORANGE_FAINT)
for i in range(len(zpts)-1):
    draw.line([zpts[i], zpts[i+1]], fill=ORANGE, width=STROKE)

# Bamboo leaves sprouting from top — two elegant arching leaves
# Left leaf
ll_pts = [
    (p2x-5, p2y-130), (p2x-25, p2y-165), (p2x-50, p2y-200),
    (p2x-60, p2y-220), (p2x-50, p2y-210), (p2x-30, p2y-180),
    (p2x-10, p2y-150), (p2x-5, p2y-130)
]
smooth_curve(draw, ll_pts, GREEN, STROKE)
ll_vein = [(p2x-8, p2y-135), (p2x-38, p2y-180)]
smooth_curve(draw, ll_vein, GREEN, STROKE_FINE)

# Right leaf
rl_pts = [
    (p2x+5, p2y-130), (p2x+22, p2y-162), (p2x+45, p2y-198),
    (p2x+55, p2y-218), (p2x+48, p2y-205), (p2x+28, p2y-172),
    (p2x+10, p2y-145), (p2x+5, p2y-130)
]
smooth_curve(draw, rl_pts, GREEN, STROKE)
rl_vein = [(p2x+8, p2y-135), (p2x+35, p2y-175)]
smooth_curve(draw, rl_vein, GREEN, STROKE_FINE)

# Tiny center leaf
cl_pts = [
    (p2x, p2y-130), (p2x-3, p2y-155), (p2x-1, p2y-172),
    (p2x+4, p2y-160), (p2x+2, p2y-142), (p2x, p2y-130)
]
smooth_curve(draw, cl_pts, GREEN, STROKE_FINE)

# Face positioned in upper-center of triangle
face_cy = p2y - 20

# Eyes — simple dots
draw_circle(draw, p2x-22, face_cy, 5, fill=ORANGE, outline=None)
draw_circle(draw, p2x+22, face_cy, 5, fill=ORANGE, outline=None)

# Blush
draw_circle(draw, p2x-42, face_cy+18, 10, fill=ORANGE_FAINT, outline=None)
draw_circle(draw, p2x+42, face_cy+18, 10, fill=ORANGE_FAINT, outline=None)

# Smile
z_smile = [(p2x-15, face_cy+22), (p2x, face_cy+32), (p2x+15, face_cy+22)]
smooth_curve(draw, z_smile, ORANGE, STROKE)

# Wrapping string — the cotton thread tied around a real zongzi
# Horizontal band
wrap_y = p2y + 40
wrap1 = [(p2x-70, wrap_y), (p2x-20, wrap_y+12), (p2x+20, wrap_y+12), (p2x+70, wrap_y)]
smooth_curve(draw, wrap1, ORANGE, STROKE_FINE)
# Vertical thread from top
wrap2 = [(p2x, p2y-100), (p2x-3, p2y-30), (p2x, p2y+60)]
smooth_curve(draw, wrap2, ORANGE, STROKE_FINE)

# Decorative scatter
for angle in [25, 80, 140, 200, 270, 330]:
    ax = p2x + 190 * math.cos(math.radians(angle))
    ay = p2y + 190 * math.sin(math.radians(angle))
    draw_circle(draw, ax, ay, 1.5, fill=INK_LIGHT+(45,), outline=None)

draw.text((HALF+370, 680), "02", fill=INK_LIGHT + (80,), font=font_tiny)

# ============================================================
# PANEL 3 — BOTTOM LEFT: Weighing scale
# ============================================================
p3x, p3y = 400, HALF + 380

# Scale platform — elegant rounded rectangle
# Top surface (elliptical)
platform_top = []
for deg in range(360):
    t = math.radians(deg)
    x = p3x + 140 * math.cos(t)
    y = p3y + 45 + 20 * math.sin(t)  # flattened ellipse for perspective
    platform_top.append((x, y))

# Platform body (3D box effect)
draw.line([(p3x-140, p3y+45), (p3x-140, p3y+85)], fill=INK, width=STROKE)
draw.line([(p3x+140, p3y+45), (p3x+140, p3y+85)], fill=INK, width=STROKE)
# Bottom edge
bottom_arc = []
for deg in range(0, 181):
    t = math.radians(deg)
    x = p3x + 140 * math.cos(t)
    y = p3y + 85 + 20 * math.sin(t)
    bottom_arc.append((x, y))
smooth_curve(draw, bottom_arc, INK, STROKE)

# Top ellipse
top_arc = []
for deg in range(0, 361, 3):
    t = math.radians(deg)
    x = p3x + 140 * math.cos(t)
    y = p3y + 45 + 20 * math.sin(t)
    top_arc.append((x, y))
smooth_curve(draw, top_arc, INK, STROKE)

# Inner ellipse (surface detail)
inner_arc = []
for deg in range(0, 361, 3):
    t = math.radians(deg)
    x = p3x + 120 * math.cos(t)
    y = p3y + 45 + 16 * math.sin(t)
    inner_arc.append((x, y))
smooth_curve(draw, inner_arc, INK_LIGHT + (60,), STROKE_FINE)

# Column/post rising from scale
draw.line([(p3x-4, p3y+25), (p3x-4, p3y-40)], fill=INK, width=STROKE)
draw.line([(p3x+4, p3y+25), (p3x+4, p3y-40)], fill=INK, width=STROKE)

# Circular dial face
dial_cy = p3y - 90
draw_circle(draw, p3x, dial_cy, 70, outline=INK, width=STROKE)
draw_circle(draw, p3x, dial_cy, 60, outline=INK_LIGHT + (50,), width=STROKE_FINE)

# Dial markings — fine tick marks
for angle in range(-140, 141, 15):
    rad = math.radians(angle - 90)
    x1 = p3x + 52 * math.cos(rad)
    y1 = dial_cy + 52 * math.sin(rad)
    x2 = p3x + 60 * math.cos(rad)
    y2 = dial_cy + 60 * math.sin(rad)
    w = STROKE if angle % 45 == 0 else STROKE_FINE
    draw.line([(x1, y1), (x2, y2)], fill=INK_LIGHT, width=w)

# Needle pointing to ~40° (suggesting a weight reading)
needle_angle = math.radians(-50)
nx = p3x + 45 * math.cos(needle_angle)
ny = dial_cy + 45 * math.sin(needle_angle)
draw.line([(p3x, dial_cy), (nx, ny)], fill=ORANGE, width=STROKE)
draw_circle(draw, p3x, dial_cy, 4, fill=ORANGE, outline=None)

# "kg" text
draw.text((p3x-10, dial_cy+18), "kg", fill=INK_LIGHT, font=font_tiny)

# Heart above the dial
draw_heart(draw, p3x, p3y-200, 10, outline=ORANGE, width=STROKE_FINE)

# Tiny decorative circles
draw_circle(draw, p3x-180, p3y-140, 2, fill=None, outline=INK_LIGHT+(40,), width=STROKE_FINE)
draw_circle(draw, p3x+185, p3y-120, 1.5, fill=None, outline=INK_LIGHT+(40,), width=STROKE_FINE)
draw_circle(draw, p3x-160, p3y+60, 1, fill=None, outline=INK_LIGHT+(30,), width=STROKE_FINE)

draw.text((370, HALF+680), "03", fill=INK_LIGHT + (80,), font=font_tiny)

# ============================================================
# PANEL 4 — BOTTOM RIGHT: Growth chart with botanical
# ============================================================
p4x, p4y = HALF + 360, HALF + 370

# Chart frame — clean rectangle with rounded feel
chart_w, chart_h = 240, 200
cl = p4x - chart_w//2
ct = p4y - chart_h//2
cr = p4x + chart_w//2
cb = p4y + chart_h//2
draw.rectangle([(cl, ct), (cr, cb)], outline=INK, width=STROKE)

# Subtle grid
for i in range(1, 5):
    y = ct + i * chart_h / 5
    draw.line([(cl+2, y), (cr-2, y)], fill=INK_LIGHT+(20,), width=1)
for i in range(1, 7):
    x = cl + i * chart_w / 7
    draw.line([(x, ct+2), (x, cb-2)], fill=INK_LIGHT+(20,), width=1)

# Growth curve — smooth upward trajectory
growth_pts = [
    (cl+15, cb-15), (cl+45, cb-28), (cl+80, cb-48),
    (cl+120, cb-75), (cl+160, cb-110), (cl+195, cb-145),
    (cl+225, cb-178)
]
smooth_curve(draw, growth_pts, ORANGE, STROKE+1)

# Data points with hollow circles
for pt in growth_pts:
    draw_circle(draw, pt[0], pt[1], 4, fill=BG+(255,), outline=ORANGE, width=STROKE)

# Axis labels (tiny)
draw.text((cl-2, cb+6), "0", fill=INK_LIGHT+(60,), font=font_tiny)
draw.text((cr-8, cb+6), "mo", fill=INK_LIGHT+(60,), font=font_tiny)
draw.text((cl-20, ct), "kg", fill=INK_LIGHT+(60,), font=font_tiny)

# Botanical element — elegant single flower
fx, fy = p4x + 170, p4y - 40

# Main stem — graceful curve
stem_pts = [(fx, fy+140), (fx-8, fy+100), (fx+3, fy+50), (fx-2, fy)]
smooth_curve(draw, stem_pts, GREEN, STROKE)

# Leaf pair on stem
leaf_l1 = [(fx-4, fy+80), (fx-35, fy+60), (fx-50, fy+40)]
smooth_curve(draw, leaf_l1, GREEN, STROKE_FINE)
leaf_l2 = [(fx-4, fy+80), (fx-30, fy+68), (fx-50, fy+40)]
smooth_curve(draw, leaf_l2, GREEN, STROKE_FINE)
# leaf vein
leaf_v = [(fx-4, fy+80), (fx-30, fy+55)]
smooth_curve(draw, leaf_v, GREEN, STROKE_FINE)

# Small right leaf lower
leaf_r1 = [(fx+2, fy+100), (fx+28, fy+85), (fx+38, fy+70)]
smooth_curve(draw, leaf_r1, GREEN, STROKE_FINE)
leaf_r2 = [(fx+2, fy+100), (fx+22, fy+92), (fx+38, fy+70)]
smooth_curve(draw, leaf_r2, GREEN, STROKE_FINE)

# Flower head — 5 elegant petals
petal_r = 28
for i in range(5):
    angle = math.radians(i * 72 - 90)
    # Petal shape: two curves meeting at tip
    tip_x = fx + petal_r * math.cos(angle)
    tip_y = fy + petal_r * math.sin(angle)

    left_a = angle - 0.45
    right_a = angle + 0.45
    ctrl_l = (fx + petal_r*0.6*math.cos(left_a), fy + petal_r*0.6*math.sin(left_a))
    ctrl_r = (fx + petal_r*0.6*math.cos(right_a), fy + petal_r*0.6*math.sin(right_a))

    petal = [(fx, fy), ctrl_l, (tip_x, tip_y), ctrl_r, (fx, fy)]
    color = ORANGE if i % 2 == 0 else GREEN
    smooth_curve(draw, petal, color, STROKE_FINE)

# Flower center
draw_circle(draw, fx, fy, 5, fill=ORANGE_FAINT, outline=ORANGE, width=STROKE_FINE)
# Center dots
for i in range(3):
    a = math.radians(i * 120)
    draw_circle(draw, fx+2*math.cos(a), fy+2*math.sin(a), 1, fill=ORANGE, outline=None)

# Small bud
bx, by = p4x + 200, p4y + 100
bud_stem = [(bx, by+30), (bx+3, by+15), (bx, by)]
smooth_curve(draw, bud_stem, GREEN, STROKE_FINE)
draw_circle(draw, bx, by, 4, outline=GREEN, width=STROKE_FINE)
for i in range(3):
    a = math.radians(i*120 - 90)
    draw.line([(bx, by), (bx+8*math.cos(a), by+8*math.sin(a))], fill=GREEN, width=STROKE_FINE)

draw.text((HALF+370, HALF+680), "04", fill=INK_LIGHT + (80,), font=font_tiny)

# ============================================================
# Footer
# ============================================================
draw.text((80, H-50), "EE和粽子 — Tender Cartography", fill=INK_LIGHT+(100,), font=font_label)
draw.text((W-280, H-50), "illustration sheet · 2026", fill=INK_LIGHT+(60,), font=font_tiny)

# ============================================================
# Save
# ============================================================
output_path = "/Users/leo/xxb/demo/EE-and-Zongzi/illustrations.png"
final = Image.new('RGB', (W, H), BG)
final.paste(img, (0, 0), img)
final.save(output_path, 'PNG', quality=95)
print(f"Saved to {output_path}")
print(f"Size: {W}x{H}")
