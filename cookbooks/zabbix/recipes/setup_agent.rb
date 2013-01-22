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

log "node[:zabbix][:server_path] - #{node[:zabbix][:server_path]}"
log "node[:zabbix][:username] - #{node[:zabbix][:username]}"
log "node[:zabbix][:password] - #{node[:zabbix][:password]}"
log "node[:zabbix][:client_contact] - #{node[:zabbix][:client_contact]}"
log "node[:zabbix][:contactname] - #{node[:zabbix][:clientname]}"
log "node[:zabbix][:proxy_host_name] - #{node[:zabbix][:proxy_host_name]}"
log "node[:zabbix][:proxy_ip] - #{node[:zabbix][:proxy_ip]}"
log "node[:zabbix][:package_bucket] - #{node[:zabbix][:package_bucket]}"

# * Retrieve agent package
# * Install agent package
# * Retrieve config package
# * Install init script
# * Populate node vars into zabbix_agentd.conf
# * Start agent
# * Setup api deps
# * Register host via api

case node[:zabbix][:current_os]
when "centos"
  log "  Retrieving package #{node[:zabbix][:agent_package]} from #{node[:zabbix][:package_bucket]}"
  remote_file "/tmp/#{node[:zabbix][:agent_package]}" do
    source "#{node[:zabbix][:package_bucket]}#{node[:zabbix][:agent_package]}"
    action :create_if_missing
  end
# bash "get_package" do
#    flags "-ex"
#    code <<-EOH
#      wget #{node[:zabbix][:package_bucket]}/#{node[:zabbix][:agent_package]} -O /tmp/#{node[:zabbix][:agent_package]}
#    EOH
#  end

  log "  Retrieving package zabbix-conf.tar.gz from #{node[:zabbix][:package_bucket]}"
  remote_file "/tmp/#{node[:zabbix][:agent_package]}" do
    source "#{node[:zabbix][:package_bucket]}zabbix-conf.tar.gz"
    action :create_if_missing
  end
#  bash "get_config" do
#    flags "-ex"
#    code <<-EOH
#      wget #{node[:zabbix][:package_bucket]}/zabbix-conf.tar.gz -O /tmp/#{node[:zabbix][:agent_package]}
#    EOH
#  end

  log "  Installing package #{node[:zabbix][:agent_package]}"
  package "zabbix-agent" do
    action :install
    source "/tmp/#{node[:zabbix][:agent_package]}"
  end

  execute "unpack_conf" do
    command "tar -C /tmp -xvf /tmp/#{node[:zabbix][:agent_package]}"
    user "root"
    only_if "test -f /tmp/#{node[:zabbix][:agent_package]}"
  end

  hostname=`hostname --fqdn`
  log "  Updating zabbix_agentd.conf"
  bash "update_config" do
    flags "-ex"
    code <<-EOH
       sed -i "s/^Server=/Server=#{server}/" "#{node[:zabbix][:agent_config]}"
       sed -i "s/^ActiveServer=/ActiveServer=#{node[:zabbix][:proxy_ip]}/" "#{node[:zabbix][:agent_config]}"
       sed -i "s/^Hostname=/Hostname=#{hostname}/" "#{node[:zabbix][:agent_config]}"
    EOH
  end


else
  raise "Unrecognized distro #{node[:platform]} for monitoring attributes , exiting "
end


rightscale_marker :end
