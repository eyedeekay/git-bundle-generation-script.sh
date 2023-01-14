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

To automatically download the latest git bundle using I2P, create the following script:

```sh
TODO
```