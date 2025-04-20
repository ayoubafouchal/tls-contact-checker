FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    chromium chromium-driver curl unzip fonts-liberation \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV CHROME_BIN=/usr/bin/chromium

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY script.py .

CMD ["python", "script.py"]
