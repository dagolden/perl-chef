Description
===========

To date, this cookbook has only been designed and tested on the
Ubuntu and Debian platforms.

Requirements
============

Attributes
==========


Recipes
=======

carton
----------

Installs ... 

Resources/Providers
===================

carton_app
-------------

This LWRP ...

Example:

    perlbrew_perl '5.14.2' do
      version 'perl-5.14.2'
      action :install
    end

This is equivalent to ...

Actions:

* ...

Attributes:

* ...

Usage
=====

If you wish to use the LWRP, be sure to include the `carton` recipe, which
ensures that carton is ready for use.

