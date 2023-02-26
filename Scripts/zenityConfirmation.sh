#!/bin/bash

# Comprobar si Zenity está instalado
if command -v zenity &> /dev/null; then
  echo "Zenity ya está instalado en el sistema."
else
  echo "Zenity no está instalado en el sistema. Se procederá a su instalación..."

  # Verificar permisos de administrador antes de instalar Zenity
  if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse con permisos de administrador para instalar Zenity."
    exit 1
  fi

  # Comprobar el gestor de paquetes del sistema e instalar Zenity
  if command -v apt-get &> /dev/null; then
    sudo apt-get update &> /dev/null
    sudo apt-get install -y zenity &> /dev/null &
    while [ -n "$(pgrep -f "apt-get install")" ]; do
      echo "Instalando Zenity..." # Mensaje de progreso
      sleep 1
    done
  elif command -v yum &> /dev/null; then
    sudo yum update &> /dev/null
    sudo yum install -y zenity &> /dev/null &
    while [ -n "$(pgrep -f "yum install")" ]; do
      echo "Instalando Zenity..." # Mensaje de progreso
      sleep 1
    done
  elif command -v pacman &> /dev/null; then
    sudo pacman -Sy &> /dev/null
    sudo pacman -S --noconfirm zenity &> /dev/null &
    while [ -n "$(pgrep -f "pacman -S")" ]; do
      echo "Instalando Zenity..." # Mensaje de progreso
      sleep 1
    done
  else
    echo "No se pudo encontrar un gestor de paquetes compatible en el sistema para instalar Zenity."
    exit 1
  fi

  # Comprobar si Zenity se instaló correctamente
  if command -v zenity &> /dev/null; then
    echo "Zenity se ha instalado correctamente."
  else
    echo "Ocurrió un error al instalar Zenity."
    exit 1
  fi
fi

