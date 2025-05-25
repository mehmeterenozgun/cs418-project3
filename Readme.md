Low-Latency DASH Streaming Project

A simple pipeline for sub-5 s live streaming using open-source tools on macOS.

Prerequisites
	•	OBS Studio (capture & RTMP output)
	•	Custom FFmpeg build in ~/bin/ffmpeg
	•	Node.js (for gpac-dash.js)
	•	nginx (for proxying)

Setup & Run

	1.	OBS

•	Stream: rtmp://localhost:1935/live/ (key: stream)
•	Set key-frame interval: keyint=120
•	Add on-screen clock filter

	2.	FFmpeg

OUTPUT=static/ldash
mkdir -p "$OUTPUT"
~/bin/ffmpeg -f flv -listen 1 \
  -i rtmp://localhost:1935/live/stream \
  -c:v libx264 -force_key_frames "expr:gte(t,n_forced*4)" -profile:v baseline -an \
  -ldash 1 -streaming 1 -use_template 1 -use_timeline 1 \
  -adaptation_sets "id=0,streams=v" \
  -seg_duration 4 -frag_duration 1 -frag_type duration \
  -window_size 3 -extra_window_size 1 \
  -utc_timing_url "https://time.akamai.com/?iso" \
  -remove_at_exit 1 -f dash "$OUTPUT/1.mpd"


	3.	GPAC-DASH

cd project3
node gpac-dash.js -chunk-media-segments -cors -chunks-per-segment 4 static/ldash


	4.	nginx (proxy to gpac-dash)

sudo nginx -c /path/to/nginx.conf


	5.	Playback

•	Open http://localhost/ldash/index.html in a browser

Results
	•	Sub-5 s glass-to-glass latency achieved with 4 s segments & 1 s fragments
	•	See REPORT.md for detailed charts and numbers