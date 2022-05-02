function Get-JamfComputerDetail {
    [CmdletBinding()]
    param (
        [parameter(
            Mandatory = $true,
            ValueFromPipelineBypropertyName = $true
        )]
        $id,
        $token = ($jamftoken.token | ConvertTo-SecureString -AsPlainText),
        [string]
        $JamfOrgName = "altana",
        [switch]
        $ReturnFullJson
    )
    
    begin {
        Connect-Jamf
        $baseurl = "https://$JamfOrgName.jamfcloud.com/api/v1/"
        $url = $baseurl + "computers-inventory-detail"
        $headers = @{
            Accept = "application/json"
        }
    }
    
    process {
        $idurl = $url + "/$id"
        $d = Invoke-RestMethod -Method Get -Uri $idurl -Headers $headers -Token $token -Authentication Bearer
        $lastuser = try {
            $d.general.extensionAttributes[0].values -join ","} 
            catch{}
        
        if ($ReturnFullJson){
            $d
        }
        else {

            [PSCustomObject]@{
                id = $d.id
                udid = $d.udid
                computerName = $d.general.name
                userName = $d.userAndLocation.username
                email = $d.userAndLocation.email
                lastuser = $lastuser
                localAccounts = $d.localUserAccounts.username -join ", "
                make = $d.hardware.make
                model = $d.hardware.model
                coreCount = $d.hardware.coreCount
                processorType = $d.hardware.processorType
                totalRamMegabytes = $d.hardware.totalRamMegabytes
                serialNumber = $d.hardware.serialNumber
                platform = $d.general.platform
                lastIpAddress = $d.general.lastIpAddress
                lastReportedIp = $d.general.lastReportedIp
                lastContactTime = $d.general.lastContactTime
                lastEnrolledDate= $d.general.lastEnrolledDate
                jamfBinaryVersion = $d.general.jamfBinaryVersion 

            }
        }
    }
}