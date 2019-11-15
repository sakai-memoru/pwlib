function Convertto-PsobjFromHash ($dic, $headary)
{
  $psobj = New-Object PSObject
  for($i = 0; $i -lt $headary.Count; $i++)
  {
    if($headary[$i] -in $dic.Keys)
    {
      $psobj | Add-Member -MemberType NoteProperty -Name $headary[$i] -Value $dic[$headary[$i]]
    }else{
      $psobj | Add-Member -MemberType NoteProperty -Name $headary[$i] -Value ''
    }
  }
  ## return
  $psobj
}

function Convertto-PsobjFromArray ($ary, $headary)
{
  $psobj = New-Object PSObject
  for($i = 0; $i -lt $headary.Count; $i++)
  {
    $psobj | Add-Member -MemberType NoteProperty -Name $headary[$i] -Value $ary[$i]
  }
  ## return
  $psobj
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

## hash
$dic = @{
  'head1' = 'powershell'
  'head2' = 'windows 10'
  'head4' = 'hashtable'
}

$headary = $config.C_header_ary  
$psobj = Convertto-PsobjFromHash $dic $headary
$psobj

$ary = @('pwsh', 'win10', 'array')
$psobj2 = Convertto-PsobjFromArray $ary $headary
$psobj2
  
}