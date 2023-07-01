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

# Set and create destination
archive_name=archive-$(date +%Y-%m-%d)
destination=/Users/$USER/$archive_name

echo "🏁 Starting the archiver!"

# Check if an archive.zip already exists
if [ -f "/Users/$USER/$archive_name.zip" ]; then
	echo "🛑 An archive already exists for today. Would you like to delete it? (y/N)"
	read -r response

	if [ "$response" = "y" ]; then
		echo "⭕️ Deleting $archive_name.zip..."
		rm /Users/$USER/$archive_name.zip
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

	if [ -d "/Users/$USER/$source" ]; then
		mkdir $destination/$source
		cp -r /Users/$USER/$source $destination
	else
		cp /Users/$USER/$source $destination
	fi
done

# Compress the main archive
echo "🔷 Compressing archive..."
cd $(dirname $destination)
zip -rq $archive_name.zip $(basename $destination)

# Remove the uncompressed archive
echo "⭕️ Deleting uncompressed archive..."
rm -rf $destination

echo "🎉 Done! Your archive is located at /Users/$USER/$archive_name.zip"
