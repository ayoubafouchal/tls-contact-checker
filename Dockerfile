FROM python:3.11-slim

# Installer Google Chrome et ses dépendances
RUN apt-get update && apt-get install -y \
    wget gnupg curl unzip fonts-liberation libnss3 libxss1 libasound2 libx11-xcb1 xdg-utils \
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt install -y ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Définir l'emplacement du binaire Chrome
ENV CHROME_BIN=/usr/bin/google-chrome

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY tls_checker.py .

CMD ["python", "tls_checker.py"]
