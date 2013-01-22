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

attribute "zabbix/is_agent",
  :display_name => "is_agent",
  :description => "Set to Yes if this instance is Agent, otherwise set to No",
  :required => "optional",
  :defailt => "Yes",
  :recipes => [
    "zabbix::setup_proxy",
    "zabbix::setup_agent",
    "zabbix::default"
  ]

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

attribute "zabbix/client_contact",
  :display_name => "client_contact",
  :description => "Contact email for tickets",
  :required => "optional",
  :default => "",
  :recipes => [
    "zabbix::setup_proxy",
    "zabbix::setup_agent",
    "zabbix::default"
  ]

attribute "zabbix/clientname",
  :display_name => "clientname",
  :description => "Name of the client",
  :required => "optional",
  :default => "",
  :recipes => [
    "zabbix::setup_proxy",
    "zabbix::setup_agent",
    "zabbix::default"
  ]

attribute "zabbix/proxy_host_name",
  :display_name => "proxy_host_name",
  :description => "Hostname of Proxy Server",
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

attribute "zabbix/package_bucket",
  :display_name => "package_bucket",
  :description => "",
  :required => "optional",
  :default => "https://cloudnoc.s3.amazonaws.com/",
  :recipes => [
    "zabbix::setup_proxy",
    "zabbix::setup_agent",
    "zabbix::default"
  ]

