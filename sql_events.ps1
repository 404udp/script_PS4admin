# Задайте имя экземпляра SQL Server
$instanceName = "MSSQL$ISQLPRO"

# Получите записи из журнала событий (Application Log) о перезапуске, остановке, запуске и других событиях SQL Server
$logEntries = Get-WinEvent -FilterHashtable @{
    LogName = 'Application'
    ID = 17119, 17148, 17137, 17063, 17119, 17137, 17148, 7034, 7035, 7036, 102  # Дополнительные события SQL Server
}# | Where-Object { $_.Properties.Count -gt 0 -and $_.Properties[0].Value -eq $instanceName }

# Выведите результат
#$logEntries | Format-Table TimeCreated, Id, @{Name='InstanceName';Expression={$_.Properties[0].Value}}
# Выведите результат
$logEntries | Format-Table TimeCreated, Id, Message
