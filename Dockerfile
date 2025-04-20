FROM python:3.11-slim

# Installe Chromium et dépendances
RUN apt-get update && apt-get install -y \
    chromium chromium-driver curl unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Variables d'environnement pour Selenium
ENV CHROME_BIN=/usr/bin/chromium
ENV CHROMEDRIVER_BIN=/usr/bin/chromedriver

# Installe les dépendances Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copie le script
COPY tls_checker.py .

# Commande à exécuter
CMD ["python", "tls_checker.py"]
