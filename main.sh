#!/bin/bash

# URL of the remote video
VIDEO_URL="https://cdn01.chiheisen.icu/1001668642645/60010"
VIDEO_NAME="video.mp4"

# Download the video
wget -O $VIDEO_NAME $VIDEO_URL

# Convert the video to HLS with multiple qualities
ffmpeg -i $VIDEO_NAME \
  -filter_complex "[0:v]split=3[v1][v2][v3]; \
                   [v1]scale=w=640:h=360[v1out]; \
                   [v2]scale=w=1280:h=720[v2out]; \
                   [v3]scale=w=1920:h=1080[v3out]" \
  -map [v1out] -b:v:0 800k -map [v2out] -b:v:1 2800k -map [v3out] -b:v:2 5000k \
  -map a:0 -c:a aac -c:v h264 \
  -f hls -hls_time 10 -hls_playlist_type vod \
  -master_pl_name master.m3u8 \
  -var_stream_map "v:0,a:0 v:1,a:0 v:2,a:0" \
  output.m3u8

echo "HLS conversion completed. Check the generated files."
