#
# Author:: David A. Golden
# Cookbook Name:: perlbrew
# Provider:: perlbrew_perl
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

action :install do
  unless @perl.installed
    new_resource.version(new_resource.name) if not new_resource.version
    new_resource.install_options(node['perlbrew']['install_options']) if not new_resource.install_options
    e = execute "Install perlbrew perl #{new_resource.name}" do
      environment ({'PERLBREW_ROOT' => node['perlbrew']['perlbrew_root']})
      command "#{node['perlbrew']['perlbrew_root']}/bin/perlbrew install #{new_resource.version} --as #{new_resource.name} #{new_resource.install_options}"
      action :nothing
    end
    e.run_action(:run)
    @perl.installed(true)
    new_resource.updated_by_last_action(true)
  end
end

action :remove do
  if @perl.installed
    e = execute "Remove perlbrew perl #{new_resource.name}" do
      environment ({'PERLBREW_ROOT' => node['perlbrew']['perlbrew_root']})
      command "#{node['perlbrew']['perlbrew_root']}/bin/perlbrew uninstall #{new_resource.name}"
      action :nothing
    end
    e.run_action(:run)
    @perl.installed(false)
    new_resource.updated_by_last_action(true)
  end
end

def load_current_resource
  @perl = Chef::Resource::PerlbrewPerl.new(new_resource.name)
  @perl.installed(::File.exists?("#{node['perlbrew']['perlbrew_root']}/perls/#{@perl.name}"))
end
