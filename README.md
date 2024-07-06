# Comprehensive Linux System Information Script

This repository contains a bash script that gathers and displays detailed information about a Linux system, including CPU, memory, disk usage, and system details. The script includes error handling and converts memory sizes to a human-readable format. Ideal for system administrators and developers needing quick insights into their Linux environment.

## Features

- Displays system information (OS, kernel version, architecture)
- Provides detailed CPU information
- Shows memory usage and detailed memory statistics
- Reports disk usage
- Error handling for missing commands
- Converts memory sizes to human-readable formats (GB, MB, kB)

## Requirements

- Bash shell
- Basic Unix commands: `lscpu`, `free`, `df`, `lsb_release`, `awk`, `grep`

## Usage

1. Clone the repository:

    ```bash
    git clone https://github.com/yourusername/linux-system-info.git
    cd linux-system-info
    ```

2. Make the script executable:

    ```bash
    chmod +x main.sh
    ```

3. Run the script:

    ```bash
    ./main.sh
    ```
