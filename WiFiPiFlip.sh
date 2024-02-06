#!/bin/bash

# WiFiPiFlip Utility Script
# Author: Brad Dougherty

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required tools and provide installation instructions if missing
if ! command_exists iw; then
    echo "Error: iw is not installed. Please install iw using 'sudo apt-get install iw'."
    exit 1
fi

if ! command_exists nmcli; then
    echo "Error: NetworkManager's nmcli is not installed. Please install network-manager using 'sudo apt-get install network-manager'."
    exit 1
fi

# Function to check and display the WiFi mode
check_wifi_mode() {
    local mode=$(iw dev $WIFI_INTERFACE info | grep 'type' | awk '{print $2}')
    if [ -z "$mode" ]; then
        echo "Unable to determine the current mode of $WIFI_INTERFACE."
    else
        echo "Current mode of $WIFI_INTERFACE: $mode"
    fi
}

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
    # Request SSID and WiFi Password when needed
    echo "Detected wireless interface: $WIFI_INTERFACE"
    read -p "Enter SSID for reconnection: " WIFI_SSID
    read -s -p "Enter WiFi Password: " WIFI_PASSWORD
    echo

    echo "Switching $WIFI_INTERFACE back to managed mode..."
    sudo ip link set $WIFI_INTERFACE down
    sudo iw $WIFI_INTERFACE set type managed
    sudo ip link set $WIFI_INTERFACE up
    echo "Attempting to reconnect to WiFi..."
    nmcli d wifi connect "$WIFI_SSID" password "$WIFI_PASSWORD"
    echo "Reconnected to $WIFI_SSID in managed mode."
}

# Main menu function
show_menu() {
    # Display current WiFi status
    check_wifi_mode
    echo "Please select an option:"
    echo "1) Enable monitor mode"
    echo "2) Reconnect to WiFi (managed mode)"
    echo "3) Exit"
    read -p "Selection: " choice

    case $choice in
        1) enable_monitor_mode ;;
        2) 
            # Initial setup to guess WiFi interface
            WIFI_INTERFACE=$(iw dev | awk '$1=="Interface"{print $2}' | head -n 1)
            reconnect_wifi ;;
        3) echo "Exiting."; exit 0 ;;
        *) echo "Invalid selection." ;;
    esac
}

# Loop the menu
while true; do
    show_menu
done
