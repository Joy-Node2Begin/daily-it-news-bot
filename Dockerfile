FROM n8nio/n8n:latest

USER root

# Create workflows directory
RUN mkdir -p /workflows

# Copy all workflow JSON files into the container
COPY daily_it_news.json /workflows/daily_it_news.json
COPY google_review_auto_reply.json /workflows/google_review_auto_reply.json

# Copy the import script
COPY import-workflows.sh /import-workflows.sh
RUN chmod +x /import-workflows.sh

# Give node user ownership
RUN chown -R node:node /workflows /import-workflows.sh

# Install curl for health checks
RUN apk add --no-cache curl

# Switch back to the n8n user
USER node

# Health check - Render uses this to know the service is alive
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:${N8N_PORT:-5678}/healthz || exit 1

# Start n8n and run the import script in the background
CMD sh -c "/import-workflows.sh & n8n start"
