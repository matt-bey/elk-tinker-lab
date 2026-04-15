# Enclosure Design — Mini CRT Arcade Box

## Aesthetic Direction

The enclosure is styled as a **miniature CRT television** — not a flat panel monitor. The goal is a desk-sitting object that looks like a shrunken version of a 1980s computer monitor or small TV.

## Key Design Elements

- **Thick bezel** framing the screen — CRTs had substantial plastic frames
- **Screen recessed** behind the bezel — CRTs sat back from the bezel face
- **Vent slots** on top and sides — double as speaker grilles
- **Tilt stand** — CRT monitors had a base with tilt adjustment
- **Volume knob** on front bezel — PAM8403 potentiometer, functional and period-correct
- **Power LED** on front bezel — green, gently pulsing
- **USB port** on the right side — accessible for controller
- **Rear profile** tapering to suggest CRT tube depth
- **Cardboard construction** for v1 prototype

## Speaker Placement

Speakers mount inside the enclosure behind vent/grille holes on the sides or top. Small drill or pencil holes in a grid pattern make a convincing grille.

## v1 Build Notes

- Hot glue and foam tape for mounting internal components
- Double-sided foam tape for Pi (preserves SD card access)
- Volume knob positioned for natural reach while seated at desk
- All internal cable runs kept short

## 3D Printed Enclosure

Design files live in `enclosure/`. Built with [build123d](https://github.com/gumyr/build123d) (Python parametric CAD).

- `enclosure_v2.py` — current working design: lofted CRT body, stepped bezel, flat stand

## Reference Models

Good starting points for shape/proportion reference — not used directly, just for visual guidance:

- [Retro CRT TV by peaberry](https://www.thingiverse.com/thing:5820726) — the primary shape reference used during design
- [Mini CRT TV enclosure](https://www.thingiverse.com/thing:5772841) — alternate proportions, useful for bezel detail reference
