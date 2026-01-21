# 🐧 Linux Process & Disk Manager

![Bash](https://img.shields.io/badge/Language-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

> **Sistem kaynaklarını optimize eden, kritik durumlarda disk temizliği yapan ve HTML formatında profesyonel raporlar sunan otonom sistem yöneticisi.**

---

## 📖 Proje Hakkında

Bu proje, Linux tabanlı sunucu ve istemcilerde sistem sağlığını (CPU, RAM, Disk) izleyen, belirlenen eşik değerler aşıldığında **otonom** kararlar alarak sistemi temizleyen ve yöneticiye görsel bir rapor sunan profesyonel bir otomasyon aracıdır.

**Öne Çıkan Yetenekler:**
* **Akıllı İzleme:** Sistem kaynaklarını anlık olarak takip eder.
* **Otonom Temizlik:** Disk dolduğunda manuel müdahaleye gerek kalmadan gereksiz dosyaları temizler.
* **Zombie Avcısı:** Sistem kaynaklarını tüketen ölü süreçleri (zombie process) tespit eder ve sonlandırır.
* **Görsel Raporlama:** Tüm analizleri modern bir HTML arayüzünde sunar.

---

## 📺 Proje Tanıtım ve Sunum

[![Proje Tanıtım Videosu](https://img.youtube.com/vi/2ITEi6EUJ-o/0.jpg)](https://youtu.be/2ITEi6EUJ-o)

> 📥 **[Detaylı Sunum Dosyasını İndir (.pptx)](./Linux_Process_and_Disk_Manager_PolatTren.pptx)**

---

## ✨ Temel Özellikler

| Modül | Fonksiyon |
| :--- | :--- |
| **🚀 Auto-Monitor** | CPU ve RAM kullanımını anlık izler, anormallik durumunda log kaydı oluşturur. |
| **🧹 Disk-Cleaner** | Disk kullanımı **%90**'ı aştığında cache, tmp ve log dosyalarını güvenli protokollerle temizler. |
| **🧟 Zombie-Hunter** | Performans kaybına neden olan zombie süreçleri tespit eder. |
| **📊 HTML Reporting** | Yönetici için CSS ile stillendirilmiş `index.html` formatında sağlık raporu üretir. |
| **⏰ Cron Automation** | Kurulum sonrası crontab entegrasyonu ile arka planda sessizce çalışır. |

---

## 📂 Proje Yapısı
* src/ : Ana otomasyon scripti (main.sh\) ve kurulum aracı (install.sh\).
* specs/ : Proje meta verilerini içeren standart JSON dosyası.
* researchs/ : Geliştirme öncesi yapılan derinlemesine teknik araştırmalar.
* Linux_Process_and_Disk_Manager_PolatTren.pptx : Projenin detaylı sunum dosyası.

---

## 🚀 Kurulum ve Kullanım

Projeyi yerel makinenize klonlayın ve kurulum sihirbazını başlatın.

### 1. Projeyi İndirin
```bash
git clone [https://github.com/polattren/linux-process-disk-manager.git](https://github.com/polattren/linux-process-disk-manager.git)
cd linux-process-disk-manager
```
### 2. Kurulumu Başlatın
install.sh dosyası gerekli izinleri ayarlayacak ve cron job tanımlamalarını yapacaktır.
```
chmod +x ./src/install.sh
./src/install.sh
```
### 3. Manuel Çalıştırma (Opsiyonel)
Otomasyonu beklemeden aracı hemen test etmek için:
```
sudo ./src/main.sh
```


