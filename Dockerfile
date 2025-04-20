FROM python:3.11-slim

# Installer Chromium et ses dépendances
RUN apt-get update && apt-get install -y \
    chromium chromium-driver fonts-liberation \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Définir le chemin de Chromium
ENV CHROME_BIN=/usr/bin/chromium
ENV CHROMEDRIVER_BIN=/usr/bin/chromedriver

# Installer les dépendances Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copier le script
COPY tls_checker.py .

# Lancer le script
CMD ["python", "tls_checker.py"]
