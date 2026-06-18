#!/bin/sh
# Auto-import and activate workflows on first boot

echo "=== n8n Workflow Import Script ==="
echo "Waiting for n8n to start up..."

# Wait for n8n to be fully ready (retry up to 60 seconds)
MAX_RETRIES=12
RETRY_COUNT=0
until curl -sf http://localhost:${N8N_PORT:-5678}/healthz > /dev/null 2>&1; do
  RETRY_COUNT=$((RETRY_COUNT + 1))
  if [ "$RETRY_COUNT" -ge "$MAX_RETRIES" ]; then
    echo "Warning: n8n did not respond after ${MAX_RETRIES} attempts. Importing anyway..."
    break
  fi
  echo "Waiting for n8n... (attempt $RETRY_COUNT/$MAX_RETRIES)"
  sleep 5
done

echo "n8n is ready. Importing workflows..."

# Import each workflow JSON file
for file in /workflows/*.json; do
  if [ -f "$file" ]; then
    echo "Importing: $file"
    n8n import:workflow --input="$file" 2>&1 || echo "Warning: Could not import $file (may already exist)"
  fi
done

echo "=== Workflow import complete ==="
echo "Workflows will need to be activated via the n8n UI on first deploy."
echo "After that, they persist on the disk and stay active across restarts."
