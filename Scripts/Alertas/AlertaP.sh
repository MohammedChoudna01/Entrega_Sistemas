#!/bin/bash
# Instalar curl si no está instalado
if ! command -v curl &> /dev/null
then
    echo "curl no está instalado. Instalando..."
    sudo apt-get update
    sudo apt-get install curl -y
fi

# Instalar file si no está instalado
if ! command -v file &> /dev/null
then
    echo "file no está instalado. Instalando..."
    sudo apt-get update
    sudo apt-get install file -y
fi

# Comprobar si el archivo de configuración existe
if [ ! -f ~/.correo.conf ]; then
   
    # Pedir al usuario las direcciones de correo electrónico y la ruta a gapp
    sender=$(zenity --entry --text "Introduce la dirección de correo electrónico del remitente:")
    receiver=$(zenity --entry --text "Introduce la dirección de correo electrónico del destinatario:")
    gapp=$(zenity --entry --text "Introduce la clave de acceso :")


    # Comprobar si alguna de las variables está vacía
if [ -z "$sender" ] || [ -z "$receiver" ] || [ -z "$gapp" ]
then
    # Mostrar mensaje de error con Zenity
    zenity --error --text="Una o más variables están vacías. Por favor, asegúrate de que todas las variables están definidas antes de ejecutar el script."
    exit 1
fi
    # Guardar  las variables en el archivo de configuración

    echo "sender=${sender}" >> ~/.correo.conf
    echo "receiver=${receiver}" >> ~/.correo.conf
    echo "gapp=${gapp}" >> ~/.correo.conf
else
    # Si el archivo de configuración existe, cargar las variables
    source ~/.correo.conf
fi
./alertaMim.sh "$sender" "$receiver" "$gapp"
./alertaCPU.sh "$sender" "$receiver" "$gapp"
./alertaRAM.sh "$sender" "$receiver" "$gapp"




# Si el usuario quiere eliminar el archivo de configuración, preguntar y eliminar
if zenity --question --title="Eliminar archivo de configuración" --text="¿Deseas eliminar el archivo de configuración para volver a preguntar por los datos de envio(Se pedira tambien la clave de acceso) ?" 2> /dev/null; then
    rm -f ~/.correo.conf
fi

