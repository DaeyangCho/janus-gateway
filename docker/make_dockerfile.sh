#!/bin/bash

export SSH_PRIVATE_KEY="$(cat ~/.ssh/id_ed25519)"

sudo docker build --build-arg SSH_PRIVATE_KEY="$SSH_PRIVATE_KEY" --build-arg CACHEBUST=9 -t janus:220120 .

unset SSH_PRIVATE_KEY
