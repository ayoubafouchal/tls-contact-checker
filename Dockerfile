FROM python:3.11-slim

# Installer dépendances
RUN apt-get update && apt-get install -y \
    wget gnupg unzip curl ca-certificates fonts-liberation libnss3 libxss1 libasound2 libx11-xcb1 xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Ajouter le dépôt Google Chrome et installer le navigateur
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Définir les chemins pour Chrome et ChromeDriver
ENV CHROME_BIN=/usr/bin/google-chrome
ENV CHROMEDRIVER_BIN=/usr/bin/chromedriver

# Installer les packages Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copier le script
COPY tls_checker.py .

# Lancer
CMD ["python", "tls_checker.py"]
FROM python:3.11-slim

# Installer dépendances
RUN apt-get update && apt-get install -y \
    wget gnupg unzip curl ca-certificates fonts-liberation libnss3 libxss1 libasound2 libx11-xcb1 xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Ajouter le dépôt Google Chrome et installer le navigateur
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Définir les chemins pour Chrome et ChromeDriver
ENV CHROME_BIN=/usr/bin/google-chrome
ENV CHROMEDRIVER_BIN=/usr/bin/chromedriver

# Installer les packages Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copier le script
COPY tls_checker.py .

# Lancer
CMD ["python", "tls_checker.py"]
