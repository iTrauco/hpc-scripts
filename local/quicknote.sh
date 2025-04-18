#!/bin/zsh
tempfile=$(mktemp /tmp/burner_note_XXXXXX.txt)
mousepad "$tempfile" &
