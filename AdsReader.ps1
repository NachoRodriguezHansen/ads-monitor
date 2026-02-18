# =========================
# IMPORT ENUM DEFINITIONS
# =========================

Import-Module "$PSScriptRoot\Enums.PML.psm1" -Force

if (-not $EnumMaps.ContainsKey("eStateV3"))
{
    throw "Enum eStateV3 not loaded"
}


# =========================
# CONFIG
# =========================

#$AdsDllPath = "C:\TwinCAT\Ads Api\.NET\v2.0.50727\TwinCAT.Ads.dll"
$AdsDllPath = "C:\TwinCat\3.1\Components\Plc\Build_4024.35\LacBinaries\GAC_MSIL\TwinCAT.Ads\4.2.169.0__180016cd49e5e8c3\TwinCAT.Ads.dll"



#$AmsNetId = "100.38.23.81.1.1"
$AmsNetId = "192.168.75.1.1.1"

$Port         = 851
$VariableName = "MAIN.rSpeed"
$VariableType = [System.Single]   # BOOL=[System.Boolean] INT=[System.Int16] DINT=[System.Int32] REAL=[System.Single]
$CycleTimeMs  = 200


# =========================
# VARIABLES TO MONITOR
# =========================
# Type: bool, int16, int32, real, or custom enum type

$Variables = @(
    @{
        Name = "PRG_MAIN.fbStnMachine.fbStnMlc.HMIAeStateV3"
        Type = "eStateV3"
    },
    @{
        Name = "PRG_MAIN.fbStnMachine.fbStnMlc.HMIAeModeV3"
        Type = "eModeV3"
    }
)

# =========================
# LOAD ADS DLL
# =========================

Add-Type -Path $AdsDllPath

#$handle = $client.CreateVariableHandle($var.Name)
#$notif = $client.AddDeviceNotification(


$client = $null
$handle = $null

$client = New-Object TwinCAT.Ads.TcAdsClient

try
{
    Write-Host "Connecting to ADS..."
    $client.Connect($AmsNetId, $Port)
    Write-Host "Connected OK"
    Write-Host "Reading variable: $VariableName"
    Write-Host "Press CTRL+C to stop"
    Write-Host ""

    # Crear handle una sola vez (más eficiente)
    $handle = $client.CreateVariableHandle($VariableName)

    while ($true)
    {
        try
        {
            $value     = $client.ReadAny($handle, $VariableType)
            $timestamp = Get-Date -Format "HH:mm:ss.fff"
            Write-Host "$timestamp  ->  $VariableName = $value"
            Start-Sleep -Milliseconds $CycleTimeMs
        }
        catch
        {
            Write-Host "Read error: $_"
            Start-Sleep -Milliseconds 1000
        }
    }
}
finally
{
    Write-Host ""
    Write-Host "Closing ADS connection..."

    if ($null -ne $handle -and $null -ne $client)
    {
        try { $client.DeleteVariableHandle($handle) } catch {}
    }

    if ($null -ne $client)
    {
        try { $client.Dispose() } catch {}
    }

    Write-Host "Done."
}
 
