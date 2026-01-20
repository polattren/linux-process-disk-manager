cat > README.md <<EOF
# 🐧 Linux Process & Disk Manager
**İşletim Sistemleri Dersi Proje Ödevi** | **Hazırlayan:** Polat Tren

Bu proje, Linux tabanlı sistemlerde kaynak kullanımını izleyen, kritik durumlarda disk temizliği yapan ve sistem durumunu HTML olarak raporlayan profesyonel bir Bash otomasyon aracıdır.

---

## 📺 Proje Tanıtım ve Sunum

[![Proje Tanıtım Videosu](https://img.youtube.com/vi/2OhbRR3BzlU/0.jpg)](https://youtu.be/2OhbRR3BzlU)

> **Tanıtım Videosunu izlemek için yukarıdaki görsele tıklayın.**

📥 **[Proje Sunum Dosyasını İndir (.pptx)](Linux_Process_and_Disk_Manager_PolatTren.pptx?raw=true)**

---

## ✨ Temel Özellikler
| Özellik | Açıklama |
| :--- | :--- |
| **Auto-Monitor** | CPU ve RAM kullanımını anlık izler, eşik değer aşımında log tutar. |
| **Disk-Cleaner** | Disk %90 doluluğu aşarsa gereksiz dosyaları güvenli bir şekilde temizler. |
| **Zombie-Hunter** | Sistem kaynaklarını tüketen ölü (zombie) süreçleri tespit eder. |
| **HTML Reporting** | Yönetici için görsel bir sistem sağlığı raporu (\`index.html\`) üretir. |
| **Cron Automation** | Cron Job desteği ile 7/24 kesintisiz ve otomatik çalışma sağlar. |

---

## 📂 Proje Yapısı
* \`src/\`: Ana otomasyon scripti (\`main.sh\`) ve kurulum aracı (\`install.sh\`).
* \`specs/\`: Proje meta verilerini içeren standart JSON dosyası.
* \`researchs/\`: Geliştirme öncesi yapılan derinlemesine teknik araştırmalar.
* \`Linux_Process_and_Disk_Manager_PolatTren.pptx\`: Projenin detaylı sunum dosyası.

---

## 🛠️ Kurulum ve Kullanım

\`\`\`bash
# 1. Kurulumu başlat
./src/install.sh

# 2. Manuel kontrol
sudo ./src/main.sh
\`\`\`

---

## 🤖 Yapay Zeka Entegrasyonu
Bu proje; araştırma, analiz ve sunum süreçlerinde **Gemini, ChatGPT ve Kimi AI** gibi ileri seviye yapay zeka modelleriyle "Sentez & Zenginleştirme" prensipleri doğrultusunda geliştirilmiştir.

---
**İstinye Üniversitesi • Bilgisayar Programcılığı**
EOF