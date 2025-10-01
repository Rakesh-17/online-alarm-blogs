# Download Replacement Alarm Sound
# This script downloads a unique school bell sound to replace the duplicate

Write-Host "🔔 Downloading replacement alarm sound..." -ForegroundColor Green

# Create audio directory if it doesn't exist
if (!(Test-Path "audio")) {
    New-Item -ItemType Directory -Name "audio" -Force
    Write-Host "Created audio directory" -ForegroundColor Yellow
}

# Function to download audio file
function Download-AudioFile {
    param(
        [string]$FileName,
        [string]$Url,
        [string]$Description
    )
    
    $filePath = "audio\$FileName"
    
    Write-Host "Downloading $Description..." -ForegroundColor Cyan
    
    try {
        # Remove existing file if it exists
        if (Test-Path $filePath) {
            Remove-Item $filePath -Force
            Write-Host "Removed existing $FileName" -ForegroundColor Yellow
        }
        
        # Download the file
        Invoke-WebRequest -Uri $Url -OutFile $filePath -UseBasicParsing
        
        # Check if file was downloaded successfully
        if (Test-Path $filePath) {
            $fileSize = (Get-Item $filePath).Length
            if ($fileSize -gt 10000) { # More than 10KB
                Write-Host "✅ Successfully downloaded $FileName ($([math]::Round($fileSize/1MB, 2)) MB)" -ForegroundColor Green
                return $true
            } else {
                Remove-Item $filePath -Force
                Write-Host "❌ Downloaded file is too small ($fileSize bytes)" -ForegroundColor Red
                return $false
            }
        } else {
            Write-Host "❌ Failed to download $FileName" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "❌ Error downloading $FileName`: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Download a unique school bell sound
$success = Download-AudioFile -FileName "school_bell.mp3" -Url "https://www.soundjay.com/misc/sounds/bell-ringing-05.mp3" -Description "Classic School Bell"

if ($success) {
    Write-Host "`n🎉 Successfully downloaded replacement sound!" -ForegroundColor Green
    Write-Host "The school_bell.mp3 file is now available in the audio folder." -ForegroundColor Cyan
} else {
    Write-Host "`n⚠️ Failed to download replacement sound." -ForegroundColor Yellow
    Write-Host "You may need to manually download a unique alarm sound." -ForegroundColor Yellow
}

Write-Host "`nPress any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

