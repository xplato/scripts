#!/usr/bin/env zsh

sources=(
	"Desktop"
	"Downloads"
	"Documents"
	"Music"
	"Movies"
	".ssh"
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

echo "Starting the archiver!\n"

# Check if an archive.zip already exists
if [ -f "/Users/$USER/$archive_name.zip" ]; then
	echo "An archive already exists for today. Exiting..."
	exit 1
fi

echo "Flushing node_modules..."
find ~/Documents -name "node_modules" -type d -prune -exec rm -rf {} +

echo "Flushing .next..."
find ~/Documents -name ".next" -type d -prune -exec rm -rf {} +

echo "Creating $destination..."
mkdir $destination

for source in $sources; do
	echo "Copying $source..."

	if [ -d "/Users/$USER/$source" ]; then
		mkdir $destination/$source
		cp -r /Users/$USER/$source $destination
	else
		cp /Users/$USER/$source $destination
	fi
done

# Compress the main archive
echo "Beginning zip compression..."
cd $(dirname $destination)
zip -rq $archive_name.zip $(basename $destination)

# Remove the uncompressed archive
echo "Removing uncompressed archive..."
rm -rf $destination

echo "\nDone! 🎉"
