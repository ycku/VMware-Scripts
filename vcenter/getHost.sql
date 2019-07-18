CREATE OR REPLACE FUNCTION vdi.getHost (vmname text)
RETURNS text
AS $$
import pyvim.connect
import ast
import argparse
import atexit
import getpass
import ssl

rv = plpy.execute("SELECT * FROM config WHERE key='vcenter'", 1)
vcenter = rv[0]["value"]
vcenter = ast.literal_eval(vcenter)
context = None
host = vcenter['host']
user = vcenter['user']
pwd = vcenter['passwd']
port = 443
hostname = ''

if hasattr(ssl, '_create_unverified_context'):
   context = ssl._create_unverified_context()
si = pyvim.connect.SmartConnect(host=host, user=user, pwd=pwd, port=port, sslContext=context)
atexit.register(pyvim.connect.Disconnect, si)
content = si.RetrieveContent()
for child in content.rootFolder.childEntity:
    if hasattr(child, 'vmFolder'):
       datacenter = child
       vmFolder = datacenter.vmFolder
       vmList = vmFolder.childEntity
       vmListStack = [vmList]
       while len(vmListStack)>0 and hostname == '':
        vmList = vmListStack.pop()
        for vm in vmList:
            if hasattr(vm, 'childEntity'):
               vmListStack.append(vm.childEntity)
               continue
            summary = vm.summary
            if summary.config.name == vmname:
               hostname = summary.runtime.host.config.network.dnsConfig.hostName
               break
return hostname
$$ LANGUAGE plpython3u
SECURITY DEFINER;
