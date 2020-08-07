function Remove-VSTeamTaskGroup {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string[]] $Id,

      [switch] $Force,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      foreach ($item in $Id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Task Group")) {
            # Call the REST API
            _callAPI -Method DELETE -ProjectName $ProjectName `
               -Area distributedtask `
               -Resource taskgroups `
               -Id $item `
               -Version $(_getApiVersion TaskGroups) | Out-Null

            Write-Output "Deleted task group $item"
         }
      }
   }
}
