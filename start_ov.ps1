# Получаем данные из JSON
$json = Get-Content ( $PWD.Path + '\start_ov.jsonc')  
$json = $json -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' 
$json = $json | Out-String | ConvertFrom-Json

#Переменные для работы
$vpn_path = $json.vpn_path
$name_srt = $json.name_srt
$log_path = $json.log_path
$path_RDP = $json.path_RDP
$auto_start = $json.auto_start


# Снимаем процесс RDP
Get-Process -processName  "*mstsc*" | Stop-Process

# запускаем приложения из автозапуска
$auto_start | ForEach-Object {
	& $_
}

# Если не подключены к сети ВПН
if (Get-NetAdapter -InterfaceDescription "*TAP-Windows*" | Where-Object {$_.Status -ne 'Up'})
{
	# Снимаем процесс ВПН, если запущен и запускаем его заново
	Get-Process -processName  "*openvpn-gui*" | Stop-Process
	& $vpn_path --connect $name_srt --silent_connection 1 
	Start-Sleep -Seconds 1
}

# Журнал
$txt = "CONNECTED,SUCCESS"
$status_vpn = $false


$I = 0

while ($I -le 60)
{
	# Проверяем журнал ВПН на совпадение с $txt - это означает, что ВПН, полностью подключился
	$file = get-content $log_path
	foreach($t in $txt)
	{
		if($file -match "$t") {
			$status_vpn = $true
		} 
		else {
			$status_vpn = $false
			break
		}
	}

    if ($status_vpn)
    {
		"VPN - OK. Start RDP"
        & mstsc.exe $path_RDP
        break;
    }
    else
    {
        ++$I
        "Loading - " + $I
        Start-Sleep -Seconds 1
    }
}
#pause