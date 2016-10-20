#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

apt_update 'Update the apt cache' do
  action :update
end

apt_package 'openjdk-8-jdk' do
  action :install
end


