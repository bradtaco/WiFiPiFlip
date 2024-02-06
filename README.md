# WiFiPiFlip

WiFiPiFlip enables Raspberry Pi users to effortlessly toggle their device's wireless interface between monitor and managed modes. Designed for WiFi penetration testing, network analysis, and educational projects, it combines simplicity with efficiency, suitable for both beginners and experienced users.

## Features

- **Easy Mode Switching**: Quickly switch between monitor mode for packet capturing and managed mode for network connectivity.
- **User-Friendly Interface**: Simple prompts and a menu make it easy to manage your Pi's WiFi settings.
- **Versatile Utility**: Perfect for security assessments, educational purposes, and network troubleshooting.
- **Seamless Integration**: Minimal setup required, letting you focus on your projects.

## Prerequisites

Before starting, ensure your Raspberry Pi has:
- WiFi capabilities (e.g., Raspberry Pi 3/4, Zero W).
- A recent version of Raspberry Pi OS or any compatible Linux distribution.
- NetworkManager for managing network connections.

## Installation

1. Clone the Repository:
   ```bash
   git clone https://github.com/bradtaco/WiFiPiFlip.git
   ```
   
2. Make the Script Executable:
   ```bash
   cd WiFiPiFlip
   chmod +x WiFiPiFlip.sh
   ```
   
## Usage

Execute the script in the terminal:
  ```bash
  ./WiFiPiFlip.sh
  ```

Follow the on-screen prompts to switch between modes. The script guesses your WiFi SSID and interface but allows manual input if needed.

## Contributing

Contributions are welcome! For feature suggestions, bug reports, or code contributions, please open an issue or pull request on GitHub.

## License
WiFiPiFlip is released under the GPL v3 License. See the LICENSE file for details.
