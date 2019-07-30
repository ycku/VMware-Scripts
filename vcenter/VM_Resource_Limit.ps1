import-module vmware.powercli

Set-PowerCLIConfiguration -InvalidCertificateAction:Ignore -Confirm:$false
Import-LocalizedData -FileName "vcenter_config.psd1" -BindingVariable "vcenter"

Connect-VIServer -Server $vcenter.server -User $vcenter.user -Password $vcenter.password

# 觸發門檻可調整和$usage的比較式
$cpulimit = 0
$memorylimit = 0
$vmhosts = Get-VMHost
ForEach ($vmhost in $vmhosts) {
	$usage = ($vmhost.CpuUsageMhz / $vmhost.CpuTotalMhz)
	If ($usage -gt 0.80) {
		Echo $vmhost.Name
		$cpulimit = 1
	}
	$usage = ($vmhost.MemoryUsageGB / $vmhost.MemoryTotalGB)
	If ($usage -gt 0.85) {
		Echo $vmhost.Name
		$memorylimit = 1
	}
}
# 符合條件設定要調整的資源數
If ($cpulimit -eq 1) {
	Echo "Set CPU Resource Limitation"
	$cpulimitmhz = 2048
	$cpureservationmhz = 0
} else {
	Echo "Unset CPU Resource Limitation"
	$cpulimitmhz = $null
	$cpureservationmhz = 1024
}

If ($memorylimit -eq 1) {
	Echo "Set Memory Resource Limitation"
	$memlimitgb = 6
	$memreservationgb = 1
} else {
	Echo "Unset Memory Resource Limitation"
	$memlimitgb = $null
	$memreservationgb = 2
}

# 僅更新已開機的桌面
$allvm = (Get-VM | Where { $_.PowerState -eq 'PoweredOn'})
Foreach ($vm in $allvm) {
	Echo $vm.Name
	Set-VMResourceConfiguration -Configuration $vm.VMResourceConfiguration -CpuLimitMhz $cpulimithz	-CpuReservationMhz $cpureservationmhz -MemLimitGB $memlimitgb -MemReservationGB $memreservationgb
}
