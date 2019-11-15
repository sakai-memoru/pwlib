function Global:Get-Logger{
    Param(
        [CmdletBinding()]
        [Parameter()][String]$Delimiter = " ",
        [Parameter()][String]$LogfilePath = "./apps.log",
        [Parameter()][String]$Encoding = "Default",
        [Parameter()][String]$VerbosePreference = "SilentlyContinue",
        [Parameter()][Switch]$NoDisplay
    )
    if (!(Test-Path -LiteralPath (Split-Path $LogfilePath -parent) -PathType container)) {
        New-Item $LogfilePath -type file -Force
    }
    $logger = @{}
    $logger.Set_Item('info', (Put-Log -Delimiter $Delimiter -LogfilePath $LogfilePath -Encoding $Encoding -NoDisplay $NoDisplay -Info))
    $logger.Set_Item('warn', (Put-Log -Delimiter $Delimiter -LogfilePath $LogfilePath -Encoding $Encoding -NoDisplay $NoDisplay -Warn))
    $logger.Set_Item('error', (Put-Log -Delimiter $Delimiter -LogfilePath $LogfilePath -Encoding $Encoding -NoDisplay $NoDisplay -Err))
    $logger.Set_Item('debug', (Put-Log -Delimiter $Delimiter -LogfilePath $LogfilePath -Encoding $Encoding -NoDisplay $NoDisplay -Dbg -VerbosePreference $VerbosePreference))
    return $logger
}

function Global:Put-Log
{
    Param(
        [CmdletBinding()]
        [Parameter()][String]$Delimiter = " ",
        [Parameter()][String]$LogfilePath,
        [Parameter()][String]$Encoding,
        [Parameter()][bool]$NoDisplay,
        [Parameter()][String]$VerbosePreference,
        [Parameter()][Switch]$Info,
        [Parameter()][Switch]$Warn,
        [Parameter()][Switch]$Err,
        [Parameter()][Switch]$Dbg
    )
    return {
        param([String]$msg = "")

        # Initialize variables
        # echo "Dbg=$Dbg"
        $logparam = @("White", "INFO")
        if ($Warn)  { $logparam = @("Yellow", "WARN") }
        if ($Err) { $logparam = @("Red", "ERROR") }
        if ($Dbg) { $logparam = @("White", "DEBUG") }
        $txt = "[$(Get-Date -Format "yyyy/MM/dd HH:mm:ss")]${Delimiter}{0}${Delimiter}{1}" -f $logparam[1], $msg
        
        # $VerbosePreference = 'Continue'
        # Output Display
        if(!$NoDisplay) {
            if($Dbg){
              Write-Verbose $txt
            } else {
              Write-Host -ForegroundColor $logparam[0] $txt
            }
        }
        # Output LogfilePath
        if($LogfilePath) {
            if($Dbg){
              Write-Output $txt | Out-File -FilePath $LogfilePath -Append -Encoding $Encoding
            } else {
              Write-Output $txt | Out-File -FilePath $LogfilePath -Append -Encoding $Encoding
            }
        }
    }.GetNewClosure()
}

## ---------------------------------------------------- // entry point
##
If ((Resolve-Path -Path $MyInvocation.InvocationName).ProviderPath -eq $MyInvocation.MyCommand.Path) 
{
#$VerbosePreference = 'Continue'
$VerbosePreference = 'SilentlyContinue'

$logger = Get-Logger -VerbosePreference $VerbosePreference
$logger.info.Invoke("output infomation")
$logger.warn.Invoke("output warning message")
$logger.error.Invoke("output error message")
$logger.debug.Invoke("output debug message")


} 
