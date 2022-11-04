# Get monitor info
$Monitors = Get-WmiObject WmiMonitorID -Namespace root\wmi

# List of Manufacture Codes that could be pulled from WMI and their respective full names. Used for translating later down.
$ManufacturerHash = @{
    "AAC" =	"AcerView";
    "ACR" = "Acer";
    "AOC" = "AOC";
    "AIC" = "AG Neovo";
    "APP" = "Apple Computer";
    "AST" = "AST Research";
    "AUO" = "Asus";
    "BNQ" = "BenQ";
    "CMO" = "Acer";
    "CPL" = "Compal";
    "CPQ" = "Compaq";
    "CPT" = "Chunghwa Pciture Tubes, Ltd.";
    "CTX" = "CTX";
    "DEC" = "DEC";
    "DEL" = "Dell";
    "DPC" = "Delta";
    "DWE" = "Daewoo";
    "EIZ" = "EIZO";
    "ELS" = "ELSA";
    "ENC" = "EIZO";
    "EPI" = "Envision";
    "FCM" = "Funai";
    "FUJ" = "Fujitsu";
    "FUS" = "Fujitsu-Siemens";
    "GSM" = "LG Electronics";
    "GWY" = "Gateway 2000";
    "HEI" = "Hyundai";
    "HIT" = "Hyundai";
    "HSL" = "Hansol";
    "HTC" = "Hitachi/Nissei";
    "HWP" = "HP";
    "HPN" = "HP";
    "IBM" = "IBM";
    "ICL" = "Fujitsu ICL";
    "IVM" = "Iiyama";
    "KDS" = "Korea Data Systems";
    "LEN" = "Lenovo";
    "LGD" = "Asus";
    "LPL" = "Fujitsu";
    "MAX" = "Belinea";
    "MEI" = "Panasonic";
    "MEL" = "Mitsubishi Electronics";
    "MS_" = "Panasonic";
    "NAN" = "Nanao";
    "NEC" = "NEC";
    "NOK" = "Nokia Data";
    "NVD" = "Fujitsu";
    "OPT" = "Optoma";
    "PHL" = "Philips";
    "REL" = "Relisys";
    "SAN" = "Samsung";
    "SAM" = "Samsung";
    "SBI" = "Smarttech";
    "SGI" = "SGI";
    "SNY" = "Sony";
    "SRC" = "Shamrock";
    "SUN" = "Sun Microsystems";
    "SEC" = "Hewlett-Packard";
    "TAT" = "Tatung";
    "TOS" = "Toshiba";
    "TSB" = "Toshiba";
    "VSC" = "ViewSonic";
    "ZCM" = "Zenith";
    "UNK" = "Unknown";
    "_YV" = "Fujitsu";
}


$Monitor_Array = @()

$PCName = $env:ComputerName
$userName = $env:UserName
$runDate = Get-Date -Format "dd/MM/yyyy" 
$ipAddress = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration | where {$_.DHCPEnabled -ne $null -and $_.DefaultIPGateway -ne $null}).IPAddress | Select-Object -First 1    


ForEach ($Monitor in $Monitors)
{
    # Chech for built-in display
    if ($Monitor.UserFriendlyName){

    # Convert to the readable string
    $Manufacturer = ($Monitor.ManufacturerName -ne 0 | ForEach{[char]$_}) -join ""
    $Name = ($Monitor.UserFriendlyName -ne 0 | ForEach{[char]$_}) -join ""
    $Serial = ($Monitor.SerialNumberID -ne 0 | ForEach{[char]$_}) -join ""

    # Sets a friendly name based on the hash table above. If no entry found sets it to the original 3 character code
    $ManufacturerFriendly = $ManufacturerHash.$Manufacturer
    If ($ManufacturerFriendly -eq $null) {
        $ManufacturerFriendly = $Manufacturer
    }

    # Create objects for each monitor
    $Monitor_Obj = [PSCustomObject]@{
            UserName = $userName
            PCName = $PCName
            ipAddress = $ipAddress
            Manufacturer = $ManufacturerFriendly
            Model = $Name
            SerialNumber = $Serial
            Date = $runDate
        }
    # Writing objects to the Export array
    $Monitor_Array += $Monitor_Obj
    }
}

# Export array to the .csv file for each user
$Monitor_Array | Export-Csv -Path "~/MonInfo" -Append -NoTypeInformation -Force

# Look for ExecutionPolicy error
pause;
