Description
===========

Installs perlbrew and provides resource/provider types for managing
perls with perlbrew.

To date, this cookbook has only been designed and tested on the
Ubuntu platform.

Requirements
============

Perlbrew components are downloaded from the web and requires a system-installed
perl to run.  Perlbrew managed perls are built from source and require a
standard compiler toolchain. The following packages are required (and will be
installed if missing)

* curl
* perl
* build-essential

Attributes
==========

* `node['perlbrew']['perlbrew_root'] = "/opt/perlbrew"` - Sets the `PERLBREW_ROOT` environment variable
* `node['perlbrew']['perls'] = []` - An array of perls to install, e.g. `["perl-5.14.2", "perl-5.12.3"]`
* `node['perlbrew']['install_options'] = ''` - A string of command line options for `perlbrew install`, e.g. `-D usethreads` for building all perls with threads

Recipes
=======

perlbrew
----------

Installs/updates perlbrew along with patchperl and cpanm.  This is required for
use of the LWRP.  Optionally installs perls specified in the
`node['perlbrew']['perls']` attribute list.

Resources/Providers
===================

perlbrew_perl
-------------

This LWRP installs perls into `node['perlbrew']['perlbrew_root']` using
perlbrew.

    # option 1
    perlbrew_perl perl-VERSION do
      action :install
    end

    # option 2
    perlbrew_perl NICKNAME do
      version perl-VERSION
      action :install
    end

Example:

    perlbrew_perl '5.14.2' do
      version 'perl-5.14.2'
      action :install
    end

This is equivalent to `perlbrew install perl-5.14.2 --as 5.14.2`.

Actions:

* :install - install the specified perl
* :remove - uninstall the specified perl

Attributes

* :version - the version of perl to install, in the "perl-X.Y.Z" format that perlbrew expects

Usage
=====

If you wish to use the LWRP, be sure to include the `perlbrew` recipe, which
ensures that perlbrew is ready for use.

