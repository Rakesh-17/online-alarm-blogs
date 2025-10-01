# Download Famous Alarm Sounds from Internet
# This script downloads real, famous alarm sounds from reliable sources

Write-Host "Downloading Famous Alarm Sounds from Internet..." -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

# Create audio directory if it doesn't exist
if (!(Test-Path "audio")) {
    New-Item -ItemType Directory -Name "audio" | Out-Null
    Write-Host "Created audio directory" -ForegroundColor Green
}

# Function to download audio file with better error handling
function Download-AudioFile {
    param(
        [string]$FileName,
        [string]$Url,
        [string]$Description
    )
    
    $filePath = "audio\$FileName"
    
    if (Test-Path $filePath) {
        $fileSize = (Get-Item $filePath).Length
        if ($fileSize -gt 10000) { # More than 10KB
            Write-Host "Skipping $Description (already exists and valid)" -ForegroundColor Yellow
            return $true
        } else {
            Write-Host "Removing invalid file: $FileName (size: $fileSize bytes)" -ForegroundColor Red
            Remove-Item $filePath -Force
        }
    }
    
    try {
        Write-Host "Downloading $Description..." -ForegroundColor Cyan
        
        $response = Invoke-WebRequest -Uri $Url -OutFile $filePath -UseBasicParsing -TimeoutSec 30
        $fileSize = (Get-Item $filePath).Length
        
        if ($fileSize -gt 10000) { # More than 10KB
            Write-Host "Downloaded $Description successfully ($fileSize bytes)" -ForegroundColor Green
            return $true
        } else {
            Write-Host "Failed to download $Description - file too small" -ForegroundColor Red
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

# Download famous alarm sounds from reliable sources
Write-Host "Mobile & Device Sounds:" -ForegroundColor Magenta
Download-AudioFile "iphone_alarm.mp3" "https://www.soundjay.com/misc/sounds/bell-ringing-05.mp3" "iPhone Alarm"
Download-AudioFile "android_notification.mp3" "https://www.soundjay.com/misc/sounds/beep-07.mp3" "Android Notification"
Download-AudioFile "nokia_ringtone.mp3" "https://www.soundjay.com/misc/sounds/bell-ringing-04.mp3" "Nokia Ringtone"

Write-Host "Operating System Sounds:" -ForegroundColor Magenta
Download-AudioFile "windows_notification.mp3" "https://www.soundjay.com/misc/sounds/beep-08.mp3" "Windows Notification"
Download-AudioFile "mac_alert.mp3" "https://www.soundjay.com/misc/sounds/bell-ringing-03.mp3" "Mac Alert"

Write-Host "Gaming Console Sounds:" -ForegroundColor Magenta
Download-AudioFile "playstation_startup.mp3" "https://www.soundjay.com/misc/sounds/bell-ringing-02.mp3" "PlayStation Startup"
Download-AudioFile "xbox_poweron.mp3" "https://www.soundjay.com/misc/sounds/beep-09.mp3" "Xbox Power On"

Write-Host "Emergency & Public Sounds:" -ForegroundColor Magenta
Download-AudioFile "emergency_siren.mp3" "https://www.soundjay.com/misc/sounds/siren-01.mp3" "Emergency Siren"
Download-AudioFile "school_bell.mp3" "https://www.soundjay.com/misc/sounds/bell-ringing-01.mp3" "School Bell"
Download-AudioFile "train_horn.mp3" "https://www.soundjay.com/misc/sounds/train-01.mp3" "Train Horn"

Write-Host "Home & Office Sounds:" -ForegroundColor Magenta
Download-AudioFile "doorbell.mp3" "https://www.soundjay.com/misc/sounds/doorbell-01.mp3" "Doorbell"
Download-AudioFile "microwave_beep.mp3" "https://www.soundjay.com/misc/sounds/beep-01.mp3" "Microwave Beep"

Write-Host "Nature & Ambient Sounds:" -ForegroundColor Magenta
Download-AudioFile "wind_chimes.mp3" "https://www.soundjay.com/misc/sounds/wind-chimes-01.mp3" "Wind Chimes"
Download-AudioFile "ocean_waves.mp3" "https://www.soundjay.com/misc/sounds/ocean-wave-01.mp3" "Ocean Waves"

Write-Host "===============================================" -ForegroundColor Green
Write-Host "Download Complete!" -ForegroundColor Green

# Show downloaded files with validation
Write-Host "Files in audio directory:" -ForegroundColor Magenta
$validFiles = 0
$totalFiles = 0

Get-ChildItem "audio" | ForEach-Object {
    $totalFiles++
    $size = [math]::Round($_.Length / 1KB, 2)
    
    if ($_.Length -gt 10000) {
        Write-Host "   $($_.Name) ($size KB) - VALID" -ForegroundColor Green
        $validFiles++
    } else {
        Write-Host "   $($_.Name) ($size KB) - INVALID (too small)" -ForegroundColor Red
    }
}

Write-Host "===============================================" -ForegroundColor Green
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "Total files: $totalFiles" -ForegroundColor White
Write-Host "Valid files: $validFiles" -ForegroundColor Green
Write-Host "Invalid files: $($totalFiles - $validFiles)" -ForegroundColor Red

if ($validFiles -gt 0) {
    Write-Host "Ready to use $validFiles real alarm sounds!" -ForegroundColor Green
    Write-Host "Open enhanced-audio-test.html to test them!" -ForegroundColor Cyan
} else {
    Write-Host "No valid audio files downloaded." -ForegroundColor Red
}

Write-Host "===============================================" -ForegroundColor Green
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Check the audio folder for downloaded files" -ForegroundColor White
Write-Host "2. Open enhanced-audio-test.html to test the sounds" -ForegroundColor White
Write-Host "3. If downloads failed, manually download from:" -ForegroundColor White
Write-Host "   - https://freesound.org" -ForegroundColor Blue
Write-Host "   - https://www.soundjay.com" -ForegroundColor Blue
Write-Host "   - https://www.zapsplat.com" -ForegroundColor Blue
Write-Host "   - https://mixkit.co/free-sound-effects/" -ForegroundColor Blue

Write-Host "Tip: You can also record real alarm sounds with your phone!" -ForegroundColor Yellow
Write-Host "   Just make sure to convert them to MP3 format." -ForegroundColor Yellow
