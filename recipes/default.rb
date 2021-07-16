#
# Cookbook:: gitea
# Recipe:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

package %w(git inxi)

user 'git' do
  home '/home/git'
  shell '/bin/bash'
end

%w( /var /var/lib /var/lib/gitea /var/lib/gitea ).each do |path|
  directory path do
  owner 'git'
  group 'root'
  mode  '0750'
  end
end

%w{custom data log}.each do |dir|
  directory "/var/lib/gitea/#{dir}" do
    mode '750'
    owner 'git'
    group 'root'
  end
end

directory '/etc/gitea' do
  owner 'git'
  group 'root'
  mode  '770'
end

execute 'gitea export' do
  command "/bin/bash -c 'export GITEA_WORK_DIR=/var/lib/gitea/'"
end

remote_file '/usr/local/bin/gitea' do
  source 'https://dl.gitea.io/gitea/1.8.1/gitea-1.8.1-linux-amd64'
  mode '0755'
end
