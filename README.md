# docker-i2p
This is a docker image for the I2P-router. It is intended to run on a server with sufficient bandwidth (>=50Mbit/s) though it might only use about 10Mbit/s on average depending on your hardware.

## build and run
Run './build.sh' and then './run.sh'.

## connect to the router (optional)
Then you can connect to your i2prouter on your server with
`ssh -L 4444:127.0.0.1:4444 -L 7657:127.0.0.1:7657 example-domain.tld -l username-on-your-server`.
