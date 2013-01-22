case platform
when "ubuntu"
  set_unless[:zabbix][:current_os] = "ubuntu"
  case platform_version
  when /^10\..+/
    set_unless[:zabbix][:agent_deps] = ["libsnmp15"]
    set_unless[:zabbix][:proxy_deps] = ["libsnmp15", "libssh2-1", "sqlite3"]
    set_unless[:zabbix][:agent_package] = "zabbix-agent_2.0.4-12.11.3.1_amd64.deb"
    set_unless[:zabbix][:agent_config] = "/usr/local/etc/zabbix_agentd.conf"
  when /^12\..+/
    raise "Unsupported distro #{node[:platform]} for monitoring attributes , exiting "
  end
when "centos", "redhat"
  set_unless[:zabbix][:current_os] = "centos"
  case platform_version
  when /^5\..+/
    set_unless[:zabbix][:agent_deps] = ["net-smnp"]
    set_unless[:zabbix][:proxy_deps] = ["net-smnp", "libssh2", "sqlite"]
    set_unless[:zabbix][:agent_package] = "zabbix-agent_2.0.4-12.11.3.1.86_64.rpm"
    set_unless[:zabbix][:agent_config] = "/usr/local/etc/zabbix_agentd.conf"
  end
else
  raise "Unrecognized distro #{node[:platform]} for monitoring attributes , exiting "
end
