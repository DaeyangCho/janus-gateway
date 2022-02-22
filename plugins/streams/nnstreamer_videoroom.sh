#!/bin/sh
gst-launch-1.0 \
  rtpbin name=rtpbin \
    udpsrc port=10050 caps="application/x-rtp, media=audio, encoding-name=OPUS, clock-rate=48000" ! rtpbin.recv_rtp_sink_0 \
    udpsrc port=10051 caps="application/x-rtp, media=video, encoding-name=VP8, clock-rate=90000" ! rtpbin.recv_rtp_sink_1 \
      rtpbin. ! rtpvp8depay ! vp8dec ! videoconvert ! videoscale ! video/x-raw,format=RGB,width=640,height=480,framerate=10/1 ! \
      tensor_converter ! tensor_filter framework=pytorch model=pytorch_animae_ganv2_paprika_gpu.pt input=3:640:480:1 inputtype=uint8 output=3:640:480:1 outputtype=uint8 accelerator=true:gpu ! \
      tensor_decoder mode=direct_video ! videoconvert ! fpsdisplaysink sync=false\
      rtpbin. ! rtpopusdepay ! queue ! opusdec ! pulsesink
