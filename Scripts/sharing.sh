#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  zenity --error --text "Este script debe ser ejecutado como root"
  exit 1
fi

if ! [ -x "$(command -v smbd)" ]; then
  echo "Samba no está instalado, instalando..."
  sudo apt-get update
  sudo apt-get install -y samba
fi
# Mostrar cuadro de diálogo para introducir el nombre de usuario
username=$(zenity --entry --title="Introduzca el nombre de usuario" --text="Por favor, introduzca el nombre de usuario autorizado para acceder al directorio compartido:")

# Verificar si se introdujo un nombre de usuario
if [[ -z $username ]]; then
    zenity --error --title="Error" --text="Debe introducir un nombre de usuario para acceder al directorio compartido."
    exit 1
fi
# Mostrar el explorador de archivos
file=$(zenity --file-selection --title="Seleccionar archivo para compartir")

# Verificar si el usuario ha seleccionado algún archivo
if [ -n "$file" ]; then

  # Obtener el nombre del archivo sin la ruta
  filename=$(basename "$file")

  # Cambiar el nombre del directorio compartido al del archivo seleccionado
  SHARED_DIR="${filename%.*}_$(date '+%Y-%m-%d_%H:%M:%S')"
  SHARED_DIR_PATH="/home/$SHARED_DIR"

  # Verificar si el directorio ya existe
  if [ -d "$SHARED_DIR_PATH" ]; then
    zenity --error --text="El directorio $SHARED_DIR_PATH ya existe"
    exit 1
  fi

  # Crear el directorio
  mkdir -p "$SHARED_DIR_PATH"
  
  # Mover el archivo seleccionado al directorio compartido
  mv "$file" "$SHARED_DIR_PATH/$filename"

  # Asignar permisos al directorio
  sudo chown nobody:nogroup "$SHARED_DIR_PATH"
  sudo chmod 777 "$SHARED_DIR_PATH"

  # Configurar Samba para permitir el acceso al archivo indicado
  sudo tee /etc/samba/smb.conf > /dev/null << EOF
[global]
  workgroup = MYGROUP
  security = user
[$filename]
  comment = Archivo compartido
  path = $SHARED_DIR_PATH
  valid users = $username
  force group = users
  create mask = 0660
  directory mask = 0771
  read only = no
  browsable = yes
EOF

  # Reiniciar Samba
  sudo service smbd restart

  # Mostrar la dirección IP de la máquina virtual
  ip=$(hostname -I)

  # Mostrar el mensaje de éxito
  zenity --info --text="El archivo $filename se ha compartido correctamente. Acceda a él en su máquina anfitriona utilizando la siguiente dirección:\\n \\$ip\\$filename"
else
  # Mostrar un mensaje de error
  zenity --error --text="No se ha seleccionado ningún archivo para compartir"
fi
