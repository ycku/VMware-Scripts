
# Get the numbers of 'CONNECTED' sessions and group by pools

Import-Module VMware.VimAutomation.HorizonView
Import-Module VMware.Hv.Helper
Set-PowerCLIConfiguration -InvalidCertificateAction:Ignore -Confirm:$false
Import-LocalizedData -FileName "VDI_config.psd1" -BindingVariable "VDI"

Connect-HVServer -Server $VDI.server -User $VDI.user -Password $VDI.password
$allsessions = (((get-hvmachinesummary) | where { $_.base.basicstate -eq 'CONNECTED' })).namesdata.desktopname | group

$allsessions
