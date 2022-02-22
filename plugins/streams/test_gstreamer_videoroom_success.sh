#!/bin/sh
gst-launch-1.0 \
  rtpbin name=rtpbin \
    udpsrc port=10050 caps="application/x-rtp, media=audio, encoding-name=OPUS, clock-rate=48000" ! rtpbin.recv_rtp_sink_0 \
    udpsrc port=10051 caps="application/x-rtp, media=video, encoding-name=VP8, clock-rate=90000" ! rtpbin.recv_rtp_sink_1 \
      rtpbin. ! rtpvp8depay ! vp8dec ! videorate ! video/x-raw,framerate=10/1 ! fpsdisplaysink sync=false \
      rtpbin. ! rtpopusdepay ! queue ! opusdec ! pulsesink
