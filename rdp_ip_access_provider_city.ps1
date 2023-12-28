# Задайте имя журнала событий, где хранятся данные о входах
$logName = 'Security'

# Получите записи из журнала событий о успешных входах
$successfulLogins = Get-WinEvent -FilterHashtable @{
    LogName = $logName
    ID = 4624  # ID события для успешного входа
}

# Создайте функцию для получения информации о местоположении по IP-адресу
function Get-IPInfo($ipAddress) {
    $locationInfo = Invoke-RestMethod -Uri "http://ipinfo.io/$ipAddress/json"
    [PSCustomObject]@{
        IPAddress   = $ipAddress
        Hostname    = $locationInfo.hostname
        Country     = $locationInfo.country
        City        = $locationInfo.city
        Provider    = $locationInfo.org
    }
}

# Извлеките уникальные IP-адреса из поля "IpAddress" и получите информацию о местоположении
$uniqueIPsInfo = $successfulLogins |
    ForEach-Object {
        $_.Properties |
        Where-Object { $_.Value -is [string] -and $_.Value -match '\d+\.\d+\.\d+\.\d+' } |
        Select-Object -ExpandProperty Value
    } |
    Select-Object -Unique |
    ForEach-Object { Get-IPInfo $_ } |
    Sort-Object IPAddress

# Выведите результат в виде таблицы
$uniqueIPsInfo | Format-Table IPAddress, Hostname, Country, City, Provider
