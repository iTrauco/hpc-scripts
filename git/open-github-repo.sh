#!/bin/bash

if git rev-parse --git-dir > /dev/null 2>&1; then
    REMOTE_URL=$(git config --get remote.origin.url)
    GITHUB_URL=$(echo "$REMOTE_URL" | sed 's/\.git$//')
    /usr/bin/google-chrome --profile-directory="Default" --new-window "$GITHUB_URL"
else
    /usr/bin/google-chrome --profile-directory="Default" --new-window "https://github.com/itrauco"
fi
