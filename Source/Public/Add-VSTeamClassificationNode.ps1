# Create new or update an existing classification node.
# Get-VSTeamOption 'wit' 'classificationNodes'
# id              : 5a172953-1b41-49d3-840a-33f79c3ce89f
# area            : wit
# resourceName    : classificationNodes
# routeTemplate   : {project}/_apis/{area}/{resource}/{structureGroup}/{*path}
# https://bit.ly/Add-VSTeamClassificationNode

function Add-VSTeamClassificationNode {
   [CmdletBinding()]
   param(
      [CmdletBinding(DefaultParameterSetName = 'ByArea')]
      [CmdletBinding(DefaultParameterSetName = 'ByIteration')]
      [Parameter(Mandatory = $true)]
      [string] $Name,

      [CmdletBinding(DefaultParameterSetName = 'ByArea')]
      [CmdletBinding(DefaultParameterSetName = 'ByIteration')]      
      [ValidateSet("areas", "iterations")]
      [Parameter(Mandatory = $true)]
      [string] $StructureGroup,

      [CmdletBinding(DefaultParameterSetName = 'ByArea')]
      [CmdletBinding(DefaultParameterSetName = 'ByIteration')]      
      [Parameter(Mandatory = $false)]
      [string] $Path = $null,

      [CmdletBinding(DefaultParameterSetName = 'ByIteration')]      
      [Parameter(Mandatory = $false)]
      [datetime] $StartDate,

      [CmdletBinding(DefaultParameterSetName = 'ByIteration')]      
      [Parameter(Mandatory = $false)]
      [datetime] $FinishDate,
      
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      $id = $StructureGroup

      $Path = [uri]::UnescapeDataString($Path)

      if ($Path) {
         $Path = [uri]::EscapeUriString($Path)
         $Path = $Path.TrimStart("/")
         $id += "/$Path"
      }

      $body = @{
         name = $Name
      }

      if ($StructureGroup -eq "iterations") {
         $body.attributes = @{
            startDate  = $StartDate
            finishDate = $FinishDate
         }
      }

      $bodyAsJson = $body | ConvertTo-Json

      # Call the REST API
      $resp = _callAPI -Method POST -ProjectName $ProjectName `
         -Area wit `
         -Resource classificationnodes `
         -id $id `
         -body $bodyAsJson `
         -Version $(_getApiVersion Core)
      
      $resp = [VSTeamClassificationNode]::new($resp, $ProjectName)

      Write-Output $resp
   }
}