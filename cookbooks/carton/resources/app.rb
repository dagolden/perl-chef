#
# Author:: David A. Golden
# Cookbook Name:: perlbrew
# Resource:: perlbrew_service
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

actions :create, :enable, :disable, :start, :stop, :restart

attribute :perlbrew, :kind_of => String, :required => true
attribute :command, :kind_of => String, :required => true
attribute :cwd, :kind_of => String, :required => true

attribute :user, :kind_of => String, :default => "nobody"
attribute :group, :kind_of => String, :default => "nobody"
attribute :environment, :kind_of => Hash, :default => {}

def initialize(*args)
  super
  @action = :create
end

