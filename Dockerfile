FROM python:3.11-slim

# Installer Chromium et ses dépendances
RUN apt-get update && apt-get install -y \
    chromium \
    chromium-driver \
    fonts-liberation \
    libnss3 \
    libxss1 \
    libasound2 \
    libx11-xcb1 \
    xdg-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Définir les chemins (Selenium s'en sert)
ENV CHROME_BIN=/usr/bin/chromium
ENV CHROMEDRIVER_BIN=/usr/bin/chromedriver

# Installer les paquets Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copier le script
COPY tls_checker.py .

# Commande de démarrage
CMD ["python", "tls_checker.py"]
