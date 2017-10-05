# docker-i2p
Docker Image for the I2P-router

## Scope of this repository
This image is meant to run on a server with some bandwidth and processing power.
When you want to have i2p on your server instead of your laptop or whatever - use this repo.
When you want everything important preconfigured - use this repo.
When you want to do filesharing over i2p - use this repo.
When you want to run multiple i2p-router on a big server to aid the network - use this repo.

## Using it
### Setup and run
Just execute that.
```
git clone https://github.com/jhamfler/docker-i2p.git && cd docker-i2p
./build.sh
./run-*.sh
```

### Explanation
`build.sh` builds the Dockerfile and run.sh which is neccessary since a port randomization needs to be done.
You can run the build many times and get multiple dockerfiles that way which you can use to start multiple containers.
You need to build a new one for every port since a port forward cannot be established from inside a docker container. It needs to be done before the start. Thus the script was created to make your life easier.

Simly run the appropriate run-*.sh and start the container (or many).

You can connect to your i2p-router on your server with `ssh -L 4444:127.0.0.1:4444 -L 7657:127.0.0.1:7657 example-domain.tld -l username-on-your-server`.
Check the sshd configuration on your server if this doesn't work.
After that just open your browser and connect to 127.0.0.1:7657
