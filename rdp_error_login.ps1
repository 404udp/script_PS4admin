$logEntries = Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    ID = 4625
} | Select-Object TimeCreated, Id, Message, @{Name='IPAddress';Expression={($_.Properties | Where-Object { $_.Value -is [string] -and $_.Value -match '\d+\.\d+\.\d+\.\d+' }).Value}}, @{Name='AccountName';Expression={if($_.Message -match 'Account For Which Logon Failed:[\s\S]*?Account Name:\s+([^\r\n]+)') { $matches[1] }}}

$logEntries | Format-Table TimeCreated, Id, IPAddress, AccountName, Message

