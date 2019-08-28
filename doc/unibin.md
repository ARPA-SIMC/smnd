## Installing the universal binary package ##

The most original feature of this project is the universal binary
package, which is downloadable in the [releases
section](https://github.com/dcesari/smnd/releases) as
smnd-*_unibin.tar.gz. This is the quickest and most universal way to
install the software collection.

The binary package has been built on a Fedora 28 x86_64 GNU/Linux
distribution, however it contains all the necessary libraries, so
that, in principle, it can work on any Linux x86_64 system with kernel
2.6.32 or newer.

For installation it is not necessary to be root, you just have to
unpack the unibin package and run a script:

```
# cd to the desired intallation directory and unpack the package
tar -zxvf smnd-*_unibin.tar.gz
# enter the newly created directory
cd smnd-*
# complete the installation, this creates $HOME/smnd_profile
./install_from_bin.sh
```

In order to run any command of the SMND collection, you have to
preliminary "source" the profile once with the command
`. $HOME/smnd_profile` in the working session. The profile for
universal installation just prepends `unibin/` to the `PATH`
environment variable and sets `SMND_PREFIX` variable, so it can be
incorporated in the user's shell profile scripts (usually
`.bash_profile`) or moved to a different location.

If the binary installation is relocated, the `install_from_bin.sh`
script has to be rerun from the new location.

Since SMND version 2.0 it is possible to access the same physical
installation from different paths, e.g. when it is on an nfs share
having different mountpoints on different systems; for that purpose,
the `install_from_bin.sh` should be run from within every system
involved for creating a specialized `smnd_profile` file.

### GPL compliance ###

The universal binary distribution contains various libraries in binary
form from Fedora rpms, please contact the author in order to receive
the corresponding source packages for GPL compliance.
