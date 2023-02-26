#!/bin/bash

# Comprobar si se está ejecutando como root
if [ "$EUID" -ne 0 ]
then 
    echo "Este script debe ser ejecutado como root. Por favor, inténtalo de nuevo con sudo."
    exit
fi

# Actualizar lista de paquetes e instalar herramientas de red
echo "Actualizando lista de paquetes e instalando herramientas de red..."
apt-get update
apt-get install -y nmap whois dnsutils
echo "Paquetes instalados con éxito."

# Información sobre la red
echo -e "\033[31mInformación sobre la red:\033[0m"
echo ""

# Mostrar información de la interfaz de red
echo -e "\033[31mInformación de la interfaz de red:\033[0m"
echo "---------------------------------"
ip addr show
echo ""

# Mostrar la tabla de enrutamiento
echo -e "\033[31mTable de enrutamiento:\033[0m"

echo "----------------------"
ip route
echo ""

# Escanear la red en busca de dispositivos
echo -e "\033[31mDispositivos encontrados:\033[0m"

echo "-----------------------"
ip=$(ip route get 1 | grep -oP 'src \K\S+')
nmap -sn $ip/24 # Escanea la red local a la que pertenece la IP de la máquina
echo ""

# Mostrar información del firewall
echo -e "\033[31mInformación del firewall:\033[0m"

echo "---------------------------"
iptables -L -n
echo ""

# Sugerir comandos adicionales
echo ""
echo "Para obtener más información, prueba los siguientes comandos:"
echo "- 'netstat -tulpn': muestra las conexiones de red activas y los programas que las utilizan."
echo "- 'arp -a': muestra la tabla ARP de la red."
echo "- 'ifconfig': muestra información detallada sobre la interfaz de red."
echo "- 'traceroute <dirección_IP>': muestra la ruta que sigue un paquete desde tu máquina hasta la dirección IP especificada."

