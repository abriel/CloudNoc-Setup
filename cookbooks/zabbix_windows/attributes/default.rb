#
# Cookbook Name:: zabbix_windows
# Attributes:: default

default[:zabbix_windows][:log_dir] = "C:\\zabbix\\agent\\log"
default[:zabbix_windows][:run_dir] = "C:\\zabbix\\agent"

default[:zabbix_windows][:install] = true
default[:zabbix_windows][:version] = "2.0.3"
default[:zabbix_windows][:branch] = "ZABBIX%20Latest%20Stable"
default[:zabbix_windows][:server] = ["zabbixserver.domain.local"]
default[:zabbix_windows][:hostname] = node.fqdn
default[:zabbix_windows][:configure_options] = [ "--with-libcurl" ]
default[:zabbix_windows][:install_method] = "prebuild"

default[:zabbix_windows][:include_dir] = "C:\\zabbix\\agent\\agent_include"
default[:zabbix_windows][:install_dir] = "C:\\zabbix\\agent"


case node[:kernel][:machine].to_s
	when "x86_64"
		default[:zabbix_windows][:windows_bitness] = 64
	else
		default[:zabbix_windows][:windows_bitness] = 32
end

