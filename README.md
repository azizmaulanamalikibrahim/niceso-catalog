# NICESO CATALOG ONLINE (Supabase + Capacitor)

Satu kode untuk HP (APK) dan web laptop. Semua pengguna melihat katalog yang sama secara langsung; hanya admin yang bisa mengubah.

## 1. Siapkan Supabase (gratis, sekali saja)
1. supabase.com -> New project (pilih region Singapore).
2. SQL Editor -> tempel isi `schema.sql` -> Run.
3. Authentication -> Users -> Add user (email + password admin, centang auto-confirm).
4. SQL Editor -> jalankan: `insert into admins (user_id) select id from auth.users where email = 'EMAIL-ADMIN';`
5. Project Settings -> API -> salin **Project URL** dan **anon public key** -> tempel ke `www/config.js`.

## 2. Build APK (tanpa instal apa pun)
Upload semua isi folder ke GitHub -> Actions -> Build APK -> Run workflow -> unduh `app-debug.apk` dari Artifacts -> instal di HP.
Bagikan APK yang sama ke semua pengguna.

## 3. Versi web (laptop)
Buka app.netlify.com/drop -> seret folder `www` (yang sudah berisi config.js) -> dapat link. Admin & pengguna bisa memakai link itu di laptop.

## Catatan
- Katalog tersimpan di cache HP: tetap terbuka saat offline (data terakhir). Edit admin butuh internet.
- Pembaruan produk muncul otomatis di HP lain (realtime) atau saat aplikasi dibuka kembali.
- Admin tambahan: buat user baru lalu jalankan insert ke `admins`.
- Visual Search = pencocokan sidik visual foto, bukan AI pengenal objek.
