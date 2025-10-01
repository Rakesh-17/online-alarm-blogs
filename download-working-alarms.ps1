# Download Working Alarm Sounds
# This script downloads alarm sounds from working sources

Write-Host "Downloading Working Alarm Sounds..." -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

# Create audio directory if it doesn't exist
if (!(Test-Path "audio")) {
    New-Item -ItemType Directory -Name "audio" | Out-Null
}

# Function to download with retry
function Download-WithRetry {
    param(
        [string]$FileName,
        [string]$Url,
        [string]$Description
    )
    
    $filePath = "audio\$FileName"
    
    # Remove existing file if it's too small
    if (Test-Path $filePath) {
        $fileSize = (Get-Item $filePath).Length
        if ($fileSize -lt 10000) {
            Remove-Item $filePath -Force
        } else {
            Write-Host "Skipping $Description (already exists and valid)" -ForegroundColor Yellow
            return $true
        }
    }
    
    try {
        Write-Host "Downloading $Description..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $Url -OutFile $filePath -UseBasicParsing -TimeoutSec 30
        
        $fileSize = (Get-Item $filePath).Length
        if ($fileSize -gt 10000) {
            Write-Host "Downloaded $Description successfully ($fileSize bytes)" -ForegroundColor Green
            return $true
        } else {
            Write-Host "File too small, removing..." -ForegroundColor Red
            Remove-Item $filePath -Force
            return $false
        }
    }
    catch {
        Write-Host "Failed to download $Description" -ForegroundColor Red
        if (Test-Path $filePath) {
            Remove-Item $filePath -Force
        }
        return $false
    }
}

# Try different working sources
Write-Host "Trying different alarm sound sources..." -ForegroundColor Magenta

# Source 1: GitHub raw content (more reliable)
$githubUrls = @(
    "https://raw.githubusercontent.com/username/alarm-sounds/main/iphone.mp3",
    "https://raw.githubusercontent.com/username/alarm-sounds/main/android.mp3"
)

# Source 2: Direct MP3 links from working sites
$directUrls = @(
    "https://www.soundjay.com/misc/sounds/bell-ringing-05.mp3",
    "https://www.soundjay.com/misc/sounds/bell-ringing-04.mp3",
    "https://www.soundjay.com/misc/sounds/bell-ringing-02.mp3"
)

# Source 3: Alternative sound libraries
$alternativeUrls = @(
    "https://www.zapsplat.com/wp-content/uploads/2015/sound-effects-84567/zapsplat_technology_mobile_phone_iphone_alarm_ringtone_84567.mp3",
    "https://www.zapsplat.com/wp-content/uploads/2015/sound-effects-84568/zapsplat_technology_mobile_phone_android_notification_84568.mp3"
)

# Try to download from working sources
$successCount = 0

Write-Host "Attempting downloads from multiple sources..." -ForegroundColor Cyan

# Try direct URLs first
foreach ($url in $directUrls) {
    $fileName = "alarm_$($successCount + 1).mp3"
    if (Download-WithRetry $fileName $url "Alarm Sound $($successCount + 1)") {
        $successCount++
    }
}

# Try alternative URLs
foreach ($url in $alternativeUrls) {
    $fileName = "mobile_alarm_$($successCount + 1).mp3"
    if (Download-WithRetry $fileName $url "Mobile Alarm $($successCount + 1)") {
        $successCount++
    }
}

Write-Host "===============================================" -ForegroundColor Green
Write-Host "Download Summary:" -ForegroundColor Cyan
Write-Host "Successfully downloaded: $successCount files" -ForegroundColor Green

# Show current audio files
Write-Host "Current audio files:" -ForegroundColor Magenta
Get-ChildItem "audio" | ForEach-Object {
    $size = [math]::Round($_.Length / 1KB, 2)
    if ($_.Length -gt 10000) {
        Write-Host "   $($_.Name) ($size KB) - VALID" -ForegroundColor Green
    } else {
        Write-Host "   $($_.Name) ($size KB) - INVALID" -ForegroundColor Red
    }
}

if ($successCount -eq 0) {
    Write-Host "No new files downloaded. Creating sample alarm sounds..." -ForegroundColor Yellow
    
    # Create a simple text file with instructions
    $instructions = @"
# No Audio Files Downloaded

The automatic download failed. Here are manual options:

1. **Record Your Own:**
   - Use your phone to record real alarm sounds
   - Convert to MP3 format
   - Place in this audio folder

2. **Download Manually:**
   - Visit: https://freesound.org
   - Search for "alarm", "notification", "bell"
   - Download MP3 files
   - Place in this audio folder

3. **Extract System Sounds:**
   - Copy alarm sounds from your device
   - Windows: C:\Windows\Media\
   - Mac: /System/Library/Sounds/
   - Convert to MP3 if needed

4. **Use Online Generators:**
   - https://www.soundjay.com
   - https://www.zapsplat.com
   - https://mixkit.co/free-sound-effects/

File Requirements:
- Format: MP3
- Size: >10KB
- Duration: 1-5 seconds
"@
    
    $instructions | Out-File "audio/NO_AUDIO_README.txt" -Encoding UTF8
    Write-Host "Created instructions file: audio/NO_AUDIO_README.txt" -ForegroundColor Cyan
}

Write-Host "===============================================" -ForegroundColor Green
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Check the audio folder" -ForegroundColor White
Write-Host "2. Open enhanced-audio-test.html to test sounds" -ForegroundColor White
Write-Host "3. If no sounds, follow manual instructions above" -ForegroundColor White

