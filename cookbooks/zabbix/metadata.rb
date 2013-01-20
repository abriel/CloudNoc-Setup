maintainer       "CloudNOC Inc"
maintainer_email "stanislav.kraev@cloudnoc.com"
license          "All rights reserved"
description      "Installs/Configures zabbix"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

depends "rightscale"

# supports "centos", "~> 5.8"
# supports "redhat", "~> 5.8"
# supports "ubuntu", "~> 10.04"

recipe "zabbix::default", "Setup environment"
recipe "zabbix::setup_proxy", "Setup zabbix proxy"
recipe "zabbix::setup_agent", "Setup zabbix agent"


attribute "zabbix/server_path",
  :display_name => "server_path",
  :description => "Path to zabbix server e.g. https://mon1.cloudnoc.com",
  :required => "optional",
  :default => "",
  :recipes => [
    "zabbix::setup_proxy",
    "zabbix::setup_agent",
    "zabbix::default"
  ]

attribute "zabbix/username",
  :display_name => "username",
  :description => "User name used for authentification",
  :required => "optional",
  :default => "",
  :recipes => [
    "zabbix::setup_proxy",
    "zabbix::setup_agent",
    "zabbix::default"
  ]

attribute "zabbix/password",
  :display_name => "password",
  :description => "Password name used for authentification",
  :required => "optional",
  :default => "",
  :recipes => [
    "zabbix::setup_proxy",
    "zabbix::setup_agent",
    "zabbix::default"
  ]

attribute "zabbix/contact1",
  :display_name => "contact1",
  :description => "Contact email for tickets",
  :required => "optional",
  :default => "",
  :recipes => [
    "zabbix::setup_proxy",
    "zabbix::setup_agent",
    "zabbix::default"
  ]

attribute "zabbix/proxy_host_name",
  :display_name => "proxy_host_name",
  :description => "Contact email for tickets",
  :required => "optional",
  :default => "",
  :recipes => [
    "zabbix::setup_proxy",
    "zabbix::setup_agent",
    "zabbix::default"
  ]

attribute "zabbix/proxy_ip",
  :display_name => "proxy_ip",
  :description => "PRIVATE_IP of zabbix proxy server",
  :required => "optional",
  :default => "",
  :recipes => [
    "zabbix::setup_proxy",
    "zabbix::setup_agent",
    "zabbix::default"
  ]

