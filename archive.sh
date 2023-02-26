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

echo "🏁 Starting the archiver!\n"

# Check if an archive.zip already exists
if [ -f "/Users/$USER/$archive_name.zip" ]; then
	echo "🛑 An archive already exists for today. Would you like to delete it? (y/N)"
	read -r response

	if [ "$response" = "y" ]; then
		echo "⭕️ Deleting archive..."
		rm /Users/$USER/$archive_name.zip
	else
		echo "❌ Exiting..."
		exit 1
	fi
fi

echo "⭕️ Deleting node_modules..."
find ~/Documents -name "node_modules" -type d -prune -exec rm -rf {} +

echo "⭕️ Deleting .next..."
find ~/Documents -name ".next" -type d -prune -exec rm -rf {} +

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
echo "🌀 Compressing archive..."
cd $(dirname $destination)
zip -rq $archive_name.zip $(basename $destination)

# Remove the uncompressed archive
echo "⭕️ Deleting uncompressed archive..."
rm -rf $destination

echo "\n🎉 Done!"
