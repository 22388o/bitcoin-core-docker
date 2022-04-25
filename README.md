# Introduction

> Bitcoin full node on Docker, built from source.

```shell
~$ git clone https://github.com/f-dufour/bitcoin-core-docker.git
~$ cd bitcoin-core-docker
# Edit volumes in docker-compose.yaml
~$ make up
```

- You can interact with bitcoin core within the container.
- The server automatically downloads the bitcoin blockchain. Make it persistent by mounting an external volume to `/root/.bitcoin`.
- A `bitcoin.conf.template` configuration template file is available in the repo. Name it `bitcoin.conf` on the persistent drive for `bitcoind` to use it.

# Build the image

You can use the `--build-arg` flag to tweak your Docker build.

| Software    | Default version      | --build-arg       |
|-------------|----------------------|-------------------|
| Ubuntu      | 20.04                | ubuntuVersion     |
| Bitcoin     | v23.0              | bitcoinVersion    |

_Note: Only Berkeley db 4.8.30.NC is supported and provided_

Example:

```bash
~$ ~$ docker build --build-arg bitcoinVersion=v0.13.1 --build-arg ubuntuVersion=bionic -t yourname/bitcoin:0.13.1 .
```

# Use the image

- Bitcoin core is launched in daemon mode as the container is started
- It can run on the testnet or mainnet depending on you `bitcoin.conf` (regtest also available)