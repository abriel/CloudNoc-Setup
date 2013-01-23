maintainer       "CloudNOC Inc"
maintainer_email "stanislav.kraev@cloudnoc.com"
license          "All rights reserved"
description      "Installs/Configures zabbix"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recipe "zabbix_windows::windows_agent", "Installs and configures Zabbix agent"


attribute "zabbix_windows/log_dir",
  :display_name => "agent_log_dir",
  :description => "Zabbix Agent Install Dir e.g. C:\\zabbix\\agent\\log",
  :required => "optional",
  :default => "C:\\zabbix\\agent\\log",
  :recipes => [ "zabbix_windows::windows_agent" ]

attribute "zabbix_windows/install_dir",
  :display_name => "agent_install_dir",
  :description => "Zabbix Agent Install Dir e.g. C:\\zabbix\\agent",
  :required => "optional",
  :default => "C:\\zabbix\\agent",
  :recipes => [ "zabbix_windows::windows_agent" ]

attribute "zabbix_windows/server_path",
  :display_name => "ZabbixServerPath",
  :description => "Path to zabbix server e.g. https://mon1.cloudnoc.com",
  :required => "optional",
  :default => "http://mon1.cloudnoc.com",
  :recipes => [ "zabbix_windows::windows_agent" ]

attribute "zabbix_windows/proxy_host_name",
  :display_name => "proxy_host_name",
  :description => "Hostname of Proxy Server",
  :required => "optional",
  :default => "",
  :recipes => [ "zabbix_windows::windows_agent" ]

attribute "zabbix_windows/proxy_ip",
  :display_name => "proxy_ip",
  :description => "PRIVATE_IP of zabbix proxy server",
  :required => "optional",
  :default => "",
  :recipes => [ "zabbix_windows::windows_agent" ]

attribute "zabbix_windows/username",
  :display_name => "username",
  :description => "User name used for authentification",
  :required => "optional",
  :default => "",
  :recipes => [ "zabbix_windows::windows_agent" ]

attribute "zabbix_windows/password",
  :display_name => "password",
  :description => "Password name used for authentification",
  :required => "optional",
  :default => "",
  :recipes => [ "zabbix_windows::windows_agent" ]

attribute "zabbix_windows/client_contact",
  :display_name => "client_contact",
  :description => "Contact email for tickets",
  :required => "optional",
  :default => "",
  :recipes => [ "zabbix_windows::windows_agent" ]

attribute "zabbix_windows/clientname",
  :display_name => "clientname",
  :description => "Name of the client",
  :required => "optional",
  :default => "",
  :recipes => [ "zabbix_windows::windows_agent" ]
