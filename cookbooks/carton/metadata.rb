maintainer       "David Golden"
maintainer_email "dagolden@cpan.org"
license          "Apache 2.0"
version          "0.1.1"
description      "Installs/Configures carton and provides a LWRP"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
recipe           "carton::default", "Installs carton LWRP dependencies"
supports         "debian"
supports         "ubuntu"
depends          "perlbrew", ">= 0.1.1"
depends          "runit", ">= 0.15.0"  # this is a lie, see README.md
