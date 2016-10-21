#
# Cookbook Name:: festival-elasticsearch
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

execute 'add elastic GPG key' do
  command 'wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add -'
end

cookbook_file '/etc/apt/sources.list.d/elasticsearch-2.x.list' do
  source 'elasticsearch-2.x.list'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

apt_update 'Update the apt cache' do
  action :update
end

apt_package 'openjdk-8-jdk' do
  action :install
end

apt_package 'elasticsearch' do
  options '--allow-unauthenticated'
  action :install
end

template '/etc/elasticsearch/elasticsearch.yml' do
  source 'elasticsearch.yml.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables({
    :path_data => node.combined_default['festival-elasticsearch']['path.data'],
    :network_host => node.combined_default['festival-elasticsearch']['network.host'],
    :es_heap_size => node.combined_default['festival-elasticsearch']['ES_HEAP_SIZE']
  })
end

directory node.combined_default['festival-elasticsearch']['path.data'] do
  owner 'elasticsearch'
  group 'elasticsearch'
  mode '0755'
  action :create
end

template '/etc/default/elasticsearch' do
  source 'elasticsearch.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

systemd_unit 'elasticsearch.service' do
  action [:enable, :start]
end
