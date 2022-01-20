#!/bin/bash

cd /home/klleon/janus-gateway/docker/docker-compose-janus
sudo docker-compose down

cd /home/klleon/janus-gateway/docker/docker-compose-webserver
sudo docker-compose down
