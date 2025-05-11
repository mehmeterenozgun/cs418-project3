#!/usr/bin/env bash
#
# start-gpac-dash.sh — launch GPAC DASH in low-latency mode

# determine the directory this script lives in
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# path to your NodeJS GPAC DASH server
DASH_SCRIPT="$SCRIPT_DIR/gpac-dash.js"

# invocation flags
IP="0.0.0.0"
PORT="8000"
CHUNKS_PER_SEGMENT="121"

node "$DASH_SCRIPT" \
  -ip $IP \
  -port $PORT \
  -chunk-media-segments \
  -cors \
  -chunks-per-segment $CHUNKS_PER_SEGMENT \

