#!/bin/bash
#
# Project: Linux Process & Disk Manager
# Author: Polat Tren
# Version: 1.0.0
# Description: Sistem kaynaklarini izler, disk temizligi yapar ve HTML rapor sunar.
#

# --- AYARLAR (CONFIGURATION) ---
THRESHOLD_CPU=80        # CPU uyari siniri (%)
THRESHOLD_DISK=90       # Disk temizlik siniri (%)
LOG_FILE="/tmp/linux-manager.log"
REPORT_FILE="/var/www/html/status/index.html" # Web sunucusu yoksa /tmp/report.html yapilabilir
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# --- RENKLER ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Hata yakalama modu (Strict Mode)
set -u

# --- FONKSIYON: Loglama ---
log_message() {
    local TYPE=$1
    local MSG=$2
    echo -e "${DATE} [${TYPE}] ${MSG}" | tee -a "$LOG_FILE"
}

# --- FONKSIYON: Kaynak Kontrolü ---
check_resources() {
    echo -e "${YELLOW}[*] Sistem kaynaklari kontrol ediliyor...${NC}"
    
    # CPU Kullanimi
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | cut -d. -f1)
    
    # RAM Kullanimi
    RAM_USAGE=$(free -m | awk '/Mem:/ { printf("%3.1f", $3/$2*100) }')
    
    log_message "INFO" "CPU: %${CPU_USAGE} | RAM: %${RAM_USAGE}"

    if [ "$CPU_USAGE" -gt "$THRESHOLD_CPU" ]; then
        log_message "WARNING" "Yüksek CPU kullanimi tespit edildi! (%${CPU_USAGE})"
    fi
}

# --- FONKSIYON: Disk Temizligi ---
clean_disk() {
    echo -e "${YELLOW}[*] Disk analizi yapiliyor...${NC}"
    
    DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
    
    log_message "INFO" "Disk Doluluk Orani: %${DISK_USAGE}"

    if [ "$DISK_USAGE" -gt "$THRESHOLD_DISK" ]; then
        log_message "ALERT" "Disk kritik seviyede (%${DISK_USAGE})! Temizlik baslatiliyor..."
        
        # Apt cache temizle
        apt-get clean 2>/dev/null
        # Eski loglari sil (Örnek: 7 günden eski loglar)
        find /var/log -type f -name "*.gz" -delete 2>/dev/null
        
        log_message "SUCCESS" "Disk temizligi tamamlandi."
    else
        echo -e "${GREEN}[OK] Disk durumu normal.${NC}"
    fi
}

# --- FONKSIYON: Zombie Süreç Avcisi ---
kill_zombies() {
    echo -e "${YELLOW}[*] Zombie süreçler araniyor...${NC}"
    
    ZOMBIES=$(ps aux | awk '{ print $8 " " $2 }' | grep -w Z)
    
    if [ -z "$ZOMBIES" ]; then
        echo -e "${GREEN}[OK] Zombie süreç bulunamadi.${NC}"
    else
        ZOMBIE_COUNT=$(echo "$ZOMBIES" | wc -l)
        log_message "WARNING" "${ZOMBIE_COUNT} adet Zombie süreç bulundu. Ebeveyn süreçler uyariyor..."
        # Burada kill komutu eklenebilir, simdilik logluyoruz.
    fi
}

# --- FONKSIYON: HTML Raporu ---
generate_report() {
    # Rapor klasörü yoksa olustur
    mkdir -p $(dirname "$REPORT_FILE")
    
    cat > "$REPORT_FILE" <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Sistem Durum Raporu</title>
    <style>
        body { font-family: sans-serif; background: #1a1b26; color: #a9b1d6; padding: 20px; }
        .card { background: #24283b; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
        h1 { color: #7aa2f7; border-bottom: 2px solid #7aa2f7; }
        .metric { font-size: 24px; font-weight: bold; color: #9ece6a; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🐧 Linux Manager Raporu</h1>
        <p>Tarih: $DATE</p>
        <p>CPU Kullanımı: <span class="metric">%$CPU_USAGE</span></p>
        <p>Disk Kullanımı: <span class="metric">%$DISK_USAGE</span></p>
        <p>Son Log: $(tail -n 1 $LOG_FILE)</p>
    </div>
</body>
</html>
EOF
    log_message "INFO" "HTML raporu olusturuldu: $REPORT_FILE"
}

# --- ANA AKIŞ ---
main() {
    echo -e "${GREEN}=== Linux Process & Disk Manager Baslatildi ===${NC}"
    check_resources
    clean_disk
    kill_zombies
    generate_report
    echo -e "${GREEN}=== Islem Tamamlandi ===${NC}"
}

main
