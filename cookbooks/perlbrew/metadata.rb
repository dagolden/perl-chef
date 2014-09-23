name             "perlbrew"
maintainer       "David Golden"
maintainer_email "dagolden@cpan.org"
license          "Apache 2.0"
version          "0.1.1"
description      "Installs/Configures perlbrew"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
recipe           "perlbrew::default", "Installs/updates perlbrew"

%w{ debian ubuntu centos amazon }.each do |os|
  supports os
end

depends "build-essential"
