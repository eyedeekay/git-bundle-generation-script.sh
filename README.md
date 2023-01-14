# git-bundle-generation-script.sh

Generate git bundles of every I2P tag automatically.

 - **[Torrents Listing](TORRENTS.html)**

To use the `generate.sh` script to create torrents of every possible I2P git bundle,
first, install all the I2P build dependencies.

On Debian or Ubuntu, use:

```sh

sudo apt-get install debhelper ant debconf default-jdk gettext libgmp-dev po-debconf fakeroot \
  build-essential quilt dh-apparmor libservice-wrapper-java libjson-simple-java \
  devscripts libjetty9-java libtomcat9-java libtaglibs-standard-jstlel-java libgetopt-java git
```

Then check out this repository to the `docroot` of your `zzzot` installation.
Run the `generate.sh` script to create the torrents.
Re-run the `generate.sh` script to create new torrents, as-needed.
It is designed so it can be used as a cron job by a user with I2P and `zzzot` installed.

**To make every torrent also have a webseed, set a `HOST` environment variable containing the URL(base32 form) of your zzzot instance.**
**Without a trailing slash.**
For example:

```sh

export HOST=http://ae5rbez5qu54o3lt7iczg56bmwvicpymj7al2riuhvogdllz554q.b32.i2p
```

To automatically download the latest git bundle using I2P, create the following script:

```sh

#! /usr/bin/env sh

DIR=$( cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P )

if [ -z "$I2PSNARK" ]; then
    I2PSNARK="$HOME/.i2p/i2psnark"
fi

if [ ! -d "$HOME/.i2p/i2psnark" ]; then
    if [ -d "$HOME/i2p/i2psnark" ]; then
        I2PSNARK="$HOME/i2p/i2psnark"
    fi
fi

if [ -z "$I2PSNARK" ]; then
    echo "I2PSnark directory not found"
    exit 1
fi

if [ -z "$HOST" ]; then
    HOST="http://ae5rbez5qu54o3lt7iczg56bmwvicpymj7al2riuhvogdllz554q.b32.i2p"
fi

rm -f "$I2PSNARK/i2p.i2p.trunk.bundle.torrent.bak" 
mv "$I2PSNARK/i2p.i2p.trunk.bundle" "$I2PSNARK/i2p.i2p.trunk.bundle.bak"; true
export http_proxy=http://localhost:4444
export https_proxy=http://localhost:4444
wget -O "$I2PSNARK/i2p.i2p.trunk.bundle.torrent" "$HOST/torrents/i2p.i2p.trunk.bundle.torrent"
```

and run it as a cron job too. You can download it [here](http://ae5rbez5qu54o3lt7iczg56bmwvicpymj7al2riuhvogdllz554q.b32.i2p/peer.sh).
