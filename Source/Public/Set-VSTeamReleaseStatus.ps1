function Set-VSTeamReleaseStatus {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int[]] $Id,

      [ValidateSet('Active', 'Abandoned')]
      [string] $Status,

      [switch] $Force,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   Process {
      $body = '{ "id": ' + $id + ', "status": "' + $status + '" }'

      foreach ($item in $id) {
         if ($force -or $pscmdlet.ShouldProcess($item, "Set status on Release")) {

            try {
               # Call the REST API
               _callAPI -Method PATCH -SubDomain vsrm -ProjectName $ProjectName `
                  -Area release `
                  -Resource releases `
                  -id $item `
                  -body $body `
                  -Version $(_getApiVersion Release) | Out-Null

               Write-Output "Release $item status changed to $status"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}
