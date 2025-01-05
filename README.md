# Network Ping Script

This script scans the local network for live devices by pinging IP addresses in a `/24` subnet (from `1` to `254`). It supports both parallel and sequential pings using either `fping` or `ping`, depending on the available tools.

The script automatically detects the operating system (Linux, macOS, or Windows) and adapts accordingly to retrieve the local IP address and netmask. It then calculates the network range and proceeds to ping each IP address to check if it is live.

## Prerequisites

- The script requires Python 3 to calculate the network range (CIDR format).
- If `fping` is installed, it will be used for parallel pings. Otherwise, it will fall back to using the standard `ping` command for sequential pings.

### Installing Dependencies

#### Install Python 3

If Python 3 is not installed, it can be installed using the following commands:

- **Linux**:

  ```bash
  sudo apt install python3

    macOS:

    Download and install Python from python.org.

    Windows:

    Download and install Python from python.org.

Install fping (optional, for parallel pinging)

If you want to use fping for parallel pings, you can install it using:

    Linux:

sudo apt install fping

On other Linux distributions, you may use the appropriate package manager.

macOS:

You can install fping via Homebrew:

    brew install fping

    Windows:

    Download fping from fping.org.

If fping is not installed, the script will automatically fall back to using ping.
Usage

    Make the script executable:

    Ensure the script has executable permissions by running:

chmod +x network_ping_script.sh

Run the script:

Execute the script by running:

    ./network_ping_script.sh

    Script Behavior:
        The script first checks if python3 and fping (if available) are installed.
        It detects the operating system and uses the appropriate command to get the local IP address and netmask.
        The script calculates the network prefix and generates a list of IP addresses (from .1 to .254 in the same subnet).
        It pings each IP address to check if it is live:
            If fping is available, the script pings IPs in parallel.
            If fping is not available, the script falls back to sequential ping calls.
        Live IP addresses will be displayed as output.

Example Output

Pinging devices in the network 192.168.1.0...
Live IP: 192.168.1.1
Live IP: 192.168.1.10
Live IP: 192.168.1.50

Script Details

    Dependencies:
        python3 for calculating the network range.
        fping for parallel pinging (optional, defaults to ping if not installed).
        The script works on Linux, macOS, and Windows (via PowerShell).

    Network Range: The script pings IPs from 1 to 254 in the same subnet (/24). You can modify the start and end variables to adjust the range for different subnets.

    OS Detection: The script automatically detects Linux, macOS, or Windows and uses the appropriate method to get the local IP address and netmask.

Troubleshooting

    Python 3 Not Found: If Python 3 is not installed, you will need to install it. Check the instructions above for installing Python.

    fping Not Found: If fping is not installed, the script will fall back to using the ping command. You can still use the script, but it will perform slower, sequential pings.

    No IP Address or Netmask: If the script is unable to retrieve the IP address or netmask, ensure that your network interface is configured correctly, and that you have the necessary permissions to execute the script.

License

This script is provided "as-is" and is free to modify and distribute under your own terms.


This `README.md` provides clear documentation about the script's installation, usage, and behavior, as well as troubleshooting tips. It assumes the script can be run on Linux, macOS, and Windows with some dependencies like `python3` and `fping`. Feel free to customize it according to your needs.
