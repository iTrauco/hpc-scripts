#!/bin/bash
# collect_system_info.sh - System hardware inventory collector

OUTPUT_FILE="system_info_$(hostname)_$(date +%Y%m%d).txt"

{
  echo "��️ SYSTEM OVERVIEW -----------------------------"
  echo "Hostname: $(hostname)"
  echo "Date: $(date)"
  echo "OS: $(lsb_release -d | cut -f2-)"
  echo

  echo "🧬 CPU INFO ------------------------------------"
  lscpu
  echo

  echo "📦 RAM INFO ------------------------------------"
  sudo dmidecode --type 17 | grep -E "Size:|Type:|Speed:" | grep -v "No Module Installed"
  echo

  echo "🏭 SYSTEM IDENTIFICATION ------------------------"
  sudo dmidecode -t system | grep -E "Manufacturer:|Product Name:|Serial Number:"
  echo

  echo "📋 MOTHERBOARD ---------------------------------"
  sudo dmidecode -t baseboard | grep -E "Manufacturer:|Product Name:"
  echo

  echo "🌐 NETWORK INTERFACES --------------------------"
  ip -o link show | awk -F': ' '{print $2}' | while read iface; do
    echo "Interface: $iface"
    ethtool $iface 2>/dev/null | grep -E "Speed|Duplex|Link detected"
    echo
  done

} | tee "$OUTPUT_FILE"
