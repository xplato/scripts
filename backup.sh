#!/usr/bin/env zsh

# Set and create destination
archive_name=archive-$(date +%Y-%m-%d).zip
destination=/Users/$USER/$archive_name

# Since I'm prompted for my SSH password, I want to be
# notified when the process begins.
osascript -e 'display notification "The automatic archival process is beginning. Prepare to be prompted for your SSH password." with title "Archiver" sound name "Blow"'

# Create the archive
zsh ~/Documents/Projects/@xplato/scripts/archive.sh

# Copy the archive to the server
echo "✅ Copying the archive to the server..."
scp ~/$archive_name xplato@${ARCHIVE_SERVER_IP}:archives/

# Delete the archive
echo "⭕️ Deleting the local archive..."
rm $destination

echo "🎉 Archive copied to the server!"
