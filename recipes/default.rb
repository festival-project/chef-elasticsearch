#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

execute 'add elastic GPG key' do
  command 'wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add -'
  command 'echo "deb https://packages.elastic.co/elasticsearch/2.x/debian stable main" | tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list'
end

apt_update 'Update the apt cache' do
  action :update
end

apt_package 'openjdk-8-jdk' do
  action :install
end

apt_package 'elasticsearch' do
  action :install
end

execute 'auto start setting' do
  command '/bin/systemctl daemon-reload'
  command '/bin/systemctl enable elasticsearch.service'
end

template '/etc/elasticsearch/elasticsearch.yml' do
  source 'elasticsearch.yml.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

template '/etc/default/elasticsearch' do
  source 'elasticsearch.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

execute 'start elasticsearch' do
  command '/bin/systemctl start elasticsearch.service'
end
