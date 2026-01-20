# 🐧 Linux Process & Disk Manager
**İşletim Sistemleri Dersi Proje Ödevi** | **Hazırlayan:** Polat Tren

Bu proje, Linux tabanlı sistemlerde kaynak kullanımını izleyen, kritik durumlarda disk temizliği yapan ve sistem durumunu HTML olarak raporlayan profesyonel bir Bash otomasyon aracıdır.

---

## ✨ Temel Özellikler
| Özellik | Açıklama |
| :--- | :--- |
| **Auto-Monitor** | CPU ve RAM kullanımını anlık izler, eşik değer aşımında log tutar. |
| **Disk-Cleaner** | Disk %90 doluluğu aşarsa gereksiz dosyaları güvenli bir şekilde temizler. |
| **Zombie-Hunter** | Sistem kaynaklarını tüketen ölü (zombie) süreçleri tespit eder. |
| **HTML Reporting** | Yönetici için görsel bir sistem sağlığı raporu (`index.html`) üretir. |
| **Cron Automation** | Cron Job desteği ile 7/24 kesintisiz ve otomatik çalışma sağlar. |

---

## 📂 Proje Yapısı
* `src/`: Ana otomasyon scripti (`main.sh`) ve kurulum aracı (`install.sh`).
* `specs/`: Proje meta verilerini içeren standart JSON dosyası.
* `docs/`: AI destekli hazırlanan teknik sunum materyalleri.
* `researchs/`: Geliştirme öncesi yapılan derinlemesine teknik araştırmalar.

---

## 🛠️ Kurulum ve Kullanım

Projenin kurulumu ve otomatik görevlerin aktif edilmesi oldukça basittir:

```bash
# 1. Kurulumu başlat (İzinleri ayarlar ve Cron Job ekler)
./src/install.sh

# 2. Manuel kontrol için çalıştırma
sudo ./src/main.sh
```

---

## 🤖 Yapay Zeka Entegrasyonu
Bu proje; araştırma, analiz ve sunum süreçlerinde **Gemini, ChatGPT ve Kimi AI** gibi ileri seviye yapay zeka modelleriyle "Sentez & Zenginleştirme" prensipleri doğrultusunda geliştirilmiştir.

---
**İstinye Üniversitesi • Bilgisayar Programcılığı**
