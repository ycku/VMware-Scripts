## getHostIPfromVM.py
以 VM name 取得 VM 所在的 ESXi 主機名稱
* 通常主機會有很多張網路卡和IP, 所以用 hostname 比較容易辨識
```
python getHostIPfromVM.py -s {VCenter/ESX} IP -u {username@ADdomain} -p {password} -n {VMName}
```
