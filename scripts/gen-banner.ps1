Add-Type -AssemblyName System.Drawing

$w = 800
$h = 200
$out = Join-Path $PSScriptRoot "..\assets\banner.png"

$bmp = New-Object System.Drawing.Bitmap $w, $h
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

$bg = [System.Drawing.Color]::FromArgb(255, 255, 247, 237)
$inner = [System.Drawing.Color]::FromArgb(255, 255, 251, 235)

$g.Clear($bg)
$g.DrawRectangle([System.Drawing.Pens]::Orange, 1, 1, $w - 2, $h - 2)
$g.FillRectangle([System.Drawing.Brushes]::LightYellow, 24, 24, $w - 48, $h - 48)

$g.FillEllipse([System.Drawing.Brushes]::Pink, 80, 40, 44, 44)
$g.FillEllipse([System.Drawing.Brushes]::LightSkyBlue, 650, 110, 56, 56)
$g.FillEllipse([System.Drawing.Brushes]::LightGreen, 590, 35, 32, 32)
$g.FillRectangle([System.Drawing.Brushes]::HotPink, 310, 145, 180, 4)

$font = [System.Drawing.Font]::new("Arial", 42, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
$brushPink = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 219, 39, 119))
$brushBlue = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 37, 99, 235))

$sizeLin = $g.MeasureString("Lin", $font)
$sizeJJ = $g.MeasureString("JJ12", $font)
$x = ($w - $sizeLin.Width - $sizeJJ.Width) / 2
$y = 68

$g.DrawString("Lin", $font, $brushPink, $x, $y)
$g.DrawString("JJ12", $font, $brushBlue, $x + $sizeLin.Width, $y)

$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()

Write-Output "Saved $out"
