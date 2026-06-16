FROM n8nio/n8n:latest

USER root

# Create a workflows directory
RUN mkdir -p /workflows

# Copy your workflow so it's backed up inside the Docker container
COPY daily_it_news.json /workflows/daily_it_news.json

# Give node user ownership
RUN chown -R node:node /workflows

# Switch back to the n8n user
USER node

# Start n8n
CMD ["n8n", "start"]
