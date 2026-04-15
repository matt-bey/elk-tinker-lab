#!/usr/bin/env python3
"""
Mini CRT Arcade Enclosure — v2
Retro CRT TV style: tapered body, stepped bezel, flat base

All parts share a single coordinate system so they assemble correctly in the viewer:
  Origin = center of front face
  +X = right, +Y = up, +Z = into the TV (depth direction)

  Front bezel: Z = 0 → FRONT_DEPTH
  Back body:   Z = FRONT_DEPTH → BODY_DEPTH
  Stand:       below bottom of TV body (Y < -FACE_H/2)

All dimensions in mm.
⚠ Screen dimensions are ESTIMATED — measure your board before slicing.

Run:
    uv run enclosure_v2.py
    → enclosure_v2_front.stl
    → enclosure_v2_back.stl
    → enclosure_v2_stand.stl
"""

from build123d import *

try:
    from ocp_vscode import show_all
    _VIEWER = True
except ImportError:
    _VIEWER = False


# ═══════════════════════════════════════════════════════════════
#  PARAMETERS
# ═══════════════════════════════════════════════════════════════

# Waveshare 3.5" HDMI LCD (E) — ESTIMATED, verify before printing
SCREEN_PCB_W    = 96.0
SCREEN_PCB_H    = 60.0
SCREEN_ACTIVE_W = 71.0
SCREEN_ACTIVE_H = 53.0
PCB_CLEARANCE   =  0.5

# Speakers — Gikfun 2" 4Ω 3W
SPEAKER_OD      = 50.8

# Wall thickness
WALL            =  3.0

# Front bezel geometry
BEZEL_SIDES     = 14.0
BEZEL_TOP       = 18.0
BEZEL_BOT       = 22.0
CORNER_R        =  8.0
LIP_INSET       =  5.0   # outer lip extends this far inward from bezel edge
LIP_DEPTH       =  2.5   # inner bezel face recessed this far behind outer lip
SCREEN_RECESS   =  4.0   # PCB pocket recess behind inner bezel face
FRONT_DEPTH     = 20.0   # front-to-back depth of bezel piece

# Back body — CRT taper
BACK_DEPTH      = 45.0   # depth of back body
BACK_W_RATIO    =  0.72  # back face width as fraction of front face width
BACK_H_RATIO    =  0.78  # back face height as fraction of front face height

# Screw bosses — M2.5 hardware from inventory
# Boss posts sit on front bezel interior, protrude into back body.
# Screws enter from outside the back body side walls.
BOSS_OD         =  7.0   # boss post outer diameter
BOSS_PROTRUDE   = 10.0   # how far boss extends past bezel into back body
M25_CLEAR       =  2.7   # M2.5 clearance hole (through back body wall)
M25_SELF_TAP    =  2.1   # M2.5 self-tapping hole (into boss post)

# Stand
BASE_EXTRA_SIDES = 10.0  # stand wider than TV face by this on each side
BASE_FRONT_OVER  = 15.0  # stand overhangs forward of TV front face
BASE_REAR_FLUSH  =  0.0  # stand extends past TV back (0 = flush)
BASE_H           =  8.0  # stand height


# ═══════════════════════════════════════════════════════════════
#  DERIVED
# ═══════════════════════════════════════════════════════════════

FACE_W    = SCREEN_PCB_W + BEZEL_SIDES * 2
FACE_H    = SCREEN_PCB_H + BEZEL_TOP + BEZEL_BOT
INNER_R   = max(CORNER_R - WALL, 1.5)

BODY_DEPTH = FRONT_DEPTH + BACK_DEPTH
BACK_W     = FACE_W * BACK_W_RATIO
BACK_H     = FACE_H * BACK_H_RATIO
BACK_R     = max(CORNER_R * BACK_W_RATIO, 2.0)

