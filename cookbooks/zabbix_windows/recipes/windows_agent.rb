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

#    (Get-Content "C:\\zabbix\\agent\\zabbix_agentd.conf") | %{$_ -replace "http://", ""} | Set-Content "C:\\zabbix\\agent\\zabbix_agentd.conf"
#cut https:// from conf file
powershell "Chef Tutorial" do
parameters({'MYPATH' => @node[:zabbix_windows][:install_dir]})
  powershell_script = <<'POWERSHELL_SCRIPT'
  echo "$env:MYPATH" > c:\1.txt
  (Get-Content $env:MYPATH\\zabbix_agentd.conf) | %{$_ -replace "http://", ""} | Set-Content $env:MYPATH\\zabbix_agentd.conf
POWERSHELL_SCRIPT
  source(powershell_script)
end

# Check Windows Service
require 'win32ole'
zabbixservice = 'Zabbix Agent'
wmi = WIN32OLE.connect("winmgmts://")
services = wmi.ExecQuery("Select * from Win32_Service where Name = '#{zabbixservice}'")
if services.count >= 1
  #service exists
else
  # Back to Chef-land
  execute "Install Zabbix" do
    command "#{installdir}\\#{installer} --config #{installdir}\\zabbix_agentd.conf --install"
  end
end

execute "zabbix-agentd-start" do
  command "#{installdir}\\#{installer} --config #{installdir}\\zabbix_agentd.conf -s"
end
