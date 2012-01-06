#
# Cookbook Name:: perlbrew
# Recipe:: default
#
# Copyright 2012, David A. Golden
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

prereqs = [ "build-essential", "perl", "curl" ]

prereqs.each do |p|
  package p
end

perlbrew_root = node['perlbrew']['perlbrew_root']
perlbrew_bin = "#{perlbrew_root}/bin/perlbrew"

directory perlbrew_root

# if we have perlbrew, upgrade it
# XXX is this really a good idea?
bash "perlbrew self-upgrade" do
  environment ({'PERLBREW_ROOT' => perlbrew_root})
  code <<-EOC
  #{perlbrew_bin} self-upgrade
  #{perlbrew_bin} -f install-patchperl
  #{perlbrew_bin} -f install-cpanm
  EOC
  only_if {::File.exists?(perlbrew_bin)}
end

# if not, install it
bash "perlbrew-install" do
  cwd Chef::Config[:file_cache_path]
  environment ({'PERLBREW_ROOT' => perlbrew_root})
  code <<-EOC
  curl -kL http://install.perlbrew.pl > perlbrew-install
  source perlbrew-install
  #{perlbrew_root}/bin/perlbrew -f install-cpanm
  EOC
  not_if {::File.exists?(perlbrew_bin)}
end

# were any perls requested in attributes?
if node['perlbrew']['perls']
  node['perlbrew']['perls'].each do |p|
    perlbrew_perl p do
      action :install
    end
  end
end
