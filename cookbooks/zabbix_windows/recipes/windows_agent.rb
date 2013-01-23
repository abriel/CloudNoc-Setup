#
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright 2013, CloudNOC
#
# All rights reserved - Do Not Redistribute
#

installdir	= node.zabbix_windows.agent.install_dir
includedir	= node.zabbix_windows.agent.include_dir

installer	= "zabbix_agentd#{node[:zabbix_windows][:windows_bitness]}.exe"
getter		= "zabbix_get#{node[:zabbix_windows][:windows_bitness]}.exe"
sender		= "zabbix_sender#{node[:zabbix_windows][:windows_bitness]}.exe"

log "Debug"
log "installer: #{installer}"
log "getter: #{getter}"
log "sender: #{sender}"
log "log dir: #{node[:zabbix_windows][:include_dir]}"
log "installdir: #{installdir}"
log "include dir: #{node[:zabbix_windows][:include_dir]}"

directory node[:zabbix_windows][:log_dir] do
	action :create
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


# Check Windows Service
#require win32ole
#zabbixservice = Zabbix Agent
#wmi = WIN32OLE.connect("winmgmts://")
#services = wmi.ExecQuery("Select * from Win32_Service where Name = #{zabbixservice}")
#if services.count >= 1
#	#service exists
#else
#	#INSTALL AWAY!
#	execute "Install Zabbix" do
#		command "#{installdir}\\#{installer} --config #{installdir}\\zabbix_agentd.conf --install"
#		#not_if { File.exists?("#{node[perl][install_dir]}\\perl\\bin\\perl.exe") }
#	end
#end

#service "Zabbix Agent" do
#  supports :status => true, :start => true, :stop => true, :restart => true
#  action [ :enable , :start]
#end
