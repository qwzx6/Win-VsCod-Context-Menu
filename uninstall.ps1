<#
.SYNOPSIS
    Desinstalación local completa de las entradas de VS Code.
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
            Write-Host "Eliminado: $BasePath" -ForegroundColor Green
        } catch {
            Write-Error "No se pudo eliminar: $BasePath"
        }
    }
}
Write-Host "Menú contextual limpio y restaurado al estado original." -ForegroundColor Yellow
