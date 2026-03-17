#!/usr/bin/env bash
# exit on error
set -o errexit

# Run migrations at startup
echo "DEBUG: Running migrations at startup..."
python manage.py migrate --noinput

# Start Gunicorn
echo "DEBUG: Starting Gunicorn..."
gunicorn FoodDeliverySystem.wsgi:application
