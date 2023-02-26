#!/bin/bash
email="$1"
email1="$2"
password="$3"
# Comprobar si el archivo de configuración existe
if [ ! -f ~/.disklimitusage.conf ]; then
    # Si no existe, pedir al usuario el límite de capacidad
    LIMIT_PERCENT=$(zenity --entry --text "Introduce el límite de capacidad de almacenamineto al superarlo salte la alarma en porcentaje (SIN %): ")
    # Guardar el límite en el archivo de configuración
    echo "${LIMIT_PERCENT}" > ~/.disklimitusage.conf
else
    # Si el archivo de configuración existe, leer el límite de capacidad
    LIMIT_PERCENT=$(cat ~/.disklimitusage.conf)
fi
# Obtener el porcentaje de capacidad ocupada del disco
USED_PERCENT=$(df --output=pcent / | tail -1 | tr -dc '0-9')
echo "PORCENTAJE DE MEMORIA USADO : $USED_PERCENT al superarlo salte la alarma"


# Comprobar si el porcentaje de capacidad ocupada es mayor que el límite definido
if [ "${USED_PERCENT}" -gt "${LIMIT_PERCENT}" ]; then
    # Si la capacidad ocupada es mayor que el límite, enviar un correo electrónico de alerta
    ../mailWithArgs.sh "Alerta de almacenamiento" "La capacidad ocupada del disco es del ${USED_PERCENT}%. Este valor está por encima del límite del ${LIMIT_PERCENT}%. Por favor, libere espacio en disco." "$email" "$email1" "$password"
fi
# Si el usuario quiere eliminar el archivo de configuración, preguntar y eliminar
if zenity --question --title="Eliminar archivo de configuración" --text="¿Deseas eliminar el archivo de configuración para volver a preguntar por el límite de almacenamiento autorizado?" 2> /dev/null; then
    rm -f ~/.disklimitusage.conf
fi
