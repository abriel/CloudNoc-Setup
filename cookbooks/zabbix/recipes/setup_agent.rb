#
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright 2013, CloudNOC
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :start

if #{node[:zabbix][:is_agent]}?("Yes")
  log "I'm an Agent"
else
  log "Sorry, I'm not an agent, I dont need this"
  return
end

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

case #node[:zabbix][:current_os]
when "centos"
  log "Retrieving package #{node[:zabbix][:agent_package]} from #{node[:zabbix][:package_bucket]}"
  remote_file "/tmp/#{node[:zabbix][:agent_package]}" do
    source "#{node[:zabbix][:package_bucket]}#{node[:zabbix][:agent_package]}"
    action :create_if_missing
  end

  log "  Retrieving package zabbix-conf.tar.gz from #{node[:zabbix][:package_bucket]}"
  remote_file "/tmp/zabbix-conf.tar.gz" do
    source "#{node[:zabbix][:package_bucket]}zabbix-conf.tar.gz"
    action :create_if_missing
  end

  execute "unpack_conf" do
    command "tar -C /tmp -xvf /tmp/zabbix-conf.tar.gz && cp /tmp/conf/zabbix_agentd.conf /usr/local/etc/zabbix_agentd.conf && cp /tmp/misc/init.d/fedora/core5/zabbix_agentd /etc/init.d/zabbix_agent"
    user "root"
    only_if "test -f /tmp/#{node[:zabbix][:agent_package]}"
  end

  hostname=`hostname --fqdn`
  log "  Updating zabbix_agentd.conf"
  bash "update_config" do
    code <<-EOH
      rpm -i /tmp/#{node[:zabbix][:agent_package]}
      sed -i '/^Server.*/ c\Server=#{node[:zabbix][:proxy_ip]}' /usr/local/etc/zabbix_agentd.conf
      sed -i '/^Hostname.*/ c\Hostname=#{hostname}' /usr/local/etc/zabbix_agentd.conf
      sed -i '/^ActiveServer.*/ c\ActiveServer=#{node[:zabbix][:proxy_ip]}' /usr/local/etc/zabbix_agentd.conf
    EOH
  end

  #enable and start service
  service "zabbix_agent" do
    action [ :enable, :start ]
  end

  #This Scripts adds host to Zabbix server via Zabbix API
  cookbook_file "/tmp/zabbix_host_add.sh" do
    source "zabbix_host_add.sh"
    owner "root"
    mode 00755
  end

  cookbook_file "/tmp/add_host.py" do
    source "add_host.py"
    owner "root"
    mode 00755
  end

  cookbook_file "/tmp/zabbix_api.py" do
    source "zabbix_api.py"
    owner "root"
    mode 00755
  end

  #configure
  bash "configure_script" do
    code <<-EOH
      source /var/spool/ec2/meta-data.sh

      sed -i "s%@@SERVERNAME@@%#{node[:zabbix][:server_path]}%" /tmp/add_host.py
      sed -i "s/@@USERNAME@@/#{node[:zabbix][:username]}/" /tmp/add_host.py
      sed -i "s/@@PASSWORD@@/#{node[:zabbix][:password]}/" /tmp/add_host.py
      sed -i "s/@@HOSTNAME@@/$EC2_LOCAL_HOSTNAME/" /tmp/add_host.py
      sed -i "s/@@DESCRIPTION@@/"Description"/" /tmp/add_host.py
      sed -i "s/@@CLIENTNAME@@/#{node[:zabbix][:clientname]}/" /tmp/add_host.py
      sed -i "s/@@CLIETNEMAIL@@/#{node[:zabbix][:client_contact]}/" /tmp/add_host.py
      sed -i "s/@@PROXYHOSTNAME@@/#{node[:zabbix][:proxy_host_name]}/" /tmp/add_host.py
      sed -i "s/@@AGENTIP@@/$EC2_LOCAL_IPV4/" /tmp/add_host.py
      sed -i "s/@@TMPL_ID@@/10001/" /tmp/add_host.py
    EOH
  end
  #Executing add_host to Zabbix
  execute "add_host" do
    command "/tmp/zabbix_host_add.sh -u #{node[:zabbix][:username]} -p #{node[:zabbix][:password]}\
      -h $EC2_LOCAL_HOSTNAME -n #{node[:zabbix][:clientname]} -c #{node[:zabbix][:client_contact]} -x #{node[:zabbix][:proxy_host_name]} \
      -i $EC2_LOCAL_IPV4 -t 10001"
    user "root"
  end

else
  raise "Unrecognized distro #{node[:platform]} for monitoring attributes , exiting "
end


rightscale_marker :end
