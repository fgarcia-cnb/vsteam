function Remove-VSTeamReleaseDefinition {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int[]] $Id,

      [switch] $Force,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      Write-Debug 'Remove-VSTeamReleaseDefinition Process'

      foreach ($item in $id) {
         if ($force -or $pscmdlet.ShouldProcess($item, "Delete Release Definition")) {
            _callAPI -Method DELETE -subDomain vsrm -projectName $ProjectName `
               -Area release `
               -Resource definitions `
               -id $item `
               -Version $(_getApiVersion Release) | Out-Null

            Write-Output "Deleted release definition $item"
         }
      }
   }
}
