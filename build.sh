#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Run migrations (Safe for PostgreSQL, ensure DATABASE_URL is set in Render Dashboard)
echo "DEBUG: Running migrations in build step..."
python manage.py migrate --noinput || { echo "ERROR: Migration failed. Check DATABASE_URL."; exit 1; }

# Collect static files
python manage.py collectstatic --noinput
