#!/bin/bash
die=0
# check if curl is available
curl=$(command -v curl)
if [[ "$curl" == "" ]]
then
  echo curl is not available
  echo Cannot determine external IP.
  die=1
fi

# check if shuf is available
shuf=$(command -v shuf)
if [[ "$shuf" == "" ]]
then
  echo shuf is not available
  echo Cannot generate random port number.
  die=1
fi

# check if sed is available
sed=$(command -v sed)
if [[ "$sed" == "" ]]
then
  echo sed is not available
  echo Cannot change random port number.
  die=1
fi

# check if the Dockerfile can be found
if [[ ! -e Dockerfile-template ]]
then
  echo Dockerfile-template is not present
  echo Maybe call the script from the same directory where the Dockerfile-template is.
  die=1
fi

if [[ $die == 1 ]]
then
  exit
fi

# Generate a random portnumber for the i2p-router.
# This step is normally done automatically by the i2p-router with this
# port range and recommended by the documentation.
# It needs to be done this way as docker needs to be started with portforward
# and the number would be generated after the start inside the container.
port=$(shuf -i 9000-31000 -n 1)

# copy the templates and edit them afterwards
dockerfile="Dockerfile-"$port
runfile="run-"$port".sh"
cp run.sh-template $runfile
cp Dockerfile-template $dockerfile

# change ip in dockerfile
ip=$(curl -s https://4.ifcfg.me/)
line="ENV EXTERNAL_IP "
sed -i "s/${line}.*/${line}${ip}/g" $dockerfile

# change port in dockerfile and run.sh
line="ENV I2P_PORT "
sed -i "s/${line}.*/${line}${port}/g" $dockerfile

line="EXPOSE randomportnumber"
sed -i "s/${line}.*/EXPOSE ${port}/g" $dockerfile

line="i2pport=randomport"
sed -i "s/${line}.*/i2pport=${port}/g" $runfile

# build the image
docker build -f $dockerfile -t i2p-$port
