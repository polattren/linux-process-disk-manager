#!/bin/bash
#
# Linux Sistem Yonetim Araci
# Polat Tren - Istinye Universitesi
#

# --- Degiskenler ve Ayarlar ---
max_cpu=80              # CPU %80'i gecerse uyari versin
max_disk=90             # Disk %90 dolarsa temizlesin
log_dosyasi="/tmp/linux-manager.log"
rapor_dosyasi="/var/www/html/status/index.html"
tarih=$(date '+%d.%m.%Y %H:%M:%S')

# Loglama yapan basit bir fonksiyon
log_yaz() {
    mesaj="$1"
    # Hem ekrana yazsin hem dosyaya kaydetsin
    echo "[$tarih] $mesaj" | tee -a "$log_dosyasi"
}

echo "--- Kontrol Basladi ---"

# 1. CPU ve RAM KONTROLU
# top ve free komutlariyla verileri cekiyorum
cpu_kullanim=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | cut -d. -f1)
ram_kullanim=$(free -m | awk '/Mem:/ { printf("%3.1f", $3/$2*100) }')

log_yaz "Mevcut Durum -> CPU: %$cpu_kullanim | RAM: %$ram_kullanim"

if [ "$cpu_kullanim" -gt "$max_cpu" ]; then
    log_yaz "UYARI: CPU kullanimi cok yuksek! (% $cpu_kullanim)"
fi

# 2. DISK KONTROLU VE TEMIZLIK
disk_doluluk=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')

log_yaz "Disk Doluluk Orani: %$disk_doluluk"

if [ "$disk_doluluk" -gt "$max_disk" ]; then
    log_yaz "Disk dolmus, gereksiz dosyalari siliyorum..."
    
    # apt cache ve eski loglari temizle
    apt-get clean 2>/dev/null
    find /var/log -type f -name "*.gz" -delete 2>/dev/null
    
    log_yaz "Temizlik tamamlandi."
else
    echo "Disk durumu gayet iyi, temizlige gerek yok."
fi

# 3. ZOMBIE PROCESS KONTROLU
# Z harfi ile isaretlenen olu surecleri bul
zombie_sayisi=$(ps aux | awk '{ print $8 }' | grep -c Z)

if [ "$zombie_sayisi" -gt 0 ]; then
    log_yaz "DIKKAT: Sistemde $zombie_sayisi adet Zombie surec var!"
else
    echo "Zombie surec yok, sistem temiz."
fi

# 4. RAPOR OLUSTURMA (HTML)
# Klasor yoksa olusturuyorum
mkdir -p $(dirname "$rapor_dosyasi")

# HTML kodunu buraya yaziyoruz
cat > "$rapor_dosyasi" <<HTML
<html>
<head>
    <title>Polat Tren - Sistem Raporu</title>
    <meta charset="UTF-8">
</head>
<body style="background-color: #f0f0f0; font-family: Arial;">
    <div style="background: white; width: 50%; margin: 50px auto; padding: 20px; border-radius: 10px; border: 1px solid #ccc;">
        <h2 style="color: #333;">🐧 Sistem Durum Raporu</h2>
        <hr>
        <p><b>Tarih:</b> $tarih</p>
        <p><b>CPU Kullanımı:</b> %$cpu_kullanim</p>
        <p><b>RAM Kullanımı:</b> %$ram_kullanim</p>
        <p><b>Disk Durumu:</b> %$disk_doluluk</p>
        <br>
        <p style="font-size: 12px; color: gray;">Otomatik olusturulmustur.</p>
    </div>
</body>
</html>
HTML

log_yaz "Rapor guncellendi: $rapor_dosyasi"
echo "--- Islem Bitti ---"
