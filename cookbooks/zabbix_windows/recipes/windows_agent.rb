#
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright 2013, CloudNOC
#
# All rights reserved - Do Not Redistribute
#

installdir	= node.zabbix_windows.install_dir

installer	= "zabbix_agentd#{node[:zabbix_windows][:windows_bitness]}.exe"
getter		= "zabbix_get#{node[:zabbix_windows][:windows_bitness]}.exe"
sender		= "zabbix_sender#{node[:zabbix_windows][:windows_bitness]}.exe"

log "Debug"
log "installer: #{installer}"
log "getter: #{getter}"
log "sender: #{sender}"
log "log dir: #{node[:zabbix_windows][:log_dir]}"
log "installdir: #{installdir}"

directory node[:zabbix_windows][:log_dir] do
	action :create
  recursive true
end

cookbook_file "#{installdir}\\#{installer}" do
	source "#{installer}"
	action :create
end

cookbook_file "#{installdir}\\#{getter}" do
	source "#{getter}"
	action :create
end

cookbook_file "#{installdir}\\#{sender}" do
	source "#{sender}"
	action :create
end

template "#{installdir}\\zabbix_agentd.conf" do
	source "zabbix_agentd.conf.erb"
	action :create
end

#cut https:// from conf file
powershell "cut-conf" do
  code <<-EOH
    (Get-Content "C:\\zabbix\\agent\\zabbix_agentd.conf" | %{$_ -replace "http://", ""} | Set-Content "C:\\zabbix\\agent\\zabbix_agentd.conf"
    (Get-Content "#{installdir}\\zabbix_agentd.conf" | %{$_ -replace "https://", ""} | Set-Content "#{installdir}\\zabbix_agentd.conf"
  EOH
end

execute "install-zabbix-agentd" do
  command "#{installdir}\\#{installer} --config #{installdir}\\zabbix_agentd.conf --install"
end

#service "Zabbix Agent" do
#  supports :status => true, :start => true, :stop => true, :restart => true
#  action [ :enable , :start]
#end
