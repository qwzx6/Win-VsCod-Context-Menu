# 🚀 VS Code Context Menu Installer (Online)

Un script de PowerShell open source para agregar la opción **"Abrir con Visual Studio Code"** al hacer clic derecho en cualquier carpeta en Windows, ejecutable directamente desde la nube.

## 🛠️ Instalación Rápida (Online)

No necesitas descargar nada. Abre una ventana de **PowerShell** y pega el siguiente comando (reemplaza `TU_USUARIO` y `TU_REPOSITORIO` por tus datos reales de GitHub):

```powershell
irm https://githubusercontent.com | iex
```

### ¿Qué hace este comando?
* `irm` (Invoke-RestMethod): Lee el código del script directamente desde tu GitHub.
* `iex` (Invoke-Expression): Ejecuta el código en la memoria de Windows de forma segura, sin guardar archivos basura en el disco.
* **Auto-adaptable:** Si abres PowerShell normal, se instala solo para ti. Si lo abres como Administrador, se instala para todos los usuarios.
