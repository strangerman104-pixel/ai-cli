#!/usr/bin/env python3
import sys
import urllib.request
import urllib.parse
import json

API_URL = "https://ai-mec.vercel.app/api/chat"

def main():
    if len(sys.argv) < 2:
        print("Usage: ai <your prompt here>")
        sys.exit(1)
    
    # Combine all command-line arguments into a single prompt string
    prompt = " ".join(sys.argv[1:])
    
    # Encode the prompt for the URL query parameter
    params = urllib.parse.urlencode({"prompt": prompt})
    url = f"{API_URL}?{params}"
    
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "AICLI/1.0"})
        with urllib.request.urlopen(req) as response:
            result = response.read().decode("utf-8")
            print(result)
    except Exception as e:
        print(f"Error connecting to AI service: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()