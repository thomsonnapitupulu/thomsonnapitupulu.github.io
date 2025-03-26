#!/bin/bash

# Setup script for the Jekyll personal website

echo "Setting up your personal website..."

# Check if Ruby is installed
if ! command -v ruby &> /dev/null; then
    echo "Ruby is not installed. Please install Ruby before continuing."
    exit 1
fi

# Check if Bundler is installed
if ! command -v bundle &> /dev/null; then
    echo "Installing Bundler..."
    gem install bundler
fi

# Install dependencies
echo "Installing dependencies..."
bundle install

# Create necessary directories
echo "Creating necessary directories..."
mkdir -p assets/images
mkdir -p _projects

# Prompt for basic configuration
echo "Let's set up your basic information:"

read -p "Your name: " name
read -p "GitHub username: " github_username
read -p "LinkedIn username: " linkedin_username
read -p "Medium username: " medium_username
read -p "Email address: " email

# Update _config.yml with user input
echo "Updating configuration..."
sed -i "" "s/Your Name/$name/g" _config.yml
sed -i "" "s/yourusername/$github_username/g" _config.yml
sed -i "" "s/yourlinkedinusername/$linkedin_username/g" _config.yml
sed -i "" "s/yourmediumusername/$medium_username/g" _config.yml
sed -i "" "s/your-email@example.com/$email/g" _config.yml

# Make the update-content.sh script executable
chmod +x update-content.sh

echo "Setup complete! You can now run 'bundle exec jekyll serve' to start your site locally."
echo "Don't forget to:"
echo "1. Add your profile picture to assets/images/avatar.jpg"
echo "2. Update your about.md page with your bio"
echo "3. Create your own blog posts in the _posts directory"
echo "4. Commit and push to your GitHub repository (yourusername.github.io)"