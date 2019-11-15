function Get-UpdatedFiles($dir, $fromDate, $extensions, $depth=3)
{
  $dic = @{}
  $files = dir $dir -File -Recurse -Depth $depth  | 
               where {$_.LastWriteTime -gt $fromDate} |
               where {$_.Extension -in $extensions}  |
               where {$_.DirectoryName -notmatch "\.\w*"}

  foreach ($f in $files)
  {
    $dic.Add($f.Name, $f.FullName)
  }
  $dic
}

## ---------------------------------------------------- // entry point
##
If ((Resolve-Path -Path $MyInvocation.InvocationName).ProviderPath -eq $MyInvocation.MyCommand.Path) 
{
  $work_dir = $PROFILE | Split-Path -Parent
  cd $work_dir
  $config_name = './config.psd1'
  $config = Import-PowerShellDataFile $config_name
  # $config

  $mydoc = [environment]::GetFolderPath('mydocuments')
  $today = Get-Date (Get-Date -f 'yyyy/MM/dd')
  $fromDate = $today.AddDays(-1)

  Get-UpdatedFiles $mydoc $fromDate $config.C_extensions

}
