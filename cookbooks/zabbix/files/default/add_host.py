#!/usr/bin/env python
# requires gescheit api library
# get it from github.com/gescheit/scripts.git

from zabbix_api import ZabbixAPI
import optparse

opt_parser = optparse.OptionParser(option_list = [
	optparse.make_option('-s', '--server-name', dest = 'server_name'),
	optparse.make_option('-u', '--username', dest = 'username'),
	optparse.make_option('-p', '--password', dest = 'password'),
	optparse.make_option('-n', '--hostname', dest = 'hostname'),
	optparse.make_option('-d', '--description', dest = 'description'),
	optparse.make_option('-c', '--clientname', dest = 'client_name'),
	optparse.make_option('-e', '--clientemail', dest = 'client_email'),
	optparse.make_option('-x', '--proxyhost', dest = 'proxy_host'),
	optparse.make_option('-i', '--inetaddr', dest = 'inet_addr'),
	optparse.make_option('-t', '--template', dest = 'template'),
	])

options, args = opt_parser.parse_args()

zapi = ZabbixAPI(server=options.server_name, path="", proto="https", user=options.username, passwd=options.password, log_level=6)
zapi.login(options.username, options.password)

proxyid=zapi.host.get({"filter":{'host': options.proxy_host}, 'output': 'extend', 'proxy_hosts': '1'})[0]["hostid"]
groupid=zapi.hostgroup.get({"filter":{'name': options.client_name}, 'output': 'extend'})[0]["groupid"]

zapi.host.create({ "host":options.hostname, "interfaces":{"type":"1", "main":"1", "useip":"1","ip":options.inet_addr, "dns":"", "port":"10050"}, "groups":{"groupid":groupid},"inventory":{"contact":options.client_email}, "templates":{ "templateid":options.template}, "proxy_hostid":proxyid  })
