FROM n8nio/n8n:latest

USER root

# Create workflows directory
RUN mkdir -p /workflows

# Copy all workflow JSON files into the container
COPY daily_it_news.json /workflows/daily_it_news.json
COPY google_review_auto_reply.json /workflows/google_review_auto_reply.json

# Copy the import script
COPY import-workflows.sh /import-workflows.sh
RUN sed -i 's/\r$//' /import-workflows.sh && chmod +x /import-workflows.sh

# Give node user ownership
RUN chown -R node:node /workflows /import-workflows.sh

# Switch back to the n8n user
USER node
# Use tini as the entrypoint to avoid zombie processes
ENTRYPOINT ["tini", "--"]

# Start n8n and run the import script in the background
CMD ["/bin/sh", "-c", "/import-workflows.sh & /docker-entrypoint.sh start"]
