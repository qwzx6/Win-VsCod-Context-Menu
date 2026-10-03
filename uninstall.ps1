<#
.SYNOPSIS
    Desinstalación completa de las entradas universales de VS Code en el menú contextual.
#>

$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($IsAdmin) {
    $Paths = @(
        "Registry::HKEY_CLASSES_ROOT\AllFilesystemObjects\shell\VSCodeOpen",
        "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\VSCodeOpen"
    )
} else {
    $Paths = @(
        "Registry::HKEY_CURRENT_USER\Software\Classes\AllFilesystemObjects\shell\VSCodeOpen",
        "Registry::HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\VSCodeOpen"
    )
}

foreach ($BasePath in $Paths) {
    if (Test-Path $BasePath) {
        try {
            Remove-Item -Path $BasePath -Recurse -Force
            Write-Host "Eliminado correctamente: $BasePath" -ForegroundColor Green
        } catch {
            Write-Error "No se pudo eliminar: $BasePath"
        }
    }
}
Write-Host "Menú contextual restaurado al estado original del sistema." -ForegroundColor Yellow
