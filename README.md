# SMND

## Software for Meteorology, Normally Distributed ##
> the software for sure, the meteorological data not really.

SMND is a helper package for simplifying the build and the deployment
of a collection of meteorological software packages, mainly developed
by [Arpae-SIMC](http://www.arpa.emr.it/sim). The current version is
relatively stable, including the universal binary package.

The software packages involved, all open source and freely
redistributable, are:

 - [eccodes](https://confluence.ecmwf.int/display/ECC/ecCodes+Home)
   from ECMWF
 - [wreport](https://github.com/ARPA-SIMC/wreport)
 - [bufr2netcdf](https://github.com/ARPA-SIMC/bufr2netcdf)
 - [DB.All-e](https://github.com/ARPA-SIMC/dballe)
 - [arkimet](https://github.com/ARPA-SIMC/arkimet)
 - [libsim](https://github.com/ARPA-SIMC/libsim)

### Building the software from source ###

For building autonomously the software collection you can follow the
guidelines in the [corresponding page](doc/buildfromsource.md).

### Deploying the software

If you do not want to build the packages on your own, different
approaches are possible for quickly deploying precompiled binaries:

 * The quick and universal way, [the universal binary
   package](doc/unibin.md) (no need to be the system administrator).
 * Running from a [singularity container](doc/singularity.md)
   (requires agreement with the system administrator).
 * Installing in a supported distribution (CentOS/Fedora) from [copr
   repository](doc/copr.md) (requires to BE the system administrator).

### Deprecation note

This build tool and the universal binary package are at the moment (2023-09)
deprecated in favor of the [singularity container](doc/singularity.md)
approach. See also the [nwprun package](https://github.com/ARPA-SIMC/nwprun)
for other related containers.

Please notice also that
the universal binary packages successive to smnd version 2.7
do not contain the arkimet
package due to the dependency on python which would be uncomfortable to be
included in the universal package. The universal package v2.7 though is still
available for download in the releases section of github.
