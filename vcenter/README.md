## getHostIPfromVM.py
以 VM name 取得 VM 所在的 ESXi 主機名稱
* 通常主機會有很多張網路卡和IP, 所以用 hostname 比較容易辨識
```
python getHostIPfromVM.py -s {VCenter/ESX} IP -u {username@ADdomain} -p {password} -n {VMName}
```

## getHost.sql
以 VM name 取得 VM 所在的 ESXi 主機名稱, pl/python 的版本
```
SELECT getHost('myvmname')
```

連線資訊儲存另一個 TABLE 中, 以 dictionary 格式存放. 因為 function body 無法限制被看到, 但 TABLE 可以.
```
CREATE TABLE config
(
    key text NOT NULL,
    value text,
    CONSTRAINT config_pkey PRIMARY KEY (key)
);

INSERT INTO config (key, value) VALUES ('vcenter', '{''host'': ''theip'', ''user'': ''theuser@thedomain'', ''passwd'': ''thepasswd''}');
```
限制執行者無法看到此 TABLE, 以 xxxuser 為例, public 一定要加.
```
REVOKE ALL ON TABLE config FROM public, xxxuser;
```

## VM_Resource_Limit.ps1
通常虛擬機都會 overcommit, 為了有效運用資源, 預設規格開高, 離峰時間不限制使用, 尖峰時間動態限制

可以設到排程, 定時檢視自動調控
