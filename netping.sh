#!/bin/bash

#set -x # Enable debug mode for tracing commands
#set -v # Enable verbose mode for tracing commands
#set -e # Exit immediately if a command exits with a non-zero status

# Ensure required commands are installed
if ! command -v python3 &>/dev/null; then
  echo "Command python3 not found, but can be installed with:"
  echo "sudo apt install python3 on Linux or download and install on Mac and Windows."
  echo "Please ask your administrator."
  echo "Exiting..."
  exit 1
fi

# Check if fping is installed
if ! command -v fping &>/dev/null; then
  echo "Command fping not found, but can be installed with:"
  echo "sudo apt install fping"
  echo "Please ask your administrator."
  echo "Using 'ping' instead for sequential pings."
  use_fping=false
else
  use_fping=true
fi

# Check the OS type (Windows, Linux, or macOS)
OS_TYPE=$(uname -s)

if [[ "$OS_TYPE" == "Darwin" || "$OS_TYPE" == "Linux" ]]; then
  # Linux/macOS: Use ip or ifconfig to fetch IP and netmask
  if command -v ip &>/dev/null; then
    ip_addr=$(ip addr show | grep inet | grep -v inet6 | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1 | head -n 1)
    netmask=$(ip addr show | grep inet | grep -v inet6 | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f2 | head -n 1)
  elif command -v ifconfig &>/dev/null; then
    ip_addr=$(ifconfig | grep inet | grep -v 127.0.0.1 | awk '{print $2}' | head -n 1)
    netmask=$(ifconfig | grep inet | grep -v 127.0.0.1 | awk '{print $4}' | head -n 1)
  else
    echo "Neither 'ip' nor 'ifconfig' found. Exiting."
    exit 1
  fi
elif [[ "$OS_TYPE" == "CYGWIN"* || "$OS_TYPE" == "MINGW"* || "$OS_TYPE" == "MSYS"* ]]; then
  # Windows: Use PowerShell to fetch IP and netmask
  ip_addr=$(powershell -Command "(Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.PrefixLength -eq 24 }).IPAddress")
  netmask="255.255.255.0"  # Assume default /24 for simplicity
else
  echo "Unsupported OS. Exiting."
  exit 1
fi

# Check if IP address and netmask were retrieved
if [ -z "$ip_addr" ] || [ -z "$netmask" ]; then
  echo "Unable to determine local IP address or netmask. Exiting."
  exit 1
fi

# Use Python to calculate the network range (CIDR format)
network_prefix=$(python3 -c "
import ipaddress
network = ipaddress.IPv4Network('$ip_addr/$netmask', strict=False)
print(network.network_address)
")

# Extract the first 3 octets for the network base (e.g., 192.168.1)
network_base=$(echo $network_prefix | cut -d'.' -f1-3)

# Loop through the range 1-254 for a /24 subnet (can be adjusted for other subnets)
start=1
end=254

echo "Pinging devices in the network $network_prefix..."

# If fping is available, use it for parallel pinging; otherwise, fall back to ping
if [ "$use_fping" = true ]; then
  # Generate the list of IP addresses to ping
  ip_list=""
  for i in $(seq $start $end); do
    ip="$network_base.$i"
    ip_list="$ip_list $ip"
  done

  # Use fping to ping all IPs in parallel (default timeout 1000ms)
  fping -a -g $ip_list
else
  # Ping each IP sequentially using ping
  for i in $(seq $start $end); do
    ip="$network_base.$i"
  
    # Ping the IP address and check if it's live
    if ping -c 1 -W 1 $ip &>/dev/null; then
      echo "Live IP: $ip"  # Print live IPs only
    fi
  done
fi

