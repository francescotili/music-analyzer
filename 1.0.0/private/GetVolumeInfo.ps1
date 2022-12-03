function Get-VolumeInfo {
  <#
    .SYNOPSIS
      Get the volume info from the specified file
    
    .EXAMPLE
      Get-VolumeInfo $file
    
    .PARAMETER inputFile
      Required. Complete file object to analyze.
  #>

  [CmdLetBinding(DefaultParameterSetName)]
  Param (
    [Parameter(Mandatory = $true)]
    $inputFile
  )

  # ffmpeg output is in StandardError feed, when no output is specified like in this case.
  # For this reason I added 2>&1 to redirect StdErr to StdOut and save the output in a
  # variable. This variable is a "forced" [array].
  # No output will be visible to the user side, but I must then parse it.
  $params = @(
    "-i", $inputFile.fullFilePath,
    "-filter:a", "volumedetect",
    "-f", "null", "/dev/null"
  )
  $ffmpegOutput = ffmpeg $params 2>&1

  $regEx = "max_volume: ([+-]?\d*[.]\d) dB"
  $maxVolumeString = $ffmpegOutput | Select-String -Pattern "max_volume:"
  $maxVolume = 0
  if ( $maxVolumeString ) {
    # Returns positive or negative
    $maxVolume = [Float](([regex]::Matches($maxVolumeString, $regEx)).Groups[1].Value.trim())
  }

  return $maxVolume
}