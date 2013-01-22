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

log "node[:zabbix][:server_path] - #{node[:zabbix][:server_path]}"
log "node[:zabbix][:username] - #{node[:zabbix][:username]}"
log "node[:zabbix][:password] - #{node[:zabbix][:password]}"
log "node[:zabbix][:contact1] - #{node[:zabbix][:contact1]}"
log "node[:zabbix][:proxy_host_name] - #{node[:zabbix][:proxy_host_name]}"
log "node[:zabbix][:proxy_ip] - #{node[:zabbix][:proxy_ip]}"
log "node[:zabbix][:package_bucket] - #{node[:zabbix][:package_bucket]}"

#Who am I? Agent or Proxy?
if #{node[:zabbix][:is_agent]}?("Yes")
  if platform?("centos")
    log "I'm Agent on CentOS. Installing net-snmp package via yum"
    #package action :install doesnt work on centos
    execute "yum_install_net_snmp" do
      command "yum install -y net-snmp"
      user "root"
    end
  end
else
  packages = node[:zabbix][:proxy_deps]
  packages.each do |p|
    package p do
      action :install
    end
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
