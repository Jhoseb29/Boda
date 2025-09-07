@echo off
echo Limpiando imágenes no utilizadas...

:: Crear lista de imágenes utilizadas
(
echo images/recuerdos/batman-8-bits-11358.jpg
echo images/recuerdos/Snapchat-721903153.jpg
echo images/recuerdos/nebula-rosa-en-el-espacio-11053.webp
) > imagenes_utilizadas.txt

echo Lista de imágenes utilizadas creada en imagenes_utilizadas.txt
echo.
echo Para completar la limpieza manual:
echo 1. Revisa el archivo imagenes_utilizadas.txt
echo 2. Elimina manualmente cualquier imagen en la carpeta images/recuerdos/ que no esté en la lista

echo.
pause
