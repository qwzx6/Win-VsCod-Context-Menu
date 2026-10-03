<#
.SYNOPSIS
    Instalación universal local de "Abrir con VS Code".
#>

# 1. Buscar automáticamente VS Code en la computadora del usuario
VSCodePath = "env:LocalAppData\Programs\Microsoft VS Code\Code.exe"

if (-not (Test-Path \$VSCodePath)) {
    VSCodePath = "env:ProgramFiles\Microsoft VS Code\Code.exe"
    if (-not (Test-Path \$VSCodePath)) {
        VSCodePath = "{env:ProgramFiles(x86)}\Microsoft VS Code\Code.exe"
        if (-not (Test-Path \$VSCodePath)) {
            Write-Error "No se encontró Visual Studio Code instalado en este equipo."
            Exit
        }
    }
}

# 2. Detectar si el usuario lo abrió normal o como Administrador
\$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (\$IsAdmin) {
    Write-Host "Instalando de forma global en el sistema..." -ForegroundColor Green
    \$Paths = @(
        "Registry::HKEY_CLASSES_ROOT\AllFilesystemObjects\shell\VSCodeOpen",
        "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\VSCodeOpen"
    )
} else {
    Write-Host "Instalando de forma local para tu usuario actual..." -ForegroundColor Cyan
    \$Paths = @(
        "Registry::HKEY_CURRENT_USER\Software\Classes\AllFilesystemObjects\shell\VSCodeOpen",
        "Registry::HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\VSCodeOpen"
    )
}

# 3. Crear las opciones en el menú del clic derecho
try {
    foreach (BasePath in Paths) {
        if (-not (Test-Path BasePath)) New-Item -Path BasePath -Force | Out-Null }
        Set-Item -Path \$BasePath -Value "Abrir con Visual Studio Code"
        New-ItemProperty -Path \$BasePath -Name "Icon" -Value "`"$VSCodePath`",0" -PropertyType String -Force | Out-Null

        CommandPath = "BasePath\command"
        if (-not (Test-Path CommandPath)) New-Item -Path CommandPath -Force | Out-Null }
        
        if (\$BasePath -like "*Background*") {
            Set-Item -Path \$CommandPath -Value "`"$VSCodePath`" `"%V`""
        } else {
            Set-Item -Path \$CommandPath -Value "`"$VSCodePath`" `"%1`""
        }
    }
    Write-Host "¡Éxito! La opción se agregó correctamente para todos los archivos, carpetas y fondos." -ForegroundColor Green
} catch {
    Write-Error "Error al modificar el registro de Windows: \$_"
}
