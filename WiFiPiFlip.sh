#!/bin/bash

# WiFiPiFlip Utility Script
# Author: Brad Dougherty

# Attempt to guess the WiFi interface (usually wlan0, but let's find the first wireless interface)
WIFI_INTERFACE=$(iw dev | awk '$1=="Interface"{print $2}' | head -n 1)

# Attempt to guess the SSID using nmcli (requires NetworkManager)
WIFI_SSID=$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d':' -f2)

# Ask the user to confirm or input the WiFi details
echo "Detected wireless interface: $WIFI_INTERFACE"
read -p "Enter wireless interface [$WIFI_INTERFACE]: " input_interface
WIFI_INTERFACE=${input_interface:-$WIFI_INTERFACE}

echo "Detected SSID: $WIFI_SSID"
read -p "Enter SSID [$WIFI_SSID]: " input_ssid
WIFI_SSID=${input_ssid:-$WIFI_SSID}

read -s -p "Enter WiFi Password: " WIFI_PASSWORD
echo

# Function to enable monitor mode
enable_monitor_mode() {
    echo "Bringing down $WIFI_INTERFACE..."
    sudo ip link set $WIFI_INTERFACE down
    echo "Setting $WIFI_INTERFACE to monitor mode..."
    sudo iw $WIFI_INTERFACE set monitor none
    echo "Bringing up $WIFI_INTERFACE..."
    sudo ip link set $WIFI_INTERFACE up
    echo "$WIFI_INTERFACE is now in monitor mode."
}

# Function to switch back to managed mode and attempt to reconnect to WiFi
reconnect_wifi() {
    echo "Switching $WIFI_INTERFACE back to managed mode..."
    sudo ip link set $WIFI_INTERFACE down
    sudo iw $WIFI_INTERFACE set type managed
    sudo ip link set $WIFI_INTERFACE up
    # Attempt to reconnect using NetworkManager for simplicity
    nmcli d wifi connect "$WIFI_SSID" password "$WIFI_PASSWORD"
    echo "Attempting to reconnect to $WIFI_SSID..."
}

# Main menu function
show_menu() {
    echo "Please select an option:"
    echo "1) Enable monitor mode"
    echo "2) Reconnect to WiFi (managed mode)"
    echo "3) Exit"
    read -p "Selection: " choice

    case $choice in
        1) enable_monitor_mode ;;
        2) reconnect_wifi ;;
        3) echo "Exiting."; exit 0 ;;
        *) echo "Invalid selection." ;;
    esac
}

# Loop the menu
while true; do
    show_menu
done
