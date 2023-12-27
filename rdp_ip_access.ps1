# ������� ��� ������� �������, ��� �������� ������ � ������
$logName = 'Security'

# �������� ������ �� ������� ������� � �������� ������
$successfulLogins = Get-WinEvent -FilterHashtable @{
    LogName = $logName
    ID = 4624  # ID ������� ��� ��������� �����
}

# ��������� ���������� IP-������ �� ���� "IpAddress"
$uniqueIPs = $successfulLogins |
    ForEach-Object {
        $_.Properties |
        Where-Object { $_.Value -is [string] -and $_.Value -match '\d+\.\d+\.\d+\.\d+' } |
        Select-Object -ExpandProperty Value
    } |
    Select-Object -Unique

# ���������� ���������� IP-������
$sortedUniqueIPs = $uniqueIPs | Sort-Object

# �������� ��������������� ���������� IP-������
$sortedUniqueIPs

