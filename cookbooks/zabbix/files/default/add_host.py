#!/usr/bin/env python
# requires gescheit api library
# get it from github.com/gescheit/scripts.git

from zabbix_api import ZabbixAPI

server="@@SERVERNAME@@"
username="@@USERNAME@@"
password="@@PASSWORD@@"

zapi = ZabbixAPI(server=server, path="", proto="https", user=username, passwd=password, log_level=6)
zapi.login(username, password)

host_name="@@HOSTNAME@@"

description='@@DESCRIPTION@@' 
clientname='@@CLIENTNAME@@'
clientcontact='@@CLIETNEMAIL@@'
proxy_host_name='@@PROXYHOSTNAME@@'

proxyid=zapi.host.get({"filter":{'host': proxy_host_name}, 'output': 'extend', 'proxy_hosts': '1'})[0]["hostid"]
groupid=zapi.hostgroup.get({"filter":{'name': clientname}, 'output': 'extend'})[0]["groupid"]

zapi.host.create({ "host":host_name, "interfaces":{"type":"1", "main":"1", "useip":"1","ip":"@@AGENTIP@@", "dns":"", "port":"10050"}, "groups":{"groupid":groupid},"inventory":{"contact":clientcontact}, "templates":{ "templateid":"@@TMPL_ID@@"}, "proxy_hostid":proxyid  })
