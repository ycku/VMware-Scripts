Import-Module VMware.VimAutomation.HorizonView
Import-Module VMware.Hv.Helper
Set-PowerCLIConfiguration -InvalidCertificateAction:Ignore -Confirm:$false
Import-LocalizedData -FileName "VDI_config.psd1" -BindingVariable "VDI"
Connect-HVServer -Server $VDI.server -User $VDI.user -Password $VDI.password
$connected = (((get-hvmachinesummary) | where { $_.base.basicstate -eq 'CONNECTED' })).Base.Name

foreach ($vm in $connected) {
	$locked = Get-Process logonui -ComputerName $vm -ErrorAction SilentlyContinue
	if ($locked) {
		$env_locked = (Get-WMIObject -Class Win32_Environment -ComputerName $vm -EA Stop | where { $_.name -eq 'locked' }).variablevalue
		if ($env_locked -eq "1") {
			$vm + " is going to be restarted"
			Restart-Computer -ComputerName $vm -Force
		} else {
		    $vm + " queued to be restarted"
			setx locked 1 /m /s $vm
		}
	} else {
	    $vm + " is unlocked"
		setx locked 0 /m /s $vm
	}
}
