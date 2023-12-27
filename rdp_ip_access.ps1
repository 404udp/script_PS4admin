# Задайте имя журнала событий, где хранятся данные о входах
$logName = 'Security'

# Получите записи из журнала событий о успешных входах
$successfulLogins = Get-WinEvent -FilterHashtable @{
    LogName = $logName
    ID = 4624  # ID события для успешного входа
}

# Извлеките уникальные IP-адреса из поля "IpAddress"
$uniqueIPs = $successfulLogins |
    ForEach-Object {
        $_.Properties |
        Where-Object { $_.Value -is [string] -and $_.Value -match '\d+\.\d+\.\d+\.\d+' } |
        Select-Object -ExpandProperty Value
    } |
    Select-Object -Unique

# Сортируйте уникальные IP-адреса
$sortedUniqueIPs = $uniqueIPs | Sort-Object

# Выведите отсортированные уникальные IP-адреса
$sortedUniqueIPs

