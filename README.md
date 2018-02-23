# docker-i2p
Docker Image for the Invisible Internet Project

## Scope of this repository
This image is meant to run on a server with some bandwidth and processing power.
Use this repository when you want to
* have i2p on your server instead of your laptop or whatever.
* have everything important preconfigured.
* do filesharing over i2p.
* run multiple i2p-router on a big server to aid the network.

## Using it
### Setup and run
Just execute that.
```
git clone https://github.com/jhamfler/docker-i2p.git && cd docker-i2p
./build.sh
./run-*.sh
```

### Explanation
`build.sh` builds the Dockerfile and run-<aPort>.sh which is neccessary since a port randomization needs to be done.
You can run the build many times and get multiple dockerfiles that way which you can use to start multiple containers.
You need to build a new one for every port since a port forward cannot be established from inside a docker container.
It needs to be done before the start.
Thus the script was created to make your life easier.

### Connecting to the i2p-router
You can connect to your i2p-router on your server with `ssh -L 4444:127.0.0.1:4444 -L 7600:127.0.0.1:7600 example-domain.tld -l username-on-your-server`.
Check the sshd configuration on your server if this doesn't work.
After that just open your browser and connect to the router console on 127.0.0.1:7600

## Running multiple containers
### Setup and run
```
git clone https://github.com/jhamfler/docker-i2p.git && cd docker-i2p
for i in $(seq 1 4) # make 4 containers
do
  ./build.sh
done
./run-*.sh # start all of them
```

## Further explanations
### General
You should not increase the bandwidth much more than set in the Dockerfile.
The reason for this is that the router complains about limited memory.
It makes sense as already in memory stored information doesn't have to be calculated again which helps the response time of your connections and therefore results in a fast router.
So more memory should speed up the network.
As the router comlains about low memory when set too low I adjusted it for the bandwidth I deemed practical.
In practice the router has on average a throughput of about 400-500KBps (~3-4Mbit/s) with ~700MB memory usage and 44/100% CPU load (while being limited to 2 cores of an E5-2680).

### Multiple containers
Please only use multiple containers if your server has at least 20% room left after you start another one.
So if your server already uses 41/100% of your CPU you shouldn't start another one.
Simply start one container and check its resource consumption after 3 days.
If it didn't went up after 7 days and you have enough resources left then you can start another one.

Also consider creating a router family when you do that.
More information can be found on the official website.



####
You also need to change the locales in the Dockerfile if you want a different language.
