#!/bin/bash
#
# Installer for Linux Process & Disk Manager
#

# Proje dizinini bul
PROJECT_DIR=$(pwd)
SCRIPT_PATH="$PROJECT_DIR/src/main.sh"
CRON_JOB="*/5 * * * * root $SCRIPT_PATH >> /tmp/cron_log.txt 2>&1"

echo "=== Kurulum Baslatiliyor ==="

# 1. Calistirma izni ver
chmod +x $SCRIPT_PATH
echo "[OK] İzinler verildi."

# 2. Cron Job Ekle (Eğer yoksa)
if crontab -l 2>/dev/null | grep -q "$SCRIPT_PATH"; then
    echo "[INFO] Cron job zaten mevcut."
else
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "[SUCCESS] Otomasyon kuruldu! Script her 5 dakikada bir calisacak."
fi

echo "=== Kurulum Tamamlandi ==="
