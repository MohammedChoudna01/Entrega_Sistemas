#!/usr/bin/bash

echo "Obteniendo información del sistema..."

# Verificar si el comando inxi está instalado, si no lo está, instalarlo
if ! command -v inxi &> /dev/null
then
    echo "El paquete inxi no está instalado, instalando..."
    sudo apt-get install -y inxi
fi
./screenFetch
# Mostrar información del procesador
echo -e "\n=== Información del procesador ===\n"
inxi -C

# Mostrar información de la memoria
echo -e "\n=== Información de la memoria ===\n"
free
# Mostrar información de la versión del sistema operativo
echo -e "\n== Versión del sistema operativo ==\n"
lsb_release -a

# Mostrar información de la versión del kernel
echo -e "\n== Versión del kernel ==\n"
uname -r

# Mostrar información de la dirección IP
echo -e "\n== Dirección IP ==\n"
ifconfig


