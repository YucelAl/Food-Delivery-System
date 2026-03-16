#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Run migrations
echo "DEBUG: Running migrations..."
python manage.py migrate --noinput || { echo "ERROR: Migration failed"; exit 1; }

# Collect static files
python manage.py collectstatic --noinput
