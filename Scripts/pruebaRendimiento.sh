#!/bin/bash
if ! command -v speedtest-cli &> /dev/null
then
    echo "speedtest-cli no está instalado. Instalando..."
    sudo apt-get install speedtest-cli -y
fi

if command -v speedtest-cli &> /dev/null
then
    # Si está instalado, ejecutar el comando
    echo "Ejecutando speedtest-cli..."
    speedtest-cli  
fi    
