#!/usr/bin/env bash

# ensure custom ffmpeg is in PATH
export PATH="$HOME/bin:$PATH"

# where to write the DASH files
OUTPUT_DIR="$(pwd)/static/ldash"

mkdir -p "$OUTPUT_DIR"

ffmpeg -f flv -listen 1 \
  -i rtmp://localhost:1935/live/stream \
  -an \
  -map 0:v:0 \
  -c:v libx264 \
  -force_key_frames "expr:gte(t,n_forced)" \
  -profile:v baseline \
  -ldash 1 \
  -streaming 1 \
  -use_template 1 \
  -use_timeline 0 \
  -adaptation_sets "id=0,streams=v" \
  -seg_duration 1 \
  -frag_duration 0.2 \
  -frag_type duration \
  -utc_timing_url "https://time.akamai.com/?iso" \
  -window_size 15 \
  -extra_window_size 15 \
  -remove_at_exit 1 \
  -f dash "$OUTPUT_DIR/1.mpd"