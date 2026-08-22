Add-Type -AssemblyName System.Drawing

$w = 800
$h = 160
$out = Join-Path $PSScriptRoot "..\assets\banner.png"

$bmp = New-Object System.Drawing.Bitmap $w, $h
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

$bg = [System.Drawing.Color]::FromArgb(255, 243, 244, 246)
$frame = [System.Drawing.Color]::FromArgb(255, 209, 213, 219)
$inner = [System.Drawing.Color]::FromArgb(255, 250, 250, 250)
$mist = [System.Drawing.Color]::FromArgb(60, 156, 163, 175)
$silver = [System.Drawing.Color]::FromArgb(90, 148, 163, 184)
$line = [System.Drawing.Color]::FromArgb(160, 107, 114, 128)

$g.Clear($bg)
$penFrame = New-Object System.Drawing.Pen $frame, 1
$g.DrawRectangle($penFrame, 0, 0, $w - 1, $h - 1)
$g.FillRectangle((New-Object System.Drawing.SolidBrush $inner), 20, 20, $w - 40, $h - 40)
$g.DrawRectangle((New-Object System.Drawing.Pen $frame), 20, 20, $w - 40, $h - 40)

$g.FillEllipse((New-Object System.Drawing.SolidBrush $mist), 60, 45, 70, 70)
$g.FillEllipse((New-Object System.Drawing.SolidBrush $silver), 670, 55, 90, 90)
$g.FillEllipse((New-Object System.Drawing.SolidBrush $mist), 620, 95, 36, 36)

$g.DrawLine((New-Object System.Drawing.Pen $line, 2), 280, 80, 520, 80)

$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()

Write-Output "Saved $out"
