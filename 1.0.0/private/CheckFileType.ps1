function CheckFileType {
  <#
    .SYNOPSIS
      Analyze the file type based on its extension and return the correct operation to make for the MusicAnalyzer main function
      - 'Supported' -> Means that the extension is supported
      - 'Unsupported' -> Meanse that the extension is not supported
    
    .PARAMETER inputFile
      Required. Complete file object to analyze.
  #>

  [CmdletBinding(DefaultParameterSetName)]
  param (
    [Parameter(Mandatory = $true)]
    $inputFile
  )

  $returnValue = "Unsupported"

  # Define array of supported extensions
  $supportedExtensions = @("mp3", "MP3")

  if ( $supportedExtensions.Contains( $inputFile.extension )) {
    $returnValue = 'Supported'
  }

  return $returnValue
}