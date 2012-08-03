#
# Author:: David A. Golden
# Cookbook Name:: perlbrew
# Provider:: carton_app
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

action :run do
  # XXX should probably fail if no carton.lock is found in cwd

  app_perlbrew       = new_resource.perlbrew
  app_cwd            = new_resource.cwd
  app_command        = "carton exec -I lib -- #{new_resource.command}"

  # hash carton.lock to ensure library dir is unique to a lock file
  lock_hash = `sha1sum #{app_cwd}/carton.lock`[0..7]

  app_local          = "local-#{app_perlbrew}-#{lock_hash}"
  app_env            = new_resource.environment.merge({
    'PERLBREW_ROOT'     => node['perlbrew']['perlbrew_root'],
    'PERLBREW_HOME'     => node['perlbrew']['perlbrew_root'],
    'PERL_CARTON_PATH'  => app_local
  })

  # ensure we have perl + carton for requested perlbrew version
  carton_perlbrew = app_perlbrew || node['carton']['perlbrew']
  carton_lib = "#{carton_perlbrew}@carton"

  perlbrew_perl carton_perlbrew
  perlbrew_lib carton_lib
  perlbrew_cpanm 'Carton' do
    perlbrew carton_lib
    modules ['Carton']
  end

  perlbrew_run app_command do
    perlbrew carton_lib
    environment app_env
    cwd app_cwd
  end

  new_resource.updated_by_last_action(true)
end

# :enable :disable :nothing :start :stop :restart :reload}
