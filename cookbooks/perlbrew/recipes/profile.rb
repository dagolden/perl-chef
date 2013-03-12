#
# Cookbook Name:: Perlbrew
# Recipe:: profile
#
# Author:: Jaryd Malbin, jaryd@duckduckgo.com
#
template "/etc/profile.d/perlbrew.sh" do
    source 'perlbrew.sh.erb'
    owner 'root'
    group 'root'
    mode 0644
end
