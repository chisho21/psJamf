 function Connect-Jamf {
     [CmdletBinding()]
     param (
         [string]
         $JamfOrgName ,
         [pscredential]
         $Credential

     )
     
     begin {

         Write-Host "Connecting to jamf..." -ForegroundColor Yellow
     }
     
     process {
         # Check for curent token
        $currenttime = (Get-Date).touniversaltime()
        if ($jamftoken.expires -lt $currenttime){
            if (!$JamfOrgName){
                $JamfOrgname = Read-Host "Enter Jamf org name (xxxxx.jamfcloud.com):"
                $global:JamfOrgName = $JamfOrgName
            }
            if (!$Credential){
                $Credential = Get-Credential -Message "Enter credential for Jamf API"
            }
            
            $baseurl = "https://$JamfOrgName.jamfcloud.com/api/v1/"
            $url = $baseurl + "auth/token"
            $headers = @{
                Accept = "application/json"
            }
            $global:jamftoken = Invoke-RestMethod -Method Post -Uri $url -Headers $headers -Credential $Credential -Authentication Basic
        }
        else {
            Write-Host "Already connected to jamf!" -ForegroundColor Green
        }

     }
     
     end {
         
     }
 }