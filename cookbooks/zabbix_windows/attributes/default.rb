#
# Cookbook Name:: zabbix_windows
# Attributes:: default

default['zabbix_windows']['log_dir'] = "C:\\zabbix\\agent\\log"
default['zabbix_windows']['run_dir'] = "C:\\zabbix\\agent"

default['zabbix_windows']['agent']['install'] = true
default['zabbix_windows']['agent']['version'] = "2.0.3"
default['zabbix_windows']['agent']['branch'] = "ZABBIX%20Latest%20Stable"
default['zabbix_windows']['agent']['servers'] = ["zabbixserver.domain.local"]
default['zabbix_windows']['agent']['servers_active'] = ["zabbixserver.domain.local"]
default['zabbix_windows']['agent']['hostname'] = node.fqdn
default['zabbix_windows']['agent']['configure_options'] = [ "--with-libcurl" ]
default['zabbix_windows']['agent']['install_method'] = "prebuild"

default['zabbix_windows']['agent']['include_dir'] = "C:\\zabbix\\agent\\agent_include"
default['zabbix_windows']['agent']['install_dir'] = "C:\\zabbix\\agent"


case node['kernel']['machine'].to_s
	when "x86_64"
		default['zabbix_windows']['agent']['windows_bitness'] = '64'
	else
		default['zabbix_windows']['agent']['windows_bitness'] = '32'
end

