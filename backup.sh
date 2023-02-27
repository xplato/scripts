#!/usr/bin/env zsh

# Set and create destination
archive_name=archive-$(date +%Y-%m-%d).zip
destination=/Users/$USER/$archive_name

# Create the archive
zsh ~/Documents/Projects/@xplato/scripts/archive.sh

# Copy the archive to the server
echo "✅ Copying the archive to the server..."
scp ~/$archive_name xplato@${ARCHIVE_SERVER_IP}:archives/

# Delete the archive
echo "⭕️ Deleting the local archive..."
rm $destination

echo "🎉 Archive copied to the server!"
