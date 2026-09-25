# AI Agronomy Engine V5.1 — PUBLIC PRODUCTION

V5.1 adalah upgrade dari V5 untuk penggunaan publik multi-user.

## Yang sudah ada
- Landing page publik
- Registrasi/login Supabase Auth
- Workspace otomatis untuk setiap user
- Isolasi data antar workspace
- PostgreSQL database
- RLS
- Evidence storage
- AI chat
- AI photo analysis
- Risk engine
- Knowledge Base per workspace
- Database blok
- Pemeriksaan pemeliharaan
- Action Center
- Tidak ada angka dashboard simulasi
- Tidak memakai localStorage sebagai database

## Deploy
1. Buat project Supabase.
2. Jalankan `supabase/schema.sql` di SQL Editor.
3. Buat Netlify site dari folder/repository ini.
4. Set environment variables Netlify:
   - SUPABASE_URL
   - SUPABASE_ANON_KEY
   - SUPABASE_SERVICE_ROLE_KEY
   - OPENAI_API_KEY
   - OPENAI_MODEL (opsional)
5. Redeploy.
6. Buka URL publik.
7. Daftar akun baru.
8. Masuk.
9. Tambahkan blok / data pemeriksaan.
10. Tambahkan SOP/GAP perusahaan ke Knowledge Base.
11. Gunakan Tanya AI atau AI Analysis + foto.

## Keamanan
SERVICE_ROLE_KEY dan OPENAI_API_KEY hanya berada di Netlify Functions. Jangan dimasukkan ke HTML/JavaScript.
RLS tetap dipasang di database sebagai lapisan otorisasi.
Untuk peluncuran komersial skala besar, tambahkan payment/subscription, rate limiting, email verification, CAPTCHA/bot protection, audit log, backup, observability, dan review keamanan.

## Knowledge Base
V5.1 menyediakan ruang KB per workspace. Jangan mengklaim isi SNI/ISPO/RSPO sebagai sumber resmi hanya karena judul dokumen ditulis user. Masukkan dokumen resmi yang memang dimiliki/diizinkan untuk digunakan, lalu simpan sumber dan versi dokumen.
Deploy ulang konfigurasi Supabase

## AI safety
AI adalah decision support. Foto tunggal bukan diagnosis final. Dosis pupuk/pestisida, tindakan kimia, dan keputusan sertifikasi harus merujuk pada SOP/dokumen yang relevan dan diverifikasi tenaga berwenang.
