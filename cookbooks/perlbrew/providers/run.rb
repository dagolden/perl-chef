#
# Author:: David A. Golden
# Cookbook Name:: perlbrew
# Provider:: perlbrew_run
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
action :run do
  perlbrew_env = {
    'PERLBREW_ROOT' => node['perlbrew']['perlbrew_root'],
    'PERLBREW_HOME' => node['perlbrew']['perlbrew_root']
  }
  b = bash new_resource.name do
    environment new_resource.environment.merge(perlbrew_env)
    cwd new_resource.cwd if new_resource.cwd
    code <<-EOC
    source #{node['perlbrew']['perlbrew_root']}/etc/bashrc
    perlbrew use #{new_resource.perlbrew}
    #{new_resource.command}
    EOC
    action :nothing
  end
  b.run_action(:run)
  new_resource.updated_by_last_action(true)
end
