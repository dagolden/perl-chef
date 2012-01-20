#
# Author:: David A. Golden
# Cookbook Name:: perlbrew
# Provider:: perlbrew_service
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
  perlbrew_env = {
    'PERLBREW_ROOT' => node['perlbrew']['perlbrew_root'],
    'PERLBREW_HOME' => node['perlbrew']['perlbrew_root']
  }

  my_perlbrew       = new_resource.perlbrew
  my_cwd            = new_resource.cwd
  my_user           = new_resource.user
  my_group          = new_resource.group
  my_command        = new_resource.command
  my_env            = new_resource.environment.merge(perlbrew_env)

  runit_service new_resource.name do
    template_name 'perlbrew-service'
    cookbook 'perlbrew'
    options(
      :perlbrew_root  => node['perlbrew']['perlbrew_root'],
      :perlbrew => my_perlbrew,
      :user     => my_user,
      :group    => my_group,
      :command  => my_command,
      :cwd      => my_cwd
    )
    env my_env
  end
end

# :enable :disable :nothing :start :stop :restart :reload}
