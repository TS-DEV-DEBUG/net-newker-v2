function Write-ColoredLine {
    param(
        [string]$Text,
        [ConsoleColor]$ForegroundColor = "White",
        [ConsoleColor]$BackgroundColor = "Black"
    )
    $oldFore = $Host.UI.RawUI.ForegroundColor
    $oldBack = $Host.UI.RawUI.BackgroundColor
    $Host.UI.RawUI.ForegroundColor = $ForegroundColor
    $Host.UI.RawUI.BackgroundColor = $BackgroundColor
    Write-Host $Text
    $Host.UI.RawUI.ForegroundColor = $oldFore
    $Host.UI.RawUI.BackgroundColor = $oldBack
}

do {
    Clear-Host

    # Banner lines with your requested replacement and original colors preserved for the logo part
    $bannerLines = @(
        @{Text='╔════════════════════════════════════════════════════════════╗'; Color='Magenta'},
        @{Text='║                                                            ║'; Color='Yellow'},
        @{Text='║   MADE BY TS (plz dont @)                                  ║'; Color='Cyan'},
        @{Text='║   Net Newker V2 (No UI Version)                            ║'; Color='Yellow'},
        @{Text='║                                                            ║'; Color='Green'},
        @{Text='║                                                            ║'; Color='Yellow'},
        @{Text='║     ███╗   ██╗████████╗     ██╗   ██╗██╗  ██╗███████╗      ║'; Color='Red'},
        @{Text='║     ████╗  ██║╚══██╔══╝     ██║   ██║██║ ██╔╝██╔════╝      ║'; Color='Yellow'},
        @{Text='║     ██╔██╗ ██║   ██║        ██║   ██║█████╔╝ █████╗        ║'; Color='Cyan'},
        @{Text='║     ██║╚██╗██║   ██║        ██║   ██║██╔═██╗ ██╔══╝        ║'; Color='Green'},
        @{Text='║     ██║ ╚████║   ██║        ╚██████╔╝██║  ██╗███████╗      ║'; Color='Magenta'},
        @{Text='║     ╚═╝  ╚═══╝   ╚═╝         ╚═════╝ ╚═╝  ╚═╝╚══════╝      ║'; Color='Red'},
        @{Text='║                                                            ║'; Color='Yellow'},
        @{Text='║                   Discord Webhook Spammer v2               ║'; Color='White'},
        @{Text='║                                                            ║'; Color='Magenta'},
        @{Text='╚════════════════════════════════════════════════════════════╝'; Color='White'}
    )

    foreach ($line in $bannerLines) {
        Write-ColoredLine -Text $line.Text -ForegroundColor $line.Color
    }
    Write-Host ""

    $green = [ConsoleColor]::Green

    do {
        Write-ColoredLine -Text "Enter Discord webhook URL:" -ForegroundColor $green -BackgroundColor Black
        $webhook = Read-Host
    } while ([string]::IsNullOrWhiteSpace($webhook))

    Write-Host ""

    do {
        Write-ColoredLine -Text "Enter message to send:" -ForegroundColor $green -BackgroundColor Black
        $message = Read-Host
    } while ([string]::IsNullOrWhiteSpace($message))

    Write-Host ""

    do {
        Write-ColoredLine -Text "Enter number of times to spam (positive integer):" -ForegroundColor $green -BackgroundColor Black
        $countInput = Read-Host
        $validCount = $countInput -match '^[1-9][0-9]*$'
        if (-not $validCount) {
            Write-ColoredLine -Text "Invalid number. Please enter a positive integer." -ForegroundColor 'Red' -BackgroundColor Black
        }
    } until ($validCount)
    $count = [int]$countInput

    Write-Host ""

    do {
        Write-ColoredLine -Text "Enter desired Messages per Second (MPS, positive decimal, e.g. 0.5 or 10):" -ForegroundColor $green -BackgroundColor Black
        $mpsInput = Read-Host
        $validMPS = $mpsInput -match '^\d+(\.\d+)?$' -and ([double]$mpsInput) -gt 0
        if (-not $validMPS) {
            Write-ColoredLine -Text "Invalid input. Please enter a positive number." -ForegroundColor 'Red' -BackgroundColor Black
        }
    } until ($validMPS)
    $mps = [double]$mpsInput

    # Calculate delay between messages
    $delaySeconds = 1 / $mps

    Write-Host ""
    Write-ColoredLine -Text "Starting to spam $count messages at $mps messages per second..." -ForegroundColor $green -BackgroundColor Black
    Write-Host ""

    function Send-WebhookMessage {
        param (
            [string]$Url,
            [string]$Content
        )

        $body = @{ content = $Content } | ConvertTo-Json
        try {
            Invoke-RestMethod -Uri $Url -Method Post -Body $body -ContentType 'application/json' -ErrorAction Stop
            return $true
        }
        catch {
            return $false
        }
    }

    for ($i = 1; $i -le $count; $i++) {
        $success = Send-WebhookMessage -Url $webhook -Content $message
        if ($success) {
            Write-ColoredLine -Text "Message $i/$count sent successfully." -ForegroundColor $green -BackgroundColor Black
        }
        else {
            Write-ColoredLine -Text "Failed to send message $i/$count. Stopping spam." -ForegroundColor 'Red' -BackgroundColor Black
            break
        }
        Start-Sleep -Seconds $delaySeconds
    }

    Write-Host ""

    Write-ColoredLine -Text "Done." -ForegroundColor $green -BackgroundColor Black

    do {
        Write-ColoredLine -Text "Do u Want To do That Again {Y/N}:" -ForegroundColor $green -BackgroundColor Black
        $answer = Read-Host
    } while (-not $answer)

} while ($answer.ToUpper() -eq 'Y')

if ($answer.ToUpper() -eq 'N') {
    Write-ColoredLine -Text "Exiting... Goodbye!" -ForegroundColor $green
    exit
}

exit

