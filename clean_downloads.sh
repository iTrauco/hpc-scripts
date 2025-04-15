#!/bin/bash
zenity --question --text="Delete everything in Downloads?"
if [ $? -eq 0 ]; then
  rm -rf ~/Downloads/*
fi

