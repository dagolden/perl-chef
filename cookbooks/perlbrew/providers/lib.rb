#
# Author:: David A. Golden
# Cookbook Name:: perlbrew
# Provider:: perlbrew_lib
#
# Copyright:: 2012, David A. Golden <dagolden@cpan.org>
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

require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

# XXX must be a fully qualified 'perl-5.X.Y@libname' style name
action :create do
  updated = false
  unless @lib.perlbrew_installed
    p = perlbrew_perl @lib.perlbrew do
      action :nothing
    end
    p.run_action(:install)
    updated = true
  end
  unless @lib.created
    e = execute "Create perlbrew lib #{new_resource.name}" do
      environment ({
        'PERLBREW_ROOT' => node['perlbrew']['perlbrew_root'],
        'PERLBREW_HOME' => node['perlbrew']['perlbrew_root']
      })
      command "#{node['perlbrew']['perlbrew_root']}/bin/perlbrew lib create #{new_resource.name}"
      action :nothing
    end
    e.run_action(:run)
    updated = true
  end
  new_resource.updated_by_last_action(updated)
end

# XXX must be a fully qualified 'perl-5.X.Y@libname' style name
action :delete do
  if @lib.created
    e = execute "Remove perlbrew #{new_resource.name}" do
      environment ({
        'PERLBREW_ROOT' => node['perlbrew']['perlbrew_root'],
        'PERLBREW_HOME' => node['perlbrew']['perlbrew_root']
      })
      command "#{node['perlbrew']['perlbrew_root']}/bin/perlbrew lib delete #{new_resource.name}"
      action :nothing
    end
    e.run_action(:run)
    new_resource.updated_by_last_action(true)
  end
end

def load_current_resource
  @lib = Chef::Resource::PerlbrewLib.new(new_resource.name)
  @lib.perlbrew(@lib.name[/[^@]+/])
  @lib.perlbrew_installed(::File.exists?("#{node['perlbrew']['perlbrew_root']}/perls/#{@lib.perlbrew}"))
  @lib.created(::File.exists?("#{node['perlbrew']['perlbrew_root']}/libs/#{@lib.name}"))
end
