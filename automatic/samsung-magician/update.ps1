Import-Module AU

$releases = 'https://www.samsung.com/semiconductor/minisite/ssd/download/tools/'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
     }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases

    #Samsung_Magician_Installer.exe
    #http://downloadcenter.samsung.com/content/SW/201812/20181205162757370/Samsung_Magician_Installer.exe
    $re  = "Samsung_Magician_Installer.exe"
    $urlre = "Path=(.+\.exe)"

    $url = $download_page.links | Where-Object href -match $re | Select-Object -First 1 -expand href
    $urldata = ([regex]::Match($url,$urlre)).Captures.Groups[1].value
    $url = "http://downloadcenter.samsung.com/content/" + $urldata

    $version = $download_page.links | Where-Object href -match $re | Select-Object -First 1 -expand innerhtml
    $version = (Get-Version $version).ToString()
    
    return @{ 
        URL32 = $url
        Version = $version 
    }
}

update -ChecksumFor 32
