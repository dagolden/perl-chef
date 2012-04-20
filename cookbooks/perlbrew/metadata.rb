maintainer       "David Golden"
maintainer_email "dagolden@cpan.org"
license          "Apache 2.0"
version          "0.1.0"
description      "Installs/Configures perlbrew"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
recipe           "perlbrew::default", "Installs/updates perlbrew"
supports         "debian"
supports         "ubuntu"
