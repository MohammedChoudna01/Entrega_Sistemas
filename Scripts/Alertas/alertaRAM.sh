#!/bin/bash
email="$1"
email1="$2"
password="$3"

# Comprobar si el archivo de configuración existe
if [ ! -f ~/.ramlimitusage.conf ]; then
    # Si no existe, pedir al usuario el límite de capacidad
    LIMIT_PERCENT=$(zenity --entry --text "Introduce el límite de USO DE LA MEMORIA RAM  en porcentaje (SIN %): ")
    # Guardar el límite en el archivo de configuración
    echo "${LIMIT_PERCENT}" > ~/.ramlimitusage.conf
else
    # Si el archivo de configuración existe, leer el límite de capacidad
    LIMIT_PERCENT=$(cat ~/.ramlimitusage.conf)
fi


USAGE_PERCENT=$(free | awk '/^Mem/ {print int($3/$2 * 100.0)}')

echo "El uso actual de la RAM $USAGE_PERCENT%."
# Check if the RAM usage exceeds the limit
if ((USAGE_PERCENT > LIMIT_PERCENT)); then
    # Send an email alert
        ../mailWithArgs.sh "Alerta de memoria RAM" "La cantidad usada  del RAM  es de $USAGE_PERCENT%  y está por arriba del límite del $LIMIT_PERCENT%. Por favor, libere espacio en memoria RAM." "$email" "$email1" "$password"
fi
if zenity --question --title="Eliminar archivo de configuración" --text="¿Deseas eliminar el archivo de configuración para volver a preguntar por el límite de uso de la  RAM?" 2> /dev/null; then
    rm -f ~/.ramlimitusage.conf
fi