# Boss post positions — 2 per side wall (top + bottom), 4 total
# Inset from edges so they sit cleanly within the wall material
BOSS_X = FACE_W / 2 - WALL - BOSS_OD / 2 - 1.5
BOSS_Y = FACE_H / 2 - WALL - BOSS_OD / 2 - 2.0
BOSS_POSITIONS = [
    (-BOSS_X, -BOSS_Y),  # left-bottom
    (-BOSS_X,  BOSS_Y),  # left-top
    ( BOSS_X, -BOSS_Y),  # right-bottom
    ( BOSS_X,  BOSS_Y),  # right-top
]
SCREW_Z = FRONT_DEPTH + BOSS_PROTRUDE / 2  # Z center of screw hole

# Speaker position on back body side walls
SPK_Y = (BEZEL_BOT - BEZEL_TOP) / 2          # centered on screen area
SPK_Z = FRONT_DEPTH + BACK_DEPTH * 0.45      # mid-depth of back body (world Z)

# Stand footprint (in world XZ plane)
STAND_W      = FACE_W + BASE_EXTRA_SIDES * 2
STAND_D      = BODY_DEPTH + BASE_FRONT_OVER + BASE_REAR_FLUSH
STAND_Z_CTR  = (BODY_DEPTH + BASE_REAR_FLUSH - BASE_FRONT_OVER) / 2


# ═══════════════════════════════════════════════════════════════
#  FRONT BEZEL  (Z = 0 → FRONT_DEPTH)
#  Stepped outer lip, screen aperture, PCB retention pocket.
# ═══════════════════════════════════════════════════════════════

with BuildPart() as front:

    # Full outer solid
    with BuildSketch(Plane.XY):
        RectangleRounded(FACE_W, FACE_H, CORNER_R)
    extrude(amount=FRONT_DEPTH)

    # Hollow interior — keeps front wall + side walls, open at back
    with BuildSketch(Plane.XY.offset(WALL)):
        RectangleRounded(FACE_W - WALL * 2, FACE_H - WALL * 2, INNER_R)
    extrude(amount=FRONT_DEPTH - WALL, mode=Mode.SUBTRACT)

    # Stepped bezel: recess the inner face, leaving outer lip proud
    with BuildSketch(Plane.XY):
        RectangleRounded(
            FACE_W - LIP_INSET * 2, FACE_H - LIP_INSET * 2,
            max(CORNER_R - LIP_INSET, 2.0),
        )
    extrude(amount=LIP_DEPTH, mode=Mode.SUBTRACT)

    # Screen aperture through inner bezel face
    with BuildSketch(Plane.XY.offset(LIP_DEPTH)):
        RectangleRounded(SCREEN_ACTIVE_W, SCREEN_ACTIVE_H, 2.5)
    extrude(amount=WALL - LIP_DEPTH, mode=Mode.SUBTRACT)

    # PCB retention ledge — annular pocket behind aperture
    with BuildSketch(Plane.XY.offset(LIP_DEPTH)):
        RectangleRounded(
            SCREEN_PCB_W + PCB_CLEARANCE, SCREEN_PCB_H + PCB_CLEARANCE, 3.5
        )
        RectangleRounded(SCREEN_ACTIVE_W, SCREEN_ACTIVE_H, 2.5, mode=Mode.SUBTRACT)
    extrude(amount=SCREEN_RECESS, mode=Mode.SUBTRACT)

    # Boss posts — cylindrical pegs that protrude into back body
    # Screw enters laterally from outside the back body side wall
    for bx, by in BOSS_POSITIONS:
        with Locations(Location((bx, by, WALL))):
            Cylinder(
                radius=BOSS_OD / 2,
                height=FRONT_DEPTH - WALL + BOSS_PROTRUDE,
                align=(Align.CENTER, Align.CENTER, Align.MIN),
            )

    # Self-tapping holes through boss posts (lateral, in X direction)
    for bx, by in BOSS_POSITIONS:
        x_side = 1 if bx > 0 else -1
        hole_plane = Plane(
            origin=(bx + x_side * (BOSS_OD / 2 + 1), by, SCREW_Z),
            x_dir=(0, 1, 0),
            z_dir=(-x_side, 0, 0),
        )
        with BuildSketch(hole_plane):
            Circle(M25_SELF_TAP / 2)
        extrude(amount=BOSS_OD + 2, mode=Mode.SUBTRACT)

