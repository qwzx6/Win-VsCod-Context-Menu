<#
.SYNOPSIS
    Instalación online de "Abrir con VS Code" para absolutamente todos los formatos de archivos,
    música, videos, imágenes, carpetas y fondos de pantalla en Windows.
.LICENSE
    MIT License
#>

VSCodePath = "env:LocalAppData\Programs\Microsoft VS Code\Code.exe"

if (-not (Test-Path \$VSCodePath)) {
    VSCodePath = "env:ProgramFiles\Microsoft VS Code\Code.exe"
    if (-not (Test-Path \$VSCodePath)) {
        Write-Error "No se encontró Visual Studio Code en las rutas por defecto."
        Exit
    }
}

\$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Configurar las rutas del registro globales o locales según los privilegios
if (\$IsAdmin) {
    Write-Host "Instalación universal global (Administrador)..." -ForegroundColor Green
    \$Paths = @(
        "Registry::HKEY_CLASSES_ROOT\AllFilesystemObjects\shell\VSCodeOpen",
        "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\VSCodeOpen"
    )
} else {
    Write-Host "Instalación universal local (Usuario estándar)..." -ForegroundColor Cyan
    \$Paths = @(
        "Registry::HKEY_CURRENT_USER\Software\Classes\AllFilesystemObjects\shell\VSCodeOpen",
        "Registry::HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\VSCodeOpen"
    )
}

try {
    foreach (BasePath in Paths) {
        if (-not (Test-Path BasePath)) New-Item -Path BasePath -Force | Out-Null }
        Set-Item -Path \$BasePath -Value "Abrir con Visual Studio Code"
        New-ItemProperty -Path \$BasePath -Name "Icon" -Value "`"$VSCodePath`",0" -PropertyType String -Force | Out-Null

        CommandPath = "BasePath\command"
        if (-not (Test-Path CommandPath)) New-Item -Path CommandPath -Force | Out-Null }
        
        # Ajustar el parámetro según si es el fondo de una carpeta o un archivo/directorio
        if (\$BasePath -like "*Background*") {
            Set-Item -Path \$CommandPath -Value "`"$VSCodePath`" `"%V`""
        } else {
            Set-Item -Path \$CommandPath -Value "`"$VSCodePath`" `"%1`""
        }
    }
    Write-Host "¡Éxito! VS Code se ha vinculado a TODOS los formatos de archivos (música, videos, imágenes, código), carpetas y fondos." -ForegroundColor Green
} catch {
    Write-Error "Error al modificar el registro: \$_"
}
