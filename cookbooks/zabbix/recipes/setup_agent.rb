#
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright 2013, CloudNOC
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :start
log "Installing agent"

log "node[:zabbix][:server_path] - #node[:zabbix][:server_path]"
log "node[:zabbix][:username] - #node[:zabbix][:username]"
log "node[:zabbix][:password] - #node[:zabbix][:password]"
log "node[:zabbix][:contact1] - #node[:zabbix][:contact1]"
log "node[:zabbix][:proxy_host_name] - #node[:zabbix][:proxy_host_name]"
log "node[:zabbix][:proxy_ip] - #node[:zabbix][:proxy_ip]"
log "node[:zabbix][:package_bucket] - #node[:zabbix][:package_bucket]"

#TODO
# 
# * Retrieve agent package
# * Install agent package
# * Retrieve config package
# * Install init script
# * Populate node vars into zabbix_agentd.conf
# * Start agent
# * Setup api deps
# * Register host via api
#

rightscale_marker :end
