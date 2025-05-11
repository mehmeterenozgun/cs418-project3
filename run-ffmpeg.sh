#!/usr/bin/env bash
# run_ffmpeg.sh — push a low-latency LL-DASH stream with on-screen timestamps

export PATH="$HOME/bin:$PATH"

OUTPUT_DIR="$(pwd)/ldash"
mkdir -p "$OUTPUT_DIR"

ffmpeg -f flv -listen 1 -i rtmp://localhost:1935/live/ldash \
  -vf "drawtext=fontfile=/path/to/font.ttf: text='%{localtime}': fontcolor=white: fontsize=24: x=10: y=10" \
  -c:v libx264 -preset ultrafast -tune zerolatency \
  -r 30 \
  -force_key_frames "expr:gte(t,n_forced*1)" \
  -profile:v baseline -s 640x360 -an -map v:0 \
  -ldash 1 -target_latency 3 -streaming 1 \
  -use_template 1 -use_timeline 0 \
  -adaptation_sets "id=0,streams=v" \
  -seg_duration 4 -frag_duration 4 -frag_type duration \
  -window_size 3 -extra_window_size 1 \
  -utc_timing_url "https://time.akamai.com/?iso" \
  -remove_at_exit 1 \
  -f dash "$OUTPUT_DIR/1.mpd"
