#!/bin/bash
to_human() {
    local size_kb=$1
    if ((size_kb >= 1048576)); then
        echo "$(echo "$size_kb / 1048576" | bc -l) GB"
    elif ((size_kb >= 1024)); then
        echo "$(echo "$size_kb / 1024" | bc -l) MB"
    else
        echo "$size_kb kB"
    fi
}
try() {
    "$@" || { echo "Error: Command failed - $*"; exit 1; }
}
check_tools() {
    for cmd in lscpu free df lsb_release awk grep; do
        if ! command -v $cmd &> /dev/null; then
            echo "$cmd not found"
            exit 1
        fi
    done
}
main() {
    check_tools
    echo ""
    echo "------------------- System Info ------------------------"
    echo ""
    try uname -a
    echo "Hostname: $(try hostname)"
    echo "OS: $(try lsb_release -d | awk -F'\t' '{print $2}')"
    echo "Kernel: $(try uname -r)"
    echo "Arch: $(try uname -m)"
    echo ""
    echo "------------------- CPU Information --------------------"
    echo ""
    try lscpu | grep -E 'Model name|Architecture|CPU\(s\)|Thread\(s\) per core|Core\(s\) per socket|Socket\(s\)|CPU MHz|L1d cache|L1i cache|L2 cache|L3 cache'
    echo -e "\nAdditional CPU Details:"
    echo ""
    echo "CPU Model: $(try awk -F: '/model name/ {print $2; exit}' /proc/cpuinfo)"
    echo "CPU Cores: $(try awk -F: '/cpu cores/ {print $2; exit}' /proc/cpuinfo)"
    echo "CPU Threads: $(try grep -c ^processor /proc/cpuinfo)"
    echo "CPU MHz: $(try awk -F: '/cpu MHz/ {print $2; exit}' /proc/cpuinfo)"
    echo "Cache Size: $(try awk -F: '/cache size/ {print $2; exit}' /proc/cpuinfo)"
    echo "BogoMIPS: $(try awk -F: '/bogomips/ {print $2; exit}' /proc/cpuinfo)"
    echo ""
    echo "----------------- Memory Information -------------------"
    echo ""
    try free -h
    echo ""
    echo "----------------- Memory Details -----------------------"
    echo ""
    mem_total=$(try awk '/MemTotal/ {print $2}' /proc/meminfo)
    mem_free=$(try awk '/MemFree/ {print $2}' /proc/meminfo)
    mem_available=$(try awk '/MemAvailable/ {print $2}' /proc/meminfo)
    buffers=$(try awk '/Buffers/ {print $2}' /proc/meminfo)
    cached=$(try awk '/^Cached/ {print $2}' /proc/meminfo)
    swap_total=$(try awk '/SwapTotal/ {print $2}' /proc/meminfo)
    swap_free=$(try awk '/SwapFree/ {print $2}' /proc/meminfo)
    echo "Total Memory: $(to_human $mem_total)"
    echo "Free Memory: $(to_human $mem_free)"
    echo "Available Memory: $(to_human $mem_available)"
    echo "Buffers: $(to_human $buffers)"
    echo "Cached: $(to_human $cached)"
    echo "Total Swap: $(to_human $swap_total)"
    echo "Free Swap: $(to_human $swap_free)"
    echo ""
    echo "------------------- Disk Usage -------------------------"
    echo ""
    try df -h
}
main
