#!/bin/bash
if [ ! -e ~/.i2p ]
then
  mkdir -p ~/.i2p
  chmod 777 ~/.i2p 2>/dev/null
fi

# exit and remove old container
docker stop i2prouter
docker rm i2prouter
if [[ "$1" == "stop" ]]
then
  exit
fi

# start new container
docker run -v ~/.i2p:/var/i2p:rw -p 127.0.0.1:4444:4444 -p 127.0.0.1:6668:6668 -p 127.0.0.1:7657:7657 --name i2prouter i2p
