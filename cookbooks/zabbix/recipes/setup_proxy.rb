#
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright 2013, CloudNOC
#
# All rights reserved - Do Not Redistribute
#

if ENV['RS_REBOOT'].nil? || ENV['RS_REBOOT'].empty?
  log "First start"
else
  log "In reboot, skipping recipe."
  return
end


rightscale_marker :start
log "Installing proxy"

log "node[:zabbix][:server_path] - #{node[:zabbix][:server_path]}"
log "node[:zabbix][:username] - #{node[:zabbix][:username]}"
log "node[:zabbix][:password] - #{node[:zabbix][:password]}"
log "node[:zabbix][:contact1] - #{node[:zabbix][:contact1]}"
log "node[:zabbix][:proxy_host_name] - #{node[:zabbix][:proxy_host_name]}"
log "node[:zabbix][:proxy_ip] - #{node[:zabbix][:proxy_ip]}"
log "node[:zabbix][:package_bucket] - #{node[:zabbix][:package_bucket]}"


# * Retrieve proxy package
remote_file "/tmp/zabbix-proxy" do
  source "#{node[:zabbix][:package_bucket]}zabbix-proxy_2.0.4-12.11.3.1_amd64.deb"
  action :create_if_missing
end

# * Install proxy package - no package on S3. Install from standard repo?
#package "/tmp/zabbix-proxy" do
#  action :install
#end

# * Retrieve config package
remote_file "/tmp/zabbix-conf.tar.gz" do
  source "#{node[:zabbix][:package_bucket]}zabbix-conf.tar.gz"
  action :create_if_missing 
end

directory "/usr/local/share/zabbix" do
  owner "zabbix"
  group "zabbix"
  mode 00744
  action :create
end

execute "unpack_conf" do
  command "tar -C /tmp -xvf /tmp/zabbix-conf.tar.gz && cp /tmp/misc/init.d/debian/zabbix-server /etc/init.d/zabbix_proxy && cp /tmp/conf/zabbix_proxy.conf /usr/local/etc/zabbix_proxy.conf"
  user "root"
  only_if "test ! -d /tmp/misc/init.d"
end

# * Populate node vars into zabbix_proxy.conf
# Super hack ))    sed -i "s/https\:\/\///g" /usr/local/etc/zabbix_proxy.conf
server=node[:zabbix][:server_path]
server=server.gsub(/https?:../,"")
bash "change_opts" do
  user "root"
  code <<-EOH
    dpkg -i /tmp/zabbix-proxy
    sed -i 's/server/proxy/g' /etc/init.d/zabbix_proxy
    sed -i '/^Server.*/ c\Server=#{server}' /usr/local/etc/zabbix_proxy.conf
    sed -i '/^Hostname.*/ c\Hostname=#{node[:zabbix][:proxy_host_name]}' /usr/local/etc/zabbix_proxy.conf
    sed -i '/^DBName.*/ c\DBName=/usr/local/share/zabbix/zabbix.db' /usr/local/etc/zabbix_proxy.conf

    sqlite3 /usr/local/share/zabbix/zabbix.db < /tmp/database/sqlite3/schema.sql
EOH
  only_if "test ! -f /usr/local/share/zabbix/zabbix.db"
end

file "/usr/local/share/zabbix/zabbix.db" do
  owner "zabbix"
  group "zabbix"
  action :touch
end

# * Install init script
# * Start proxy
service "zabbix_proxy" do
  action [ :enable, :start ] 
end

cron "proxy_update" do
  hour "*"
  minute "*/5"
  command "/etc/init.d/zabbix_proxy restart"
end


# * Setup api deps
# * Register new proxy via api

rightscale_marker :end
