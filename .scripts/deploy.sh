#!/bin/bash
set -e

echo "Deployment started ..."

# Enter maintenance mode or return true
# if already is in maintenance mode
(php artisan down) || true

# Pull the latest version of the app
git pull origin master

# Install composer dependencies
composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader

# Clearing Cache
php artisan cache:clear
php artisan config:clear

# Recreate cache
php artisan optimize

# Run database migrations
php artisan migrate --force

# Reload PHP to update opcache
echo "" | sudo -S service php reload

# Exit maintenance mode
php artisan up

echo "Deployment finished!"
