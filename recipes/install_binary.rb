#
# Copyright 2014 John Bellone <jbellone@bloomberg.net>
# Copyright 2014 Bloomberg Finance L.P.
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

include_recipe 'ark::default'

ark 'consul' do
  url Chef::Consul.remote_url(node)
  checksum Chef::Consul.remote_checksum(node)
  path Chef::Consul.install_path(node)
  creates 'consul'
  action :dump
end

directory File.basename(Chef::Consul.active_binary(node)) do
  recursive true
  action :create
end

# JW TODO: Remove after next major release.
file Chef::Consul.active_binary(node) do
  action :delete
  not_if "test -L #{Chef::Consul.active_binary(node)}"
end

link Chef::Consul.active_binary(node) do
  to Chef::Consul.latest_binary(node)
end

include_recipe 'consul::_service'
