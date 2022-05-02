function Set-JamfComputer {
    [CmdletBinding()]
    param (
        $id,
        $UserName,
        $Email,
        $token = ($jamftoken.token | ConvertTo-SecureString -AsPlainText),
        [string]
        $JamfOrgName = "altana"
    )
    
    begin {
        Connect-Jamf
        $baseurl = "https://$JamfOrgName.jamfcloud.com/api/v1/"
        $url = $baseurl + "computers-inventory-detail/"
        $headers = @{
            Accept = "application/json"
        }
    }
    
    process {
        $idurl = $url + $id
        if ($UserName){
            $usernamebod = @{username = $UserName}
        }
        if ($Email){
            $emailbod = @{email = $Email}
        }
        $body = @" 
{"userAndLocation":{"username":"$UserName","email":"$Email"}} 
"@
       $data = Invoke-RestMethod -Method Patch -Uri $idurl -Headers $headers -Token $token -Authentication Bearer -body $body

    }
    
    end {
        
    }
}