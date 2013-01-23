#
# Cookbook Name:: zabbix_windows
# Attributes:: default

set_unless[:zabbix_windows][:hostname] = node.fqdn

case node[:kernel][:machine].to_s
	when "x86_64"
		set_unless[:zabbix_windows][:windows_bitness] = 64
	else
		set_unless[:zabbix_windows][:windows_bitness] = 32
end
