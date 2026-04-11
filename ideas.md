# Project Ideas

Future build ideas — mostly father/son projects.

---

## Motion-Triggered Alarm ("Booby Trap")

A sensor on the bedroom door that triggers a buzzer and flashing LED when someone enters.
Framing it as a booby trap tends to be highly motivating for kids.

**Teaches:** Digital input/output, basic circuits, conditional logic

**Components:**
- PIR Motion Sensor (Keyes kit #26) — on hand
- Active buzzer (Keyes kit #6 or discrete) — on hand
- LEDs + resistors — on hand
- Raspberry Pi Zero W or 2B — on hand

**Software:** Python, RPi.GPIO

**Complexity:** Low
**Estimated build time:** 1–2 hours

---

## Reaction Time Game

An LED lights up at a random moment — press the button as fast as you can. Tracks your best
time. Head-to-head competitive play sustains interest well.

**Teaches:** Random number generation, timing, loops, user input

**Components:**
- 1–2 LEDs + resistors — on hand
- Momentary push button — on hand
- Raspberry Pi (any) — on hand

**Software:** Python, RPi.GPIO, `time` module

**Complexity:** Low
**Estimated build time:** 1–2 hours

---

## Simon Says

Four colored LEDs light up in a sequence — repeat the pattern with four matching buttons.
Sequence gets longer each round.

**Teaches:** Lists/arrays, loops, input matching, game state

**Components:**
- 4 LEDs (different colors) + resistors — on hand
- 4 momentary push buttons — on hand
- Passive buzzer (for tones) — on hand
- Raspberry Pi (any) — on hand

**Software:** Python, RPi.GPIO

**Complexity:** Medium
**Estimated build time:** 2–4 hours

---

## Distance Alarm

Ultrasonic sensor measures distance and beeps faster as a hand (or person) gets closer — like a
parking sensor or bomb-defusing prop.

**Teaches:** Analog-style feedback, distance sensing, variable timing/frequency

**Components:**
- Ultrasonic sensor HC-SR04 (Keyes kit #37) — on hand
- Passive buzzer — on hand
- Raspberry Pi (any) — on hand

**Software:** Python, RPi.GPIO

**Complexity:** Low–Medium
**Estimated build time:** 1–2 hours

---

## Secret Knock Detector

Knock a secret pattern on the desk or door — if it matches, an LED lights up or a buzzer sounds
to "grant access."

**Teaches:** Timing, pattern matching, sequences

**Components:**
- Knock Sensor (Keyes kit #18) — on hand
- LED + resistor or buzzer — on hand
- Raspberry Pi (any) — on hand

**Software:** Python, RPi.GPIO

**Complexity:** Medium (pattern timing logic takes some tuning)
**Estimated build time:** 2–3 hours

---

## Color Mixer Night Light

Three buttons (or a joystick) adjust red, green, and blue levels on an RGB LED — mix colors
interactively. Could live on a nightstand.

**Teaches:** RGB color model, PWM, variables, incremental state

**Components:**
- RGB LED + resistors — on hand
- 3 momentary push buttons — on hand (or potentiometers, but those need ADC)
- Raspberry Pi (any) — on hand

**Software:** Python, RPi.GPIO (PWM mode)

**Complexity:** Low–Medium
**Estimated build time:** 1–2 hours

---

## Temperature Tattler

Reads room temperature with a DHT11 sensor and displays it on a 4-digit 7-segment display.
Could be set up as a "is it too cold to get out of bed?" morning gadget.

**Teaches:** I2C/sensor protocols, numeric display output, data formatting

**Components:**
- DHT11 Temperature & Humidity Sensor (Keyes kit #11) — on hand
- 4-digit 7-segment display (Miuzei kit) — on hand
- 74HC595 Shift Register (Miuzei kit) — on hand
- Raspberry Pi (any) — on hand

**Software:** Python, `adafruit-circuitpython-dht`, RPi.GPIO

**Complexity:** Medium
**Estimated build time:** 2–3 hours

---

## IR Magic Wand

Point a wand (IR remote) at the Pi — different button presses trigger different LED colors,
patterns, or sounds. A shaped novelty remote (e.g., a wand-style universal TV remote) adds
to the effect.

**Teaches:** IR signal decoding, event-driven programming, switch/case logic

**Components:**
- Digital IR Receiver Module (Keyes kit #12) — on hand
- RGB LED + resistors — on hand
- Buzzer (optional, for sound effects) — on hand
- Raspberry Pi (any) — on hand
- IR remote — potentially on hand (universal TV remote shaped as a wand)

**Software:** Python, `python-lirc` or `pigpio` IR decoding

**Complexity:** Medium (IR library setup and signal mapping can be fiddly)
**Estimated build time:** 2–4 hours

**Note:** A universal TV remote that happens to be wand-shaped works perfectly as the
transmitter — no custom hardware needed on that side.

---

## Obstacle-Avoiding Rover

A small wheeled robot that drives forward and steers away when it detects a wall or object.
Classic "robot that thinks for itself" — very satisfying for a kid to watch.

**Teaches:** Autonomous decision-making, sensor-driven logic, motor control

**Components:**
- Ultrasonic sensor HC-SR04 (Keyes kit #37) — on hand
- Obstacle avoidance sensor (Keyes kit #25) — on hand
- Arduino Nano — pending purchase (Microcenter ~$4)
- L298N dual motor driver board — needs purchase (~$5)
- 2WD robot chassis kit (motors, wheels, frame) — needs purchase (~$10–15)
- 9V battery or 4xAA pack for motors — needs purchase

**Software:** Arduino IDE, C++

**Complexity:** Medium
**Estimated build time:** 3–5 hours (includes chassis assembly)

---

## Line-Following Robot

Follows a black line drawn or taped on the floor. Easy to make tracks and courses — great for
racing or maze challenges.

**Teaches:** Sensor feedback loops, conditional logic, calibration

**Components:**
- Line tracking module (Keyes kit #21) — on hand
- Arduino Nano — pending purchase
- L298N dual motor driver board — needs purchase (~$5)
- 2WD robot chassis kit — needs purchase (~$10–15)
- 9V battery or 4xAA pack — needs purchase

**Software:** Arduino IDE, C++

**Complexity:** Medium
**Estimated build time:** 3–5 hours

**Note:** Can share the same chassis kit as the obstacle-avoiding rover — swap sensor
modules to switch modes.

---

## Remote-Controlled Rover

IR-remote-controlled car. Point the wand remote to drive forward, back, left, right.
Pairs naturally with the IR magic wand idea — same remote, different project.

**Teaches:** IR decoding, directional motor control, mapping inputs to actions

**Components:**
- Digital IR Receiver Module (Keyes kit #12) — on hand
- Arduino Nano — pending purchase
- L298N dual motor driver board — needs purchase (~$5)
- 2WD robot chassis kit — needs purchase (~$10–15)
- 9V battery or 4xAA pack — needs purchase
- IR remote (wand-style universal remote) — potentially on hand

**Software:** Arduino IDE, IRremote library

**Complexity:** Medium
**Estimated build time:** 3–5 hours

---

## Robot Face (LED Matrix)

Not a moving robot — a panel that displays animated pixel faces that react to sound (clapping,
talking) or touch. Good intro to "robot personality" before tackling a full rover.

**Teaches:** LED matrix addressing, animation frames, sensor input, arrays

**Components:**
- 8x8 LED matrix with MAX7219 driver — needs purchase (~$3–5)
- Microphone Sound Sensor (Keyes kit #24) — on hand (analog, needs ADC on Pi; digital
  threshold mode works fine on Arduino)
- Arduino Nano — pending purchase

**Software:** Arduino IDE, MD_MAX72XX or LedControl library

**Complexity:** Low–Medium
**Estimated build time:** 1–2 hours

**Note:** This is a great "face for a future rover" — build it standalone first, then
mount it on a chassis later.

---

## Servo Claw / Robot Arm

A single-axis gripper or multi-joint arm controlled by potentiometer knobs — one knob per
joint. He turns the knob, the arm moves. Very tactile.

**Teaches:** PWM servo control, analog input, mechanical linkage

**Components:**
- Servo motors (SG90 or MG90S) — needs purchase (~$2–4 each, need 1–3)
- Potentiometer 10KΩ — on hand (Miuzei kit, qty 2)
- Arduino Nano — pending purchase
- Cardboard or 3D-printed arm pieces — on hand (Ender 3)

**Software:** Arduino IDE, Servo library

**Complexity:** Low–Medium (wiring is simple; mechanical build depends on approach)
**Estimated build time:** 2–4 hours

**Note:** SG90 servos are dirt cheap and ubiquitous. A 3D-printed arm frame would make
this significantly more impressive — good excuse to dial in the Ender 3.
