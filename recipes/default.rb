#
# Cookbook:: gitea
# Recipe:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.
include_recipe "ark"

package %w(git inxi)

ark "gitea" do
  path "/var/lib/gitea"
  url 'https://dl.gitea.io/gitea/1.8.1/gitea-1.8.1-linux-amd64'
end
