Here’s a clean, copy-paste-ready **README.md** for your GitHub repo. It matches the simplified Flutter app we just built (3-tab bottom nav, notification icon on AppBar, QR attendance, BAP, Settings).

---

# CORELASI (Flutter)

Aplikasi mobile sederhana untuk **presensi siswa berbasis QR**, **rekap kehadiran**, dan **BAP (Berita Acara Pembelajaran)**, dilengkapi **Settings** (Dark Mode, Language, Edit Account, Bookmarks, Privacy & Help) dan **ikon notifikasi** di kanan atas AppBar.

![CORELASI](assets/logo.png)

<p align="center">
  <a href="https://flutter.dev">Flutter</a> ·
  <a href="#features">Features</a> ·
  <a href="#quickstart">Quickstart</a> ·
  <a href="#project-structure">Structure</a> ·
  <a href="#screens--flows">Screens</a> ·
  <a href="#team--libraries">Team</a>
</p>

---

## Features

* **Bottom Navigation (3 tab)**: Home · Scan · Profile
* **Notifikasi lokal** via **ikon lonceng** di AppBar (kanan atas)
* **Scan QR** untuk presensi (format: `NIS|NAMA`)
* **Rekap Kehadiran**: total/hadir/absen, toggle status
* **BAP**: input topik & catatan → preview ringkas
* **Settings (Profile)**:

  * Dark Mode (persist, `SharedPreferences`)
  * Language (ID/EN sederhana, persist)
  * Edit Account (form sederhana)
  * Bookmarks (catatan singkat, persist)
  * Privacy & Help (informasi statis)
* **Tanpa backend**: semua data lokal (mudah dipahami & dikembangkan)

---

## Tech Stack

* **Flutter** (Material 3, Google Fonts)
* **State**: `provider`
* **Storage**: `shared_preferences` (JSON)
* **QR Scan**: `qr_code_scanner`
* **Local Notifications**: `flutter_local_notifications`

---

## Screens & Flows

* **Login** → **HomeShell (AppBar + BottomNav)**
* **Home**: kartu jadwal contoh + link ke Rekap & BAP
* **Scan**: kamera + overlay; simpan/toggle presensi dari QR (`NIS|NAMA`)
* **Profile/Settings**: Dark Mode, Language, Edit Account, Bookmarks, Privacy & Help
* **AppBar**: ikon 🔔 untuk trigger notifikasi lokal

> **Catatan BAP**: Saat ini **preview teks**. Jika ingin **export PDF**, tambahkan paket `pdf` + `printing`.

---

## Quickstart

### 1) Requirement

* Flutter SDK terbaru (3.x)
* Android Studio / Xcode untuk build device

### 2) Clone & Install

```bash
git clone https://github.com/<org-or-user>/corelasi.git
cd corelasi
flutter pub get
```

### 3) Jalankan

```bash
flutter run
```

### 4) Permissions

**Android** – `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
```

**iOS** – `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera is used for scanning QR codes for attendance.</string>
```

---

## Project Structure

```
lib/
  main.dart
  app_theme.dart
  models/
    student.dart
  providers/
    theme_provider.dart
    data_provider.dart
  services/
    notification_service.dart
  screens/
    login_screen.dart
    home_shell.dart
    home_page.dart
    scan_page.dart
    profile_page.dart
    edit_account_page.dart
    language_page.dart
    bookmarks_page.dart
    privacy_help_page.dart
    bap_page.dart
    attendance_recap_page.dart

assets/
  logo.png  (opsional untuk splash/header)
```

* **`data_provider.dart`**: simpan **students**, **bookmarks**, **language** ke `SharedPreferences` (JSON).
* **`theme_provider.dart`**: Dark Mode toggle + persist.
* **`notification_service.dart`**: inisialisasi & tampilkan notifikasi lokal.
* **`scan_page.dart`**: QRView → `DataProvider.toggleScan(code)`.

---

## Data Model

```json
Student {
  "nis": "string",
  "name": "string",
  "present": true | false,
  "time": "ISO8601"
}
```

* QR format: `NIS|NAMA` (contoh: `120031|Adi Nugraha`)

---

## Configuration

* Ubah **logo** (opsional) di `assets/logo.png`
* Tambah **kelas/jadwal** di `home_page.dart` (kartu contoh)
* Notifikasi saat ini **manual trigger** (ikon 🔔). Bisa di-upgrade ke **scheduled** jika dibutuhkan.

---

## Roadmap (opsional)

* Export **BAP ke PDF** (`pdf` + `printing`)
* **Scheduled notifications** sesuai jam pelajaran
* **Import/Export CSV** daftar siswa
* Integrasi **backend** (Firestore/REST) + auth sebenarnya
* Role **guru/siswa**, multi-kelas & mata pelajaran

---

## Team & Libraries

Pembagian kerja untuk **6 orang** (masing-masing mengerjakan fitur + memakai library relevan):

1. **A – UI/Theme/Settings**
   `app_theme.dart`, `theme_provider.dart`, `profile_page.dart`
   *Libraries*: `provider`, `shared_preferences`, `google_fonts`

2. **B – Notifications**
   `services/notification_service.dart`, integrasi di `home_shell.dart`
   *Libraries*: `flutter_local_notifications`

3. **C – QR Attendance**
   `scan_page.dart`, hook ke `data_provider.dart`
   *Libraries*: `qr_code_scanner`, `provider`

4. **D – Language/Prefs**
   `language_page.dart`, `data_provider.dart`
   *Libraries*: `shared_preferences`, `provider`

5. **E – Edit Account & Forms**
   `edit_account_page.dart` (form sederhana)
   *Libraries*: (native Flutter widgets)

6. **F – Rekap, BAP, Bookmarks**
   `attendance_recap_page.dart`, `bap_page.dart`, `bookmarks_page.dart`
   *Libraries*: `provider`, `shared_preferences`

---

## Contributing

1. Buat branch dari `main` (mis. `feature/qr-scan`)
2. Commit kecil & jelas, sertakan deskripsi
3. Buka Pull Request + screenshot/rekaman fitur
4. Review minimal 1 rekan tim sebelum merge

---

## FAQ

**Q:** Kenapa data hilang saat reinstall?
**A:** Disimpan lokal (`SharedPreferences`). Untuk persist lebih kuat/sync multi-device, pakai DB lokal (Hive/Isar) atau backend.

**Q:** QR tidak terbaca?
**A:** Pastikan izin kamera aktif. Format harus `NIS|NAMA`. Coba perbesar/terangi QR.

**Q:** Notifikasi tidak tampil?
**A:** Cek izin notifikasi OS. Di iOS, notifikasi perlu izin user; di Android 13+ juga.

---

## License

MIT © 2025 CORELASI Team

---

### Screenshots (optional)

Letakkan gambar ke folder `screenshots/` dan tampilkan di sini:

```
screenshots/
  home.png
  scan.png
  profile.png
  recap.png
  bap.png
```

Contoh embed:

```md
![Home](screenshots/home.png)
![Scan](screenshots/scan.png)
```

---

> Pengen *badge* CI/CD, release, atau coverage? Nanti bisa kita tambahkan GitHub Actions workflow sesuai kebutuhan.
