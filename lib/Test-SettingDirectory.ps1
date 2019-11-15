function Test-SettingDirectory($path)
{
  if (-not(Test-Path $path))
  {
    $null = New-Item -Path $path -ItemType Directory
  }
  # return
  $null
}


function Test-TargetFile($path)
{
  if (-not(Test-Path $path))
  {
    $parent_dir = Split-Path $path -Parent
    Test-SettingDirectory $parent_dir
    $null = New-Item -Path $path -ItemType File
  }
  # return
  $null
}

## ---------------------------------------------------- // entry point
##
If ((Resolve-Path -Path $MyInvocation.InvocationName).ProviderPath -eq $MyInvocation.MyCommand.Path) 
{

## include configs
$work_directory = $PROFILE | split-path -parent
$config_file_name = 'config.psd1'
$config_path = Join-Path $work_directory $config_file_name
$config = Import-PowerShellDataFile $config_path

## test path
$path = Join-Path ([Environment]::GetFolderPath('MyDocuments')) $config.C_backup_dir
$file_path = Join-Path $path $config.C_search_target
  
# test-SettingDirectory $path
Test-TargetFile $file_path
  
}
