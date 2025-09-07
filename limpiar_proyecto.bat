@echo off
echo Limpiando proyecto...

:: 1. Limpiar node_modules y archivos de compilación
echo Eliminando node_modules...
if exist node_modules rmdir /s /q node_modules

echo Eliminando archivos de compilación...
del /s /q *.log

:: 2. Crear estructura de carpetas temporal
mkdir css_temp
mkdir js_temp
mkdir fonts_temp

:: 3. Mover archivos CSS necesarios (según index.html)
echo Copiando archivos CSS necesarios...
if not exist "css" mkdir css

:: Lista de archivos CSS utilizados (según index.html)
set "css_files=bootstrap.min.css jquery.fancybox.css normalize.min.css styles.min.css queries.css flexslider.css"

:: Copiar solo los archivos CSS necesarios
for %%f in (%css_files%) do (
    if exist "css\%%f" (
        echo Copiando %%f
        copy "css\%%f" "css_temp\" >nul
    )
)

:: Identificar archivos CSS no utilizados
echo.
echo Analizando archivos CSS no utilizados...
setlocal enabledelayedexpansion
set "unused_css=0"

for /f "delim=" %%f in ('dir /b /a-d "css\*.css" 2^>nul') do (
    set "file_used=0"
    for %%c in (%css_files%) do (
        if /i "%%~nxf"=="%%~nxc" set "file_used=1"
    )
    if "!file_used!"=="0" (
        echo - %%f (no utilizado)
        set /a "unused_css+=1"
    )
)

if !unused_css! gtr 0 (
    echo.
    echo Se encontraron !unused_css! archivos CSS no utilizados.
    echo Se recomienda revisar si son necesarios antes de eliminarlos.
) else (
    echo No se encontraron archivos CSS no utilizados.
)
endlocal

:: 4. Mover archivos JS necesarios
echo.
echo Copiando archivos JavaScript necesarios...
if not exist "js" mkdir js
if not exist "js\vendor" mkdir "js\vendor"

:: Lista de archivos JS utilizados (según index.html)
set "js_files=jquery.fancybox.pack.js scripts.js vendor\jquery-1.11.2.min.js vendor\modernizr-2.8.3-respond-1.4.2.min.js"

:: Copiar solo los archivos JS necesarios
for %%f in (%js_files%) do (
    if exist "js\%%f" (
        echo Copiando %%f
        if not exist "js_temp\%%~pf" mkdir "js_temp\%%~pf"
        copy "js\%%f" "js_temp\%%~pf" >nul
    )
)

:: Identificar archivos JS no utilizados
echo.
echo Analizando archivos JavaScript no utilizados...
setlocal enabledelayedexpansion
set "unused_js=0"
set "js_file_list="

:: Obtener lista de archivos JS en el directorio
for /f "delim=" %%f in ('dir /b /s /a-d "js\*.js" 2^>nul') do (
    set "file_used=0"
    set "rel_path=%%f"
    set "rel_path=!rel_path:*js\=!"
    
    for %%j in (%js_files%) do (
        if /i "!rel_path!"=="%%j" set "file_used=1"
    )
    
    if "!file_used!"=="0" (
        echo - !rel_path! (no utilizado)
        set /a "unused_js+=1"
        set "js_file_list=!js_file_list! "!rel_path""
    )
)

if !unused_js! gtr 0 (
    echo.
    echo Se encontraron !unused_js! archivos JavaScript no utilizados.
    echo Se recomienda revisar si son necesarios antes de eliminarlos.
    
    echo.
    echo ¿Desea eliminar los archivos JS no utilizados? (S/N)
    set /p "delete_js=Opción: "
    
    if /i "!delete_js!"=="S" (
        for %%f in (!js_file_list!) do (
            if exist "js\%%~f" (
                echo Eliminando %%~f
                del "js\%%~f"
            )
        )
        echo.
        echo Archivos no utilizados eliminados.
    )
) else (
    echo No se encontraron archivos JavaScript no utilizados.
)
endlocal

:: 5. Manejo de fuentes
echo.
echo Gestionando fuentes...

:: Crear directorio de fuentes si no existe
if not exist "fonts_temp" mkdir "fonts_temp"

:: Verificar si hay fuentes locales que necesitemos conservar
set "font_found=0"

:: Buscar fuentes locales que podrían estar en uso
for /f "delim=" %%f in ('dir /b /s /a-d "fonts\*.*" 2^>nul') do (
    set "font_file=%%~nxf"
    set "font_ext=%%~xf"
    
    if /i "!font_ext!"==".ttf" set "font_found=1"
    if /i "!font_ext!"==".otf" set "font_found=1"
    if /i "!font_ext!"==".woff" set "font_found=1"
    if /i "!font_ext!"==".woff2" set "font_found=1"
    if /i "!font_ext!"==".eot" set "font_found=1"
    if /i "!font_ext!"==".svg" set "font_found=1"
)

if "!font_found!"=="1" (
    echo.
    echo ADVERTENCIA: Se encontraron archivos de fuentes locales en la carpeta fonts\
    echo El proyecto utiliza principalmente Google Fonts (Dancing Script, Inter) y Font Awesome.
    echo.
    echo ¿Desea conservar las fuentes locales? (S/N)
    set /p "keep_fonts=Opción: "
    
    if /i "!keep_fonts!"=="S" (
        echo Copiando fuentes locales a la carpeta temporal...
        xcopy /E /I /Y "fonts\*.*" "fonts_temp\"
    ) else (
        echo No se copiarán las fuentes locales.
    )
) else (
    echo No se encontraron fuentes locales para copiar.
)

:: 6. Eliminar carpetas antiguas
echo Eliminando carpetas antiguas...
if exist css rmdir /s /q css
if exist js rmdir /s /q js
if exist fonts rmdir /s /q fonts
if exist sass rmdir /s /q sass

:: 7. Renombrar carpetas temporales
echo Reconstruyendo estructura...
ren css_temp css
ren js_temp js
if exist fonts_temp ren fonts_temp fonts

:: 8. Limpiar archivos innecesarios
del /q *.sublime-*
del /q .DS_Store 2>nul
del /q Thumbs.db 2>nul

echo.
echo ===================================
echo Limpieza completada exitosamente!
echo ===================================
echo.
echo Archivos y carpetas eliminados:
echo - node_modules
echo - Archivos de compilación (*.log)
echo - Carpetas innecesarias

echo.
echo Estructura final del proyecto:
tree /F /A

echo.
pause
