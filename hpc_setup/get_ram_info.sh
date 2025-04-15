#!/bin/bash
echo "🔬 RAM Info:"
sudo dmidecode -t memory | grep -Ei 'Size:|Speed:|Locator|Type:|Manufacturer|Part Number' | grep -v 'No Module Installed'
