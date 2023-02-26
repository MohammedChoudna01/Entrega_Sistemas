#!/bin/bash
email="$1"
email1="$2"
password="$3"


if [ ! -f ~/.cpulimitusage.conf ]; then
    # Si no existe, pedir al usuario el límite de capacidad
    LIMIT=$(zenity --entry --text "Introduce el límite de uso del CPU al que al superarlo salte el correo de alarma  en porcentaje (SIN %): ")
    # Guardar el límite en el archivo de configuración
    echo "${LIMIT}" > ~/.cpulimitusage.conf
else
    # Si el archivo de configuración existe, leer el límite de capacidad
    LIMIT=$(cat ~/.cpulimitusage.conf)
fi


# Obtener el porcentaje de uso de CPU del sistema
USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
echo "En este momento se esta usabdo : $USAGE% de la CPU"
# Comprobar si el uso de CPU supera el límite definido
if [ "${USAGE}" > "${LIMIT}" ]; then
    # Si el uso de CPU supera el límite, enviar un correo electrónico de alerta
    ../mailWithArgs.sh "Alerta de alto uso de CPU" "El uso de CPU ha superado(${USAGE}%) el límite del ${LIMIT}%. Por favor, revise el sistema." "$email" "$email1" "$password"
fi
# Si el usuario quiere eliminar el archivo de configuración, preguntar y eliminar
if zenity --question --title="Eliminar archivo de configuración" --text="¿Deseas eliminar el archivo de configuración para volver a preguntar por el límite de uso de la CPU?" 2> /dev/null; then
    rm -f ~/.cpulimitusage.conf
fi
