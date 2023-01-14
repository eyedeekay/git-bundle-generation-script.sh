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
