#!/usr/bin/env bash
# exit on error
set -o errexit

# Try to force create missing tables if any
echo "DEBUG: Checking for missing tables..."
MISSING=$(python manage.py shell -c "from django.db import connection; from delivery.models import Restaurant, MenuItem, Order, OrderItem, Profile; tables = connection.introspection.table_names(); models_to_check = [Restaurant, MenuItem, Order, OrderItem, Profile]; missing = [m._meta.db_table for m in models_to_check if m._meta.db_table not in tables]; print(len(missing))" 2>/dev/null || echo "1")

if [ "$MISSING" != "0" ]; then
    echo "DEBUG: $MISSING tables are missing or error occurred. Attempting to force migration recovery..."
    # Force Django to think the migration hasn't run if tables are missing
    python manage.py shell -c "from django.db import connection; cursor = connection.cursor(); cursor.execute(\"CREATE TABLE IF NOT EXISTS django_migrations (id serial PRIMARY KEY, app varchar(255), name varchar(255), applied timestamptz)\"); cursor.execute(\"DELETE FROM django_migrations WHERE app='delivery'\"); connection.commit()" || echo "WARNING: Could not clear migration history."
fi

# Run migrations at startup
echo "DEBUG: Running migrations at startup..."
# Try a normal migrate first.
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
