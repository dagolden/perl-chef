Description
===========

Installs perlbrew and provides resource/provider types for managing
perls with perlbrew.

To date, this cookbook has only been designed and tested on the
Ubuntu and Debian platforms.

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
* `node['perlbrew']['cpanm_options'] = ''` - A string of command line options for `cpanm`, e.g. `--notest` for installing modules without running tests

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

* :install - install the specified perl (default action)
* :remove - uninstall the specified perl

Attributes:

* :version - the version of perl to install, in the "perl-X.Y.Z" format that perlbrew expects
This is based on the perlbrew_perl name if not provided.
* :install_options - overrides the default install options on the node. (Not recommended.)

perlbrew_lib
------------

This LWRP creates a perlbrew-based local::lib library for a particular perlbrew
perl.

Example:

    perlbrew_lib 'perl-5.14.2@mylib' do
      action :create
    end

This is equivalent to `perlbrew lib create perl-5.14.2@mylib`

Action:

* :create - creates the local::lib (default action)
* :delete - removes the local::lib

Attributes:

* :perlbrew - the perlbrew perl to attach the library to (e.g. 'perl-5.14.2').
It will be derived from the perlbrew_lib name if not provided.  The
perlbrew perl will be installed using the perlbrew_perl LRWP if it has not already
been installed.

perlbrew_cpanm
--------------

This LWRP installs CPAN modules to a given perlbrew perl or local::lib using
cpanm (App::cpanminus).

Example:

    perlbrew_cpanm 'Modern Perl modules' do
      perlbrew 'perl-5.14.2@mylib'
      modules ['Modern::Perl', 'Task::Kensho']
    end

This is equivalent to

    $ perlbrew use perl-5.14.2@mylib
    $ cpanm Modern::Perl Task::Kensho

Note that the resource name "Modern Perl modules" will be associated with a set of
modules only once.  The name should be unique for any particular chef run.

Action:

* :install - install the list of modules (default action) 

Attributes:

* :perlbrew - the perlbrew perl (and optional library) to use for installing
modules (REQUIRED)
* :modules - an array of module names to pass to cpanm.  Any legal input
to cpanm is allowed.
* :options - a string of options to pass to cpanm.  Any legal options to
cpanm is allowed.

perlbrew_run
------------

This LWRP runs a bash command in the context of a given perlbrew perl or local::lib.

Example 1:

    perlbrew_run 'Perl hello world' do
      perlbrew 'perl-5.14.2@mylib'
      command "perl -wE 'say q{Hello World}'"
    end

This is equivalent to

    $ perlbrew use perl-5.14.2@mylib
    $ perl -wE 'say q{Hello World}'

Example 2:

    perlbrew_run 'hello-world.pl' do
      perlbrew 'perl-5.14.2@mylib'
    end

This is equivalent to

    $ perlbrew use perl-5.14.2@mylib
    $ hello-world.pl

Note that the resource name will only be executed once for a given chef run.

Action:

* :run - runs the command (default action) 

Attributes:

* :perlbrew - the perlbrew perl (and optional library) to be enabled prior
to running the command (REQUIRED)
* :command - the bash command to run; taken from the resource name if not
provided
* :cwd - directory to enter prior to running the command, just like the `bash`
resource attribute
* :environment - hash of environment variables to set prior to running the
command, just like the `bash` resource attribute

Usage
=====

If you wish to use the LWRP, be sure to include the `perlbrew` recipe, which
ensures that perlbrew is ready for use.

