## getHostIPfromVM.py
To locate the ESXi host and return the hostname by VM name.
* There are usually many network cards and IPs, so it is much recognized by hostname. 
```
python getHostIPfromVM.py -s {VCenter/ESX} IP -u {username@ADdomain} -p {password} -n {VMName}
```

## getHost.sql
pl/python version: To locate the ESXi host and return the hostname by VM name.
```
SELECT getHost('myvmname')
```

Connection parameters in python dictionary format are stored in another table. <br/>
Because we can not prevent the function body from showing, but we can defence tables.
```
CREATE TABLE config
(
    key text NOT NULL,
    value text,
    CONSTRAINT config_pkey PRIMARY KEY (key)
);

INSERT INTO config (key, value) VALUES ('vcenter', '{''host'': ''theip'', ''user'': ''theuser@thedomain'', ''passwd'': ''thepasswd''}');
```

To prevent the executor from viewing the table. <br/>
"public" must be added to the REVOKE command.
```
REVOKE ALL ON TABLE config FROM public, xxxuser;
```

## VM_Resource_Limit.ps1
The hypervisor is always overcommit to maximize the resource utilization. <br/>
We can set higher hardware specification by default. <br/>
Let user allocate more resource as possible, but limit them dynamically in peak time.
