#!/bin/bash
# copy the templates and edit them afterwards
cp run.sh-template run.sh
cp Dockerfile-template Dockerfile

# check if curl is available
curl=$(command -v curl)
if [[ "$curl" == "" ]]
then
  echo curl is not available
  echo cannot determine external ip
  exit
fi

# check if shuf is available
shuf=$(command -v shuf)
if [[ "$shuf" == "" ]]
then
  echo shuf is not available
  echo cannot generate random port number
  exit
fi

# check if sed is available
sed=$(command -v sed)
if [[ "$sed" == "" ]]
then
  echo sed is not available
  echo cannot generate random port number
  exit
fi

# check if Dockerfile can be found
if [[ ! -e Dockerfile ]]
then
  echo Dockerfile is not present
  echo maybe call the script from the same directory where the Dockerfile is
  exit
fi

# change ip in dockerfile
ip=$(curl -s https://4.ifcfg.me/)
line="ENV EXTERNAL_IP "
sed -i "s/${line}.*/${line}${ip}/g" Dockerfile

# change port in dockerfile and run.sh
port=$(shuf -i 9000-31000 -n 1)
line="ENV I2P_PORT "
sed -i "s/${line}.*/${line}${port}/g" Dockerfile

line="EXPOSE randomportnumber"
sed -i "s/${line}.*/EXPOSE ${port}/g" Dockerfile

line="i2pport=randomport"
sed -i "s/${line}.*/i2pport=${port}/g" run.sh

# build the image
docker build -t i2p .
