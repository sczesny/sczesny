#!/usr/bin/env bash
set -e

# https://googlefonts.github.io/noto-emoji-animation/?selected=Animated%20Emoji%3Aemoji_u1f44b%3A
INPUT="512.gif"
OUTPUT="512_loop.gif"
FRAMES_DIR="frames"
FRAMES_LOOP_DIR="frames_loop"

# Extract source frames
mkdir -p "$FRAMES_DIR"
magick "$INPUT" "$FRAMES_DIR/frame_%04d.png"

# Build frame lists
FORWARD=$(for i in $(seq 0 45); do printf "%s/frame_%04d.png " "$FRAMES_DIR" $i; done)
REVERSE=$(for i in $(seq 13 -1 1); do printf "%s/frame_%04d.png " "$FRAMES_DIR" $i; done)
LAST="$FRAMES_DIR/frame_0000.png"

# Build GIF: frames 0-45, then 13-0 reversed, last frame held 3s
magick -background none \
  -dispose Background -delay 3 $FORWARD \
  -dispose Background -delay 3 $REVERSE \
  -dispose Background -delay 500 "$LAST" \
  -loop 0 \
  "$OUTPUT"

# Export all frames of result
rm -rf "$FRAMES_LOOP_DIR"
mkdir -p "$FRAMES_LOOP_DIR"
magick "$OUTPUT" -coalesce "$FRAMES_LOOP_DIR/frame_%04d.png"

rm -rf "$FRAMES_DIR" "$FRAMES_LOOP_DIR"
echo "Done: $(ls "$FRAMES_LOOP_DIR" | wc -l) frames -> $OUTPUT"
