function Get-JamfComputer {
    [CmdletBinding()]
    param (
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
        $url = $baseurl + "computers-inventory"
        if ($id){
            $url = $url + "/$id"
        }
        $headers = @{
            Accept = "application/json"
        }
    }
    
    process {
        
       $data = Invoke-RestMethod -Method Get -Uri $url -Headers $headers -Token $token -Authentication Bearer

    }
    
    end {
        if ($ReturnFullJson){
            $data
        }
        else {

            if (!$id){
                $loopdata = $data.results
            }
            else {
                $loopdata = $data
            }
            foreach ($d in $loopdata){
                $lastuser = try {
                    $d.general.extensionAttributes[0].values -join ","} 
                    catch{}
                [PSCustomObject]@{
                    id = $d.id
                    name = $d.general.name
                    lastuser = $lastuser
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
}