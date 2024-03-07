#!/usr/bin/env zsh

# archive.sh
# Archives files and folders to a zip file
#
# Note that this script is optimized for MacOS. If you wish to use
# it on another OS, you will need to change the paths.
#
# Usage: archive.sh [-m|--keep-modules]
# -m or --keep-modules • keep node_modules and .next directories
# (default is to delete them)

# Emoji legend
# 🏁 Start
# 🔷 Info
# 🛑 Error prompt
# ❌ Error / Exit
# ⭕️ Delete
# ✅ Copy / Create
# 🎉 Done

sources=(
	"Desktop"
	"Downloads"
	"Documents"
	"Music"
	"Movies"
	"Images"
	".vim"
	".warp"
	".gitconfig"
	".vimrc"
	".gitignore"
	".npmrc"
	".zshrc"
)

# Get the user-defined name of the system
raw_name=$(scutil --get ComputerName)

# Replace spaces with dashes and convert to lowercase
formatted_name=$(echo "$raw_name" | sed 's/ /-/g' | tr '[:upper:]' '[:lower:]')

# Generate date-based part of archive name
date_part=$(date +%Y-%m-%d)

# Set and create destination with computer name prepended
archive_name="${formatted_name}-${date_part}"
destination=$HOME/$archive_name

echo "🏁 Starting the archiver!"

# Check if an archive.zip already exists
if [ -f "$destination.zip" ]; then
	echo "🛑 An archive already exists for today. Would you like to delete it? (y/N)"
	read -r response

	if [ "$response" = "y" ]; then
		echo "⭕️ Deleting $archive_name.zip..."
		rm $destination.zip
	else
		echo "❌ Exiting..."
		exit 1
	fi
fi

# Clear out node_modules and .next automatically unless -m or --keep-modules is passed
if [[ $1 =~ ^(-m|--keep-modules) ]]; then
	echo "🔷 Not deleting node_modules and .next"
else
	echo "⭕️ Deleting node_modules..."
	find ~/Documents -name "node_modules" -type d -prune -exec rm -rf {} +

	echo "⭕️ Deleting .next..."
	find ~/Documents -name ".next" -type d -prune -exec rm -rf {} +
fi

echo "✅ Creating $destination..."
mkdir $destination

for source in $sources; do
	echo "✅ Copying $source..."

	if [ -d "$HOME/$source" ]; then
		mkdir $destination/$source
		cp -r $HOME/$source $destination
	else
		cp $HOME/$source $destination
	fi
done

# Compress the main archive
echo "🔷 Compressing archive..."
cd $(dirname $destination)
zip -rq $archive_name.zip $(basename $destination)

# Remove the uncompressed archive
echo "⭕️ Deleting uncompressed archive..."
rm -rf $destination

echo "🎉 Done! Your archive is located at $destination.zip"
