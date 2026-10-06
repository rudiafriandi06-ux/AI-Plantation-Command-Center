# AI Agronomy Engine V5.1 — Public Production

**AI Agronomy Engine V5.1** adalah platform digital **AI-powered agronomy decision support** untuk pengelolaan perkebunan kelapa sawit secara terstruktur, berbasis data, evidence, dan knowledge base perusahaan.

V5.1 dirancang sebagai **public production multi-user application**, dengan setiap pengguna memiliki workspace terisolasi sehingga data blok, pemeriksaan, evidence, knowledge base, dan aktivitas operasional tidak tercampur dengan pengguna lain.

## Core Capabilities

* **Public Landing Page** — akses aplikasi melalui URL publik.
* **Supabase Authentication** — registrasi dan login pengguna.
* **Multi-Workspace Architecture** — setiap pengguna memiliki workspace sendiri.
* **Row Level Security (RLS)** — isolasi dan kontrol akses data pada level PostgreSQL.
* **Block Database** — pengelolaan data blok perkebunan.
* **Maintenance Inspection** — pencatatan dan pemeriksaan kondisi pemeliharaan.
* **Evidence Storage** — penyimpanan foto dan evidence pemeriksaan.
* **AI Chat** — konsultasi agronomi berbasis AI.
* **AI Photo Analysis** — analisis awal kondisi tanaman berdasarkan foto.
* **Risk Engine** — identifikasi risiko, potensi dampak, prioritas, dan tindakan.
* **Workspace Knowledge Base** — penyimpanan SOP, GAP, dan dokumen referensi perusahaan.
* **Action Center** — mengubah hasil analisis menjadi daftar tindakan yang dapat ditindaklanjuti.
* **Data-Driven Dashboard** — dashboard menggunakan data aktual, bukan angka simulasi.
* **No LocalStorage Database** — data operasional disimpan pada PostgreSQL/Supabase.

## Production Architecture

```text
Public Web Application
        │
        ▼
     Netlify
        │
        ├── Frontend
        │
        └── Netlify Functions
                │
                ├── Supabase Auth
                ├── Supabase PostgreSQL
                ├── Supabase Storage
                └── OpenAI API
```

### Security Model

V5.1 menggunakan beberapa lapisan keamanan:

1. **Supabase Auth** untuk autentikasi pengguna.
2. **PostgreSQL RLS** untuk membatasi akses data berdasarkan workspace.
3. **Workspace isolation** untuk mencegah pengguna mengakses data workspace lain.
4. **Server-side secrets** untuk credential sensitif.
5. `SUPABASE_SERVICE_ROLE_KEY` dan `OPENAI_API_KEY` **tidak pernah ditempatkan di frontend**.
6. Data operasional tidak bergantung pada `localStorage`.

## Environment Variables

Konfigurasi production dilakukan melalui environment variables pada Netlify:

```text
SUPABASE_URL
SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE_KEY
OPENAI_API_KEY
OPENAI_MODEL
```

`SUPABASE_SERVICE_ROLE_KEY` dan `OPENAI_API_KEY` hanya digunakan pada **Netlify Functions/server-side environment**.

## Knowledge Base

Knowledge Base tersedia secara terpisah untuk setiap workspace.

Pengguna dapat memasukkan:

* SOP perusahaan
* GAP perkebunan
* standar internal
* instruksi kerja
* dokumen teknis
* referensi agronomi yang memiliki hak penggunaan

Aplikasi **tidak menganggap sebuah dokumen sebagai sumber resmi hanya berdasarkan nama atau judul yang dimasukkan pengguna**.

Untuk setiap dokumen, sebaiknya disimpan:

* nama dokumen
* sumber
* nomor/versi
* tanggal berlaku
* status dokumen
* ruang lingkup penggunaan

## AI Agronomy Safety

AI Agronomy Engine merupakan **decision-support system**, bukan pengganti agronomist atau tenaga berwenang.

Analisis foto digunakan sebagai **indikasi awal**, bukan diagnosis final.

Keputusan terkait:

* dosis pupuk
* aplikasi pestisida
* tindakan kimia
* pengendalian organisme pengganggu tanaman
* keputusan sertifikasi
* tindakan operasional berisiko tinggi

harus mengacu pada SOP/dokumen yang relevan dan diverifikasi oleh personel yang berwenang.

## Deployment

1. Buat project Supabase.
2. Jalankan `supabase/schema.sql` pada Supabase SQL Editor.
3. Deploy repository ke Netlify.
4. Masukkan environment variables production.
5. Redeploy Netlify.
6. Buka URL aplikasi publik.
7. Registrasikan user baru.
8. Login.
9. Buat dan kelola workspace/blok.
10. Masukkan data pemeriksaan.
11. Tambahkan SOP/GAP perusahaan ke Knowledge Base.
12. Gunakan **Tanya AI**, **AI Photo Analysis**, **Risk Engine**, dan **Action Center**.

## Production Roadmap

Untuk penggunaan komersial dengan skala pengguna yang lebih besar, sistem perlu dilengkapi dengan:

* subscription/payment system
* rate limiting
* email verification
* CAPTCHA/bot protection
* audit logging
* automated backup
* monitoring & observability
* error tracking
* security review
* database performance optimization
* disaster recovery

## Project Status

**Version:** V5.1
**Environment:** Public Production
**Architecture:** Multi-user / Multi-workspace
**Database:** PostgreSQL / Supabase
**Authentication:** Supabase Auth
**Backend:** Netlify Functions
**AI:** OpenAI API
**Storage:** Supabase Storage
**Authorization:** PostgreSQL RLS

> **AI Agronomy Engine V5.1 — From field evidence to agronomy decision support and actionable field management.**
