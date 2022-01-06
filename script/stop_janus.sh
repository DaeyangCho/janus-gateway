#!/bin/bash

sudo docker ps
sudo docker stop janus
sleep 5
sudo docker ps -a
sudo docker rm janus
sudo docker ps -a
