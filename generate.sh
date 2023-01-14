#! /usr/bin/env sh

DIR=$( cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P )
cd "$DIR"

if [ ! -d "$DIR/i2p.i2p" ]; then
    git clone https://i2pgit.org/i2p-hackers/i2p.i2p || exit 1
fi

cd "$DIR/i2p.i2p" || exit 1
git pull --unshallow
git pull --tags
TAGLIST=$(git tag)
for tag in $TAGLIST; do
    if [ ! -f "$DIR/torrents/i2p.i2p.$tag.bundle" ]; then
        git bundle create "$DIR/torrents/i2p.i2p.$tag.bundle" "$tag"
    fi
done
BUNDLE=$(ls "$DIR/i2p.i2p/"*.bundle)
if [ ! -f "$BUNDLE" ]; then
    ant git-bundle 
fi

rm -f "$DIR/torrents/i2p.i2p.trunk.bundle"
git bundle create "$DIR/torrents/i2p.i2p.trunk.bundle" "master" --all --tags --branches


cd "$DIR/torrents" || exit 1

mki2ptorrent() {
    if [ ! -f "$DIR/i2p.i2p/build/i2psnark.jar" ]; then
        ant buildI2PSnark
    fi
    if [ ! -z "$HOST" ]; then
        fname=$(basename $1)
        WEBSEED_URL="-w $HOST/torrents/$fname"
    fi
    java \
        -cp "$DIR/i2p.i2p/build/i2p.jar:$DIR/i2p.i2p/build/i2psnark.jar" \
        "org.klomp.snark.Storage" \
        -a "http://w7tpbzncbcocrqtwwm3nezhnnsw4ozadvi2hmvzdhrqzfxfum7wa.b32.i2p/a" \
        -c "$(whoami)" \
        -m "torrent for version $1" \
        $WEBSEED_URL \
        "$1"
    echo $WEBSEED_URL | sed 's|-w|Webseed:    |g'
}

DATE=$(date)

echo "I2P Git Bundles" | tee "$DIR/TORRENTS.md"
echo "===============" | tee -a "$DIR/TORRENTS.md"
echo "" | tee -a "$DIR/TORRENTS.md"
echo "These are torrents of the I2P git bundles." | tee -a "$DIR/TORRENTS.md"
echo "" | tee -a "$DIR/TORRENTS.md"
echo "Trunk" | tee -a "$DIR/TORRENTS.md"
echo "=====" | tee -a "$DIR/TORRENTS.md"
echo "" | tee -a "$DIR/TORRENTS.md"
echo "This torrent contains all branches, tags, and checkins as of $DATE" | tee -a "$DIR/TORRENTS.md"
echo "" | tee -a "$DIR/TORRENTS.md"
echo " - [$bundle](/torrents/i2p.i2p.trunk.bundle)" | tee -a "$DIR/TORRENTS.md"
echo '```' | tee -a "$DIR/TORRENTS.md"
echo "" | tee -a "$DIR/TORRENTS.md"
mki2ptorrent "$DIR/torrents/i2p.i2p.trunk.bundle" | tee -a "$DIR/TORRENTS.md"
echo '```' | tee -a "$DIR/TORRENTS.md"
echo "" | tee -a "$DIR/TORRENTS.md"
echo "Tags" | tee -a "$DIR/TORRENTS.md"
echo "====" | tee -a "$DIR/TORRENTS.md"
echo "" | tee -a "$DIR/TORRENTS.md"
echo "These are snapshots of the git repository i2p.i2p corresponding to each tag." | tee -a "$DIR/TORRENTS.md"
echo "You can download them with I2PSnark, and then clone the tag from your filesystem." | tee -a "$DIR/TORRENTS.md"
echo "" | tee -a "$DIR/TORRENTS.md"
for bundle in *.bundle; do
    bundle=$(basename $bundle)
    echo "" | tee -a "$DIR/TORRENTS.md"
    echo " - [$bundle](/torrents/$bundle.torrent)" | tee -a "$DIR/TORRENTS.md"
    echo '```' | tee -a "$DIR/TORRENTS.md"
    echo "" | tee -a "$DIR/TORRENTS.md"
    mki2ptorrent "$bundle" | tee -a "$DIR/TORRENTS.md"
    echo '```' | tee -a "$DIR/TORRENTS.md"
done

edgar
