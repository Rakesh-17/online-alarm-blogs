# Download Audio Files for Online Alarm
# This script downloads real alarm sound files from free sources

Write-Host "Downloading Real Alarm Sound Files..." -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

# Create audio directory if it doesn't exist
if (!(Test-Path "audio")) {
    New-Item -ItemType Directory -Name "audio" | Out-Null
    Write-Host "Created audio directory" -ForegroundColor Green
}

# Function to download audio file
function Download-AudioFile {
    param(
        [string]$FileName,
        [string]$Url,
        [string]$Description
    )
    
    $filePath = "audio\$FileName"
    
    if (Test-Path $filePath) {
        Write-Host "Skipping $Description (already exists)" -ForegroundColor Yellow
        return
    }
    
    try {
        Write-Host "Downloading $Description..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $Url -OutFile $filePath -UseBasicParsing
        Write-Host "Downloaded $Description" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to download $Description" -ForegroundColor Red
    }
}

# Download real alarm sounds from free sources
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
Write-Host "Audio Download Complete!" -ForegroundColor Green
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Check the 'audio' folder for downloaded files" -ForegroundColor White
Write-Host "2. Open enhanced-audio-test.html to test the sounds" -ForegroundColor White
Write-Host "3. If some downloads failed, manually download from:" -ForegroundColor White
Write-Host "   - https://freesound.org" -ForegroundColor Blue
Write-Host "   - https://www.soundjay.com" -ForegroundColor Blue
Write-Host "   - https://www.zapsplat.com" -ForegroundColor Blue

Write-Host "Tip: You can also record real alarm sounds with your phone!" -ForegroundColor Yellow
Write-Host "   Just make sure to convert them to MP3 format." -ForegroundColor Yellow

# Show downloaded files
Write-Host "Files in audio directory:" -ForegroundColor Magenta
Get-ChildItem "audio" | ForEach-Object {
    $size = [math]::Round($_.Length / 1KB, 2)
    Write-Host "   $($_.Name) ($size KB)" -ForegroundColor White
}

Write-Host "Ready to use real alarm sounds!" -ForegroundColor Green
