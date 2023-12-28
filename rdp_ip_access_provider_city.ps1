# ������� ��� ������� �������, ��� �������� ������ � ������
$logName = 'Security'

# �������� ������ �� ������� ������� � �������� ������
$successfulLogins = Get-WinEvent -FilterHashtable @{
    LogName = $logName
    ID = 4624  # ID ������� ��� ��������� �����
}

# �������� ������� ��� ��������� ���������� � �������������� �� IP-������
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

# ��������� ���������� IP-������ �� ���� "IpAddress" � �������� ���������� � ��������������
$uniqueIPsInfo = $successfulLogins |
    ForEach-Object {
        $_.Properties |
        Where-Object { $_.Value -is [string] -and $_.Value -match '\d+\.\d+\.\d+\.\d+' } |
        Select-Object -ExpandProperty Value
    } |
    Select-Object -Unique |
    ForEach-Object { Get-IPInfo $_ } |
    Sort-Object IPAddress

# �������� ��������� � ���� �������
$uniqueIPsInfo | Format-Table IPAddress, Hostname, Country, City, Provider
