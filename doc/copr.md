## Installing packages in a supported distribution ##

All the packages composing the SMND collection are available as
pre-built and source RPM pakages for Centos 7 and for the latest
Fedora GNU/Linux distributions on the [Arpae-SIMC public software
repository](https://copr.fedorainfracloud.org/coprs/simc/stable/) on
the [Copr](https://copr.fedorainfracloud.org) platform, which is a
free service provided by the Fedora project.

The steps for enabling the repository and installing the packages
(similarly to what is done in the
[container](https://github.com/ARPA-SIMC/smnd/blob/master/centos7-smnd-run.def)
approach), on a CentOS 7 distribution are the following:

```
# install copr plugin and enable simc repository
yum install yum-plugin-copr
yum copr enable simc/stable epel-7
# install smnd packages from simc repository
yum install wreport bufr2netcdf dballe arkimet libsim
```

while for Fedora:

```
dnf install dnf-plugins-core
dnf copr enable simc/stable
dnf install wreport bufr2netcdf dballe arkimet libsim
```

The rpm packages in the copr repository are automatically rebuilt and
published when a new release of the corresponding package is created
on github repository.
