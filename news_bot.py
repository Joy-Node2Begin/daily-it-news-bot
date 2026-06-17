import os
import requests
import re

# Load Secrets
GNEWS_API_KEY = os.environ.get("GNEWS_API_KEY")
TELEGRAM_BOT_TOKEN = os.environ.get("TELEGRAM_BOT_TOKEN")
TELEGRAM_CHAT_ID = os.environ.get("TELEGRAM_CHAT_ID")

if not GNEWS_API_KEY or not TELEGRAM_BOT_TOKEN or not TELEGRAM_CHAT_ID:
    print("Missing one or more required environment variables.")
    exit(1)

def get_news():
    url = "https://gnews.io/api/v4/search"
    query = "AI OR \"machine learning\" OR cybersecurity OR software OR tech OR \"artificial intelligence\" OR cloud OR OpenAI OR Google OR Microsoft OR Apple OR Meta OR startup OR blockchain OR semiconductor"
    params = {
        "q": query,
        "lang": "en",
        "sortby": "publishedAt",
        "max": 10,
        "apikey": GNEWS_API_KEY
    }
    
    response = requests.get(url, params=params)
    response.raise_for_status()
    return response.json().get("articles", [])

def clean_html(raw_html):
    cleanr = re.compile('<.*?>')
    cleantext = re.sub(cleanr, '', raw_html)
    return cleantext

def send_to_telegram(text):
    url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
    payload = {
        "chat_id": TELEGRAM_CHAT_ID,
        "text": text,
        "parse_mode": "Markdown",
        "disable_web_page_preview": False
    }
    response = requests.post(url, json=payload)
    if response.status_code != 200:
        print(f"Failed to send to Telegram: {response.text}")

def main():
    print("Fetching news...")
    articles = get_news()
    
    if not articles:
        print("No articles found today.")
        return
        
    print(f"Found {len(articles)} articles. Sending to Telegram...")
    
    for article in articles:
        title = article.get("title", "Tech News")
        link = article.get("url", "")
        snippet = article.get("content", article.get("description", ""))
        
        # Clean snippet and limit to 150 chars
        clean_snippet = clean_html(snippet)[:150]
        if len(clean_snippet) == 150:
            clean_snippet += "..."
            
        final_text = f"🚀 *{title}*\n\n{clean_snippet}\n\n🔗 [Read More]({link})"
        
        send_to_telegram(final_text)
        
    print("Successfully sent all articles!")

if __name__ == "__main__":
    main()
