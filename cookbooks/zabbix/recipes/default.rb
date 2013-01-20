#
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright 2013, CloudNOC
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :start
log "Centos detected - installing deps"

log "node[:zabbix][:server_path] - #node[:zabbix][:server_path]"
log "node[:zabbix][:username] - #node[:zabbix][:username]"
log "node[:zabbix][:password] - #node[:zabbix][:password]"
log "node[:zabbix][:contact1] - #node[:zabbix][:contact1]"
log "node[:zabbix][:proxy_host_name] - #node[:zabbix][:proxy_host_name]"
log "node[:zabbix][:proxy_ip] - #node[:zabbix][:proxy_ip]"
log "node[:zabbix][:package_bucket] - #node[:zabbix][:package_bucket]"


packages = node[:zabbix][:proxy_deps]
packages.each do |p|
  package p do
    action :install
  end
end

group "zabbix" do
  action :create
end

user "zabbix" do
  comment "Zabbix user"
  gid "users"
end

rightscale_marker :end
