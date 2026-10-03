<#
.SYNOPSIS
    Instalación online de "Abrir con VS Code" en el menú contextual.
.LICENSE
    MIT License
#>

VSCodePath = "env:LocalAppData\Programs\Microsoft VS Code\Code.exe"

if (-not (Test-Path \$VSCodePath)) {
    # Buscar en la ruta alternativa por si está instalado globalmente
    VSCodePath = "env:ProgramFiles\Microsoft VS Code\Code.exe"
    if (-not (Test-Path \$VSCodePath)) {
        Write-Error "No se encontró Visual Studio Code en las rutas por defecto."
        Exit
    }
}

\$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (\$IsAdmin) {
    Write-Host "Instalación global (Administrador)..." -ForegroundColor Green
    \$BasePath = "Registry::HKEY_CLASSES_ROOT\Directory\shell\VSCodeOpen"
} else {
    Write-Host "Instalación local (Usuario estándar)..." -ForegroundColor Cyan
    \$BasePath = "Registry::HKEY_CURRENT_USER\Software\Classes\Directory\shell\VSCodeOpen"
}

try {
    if (-not (Test-Path BasePath)) New-Item -Path BasePath -Force | Out-Null }
    Set-Item -Path \$BasePath -Value "Abrir con Visual Studio Code"
    New-ItemProperty -Path \$BasePath -Name "Icon" -Value "`"$VSCodePath`",0" -PropertyType String -Force | Out-Null

    CommandPath = "BasePath\command"
    if (-not (Test-Path CommandPath)) New-Item -Path CommandPath -Force | Out-Null }
    Set-Item -Path \$CommandPath -Value "`"$VSCodePath`" `"%V`""

    Write-Host "¡Éxito! La opción se agregó al menú contextual." -ForegroundColor Green
} catch {
    Write-Error "Error al modificar el registro: \$_"
}
