import time
import requests
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager

# === CONFIGURATION ===

URL = "https://fr.tlscontact.com/appointment/ma/maAGA2fr/19188845"

# Remplace avec TON token Telegram
TELEGRAM_TOKEN = "7374062505:AAFwkGCfE2U9Z6rCfGxZvGg1rae_p1PbFng"  # ex: "123456789:ABCDefghIJKlmnoPQRstuvWXYz12345678"
TELEGRAM_CHAT_ID = "2030658684"  # Ton chat ID

# === SETUP CHROME (Headless) ===




def setup_driver():
    options = Options()
    options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")

    # Créer le service avec le chemin auto-téléchargé par webdriver-manager
    service = Service(ChromeDriverManager().install())

    return webdriver.Chrome(service=service, options=options)


# === ENVOI DU MESSAGE TELEGRAM ===

def send_telegram_message(message):
    api_url = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/sendMessage"
    payload = {
        "chat_id": TELEGRAM_CHAT_ID,
        "text": message
    }
    try:
        response = requests.post(api_url, data=payload)
        if response.status_code == 200:
            print("✅ Message Telegram envoyé.")
        else:
            print("❌ Erreur Telegram :", response.text)
    except Exception as e:
        print("❌ Erreur envoi Telegram :", e)

# === VÉRIFICATION DE DISPONIBILITÉ ===

def check_rdv(driver):
    try:
        driver.get(URL)

        # Attente que le corps de page charge
        WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.TAG_NAME, "body")))

        # Recherche des blocs indiquant des créneaux
        rdvs = driver.find_elements(By.CLASS_NAME, "tls-appointment-time-picker")

        print(f"📅 Créneaux détectés : {len(rdvs)}")

        return len(rdvs) > 0  # Si au moins un bloc est présent, il y a peut-être un RDV
    except Exception as e:
        print("❌ Erreur pendant la vérification :", e)
        return False

# === BOUCLE PRINCIPALE ===

if __name__ == "__main__":
    driver = setup_driver()
    rdv_envoye = False

    try:
        while True:
            print("\n🔍 Vérification en cours...")
            if check_rdv(driver):
                if not rdv_envoye:
                    print("⚠️ RDV détecté ! Envoi Telegram...")
                    send_telegram_message(f"📢 Un rendez-vous est peut-être dispo sur TLSContact ! Vérifie ici :\n{URL}")
                    rdv_envoye = True
                else:
                    print("🔁 RDV toujours présent (déjà notifié).")
            else:
                rdv_envoye = False
                print("❌ Aucun RDV dispo. Nouvelle vérif dans 60 sec.")
            time.sleep(60)
    except KeyboardInterrupt:
        print("🛑 Script arrêté par l'utilisateur.")
    finally:
        driver.quit()
