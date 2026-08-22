Add-Type -AssemblyName System.Drawing

function Draw-Wave {
    param(
        [System.Drawing.Graphics]$Graphics,
        [System.Drawing.Pen]$Pen,
        [int]$Width,
        [int]$BaseY,
        [double]$Amplitude,
        [double]$Frequency,
        [double]$Phase
    )

    $points = New-Object System.Collections.Generic.List[System.Drawing.PointF]
    for ($x = 0; $x -le $Width; $x += 8) {
        $y = $BaseY + $Amplitude * [Math]::Sin(($x * $Frequency) + $Phase)
        $points.Add([System.Drawing.PointF]::new($x, $y))
    }
    $Graphics.DrawCurve($Pen, $points.ToArray())
}

function New-WaveImage {
    param(
        [string]$OutputPath,
        [bool]$Flip
    )

    $w = 720
    $h = 64
    $bmp = New-Object System.Drawing.Bitmap $w, $h
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([System.Drawing.Color]::Transparent)

    $waves = @(
        @{ Color = [System.Drawing.Color]::FromArgb(230, 244, 114, 182); Y = 40; Amp = 10; Freq = 0.035; Phase = 0.0; Size = 3.0 }
        @{ Color = [System.Drawing.Color]::FromArgb(220, 96, 165, 250); Y = 30; Amp = 8; Freq = 0.042; Phase = 1.2; Size = 2.5 }
        @{ Color = [System.Drawing.Color]::FromArgb(210, 167, 139, 250); Y = 48; Amp = 7; Freq = 0.038; Phase = 2.1; Size = 2.0 }
        @{ Color = [System.Drawing.Color]::FromArgb(200, 52, 211, 153); Y = 22; Amp = 6; Freq = 0.030; Phase = 0.8; Size = 2.0 }
        @{ Color = [System.Drawing.Color]::FromArgb(190, 251, 146, 60); Y = 52; Amp = 5; Freq = 0.045; Phase = 1.8; Size = 1.8 }
    )

    if ($Flip) {
        $g.ScaleTransform(1, -1)
        $g.TranslateTransform(0, -$h)
        foreach ($wave in $waves) {
            $wave.Y = $h - $wave.Y
        }
    }

    foreach ($wave in $waves) {
        $pen = New-Object System.Drawing.Pen $wave.Color, $wave.Size
        $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
        $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
        Draw-Wave -Graphics $g -Pen $pen -Width $w -BaseY $wave.Y -Amplitude $wave.Amp -Frequency $wave.Freq -Phase $wave.Phase
        $pen.Dispose()
    }

    $bmp.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
}

$assets = Join-Path $PSScriptRoot "..\assets"
New-WaveImage -OutputPath (Join-Path $assets "wave-top.png") -Flip $false
New-WaveImage -OutputPath (Join-Path $assets "wave-bottom.png") -Flip $true
Write-Output "Generated wave PNG files"
