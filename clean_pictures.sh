#!/bin/bash
zenity --question --text="Delete everything in Pictures?"
if [ $? -eq 0 ]; then
  rm -rf ~/Pictures/*
fi

