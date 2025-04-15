#!/bin/bash
echo "🖼️ GPU Info:"
lspci | grep -i --color 'vga\|3d\|2d'
