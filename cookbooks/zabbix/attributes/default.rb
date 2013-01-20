case platform
when "ubuntu"
  set_unless[:zabbix][:current_os] = "ubuntu"
  case platform_version
  when /^10\..+/
    set_unless[:zabbix][:agent_deps] = ["libsnmp15"]
    set_unless[:zabbix][:proxy_deps] = ["libsnmp15", "libssh2-1", "sqlite3"]
  when /^12\..+/
    raise "Unsupported distro #{node[:platform]} for monitoring attributes , exiting "
  end
when "centos", "redhat"
  set_unless[:zabbix][:current_os] = "centos"
  case platform_version
  when /^5\..+/
    set_unless[:zabbix][:agent_deps] = ["net-smnp"]
    set_unless[:zabbix][:proxy_deps] = ["net-smnp", "libssh2", "sqlite"]
  end
else
  raise "Unrecognized distro #{node[:platform]} for monitoring attributes , exiting "
end

raise "Unrecognized distro #{node[:platform]} for monitoring attributes , exiting "
