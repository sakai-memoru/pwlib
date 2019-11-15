## Get-GitRepositories

function Get-GitReposDirectories($path)
{
  Get-ChildItem $path -Depth 2 -Filter .gitignore |
    where {$_.DirectoryName -notmatch "backup"} |
    set -Name ary_gitignore
  
  foreach($ignore in $ary_gitignore)
  {
    "last access time = " + $ignore.LastAccessTime
    "last write time = " + $ignore.LastWriteTime
    "creation time = " + $ignore.CreationTime
    $ignore.FullName | split-path -Parent
  }
}


## ---------------------------------------------------- // entry point
## reference
## https://stackoverflow.com/questions/4693947/powershell-equivilent-of-pythons-if-name-main
##

If ((Resolve-Path -Path $MyInvocation.InvocationName).ProviderPath -eq $MyInvocation.MyCommand.Path) 
{
  ## include configs
  $mydoc_directory = [environment]::GetFolderPath('MyDocuments')
  $work_directory = $PROFILE | split-path -parent
  $config_file_name = 'config.psd1'
  $target_path = Join-Path $work_directory $config_file_name
  $setting = Import-PowerShellDataFile $target_path

  $ary = @()
  $base_target_dir = $setting.C_target_directory + @($mydoc_directory)

  foreach($dir in $base_target_dir){
    $ary = $ary + (Get-GitReposDirectories $dir)
  }

  $ary
}
