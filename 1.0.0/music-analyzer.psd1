@{
  RootModule        = "music-analyzer.psm1"
  ModuleVersion     = "1.0.0"
  GUID              = "a228b4fc-0de5-4b74-aca8-7f0728d4a339"
  Author            = "Francesco Tili"
  Description       = "Analyze, correct and normalize your music library"
  PowerShellVersion = "5.1"
  FunctionsToExport = @(
    'MusicAnalyzer'
  )
}