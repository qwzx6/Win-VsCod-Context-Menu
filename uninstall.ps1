<#
.SYNOPSIS
    Desinstalación online de "Abrir con VS Code" del menú contextual.
.LICENSE
    MIT License
#>

$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($IsAdmin) {
    Write-Host "Buscando en la configuración global (Administrador)..." -ForegroundColor Green
    $BasePath = "Registry::HKEY_CLASSES_ROOT\Directory\shell\VSCodeOpen"
} else {
    Write-Host "Buscando en la configuración local (Usuario estándar)..." -ForegroundColor Cyan
    $BasePath = "Registry::HKEY_CURRENT_USER\Software\Classes\Directory\shell\VSCodeOpen"
}

if (Test-Path $BasePath) {
    try {
        # Elimina la clave y todas sus subclaves (como 'command')
        Remove-Item -Path $BasePath -Recurse -Force
        Write-Host "¡Éxito! La opción 'Abrir con Visual Studio Code' ha sido eliminada." -ForegroundColor Green
    } catch {
        Write-Error "No se pudo eliminar la clave del registro: $_"
    }
} else {
    Write-Host "No se encontró la opción en el registro. Ya está desinstalado o se instaló con otros privilegios." -ForegroundColor Yellow
}
