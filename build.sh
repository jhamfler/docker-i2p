#!/bin/bash
die=0
# check for locale setting
loc=$(command -v locale)
if [[ "$loc" == "" ]]
then
  echo locale not available
  echo Cannot determine the language of the system. Please set it manually inside Dockerfile-template.
  echo Using english as default for now.
else
  lang=$(locale|grep LANG=)
  lang=${lang##*=}
fi

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
# if no internet conection -> external ip is empty
if [[ "$ip" == "" ]]
then
  # find it using the local ip -> should be std on a server
  ip=$(ip -4 a| grep ": e" -A 1|grep inet | grep -Eo '((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])' | grep -m1 '.*')
fi
line="ENV EXTERNAL_IP "
sed -i "s/${line}.*/${line}${ip}/g" $dockerfile

# change port in dockerfile and run.sh
line="ENV I2P_PORT "
sed -i "s/${line}.*/${line}${port}/g" $dockerfile

line="EXPOSE randomportnumber"
sed -i "s/${line}.*/EXPOSE ${port}/g" $dockerfile

line="i2pport=randomport"
sed -i "s/${line}.*/i2pport=${port}/g" $runfile

# set the language of the image to the language of the system
line="ENV LANG "
if [[ "$lang" == "" ]]
then
  sed -i "s/${line}.*/${line}en_GB.UTF-8/g" $dockerfile
else
  sed -i "s/${line}.*/${line}${lang}/g" $dockerfile
fi

# find out how many containers were created and set the control port based on that
containers=$(ls -1 | grep 'run\-' | wc -l)
if [[ $(printf $containers | wc -c) == 1 ]]
then
  controlport="760$containers"
else
  controlport="76$containers"
fi
line="i2pcontrolport=noportyet"
sed -i "s/${line}.*/i2pcontrolport=${controlport}/g" $runfile

# build the image
docker build -f $dockerfile -t i2p-$port .
