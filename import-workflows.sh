#!/bin/sh
# Import workflows synchronously before starting n8n server to save memory

echo "=== n8n Workflow Import Script ==="

# Import each workflow JSON file directly into the database
for file in /workflows/*.json; do
  if [ -f "$file" ]; then
    echo "Importing: $file"
    n8n import:workflow --input="$file" 2>&1 || echo "Warning: Could not import $file (may already exist)"
  fi
done

echo "=== Workflow import complete ==="
echo "Starting n8n server..."

