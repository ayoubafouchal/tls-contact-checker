FROM python:3.11-slim

# Installer dépendances système
RUN apt-get update && apt-get install -y \
    wget curl gnupg unzip fonts-liberation libnss3 libxss1 libasound2 libx11-xcb1 xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Installer Google Chrome stable
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb || apt-get -fy install && \
    rm google-chrome-stable_current_amd64.deb

# Définir le chemin Chrome
ENV CHROME_BIN=/usr/bin/google-chrome

# Copier les fichiers Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY tls_checker.py .

CMD ["python", "tls_checker.py"]
