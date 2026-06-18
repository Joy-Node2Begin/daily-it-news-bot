FROM n8nio/n8n:latest

USER root

# Create workflows directory
RUN mkdir -p /workflows

# Copy all workflow JSON files into the container
COPY *.json /workflows/

# Copy the import script
COPY import-workflows.sh /import-workflows.sh

# Fix line endings in case of Windows CRLF, and make executable
RUN sed -i 's/\r$//' /import-workflows.sh && chmod +x /import-workflows.sh

# Give node user ownership
RUN chown -R node:node /workflows /import-workflows.sh

# Switch back to the n8n user
USER node

# Use tini as the entrypoint to avoid zombie processes
ENTRYPOINT ["tini", "--"]

# Run the import script first, then start n8n to avoid Out-Of-Memory (OOM) on free tier
CMD ["/bin/sh", "-c", "/import-workflows.sh && exec /docker-entrypoint.sh start"]
