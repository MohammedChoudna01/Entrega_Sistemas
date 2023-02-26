#!/bin/bash

# Definir variables
TITLE="Menú principal"
TEXT="Seleccione una opción:"
WIDTH=400
HEIGHT=300
BUTTON_CANCEL="Cancelar"
OPTIONS=("Prueba de velocidad" "Informacion de red")


# Mostrar el menú
for OPTION in "${OPTIONS[@]}"
do
    MENU_ITEMS+=("$OPTION")
done

MENU_SELECTION=$(zenity --list --title="$TITLE" --text="$TEXT" --width=$WIDTH --height=$HEIGHT --column="Menú" "${MENU_ITEMS[@]}" --cancel-label=$BUTTON_CANCEL)
# Verificar si se seleccionó una opción o se canceló el menú
if [[ -n "$MENU_SELECTION" ]]; then
    # Ejecutar el script correspondiente a la opción seleccionada
    case "$MENU_SELECTION" in
        "Prueba de velocidad")
            ./pruebaRendimiento.sh
            ;;
        "Informacion de red")
            ./networkInfo.sh
            ;;
      
    esac
fi

                      
