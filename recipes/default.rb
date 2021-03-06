#
# Cookbook:: gitea
# Recipe:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

package %w(git inxi sqlite)

group 'git' do
  system true
  action :create
end

user 'git' do
  action :create
  comment 'Gitea server user'
  home '/home/git'
  group 'git'
  shell '/bin/bash'
  system true
  manage_home true
end

directory '/var/lib/gitea' do
  owner 'git'
  group 'git'
  mode  '0750'
end

%w{custom data log}.each do |dir|
  directory "/var/lib/gitea/#{dir}" do
    mode '750'
    owner 'git'
    group 'git'
  end
end

directory '/etc/gitea' do
  owner 'git'
  group 'git'
  mode  '770'
end

remote_file '/usr/local/bin/gitea' do
  source 'https://dl.gitea.io/gitea/1.8.1/gitea-1.8.1-linux-amd64'
  mode '0755'
end




systemd_unit 'gitea.service' do
  content <<~EOU
  [Unit]
  Description=Gitea (Git with a cup of tea)
  After=syslog.target
  After=network.target
  #Requires=mysql.service
  #Requires=mariadb.service
  #Requires=postgresql.service
  #Requires=memcached.service
  #Requires=redis.service

  [Service]
  # Modify these two values and uncomment them if you have
  # repos with lots of files and get an HTTP error 500 because
  # of that
  ###
  #LimitMEMLOCK=infinity
  #LimitNOFILE=65535
  RestartSec=2s
  Type=simple
  User=git
  Group=git
  WorkingDirectory=/var/lib/gitea/
  ExecStart=/usr/local/bin/gitea web -c /etc/gitea/app.ini
  Restart=always
  Environment=USER=git HOME=/home/git GITEA_WORK_DIR=/var/lib/gitea
  # If you want to bind Gitea to a port below 1024 uncomment
  # the two values below
  ###
  #CapabilityBoundingSet=CAP_NET_BIND_SERVICE
  #AmbientCapabilities=CAP_NET_BIND_SERVICE

  [Install]
  WantedBy=multi-user.target
  EOU

  action [:create, :enable, :start]
end

service 'gitea' do
  action :start
end

ENV['GITEA_WORK_DIR'] = '/var/lib/gitea'
bash 'setenv' do
  user 'root'
  code 'echo GITEA_WORK_DIR=/var/lib/gitea/ >> /etc/environment' 
end

execute 'gitea' do
  command '/usr/local/bin/gitea web -c /etc/gitea/app.ini &'
end
