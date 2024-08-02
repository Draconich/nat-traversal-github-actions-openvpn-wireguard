#!/bin/bash

# Function to handle Ctrl+C
cleanup() {
    echo "Ctrl+C caught. Cancelling in-progress GitHub Actions runs..."
    gh run list --json databaseId,status -q '.[] | select(.status == "in_progress" or .status == "queued" or .status == "waiting") | .databaseId' | xargs -r -n1 gh run cancel
    echo "Cleanup completed. Exiting."
    exit 0
}

# Trap Ctrl+C and call the cleanup function
trap cleanup SIGINT

while true; do
    # Get the current IP address
    IP=$(wget -qO - https://icanhazip.com)
    # Run the git command
    git commit -m "DT: $IP:443" --allow-empty && git push

    echo "Executed at $(date)"

    # Sleep for 6 hours (21600 seconds)
    sleep 21600 &

    # Wait for sleep to finish or for a signal to be caught
    wait $!
done