front_part = front.part


# ═══════════════════════════════════════════════════════════════
#  BACK BODY  (Z = FRONT_DEPTH → BODY_DEPTH)
#  Lofted CRT shape: wide at front, tapers to smaller back face.
#  Starts at Z=FRONT_DEPTH so it sits directly behind the bezel.
# ═══════════════════════════════════════════════════════════════

with BuildPart() as back:

    # Outer lofted solid
    with BuildSketch(Plane.XY.offset(FRONT_DEPTH)):
        RectangleRounded(FACE_W, FACE_H, CORNER_R)
    with BuildSketch(Plane.XY.offset(BODY_DEPTH)):
        RectangleRounded(BACK_W, BACK_H, BACK_R)
    loft()

    # Hollow interior — lofted subtract for uniform wall thickness
    with BuildSketch(Plane.XY.offset(FRONT_DEPTH)):
        RectangleRounded(FACE_W - WALL * 2, FACE_H - WALL * 2, INNER_R)
    with BuildSketch(Plane.XY.offset(BODY_DEPTH - WALL)):
        RectangleRounded(
            max(BACK_W - WALL * 2, 10.0),
            max(BACK_H - WALL * 2, 10.0),
            max(BACK_R - WALL, 1.0),
        )
    loft(mode=Mode.SUBTRACT)

    # Speaker holes on left and right side walls
    for x_side in (-1, 1):
        spk_plane = Plane(
            origin=(x_side * FACE_W / 2, SPK_Y, SPK_Z),
            x_dir=(0, 1, 0),
            z_dir=(-x_side, 0, 0),
        )
        with BuildSketch(spk_plane):
            Circle(SPEAKER_OD / 2)
        extrude(amount=WALL + 2, mode=Mode.SUBTRACT)

    # Screw clearance holes through side walls — align with front bezel boss posts
    # M2.5 screw enters here, travels through wall, self-taps into boss post
    for bx, by in BOSS_POSITIONS:
        x_side = 1 if bx > 0 else -1
        screw_plane = Plane(
            origin=(x_side * FACE_W / 2, by, SCREW_Z),
            x_dir=(0, 1, 0),
            z_dir=(-x_side, 0, 0),
        )
        with BuildSketch(screw_plane):
            Circle(M25_CLEAR / 2)
        extrude(amount=WALL + 2, mode=Mode.SUBTRACT)

back_part = back.part


# ═══════════════════════════════════════════════════════════════
#  STAND  (horizontal platform below TV body)
#  Top face at Y = -FACE_H/2 (bottom of TV), extends down by BASE_H.
#  Wider and deeper than the TV body for a proper pedestal look.
# ═══════════════════════════════════════════════════════════════

with BuildPart() as stand:
    # Sketch in the XZ plane at the bottom of the TV body
    with BuildSketch(Plane.XZ.offset(-FACE_H / 2)):
        with Locations(Location((0, STAND_Z_CTR))):
            RectangleRounded(STAND_W, STAND_D, 6.0)
    extrude(amount=-BASE_H)   # extrude downward (-Y)

stand_part = stand.part


# ═══════════════════════════════════════════════════════════════
#  EXPORT
# ═══════════════════════════════════════════════════════════════

export_stl(front_part, "enclosure_v2_front.stl")
export_stl(back_part,  "enclosure_v2_back.stl")
export_stl(stand_part, "enclosure_v2_stand.stl")

print(f"Front bezel: {FACE_W:.0f} × {FACE_H:.0f} × {FRONT_DEPTH:.0f} mm")
print(f"Back body:   {FACE_W:.0f}→{BACK_W:.0f} × {FACE_H:.0f}→{BACK_H:.0f} × {BACK_DEPTH:.0f} mm")
print(f"Stand:       {STAND_W:.0f} × {STAND_D:.0f} × {BASE_H:.0f} mm")
print("Exported enclosure_v2_front.stl / back.stl / stand.stl")

if _VIEWER:
    show_all()
