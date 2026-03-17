#!/usr/bin/env bash
# exit on error
set -o errexit

# Run migrations at startup
echo "DEBUG: Running migrations at startup..."
# Set +e to allow error handling for migrations
set +o errexit

# Try normal migration first
# We use --fake-initial but if it fails (likely due to inconsistent state where SOME tables exist)
# we might need more aggressive measures.
python manage.py migrate --noinput --fake-initial
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    echo "WARNING: Migration failed with exit code $EXIT_CODE. Attempting to diagnose..."
    
    # DEBUG: List tables for visibility
    echo "DEBUG: Current database tables (before recovery):"
    python manage.py shell -c "from django.db import connection; print('Tables:', connection.introspection.table_names())"
    
    # If migrate --fake-initial fails, it might be because some tables exist but others DON'T.
    # We'll try to apply it normally. If it still fails, it's likely "already exists".
    # In that case, we might need to fake the 'delivery' app specifically.
    echo "DEBUG: Attempting normal migrate without --fake-initial..."
    python manage.py migrate --noinput
    
    if [ $? -ne 0 ]; then
        echo "WARNING: Normal migrate also failed. Trying to fake it as a last resort."
        # This is risky if tables are missing, but if the migration is "already applied" 
        # in django_migrations but tables are missing (unlikely) OR vice-versa.
        python manage.py migrate delivery --fake
    fi
fi

# Re-enable exit on error
set -o errexit

# DEBUG: List tables after migration
echo "DEBUG: Listing database tables (final state):"
python manage.py shell -c "from django.db import connection; print('Tables:', connection.introspection.table_names())"

# Import initial data from fooddeliverysys.sql (safe to run multiple times due to update_or_create)
echo "DEBUG: Importing data from fooddeliverysys.sql..."
python import_sql_data.py

# Start Gunicorn
echo "DEBUG: Starting Gunicorn..."
gunicorn FoodDeliverySystem.wsgi:application
