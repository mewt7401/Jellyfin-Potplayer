# potplayer_aifixed_cover.ps1 
# just replace the code from the original potplayer.ps1
param($url)

# 移除协议前缀
$path = $url -replace '^potplayer://', ''

# URL解码
Add-Type -AssemblyName System.Web
$decoded = [System.Web.HttpUtility]::UrlDecode($path)

# 使用System.IO.Path方法
# 先将正斜杠替换为反斜杠
$tempPath = $decoded -replace '/', '\'

# 确保盘符格式正确
if ($tempPath -match '^[A-Z]\\') {
    # 第一个字符是盘符，后面是反斜杠，需要插入冒号
    $drive = $tempPath[0]
    $rest = $tempPath.Substring(1)
    $windowsPath = "$drive`:$rest"
} else {
    $windowsPath = $tempPath
}

# 使用Path.GetFullPath规范化路径
try {
    $fullPath = [System.IO.Path]::GetFullPath($windowsPath)
    Write-Host "完整路径: $fullPath"
    $windowsPath = $fullPath
} catch {
    Write-Host "无法获取完整路径，使用原路径" -ForegroundColor Yellow
}

# 启动PotPlayer
$potplayer = "C:\Program Files\DAUM\PotPlayer\PotPlayerMini64.exe"
Start-Process -FilePath $potplayer -ArgumentList "`"$windowsPath`""
