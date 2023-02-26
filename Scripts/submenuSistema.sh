#!/bin/bash

# Configurar variables de Zenity
TITLE="Menú personalizado"
TEXT="Selecciona una opción:"
WIDTH=700
HEIGHT=500
BUTTON_CANCEL="Cancelar"
MENU_ITEMS=("Compartir directorio o archivos" "Limpiador de archivos (borrar archivos antiguos o innecesarios)" "Gestión de usuarios" "Informacion del sistema")

# Bucle hasta que el usuario seleccione una opción o presione "Cancelar"
MENU_SELECTION=$(zenity --list --title="$TITLE" --text="$TEXT" --width=$WIDTH --height=$HEIGHT --column="Menú" "${MENU_ITEMS[@]}" --cancel-label=$BUTTON_CANCEL)

# Verificar si se seleccionó una opción o se canceló el menú
if [[ -n "$MENU_SELECTION" ]]; then
    # Ejecutar el script correspondiente a la opción seleccionada
    case "$MENU_SELECTION" in
        "Compartir directorio o archivos")
            ./sharing.sh
            ;;
        "Limpiador de archivos antiguos o innecesarios")
            ./cleaning.sh
            ;;
        "Gestión de usuarios")
		 ./usersManagement.sh
            ;;
    "Informacion del sistema")
	    ./systemInfo.sh
	    ;;
    esac
fi
