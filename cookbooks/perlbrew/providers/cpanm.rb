#
# Author:: David A. Golden
# Cookbook Name:: perlbrew
# Provider:: perlbrew_cpanm
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
  perlbrew_env = {
    'PERLBREW_ROOT' => node['perlbrew']['perlbrew_root'],
    'PERLBREW_HOME' => node['perlbrew']['perlbrew_root']
  }
  options = new_resource.options ? new_resource.options : node['perlbrew']['cpanm_options']
  new_resource.modules([new_resource.name]) unless new_resource.modules.length > 0
  p = perlbrew_run "cpanm #{options} #{new_resource.modules.join(' ')}" do
    perlbrew new_resource.perlbrew
    action :nothing
  end
  p.run_action(:run)
  new_resource.updated_by_last_action(true)
end

alias_method :action_run, :action_install
