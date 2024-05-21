#!/bin/bash

# Function to display a prompt asking the user if they want to reboot
function prompt_reboot {
    osascript <<EOF
tell application "System Events"
    activate
    display dialog "TG Security has completed Patch Tuesday updates for your computer. As mentioned in our #updates Slack channel, please choose if you'd like to reboot now or later. (Our preference is... now!)" buttons {"Reboot Now", "Later"} default button "Later"
end tell
EOF
}

# Number of prompts
max_prompts=3

# Interval between prompts in seconds (30 minutes = 1800 seconds)
prompt_interval=1800

# Current prompt count
prompt_count=0

while [[ $prompt_count -lt $max_prompts ]]; do
    # Call the prompt function and capture user choice
    user_choice=$(prompt_reboot)

    # Check user's decision
    if [[ "$user_choice" == "button returned:Reboot Now" ]]; then
        echo "Rebooting now."
        sudo shutdown -r now
        exit 0
    else
        echo "User opted to reboot later."
        ((prompt_count++))
        
        # Check if we should continue prompting
        if [[ $prompt_count -eq $max_prompts ]]; then
            echo "Maximum number of prompts reached. No more prompts will be issued."
            break
        else
            echo "Next prompt in 30 minutes."
            sleep $prompt_interval
        fi
    fi
done
