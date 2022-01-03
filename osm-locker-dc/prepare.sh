#!/usr/bin/env bash

# First time routine. Run as follows.
# > cd root-of-project
# > make spark-prepare

composer install
php artisan key:generate

php artisan cache:clear
php artisan migrate
php artisan db:seed

php artisan storage:link

#npm install
#npm run dev

# Seeders yet to come.

echo "Inserted DB with initial data."