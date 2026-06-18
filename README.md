# n8n Automation Bot — Render Deployment

24/7 n8n instance deployed on Render with Docker, running:
- **Daily IT News Bot** — automated daily news workflow
- **Google Review Auto-Reply** — real-time AI-powered reply to Google Business reviews via Pub/Sub

## Architecture

```
Google Business Profile → Pub/Sub → Render Webhook → n8n Workflow → AI Reply → Post to Google
```

## Deployment

### 1. Push to GitHub
```bash
git add -A && git commit -m "Deploy" && git push origin main
```

### 2. Create Render Service
1. Go to [Render Dashboard](https://dashboard.render.com)
2. **New** → **Web Service** → Connect this GitHub repo
3. Render auto-detects `render.yaml` (Blueprint)

### 3. Set Environment Variables (in Render Dashboard)
| Variable | Value |
|---|---|
| `N8N_BASIC_AUTH_USER` | your-username |
| `N8N_BASIC_AUTH_PASSWORD` | your-strong-password |
| `N8N_ENCRYPTION_KEY` | any-random-32-char-string |

### 4. After First Deploy
1. Open `https://n8n-automation-bot.onrender.com`
2. Log in with your basic auth credentials
3. **Activate** both workflows (toggle ON)
4. Set up your credentials (Google OAuth2, Groq API key, etc.)
5. Update the Pub/Sub subscription push endpoint to: `https://n8n-automation-bot.onrender.com/webhook/gbp-review-pubsub`

## Cost
- **Render Starter Plan**: $7/month (required for 24/7)
- **Persistent Disk (1GB)**: $0.25/month
- **Total**: ~$7.25/month

## Files
| File | Purpose |
|---|---|
| `Dockerfile` | Docker image based on `n8nio/n8n:latest` |
| `render.yaml` | Render Blueprint (infra-as-code) |
| `import-workflows.sh` | Auto-imports workflows on first boot |
| `daily_it_news.json` | Daily IT news workflow |
| `google_review_auto_reply.json` | Google review auto-reply workflow |
