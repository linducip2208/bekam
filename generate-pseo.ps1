# ============================================================
# PSEO Generator — BekamAkhwat
# Generate 1000+ static HTML PSEO pages
# ============================================================
param(
    [string]$DataFile = "pseo-data.json",
    [string]$OutDir = "pseo"
)

$ErrorActionPreference = "Continue"
$startTime = Get-Date
$genCount = 0

# ----------------------------------------------------------
# Read data
# ----------------------------------------------------------
$raw = [System.IO.File]::ReadAllText($DataFile)
$data = $raw | ConvertFrom-Json
$DOMAIN = $data.domain
$PHONE  = $data.phone
$BRAND  = $data.brand

# ----------------------------------------------------------
# Ensure output directories
# ----------------------------------------------------------
$dirs = @("$OutDir", "$OutDir\compare")
foreach ($d in $dirs) {
    if (-not (Test-Path -LiteralPath $d)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
    }
}

# ----------------------------------------------------------
# UTILITY: simple template replacement
# ----------------------------------------------------------
function Apply($tmpl, $map) {
    $r = $tmpl
    foreach ($k in $map.Keys) {
        $r = $r.Replace($k, $map[$k])
    }
    return $r
}

# ----------------------------------------------------------
# HTML fragments (single-quoted, use {{PLACEHOLDER}} tokens)
# ----------------------------------------------------------

$H_TOP = @'
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{TITLE}}</title>
    <meta name="description" content="{{DESC}}">
    <link rel="canonical" href="{{CANONICAL}}">
    <meta property="og:title" content="{{TITLE}}">
    <meta property="og:description" content="{{DESC}}">
    <meta property="og:type" content="website">
    <meta property="og:url" content="{{CANONICAL}}">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="{{TITLE}}">
    <meta name="twitter:description" content="{{DESC}}">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: { 50: '#ecfdf5', 100: '#d1fae5', 200: '#a7f3d0', 300: '#6ee7b7', 400: '#34d399', 500: '#059669', 600: '#047857', 700: '#065f46', 800: '#064e3b', 900: '#022c22' },
                        gold: { 400: '#D4A574', 500: '#C4956A', 600: '#B08560' }
                    },
                    fontFamily: { display: ['"Playfair Display"','serif'], body: ['"Inter"','sans-serif'] }
                }
            }
        }
    </script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Playfair+Display:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Cpath fill='%23dc2626' d='M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z'/%3E%3C/svg%3E">
    <link rel="stylesheet" href="../css/style.css">
    <!-- Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-VZ0QB43NJQ"></script>
    <script>window.dataLayer=window.dataLayer||[];function gtag(){dataLayer.push(arguments);}gtag('js',new Date());gtag('config','G-VZ0QB43NJQ');</script>
    <script type="application/ld+json">{{JSONLD}}</script>
</head>
<body class="font-body bg-white text-stone-800 antialiased">

<header class="fixed top-0 left-0 right-0 z-50 bg-white/80 backdrop-blur-xl border-b border-stone-100">
    <nav class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16 lg:h-18">
            <a href="/" class="flex items-center gap-2.5 group">
                <div class="w-9 h-9 bg-gradient-to-br from-brand-500 to-brand-700 rounded-xl flex items-center justify-center text-white text-lg shadow-lg shadow-brand-500/20 group-hover:shadow-brand-500/40 transition-shadow">&#9764;</div>
                <span class="font-display font-bold text-xl text-brand-800">Bekam<span class="text-gold-500">Akhwat</span></span>
            </a>

            <div class="hidden lg:flex items-center gap-8">
                <a href="../" class="text-sm font-medium text-stone-600 hover:text-brand-600 transition-colors">Beranda</a>
                <a href="../tentang.html" class="text-sm font-medium text-stone-600 hover:text-brand-600 transition-colors">Tentang</a>
                <a href="../layanan.html" class="text-sm font-medium text-stone-600 hover:text-brand-600 transition-colors">Layanan</a>
                <a href="../blog.html" class="text-sm font-medium text-stone-600 hover:text-brand-600 transition-colors">Blog</a>
                <a href="../kontak.html" class="text-sm font-medium text-stone-600 hover:text-brand-600 transition-colors">Kontak</a>
            </div>

            <div class="flex items-center gap-3">
                <a href="https://wa.me/PHONE_PLACEHOLDER?text=Assalamu'alaikum%2C%20saya%20ingin%20booking%20bekam" target="_blank" rel="noopener" class="hidden sm:inline-flex items-center gap-2 bg-brand-600 hover:bg-brand-700 text-white text-sm font-semibold px-5 py-2.5 rounded-xl shadow-lg shadow-brand-500/25 hover:shadow-brand-500/40 transition-all hover:-translate-y-0.5">
                    <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/></svg>
                    Booking via WA
                </a>
                <button id="menu-toggle" class="lg:hidden p-2 rounded-lg hover:bg-stone-100 transition-colors" aria-label="Menu">
                    <svg class="w-6 h-6 text-stone-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/></svg>
                </button>
            </div>
        </div>
        <div id="mobile-menu" class="lg:hidden hidden pb-4 space-y-1">
            <a href="../" class="block px-3 py-2 rounded-lg text-sm font-medium text-stone-600 hover:bg-stone-50">Beranda</a>
            <a href="../tentang.html" class="block px-3 py-2 rounded-lg text-sm font-medium text-stone-600 hover:bg-stone-50">Tentang</a>
            <a href="../layanan.html" class="block px-3 py-2 rounded-lg text-sm font-medium text-stone-600 hover:bg-stone-50">Layanan</a>
            <a href="../blog.html" class="block px-3 py-2 rounded-lg text-sm font-medium text-stone-600 hover:bg-stone-50">Blog</a>
            <a href="../kontak.html" class="block px-3 py-2 rounded-lg text-sm font-medium text-stone-600 hover:bg-stone-50">Kontak</a>
        </div>
    </nav>
</header>
<main>
'@

$H_HERO = @'
<section class="pt-28 pb-12 lg:pt-36 lg:pb-16 bg-gradient-to-br from-brand-50 via-white to-emerald-50 relative overflow-hidden">
    <div class="absolute inset-0 opacity-15" style="background-image: radial-gradient(circle at 20% 50%, #059669 0%, transparent 50%), radial-gradient(circle at 80% 20%, #D4A574 0%, transparent 40%)"></div>
    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center reveal max-w-4xl mx-auto">
            <div class="inline-flex items-center gap-2 bg-white/80 backdrop-blur border border-brand-200 rounded-full px-4 py-1.5 text-xs font-semibold text-brand-700 mb-6 shadow-sm">
                <span class="w-2 h-2 bg-brand-500 rounded-full animate-pulse"></span>
                Khusus Muslimah & Akhwat
            </div>
            <h1 class="font-display text-3xl sm:text-4xl lg:text-5xl font-bold leading-tight text-stone-900 mb-6">{{H1}}</h1>
            <p class="text-lg text-stone-600 leading-relaxed mb-8 max-w-2xl mx-auto">{{SUB}}</p>
            <div class="flex flex-wrap justify-center gap-3">
                <a href="https://wa.me/PHONE_PLACEHOLDER?text=Assalamu'alaikum%2C%20saya%20ingin%20booking%20bekam" target="_blank" rel="noopener" class="inline-flex items-center gap-2 bg-brand-600 hover:bg-brand-700 text-white font-semibold px-6 py-3.5 rounded-xl shadow-xl shadow-brand-500/30 hover:shadow-brand-500/40 transition-all hover:-translate-y-0.5 text-base">
                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/></svg>
                    Booking Sekarang
                </a>
                <a href="../layanan.html" class="inline-flex items-center gap-2 bg-white hover:bg-stone-50 text-stone-700 font-semibold px-6 py-3.5 rounded-xl border border-stone-200 shadow-sm hover:shadow-md transition-all hover:-translate-y-0.5 text-base">
                    Lihat Layanan
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
                </a>
            </div>
        </div>
    </div>
</section>
'@

$H_CTA = @'
<section class="py-16 lg:py-20 bg-gradient-to-br from-brand-600 to-brand-800 text-white relative overflow-hidden">
    <div class="absolute inset-0 opacity-10" style="background-image: radial-gradient(circle at 50% 50%, #fff 0%, transparent 70%)"></div>
    <div class="relative max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <h2 class="font-display text-3xl lg:text-4xl font-bold mb-4">{{CTATITLE}}</h2>
        <p class="text-brand-100 text-lg mb-8">{{CTADESC}}</p>
        <a href="https://wa.me/PHONE_PLACEHOLDER?text=Assalamu'alaikum%2C%20saya%20ingin%20booking%20bekam" target="_blank" rel="noopener" class="inline-flex items-center gap-2 bg-white hover:bg-brand-50 text-brand-700 font-bold px-8 py-4 rounded-xl shadow-2xl transition-all hover:-translate-y-0.5 text-lg">Booking via WhatsApp</a>
    </div>
</section>
'@

$H_BOTTOM = @'
</main>
<footer class="bg-stone-900 text-stone-400 py-12 lg:py-16">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid md:grid-cols-4 gap-8 mb-10">
            <div class="md:col-span-1">
                <a href="/" class="flex items-center gap-2.5 mb-4">
                    <div class="w-9 h-9 bg-gradient-to-br from-brand-500 to-brand-700 rounded-xl flex items-center justify-center text-white text-lg">&#9764;</div>
                    <span class="font-display font-bold text-xl text-white">Bekam<span class="text-gold-400">Akhwat</span></span>
                </a>
                <p class="text-sm leading-relaxed text-stone-500">Klinik bekam syar'iyyah khusus wanita & akhwat. Privasi terjaga, terapis muslimah profesional.</p>
            </div>
            <div><h4 class="font-semibold text-white mb-4 text-sm uppercase tracking-wider">Menu</h4>
            <ul class="space-y-2 text-sm">
                <li><a href="../" class="hover:text-white transition-colors">Beranda</a></li>
                <li><a href="../tentang.html" class="hover:text-white transition-colors">Tentang Kami</a></li>
                <li><a href="../layanan.html" class="hover:text-white transition-colors">Layanan</a></li>
                <li><a href="../blog.html" class="hover:text-white transition-colors">Blog</a></li>
                <li><a href="../kontak.html" class="hover:text-white transition-colors">Kontak</a></li>
            </ul></div>
            <div><h4 class="font-semibold text-white mb-4 text-sm uppercase tracking-wider">Layanan</h4>
            <ul class="space-y-2 text-sm">
                <li><a href="../layanan.html" class="hover:text-white transition-colors">Bekam Kering</a></li>
                <li><a href="../layanan.html" class="hover:text-white transition-colors">Bekam Basah</a></li>
                <li><a href="../layanan.html" class="hover:text-white transition-colors">Bekam + Ruqyah</a></li>
            </ul></div>
            <div><h4 class="font-semibold text-white mb-4 text-sm uppercase tracking-wider">Kontak</h4>
            <ul class="space-y-2 text-sm">
                <li class="flex items-center gap-2"><svg class="w-4 h-4 text-brand-400 flex-shrink-0" fill="currentColor" viewBox="0 0 24 24"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/></svg><a href="https://wa.me/PHONE_PLACEHOLDER" class="hover:text-white transition-colors">0821-1783-4032</a></li>
                <li class="flex items-center gap-2"><svg class="w-4 h-4 text-brand-400 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/></svg><span>Jl. Kampung Bahari 2 No. 34, Tanjung Priok, Jakarta Utara</span></li>
            </ul></div>
        </div>
        <div class="border-t border-stone-700 pt-8 mb-6">
            <div id="visitor-stats" class="flex flex-wrap justify-center gap-3 md:gap-5 text-center">
                <div class="stats-item bg-stone-800/50 backdrop-blur rounded-xl px-5 py-3 border border-stone-700 min-w-[100px]">
                    <div class="text-2xl font-bold text-brand-400 font-display" id="stat-online">-</div>
                    <div class="text-xs text-stone-400 mt-0.5">Online</div>
                </div>
                <div class="stats-item bg-stone-800/50 backdrop-blur rounded-xl px-5 py-3 border border-stone-700 min-w-[100px]">
                    <div class="text-2xl font-bold text-brand-400 font-display" id="stat-today">-</div>
                    <div class="text-xs text-stone-400 mt-0.5">Hari Ini</div>
                </div>
                <div class="stats-item bg-stone-800/50 backdrop-blur rounded-xl px-5 py-3 border border-stone-700 min-w-[100px]">
                    <div class="text-2xl font-bold text-brand-400 font-display" id="stat-total">-</div>
                    <div class="text-xs text-stone-400 mt-0.5">Total Pengunjung</div>
                </div>
                <div class="stats-item bg-stone-800/50 backdrop-blur rounded-xl px-5 py-3 border border-stone-700 min-w-[100px]">
                    <div class="text-2xl font-bold text-brand-400 font-display" id="stat-pageviews">-</div>
                    <div class="text-xs text-stone-400 mt-0.5">Total Tayangan</div>
                </div>
            </div>
            <div id="stats-error" class="hidden text-center text-xs text-stone-500 mt-3"></div>
        </div>
        <div class="border-t border-stone-800 pt-8 flex flex-col sm:flex-row justify-between items-center gap-4 text-sm text-stone-500">
            <p>&copy; 2026 BekamAkhwat. Seluruh hak cipta dilindungi.</p>
            <p class="text-xs">Dibuat dengan &#128150; untuk kesehatan muslimah Indonesia</p>
        </div>
    </div>
</footer>

<a href="https://wa.me/PHONE_PLACEHOLDER?text=Assalamu'alaikum%2C%20saya%20ingin%20booking%20bekam" target="_blank" rel="noopener" class="fixed bottom-6 right-6 z-50 w-14 h-14 bg-green-500 hover:bg-green-600 text-white rounded-full shadow-xl shadow-green-500/30 hover:shadow-green-500/50 flex items-center justify-center transition-all hover:-translate-y-1" style="animation: floatSlow 5s ease-in-out infinite" aria-label="Chat WhatsApp">
    <svg class="w-7 h-7" fill="currentColor" viewBox="0 0 24 24"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/></svg>
</a>

<script src="../js/main.js"></script>
<style>
    @keyframes floatSlow { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-12px)} }
    .card-lift { transition:transform .35s,box-shadow .35s }
    .card-lift:hover { transform:translateY(-6px);box-shadow:0 24px 48px -12px rgba(0,0,0,.18) }
    .reveal { opacity:0;transform:translateY(30px);transition:opacity .7s,transform .7s cubic-bezier(.16,1,.3,1) }
    .reveal.visible { opacity:1;transform:translateY(0) }
</style>
<script>
    document.getElementById('menu-toggle').addEventListener('click', function() {
        document.getElementById('mobile-menu').classList.toggle('hidden');
    });
    (function() {
        var observer = new IntersectionObserver(function(entries) {
            entries.forEach(function(e) { if (e.isIntersecting) e.target.classList.add('visible'); });
        }, { threshold: 0.15 });
        document.querySelectorAll('.reveal').forEach(function(el) { observer.observe(el); });
    })();
</script>
</body>
</html>
'@

# ----------------------------------------------------------
# CONTENT: City page paragraphs
# ----------------------------------------------------------
$CITY_P1A = '<p class="mb-4">Bekam merupakan terapi sunnah yang telah terbukti secara ilmiah mampu mengatasi berbagai keluhan kesehatan. Bagi muslimah di <strong>{{N}}</strong> dan sekitarnya, kini telah hadir <strong>{{B}}</strong> - klinik bekam syariyyah <strong>khusus wanita</strong> yang mengutamakan privasi, kenyamanan, dan keamanan sesuai tuntunan Islam. Kami memahami bahwa sebagai akhwat, Anda membutuhkan tempat bekam yang benar-benar aman tanpa kehadiran laki-laki. Di sinilah kami hadir sebagai solusi.</p>'
$CITY_P1B = '<p class="mb-4">{{B}} melayani terapi bekam untuk muslimah di <strong>{{N}}</strong> dengan standar profesional. Seluruh terapis kami adalah <strong>wanita muslimah bersertifikat</strong> yang telah berpengalaman menangani ribuan pasien. Kami menggunakan alat <strong>disposable (sekali pakai)</strong> - satu pasien satu set - sehingga Anda tidak perlu khawatir tentang kebersihan dan sterilisasi. Lingkungan klinik kami islami, bersih, dan nyaman.</p>'
$CITY_P1C = '<p class="mb-4">Bagi Anda yang tinggal di <strong>{{P}}</strong>, khususnya wilayah <strong>{{N}}</strong>, akses ke klinik bekam khusus muslimah kini semakin mudah. Tidak perlu lagi khawatir tentang privasi saat berbekam. Ruang terapi kami <strong>tertutup rapat</strong>, satu ruang untuk satu pasien, sehingga aurat Anda terjaga sepenuhnya selama proses terapi berlangsung. Inilah yang membedakan kami dari tempat bekam umum.</p>'
$CITY_P1D = '<p class="mb-4">Kami berlokasi di <strong>Jakarta Utara</strong> dan mudah dijangkau dari berbagai wilayah termasuk <strong>{{N}}</strong>. Banyak pasien kami yang datang dari {{P}} dan merasa puas dengan pelayanan eksklusif khusus muslimah yang kami tawarkan. Jika Anda mencari tempat bekam yang benar-benar memahami kebutuhan muslimah, {{B}} adalah jawabannya.</p>'

$CITY_P2A = '<h2 class="font-display text-2xl font-bold text-stone-900 mb-4 mt-8">Mengapa Memilih Bekam di {{N}}?</h2><p class="mb-4">Masyarakat <strong>{{N}}</strong> dan {{P}} pada umumnya semakin sadar akan pentingnya pengobatan sunnah. Bekam tidak hanya menyembuhkan secara fisik, tetapi juga menjadi sarana menjalankan sunnah Rasulullah SAW. Dengan berbekam di tempat yang tepat, Anda mendapatkan <strong>dua manfaat sekaligus</strong>: kesehatan jasmani dan pahala mengikuti sunnah.</p><p class="mb-4">Rasulullah SAW bersabda: <em>Sesungguhnya sebaik-baik pengobatan yang kalian lakukan adalah bekam (hijamah).</em> (HR. Bukhari & Muslim). Hadits ini menjadi landasan utama kami dalam memberikan pelayanan bekam yang sesuai syariat, dipadukan dengan standar medis modern untuk hasil yang optimal.</p><p class="mb-4">Banyak muslimah di <strong>{{N}}</strong> yang telah merasakan manfaat luar biasa dari terapi bekam. Mulai dari meredakan migrain kronis, menurunkan darah tinggi, mengatasi pegal linu, hingga meningkatkan kualitas tidur. Bekam juga terbukti efektif untuk membantu mengatasi gangguan hormonal pada wanita, termasuk masalah haid dan kesuburan.</p>'

$CITY_P2B = '<h2 class="font-display text-2xl font-bold text-stone-900 mb-4 mt-8">Layanan Bekam untuk Muslimah {{N}}</h2><p class="mb-4">Kami menyediakan tiga jenis layanan bekam utama yang bisa disesuaikan dengan kebutuhan Anda. <strong>Bekam Kering</strong> (Rp 150.000/sesi) cocok untuk pemula dan perawatan rutin - menggunakan hisapan tanpa sayatan untuk melancarkan peredaran darah dan meredakan nyeri otot. <strong>Bekam Basah/Hijamah</strong> (Rp 250.000/sesi) adalah metode sunnah dengan sayatan ringan untuk mengeluarkan toksin dan darah kotor. <strong>Bekam + Ruqyah</strong> (Rp 350.000/sesi) menggabungkan terapi fisik dan spiritual untuk penyembuhan holistik.</p><p class="mb-4">Setiap sesi dimulai dengan konsultasi singkat untuk memahami keluhan Anda. Terapis kami akan menjelaskan prosedur, memilih titik bekam yang tepat, dan memastikan Anda nyaman selama terapi. Untuk muslimah di <strong>{{N}}</strong> yang baru pertama kali bekam, kami sarankan memulai dengan bekam kering terlebih dahulu.</p>'

$CITY_P2C = '<h2 class="font-display text-2xl font-bold text-stone-900 mb-4 mt-8">Manfaat Bekam untuk Wanita</h2><p class="mb-4">Bekam memiliki manfaat yang sangat beragam, terutama bagi wanita. Secara ilmiah, bekam membantu melancarkan peredaran darah, mengurangi peradangan, memperkuat sistem imun, dan membuang toksin dari dalam tubuh. Bagi muslimah di <strong>{{N}}</strong> dan sekitarnya, bekam juga terbukti membantu mengatasi masalah kewanitaan seperti nyeri haid, haid tidak lancar, keputihan, dan gangguan hormonal.</p><p class="mb-4">Yang lebih penting, bekam adalah sunnah Rasulullah SAW yang memiliki nilai ibadah. Dengan niat yang benar, setiap sesi bekam yang Anda jalani bernilai pahala di sisi Allah SWT. Inilah keistimewaan pengobatan islami yang tidak dimiliki metode pengobatan konvensional.</p>'

$CITY_BENEFITS = '<div class="mt-12 grid sm:grid-cols-3 gap-6"><div class="bg-brand-50 rounded-2xl p-6 text-center card-lift"><div class="text-3xl mb-3">&#128105;&#8205;&#9877;&#65039;</div><h4 class="font-semibold text-stone-800 mb-1">Terapis Wanita</h4><p class="text-xs text-stone-500">100% muslimah bersertifikat</p></div><div class="bg-brand-50 rounded-2xl p-6 text-center card-lift"><div class="text-3xl mb-3">&#128737;&#65039;</div><h4 class="font-semibold text-stone-800 mb-1">Privasi Terjaga</h4><p class="text-xs text-stone-500">Ruang tertutup satu pasien</p></div><div class="bg-brand-50 rounded-2xl p-6 text-center card-lift"><div class="text-3xl mb-3">&#128308;</div><h4 class="font-semibold text-stone-800 mb-1">Alat Steril</h4><p class="text-xs text-stone-500">Disposable sekali pakai</p></div></div>'

# ----------------------------------------------------------
# CONTENT: Condition page paragraphs
# ----------------------------------------------------------
$COND_P1A = '<p class="mb-4"><strong>{{N}}</strong> ({{D}}) merupakan salah satu keluhan kesehatan yang sering dialami oleh banyak wanita. Kondisi ini bisa sangat mengganggu aktivitas sehari-hari dan menurunkan kualitas hidup. Kabar baiknya, terapi bekam telah terbukti secara ilmiah maupun berdasarkan pengalaman empiris mampu membantu meredakan dan mengatasi kondisi {{D}} ini.</p>'
$COND_P1B = '<p class="mb-4">Bagi muslimah yang mengalami <strong>{{N}}</strong>, bekam bisa menjadi solusi pengobatan sunnah yang aman dan efektif. Metode bekam bekerja dengan cara memperbaiki sirkulasi darah, mengeluarkan toksin dari tubuh, dan merangsang titik-titik akupuntur alami yang berkaitan dengan penyembuhan berbagai keluhan termasuk {{D}}.</p>'
$COND_P1C = '<p class="mb-4">Penelitian modern telah menunjukkan bahwa bekam dapat membantu mengurangi peradangan, meningkatkan sistem imun, dan memperbaiki fungsi organ tubuh. Untuk kasus <strong>{{N}}</strong> ({{D}}), bekam bekerja dengan cara melancarkan aliran darah ke area yang bermasalah dan membuang zat-zat patogen yang menyebabkan keluhan.</p>'

$COND_P2A = '<h2 class="font-display text-2xl font-bold text-stone-900 mb-4 mt-8">Bagaimana Bekam Membantu Mengatasi {{N}}?</h2><p class="mb-4">Mekanisme bekam dalam membantu mengatasi <strong>{{N}}</strong> melibatkan beberapa proses fisiologis. Pertama, hisapan bekam menciptakan tekanan negatif yang membuka pembuluh darah kapiler dan meningkatkan aliran darah ke area yang diterapi. Kedua, sayatan ringan pada bekam basah membantu mengeluarkan sel darah merah yang rusak, kolesterol jahat, asam urat, dan toksin lainnya dari dalam tubuh.</p><p class="mb-4">Ketiga, bekam merangsang sistem saraf dan pelepasan endorfin - hormon alami tubuh yang berfungsi sebagai pereda nyeri. Inilah mengapa banyak pasien merasakan efek relaksasi dan perbaikan kondisi setelah menjalani terapi, termasuk mereka yang mengalami {{D}}. Kombinasi ketiga mekanisme ini menjadikan bekam sebagai terapi holistik yang komprehensif.</p><p class="mb-4">Untuk hasil yang optimal dalam mengatasi <strong>{{N}}</strong>, disarankan melakukan bekam secara rutin sesuai anjuran. Umumnya, bekam dilakukan sebulan sekali untuk perawatan, atau lebih sering sesuai tingkat keparahan keluhan. Terapis kami akan memberikan rekomendasi frekuensi yang tepat setelah konsultasi awal.</p>'

$COND_P2B = '<h2 class="font-display text-2xl font-bold text-stone-900 mb-4 mt-8">Titik Bekam untuk {{N}}</h2><p class="mb-4">Dalam pengobatan bekam, pemilihan titik sangat penting untuk efektivitas terapi. Untuk mengatasi <strong>{{N}}</strong> ({{D}}), terapis kami akan memilih titik-titik bekam yang sesuai berdasarkan keluhan dan kondisi Anda. Titik bekam dipilih secara individual setelah konsultasi dan pemeriksaan singkat.</p><p class="mb-4">Setiap pasien memiliki kondisi yang unik, sehingga pendekatan terapi juga bersifat personal. Terapis kami yang berpengalaman akan menyesuaikan jumlah cup, durasi hisapan, dan titik bekam berdasarkan kebutuhan spesifik Anda. Dengan pendekatan personal ini, hasil terapi menjadi lebih maksimal.</p>'

$COND_NOTE = '<div class="mt-12 p-6 bg-amber-50 border border-amber-200 rounded-2xl"><h3 class="font-display font-bold text-lg text-stone-900 mb-2">&#128221; Catatan Penting</h3><p class="text-sm text-stone-600">Hasil terapi bekam bersifat individual. Setiap pasien memiliki respons berbeda. Kami sarankan konsultasi terlebih dahulu dengan terapis kami untuk menentukan apakah bekam cocok untuk kondisi Anda. Bekam bukan pengganti pengobatan medis - selalu konsultasikan dengan dokter untuk kondisi serius.</p></div>'

# ----------------------------------------------------------
# CONTENT: Tips page
# ----------------------------------------------------------
$TIPS_INTROA = '<p class="mb-4">{{D}} merupakan topik yang sering ditanyakan oleh muslimah yang ingin memulai terapi bekam. Memahami {{N}} dengan baik akan membantu Anda mendapatkan manfaat maksimal dari terapi bekam syariyyah.</p>'
$TIPS_INTROB = '<p class="mb-4">Dalam artikel ini, kami dari <strong>{{B}}</strong> akan membagikan informasi lengkap seputar <strong>{{N}}</strong> berdasarkan pengalaman kami melayani ribuan pasien muslimah. Semoga bermanfaat dan menambah wawasan Anda tentang terapi sunnah yang mulia ini.</p>'
$TIPS_BODY = '<h2 class="font-display text-2xl font-bold text-stone-900 mb-4 mt-8">Panduan Lengkap {{N}}</h2><p class="mb-4">Berikut adalah penjelasan lengkap mengenai <strong>{{N}}</strong> yang penting diketahui setiap muslimah yang ingin menjalani terapi bekam:</p><div class="space-y-4 mt-6"><div class="flex items-start gap-3 bg-brand-50/50 rounded-xl p-4 border border-brand-100"><div class="w-8 h-8 bg-brand-500 rounded-lg flex items-center justify-center text-white font-bold text-sm flex-shrink-0">1</div><div><h4 class="font-semibold text-stone-800 mb-1">Pahami Dasar {{N}}</h4><p class="text-sm text-stone-600">Pelajari dasar-dasar {{N}} dari sumber yang terpercaya dan sesuai tuntunan syariat. Jangan ragu untuk berkonsultasi dengan terapis profesional kami.</p></div></div><div class="flex items-start gap-3 bg-brand-50/50 rounded-xl p-4 border border-brand-100"><div class="w-8 h-8 bg-brand-500 rounded-lg flex items-center justify-center text-white font-bold text-sm flex-shrink-0">2</div><div><h4 class="font-semibold text-stone-800 mb-1">Konsultasi dengan Terapis</h4><p class="text-sm text-stone-600">Setiap orang memiliki kondisi berbeda. Konsultasikan kondisi Anda dengan terapis kami untuk mendapatkan rekomendasi yang tepat seputar {{N}}.</p></div></div><div class="flex items-start gap-3 bg-brand-50/50 rounded-xl p-4 border border-brand-100"><div class="w-8 h-8 bg-brand-500 rounded-lg flex items-center justify-center text-white font-bold text-sm flex-shrink-0">3</div><div><h4 class="font-semibold text-stone-800 mb-1">Ikuti Anjuran Sunnah</h4><p class="text-sm text-stone-600">Pastikan setiap langkah terkait {{N}} sesuai dengan tuntunan Rasulullah SAW untuk mendapatkan keberkahan dan manfaat optimal.</p></div></div><div class="flex items-start gap-3 bg-brand-50/50 rounded-xl p-4 border border-brand-100"><div class="w-8 h-8 bg-brand-500 rounded-lg flex items-center justify-center text-white font-bold text-sm flex-shrink-0">4</div><div><h4 class="font-semibold text-stone-800 mb-1">Lakukan Secara Konsisten</h4><p class="text-sm text-stone-600">Konsistensi adalah kunci. Lakukan terapi bekam secara rutin sesuai anjuran untuk hasil yang maksimal dan berkelanjutan.</p></div></div></div>'

# ----------------------------------------------------------
# CONTENT: Compare page
# ----------------------------------------------------------
$COMP_TMPL = '<p class="mb-4">Banyak muslimah yang bingung memilih antara <strong>{{A}}</strong> dan <strong>{{B}}</strong>. Keduanya merupakan metode pengobatan yang populer, namun memiliki karakteristik, manfaat, dan pendekatan yang berbeda. Artikel ini akan membantu Anda memahami perbedaan keduanya sehingga bisa memilih yang paling sesuai dengan kebutuhan.</p><h2 class="font-display text-2xl font-bold text-stone-900 mb-4 mt-8">Apa Itu {{A}}?</h2><p class="mb-4">{{A}} merupakan salah satu metode terapi yang banyak digunakan dalam konteks {{CTX}}. Metode ini memiliki keunggulan dan karakteristik tersendiri yang membedakannya dari {{B}}.</p><h2 class="font-display text-2xl font-bold text-stone-900 mb-4 mt-8">Apa Itu {{B}}?</h2><p class="mb-4">Di sisi lain, {{B}} adalah {{CTX}} dengan pendekatan yang berbeda. Kedua metode ini memiliki kelebihan dan kekurangannya masing-masing, dan pemilihan yang tepat sangat bergantung pada kondisi dan kebutuhan individu.</p><h2 class="font-display text-2xl font-bold text-stone-900 mb-4 mt-8">Perbandingan {{A}} vs {{B}}</h2><div class="overflow-x-auto mt-6 mb-8"><table class="w-full bg-white rounded-xl border border-stone-200 overflow-hidden text-sm"><thead><tr class="bg-brand-500 text-white"><th class="p-4 text-left font-semibold">Aspek</th><th class="p-4 text-left font-semibold">{{A}}</th><th class="p-4 text-left font-semibold">{{B}}</th></tr></thead><tbody><tr class="border-t border-stone-100"><td class="p-4 font-medium text-stone-700">Metode</td><td class="p-4 text-stone-600">Hisapan + sayatan ringan</td><td class="p-4 text-stone-600">Sesuai karakteristik</td></tr><tr class="border-t border-stone-100 bg-stone-50"><td class="p-4 font-medium text-stone-700">Efek Samping</td><td class="p-4 text-stone-600">Minimal, hanya bekas merah sementara</td><td class="p-4 text-stone-600">Tergantung metode</td></tr><tr class="border-t border-stone-100"><td class="p-4 font-medium text-stone-700">Waktu Terapi</td><td class="p-4 text-stone-600">45-90 menit</td><td class="p-4 text-stone-600">Bervariasi</td></tr><tr class="border-t border-stone-100 bg-stone-50"><td class="p-4 font-medium text-stone-700">Landasan</td><td class="p-4 text-stone-600">Sunnah Rasulullah SAW</td><td class="p-4 text-stone-600">Tergantung metode</td></tr></tbody></table></div><p class="mb-4">Kesimpulannya, <strong>{{A}}</strong> memiliki keunggulan sebagai terapi sunnah yang telah terbukti selama ribuan tahun dan dianjurkan langsung oleh Rasulullah SAW. Baik {{A}} maupun {{B}} bisa menjadi pilihan pengobatan yang bermanfaat bila dilakukan oleh praktisi yang kompeten.</p>'

# ----------------------------------------------------------
# CONTENT: Source Code SEO
# ----------------------------------------------------------
$SC_P = @(
'<p class="mb-4">Di era digital seperti sekarang, mengelola klinik bekam secara manual sudah tidak efisien lagi. <strong>Aplikasi klinik bekam</strong> hadir sebagai solusi modern untuk mengotomatisasi seluruh operasional klinik - mulai dari booking pasien, manajemen antrian, pencatatan rekam medis, hingga laporan keuangan. Dengan aplikasi yang tepat, Anda bisa fokus melayani pasien sementara sistem bekerja mengelola administrasi.</p>',
'<p class="mb-4">Kami menyediakan <strong>source code aplikasi bekam</strong> yang bisa Anda beli dan gunakan untuk bisnis klinik bekam Anda. Source code ini dirancang khusus untuk kebutuhan klinik bekam - lengkap dengan fitur booking online, manajemen pasien, pencatatan terapi, invoicing, dan dashboard laporan. Semua sudah siap pakai, tinggal install dan jalankan.</p>',
'<p class="mb-4">Source code aplikasi bekam kami dijual dengan lisensi <strong>whitelabel</strong> - artinya Anda bisa rebranding, modifikasi, dan menjual kembali software ini dengan merek Anda sendiri. Cocok untuk developer yang ingin menawarkan solusi software ke klinik-klinik bekam di Indonesia, atau untuk pemilik klinik yang ingin memiliki sistem sendiri.</p>'
)

$SC_FEATURES = '<h2 class="font-display text-2xl font-bold text-stone-900 mb-4 mt-8">Fitur Unggulan Aplikasi Bekam</h2><div class="grid sm:grid-cols-2 gap-4 mt-6 mb-8"><div class="flex items-start gap-3 bg-brand-50/50 rounded-xl p-4 border border-brand-100"><svg class="w-5 h-5 text-brand-500 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg><div><h4 class="font-semibold text-stone-800 mb-1">Booking Online</h4><p class="text-sm text-stone-600">Pasien bisa booking via website/WhatsApp terintegrasi</p></div></div><div class="flex items-start gap-3 bg-brand-50/50 rounded-xl p-4 border border-brand-100"><svg class="w-5 h-5 text-brand-500 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg><div><h4 class="font-semibold text-stone-800 mb-1">Rekam Medis Digital</h4><p class="text-sm text-stone-600">Catatan terapi, titik bekam, progress pasien tersimpan rapi</p></div></div><div class="flex items-start gap-3 bg-brand-50/50 rounded-xl p-4 border border-brand-100"><svg class="w-5 h-5 text-brand-500 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg><div><h4 class="font-semibold text-stone-800 mb-1">Manajemen Stok</h4><p class="text-sm text-stone-600">Pantau stok alat bekam & disposable</p></div></div><div class="flex items-start gap-3 bg-brand-50/50 rounded-xl p-4 border border-brand-100"><svg class="w-5 h-5 text-brand-500 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg><div><h4 class="font-semibold text-stone-800 mb-1">Laporan Keuangan</h4><p class="text-sm text-stone-600">Dashboard revenue, laporan harian/bulanan</p></div></div><div class="flex items-start gap-3 bg-brand-50/50 rounded-xl p-4 border border-brand-100"><svg class="w-5 h-5 text-brand-500 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg><div><h4 class="font-semibold text-stone-800 mb-1">Multi-Terapis</h4><p class="text-sm text-stone-600">Atur jadwal & assignment terapis</p></div></div><div class="flex items-start gap-3 bg-brand-50/50 rounded-xl p-4 border border-brand-100"><svg class="w-5 h-5 text-brand-500 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg><div><h4 class="font-semibold text-stone-800 mb-1">Whitelabel Ready</h4><p class="text-sm text-stone-600">Bisa di-rebrand dengan nama klinik sendiri</p></div></div></div>'

$SC_CTA = '<div class="bg-gradient-to-br from-brand-600 to-brand-800 rounded-2xl p-8 text-white text-center mt-8"><h3 class="font-display text-2xl font-bold mb-3">Ingin Punya Aplikasi Bekam Sendiri?</h3><p class="text-brand-100 mb-6">Dapatkan source code aplikasi bekam lengkap dengan lisensi whitelabel. Bisa dijual kembali ke klinik lain.</p><a href="https://wa.me/PHONE_PLACEHOLDER?text=Assalamu%27alaikum%2C%20saya%20tertarik%20dengan%20source%20code%20aplikasi%20bekam" target="_blank" rel="noopener" class="inline-flex items-center gap-2 bg-white hover:bg-brand-50 text-brand-700 font-bold px-8 py-3.5 rounded-xl shadow-xl transition-all hover:-translate-y-0.5"><svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/></svg>Tanya via WhatsApp</a></div>'

# ----------------------------------------------------------
# JSON-LD helpers
# ----------------------------------------------------------
function Get-JSONLD($type, $name, $desc) {
    return ('{"@context":"https://schema.org","@type":"' + $type + '","name":"BekamAkhwat - ' + $name + '","description":"' + $desc + '","url":"' + $DOMAIN + '","telephone":"+62' + $PHONE + '","address":{"@type":"PostalAddress","streetAddress":"Jl. Kampung Bahari 2 No. 34","addressLocality":"Tanjung Priok","addressRegion":"Jakarta Utara","addressCountry":"ID"},"areaServed":"Indonesia"}')
}

# ----------------------------------------------------------
# WRITE OUTPUT
# ----------------------------------------------------------
function Write-Page($path, $content) {
    $parent = Split-Path -Parent $path
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    [System.IO.File]::WriteAllText($path, $content, [System.Text.UTF8Encoding]::new($false))
    $script:genCount++
}

function Build-Page($title, $desc, $canonical, $jsonld, $h1, $sub, $body, $ctaTitle, $ctaDesc) {
    $top = $H_TOP.Replace('{{TITLE}}',$title).Replace('{{DESC}}',$desc).Replace('{{CANONICAL}}',$canonical).Replace('{{JSONLD}}',$jsonld)
    $top = $top.Replace('PHONE_PLACEHOLDER',$PHONE)
    $hero = $H_HERO.Replace('{{H1}}',$h1).Replace('{{SUB}}',$sub).Replace('PHONE_PLACEHOLDER',$PHONE)
    $cta  = $H_CTA.Replace('{{CTATITLE}}',$ctaTitle).Replace('{{CTADESC}}',$ctaDesc).Replace('PHONE_PLACEHOLDER',$PHONE)
    $bottom = $H_BOTTOM.Replace('PHONE_PLACEHOLDER',$PHONE)
    return $top + $hero + $body + $cta + $bottom
}

# ----------------------------------------------------------
# GENERATOR: City pages
# ----------------------------------------------------------
function Gen-CityPages($slugPrefix, $h1Prefix, $descTxt, $titlePrefix, $subTxt, $ctaT, $ctaD, $takeN) {
    $cities = $data.cities
    if ($takeN -gt 0) { $cities = $cities[0..($takeN-1)] }
    $total = $cities.Count
    Write-Host "  $slugPrefix ({0} pages)..." -f $total
    $p1s = @($CITY_P1A, $CITY_P1B, $CITY_P1C, $CITY_P1D)
    $p2s = @($CITY_P2A, $CITY_P2B, $CITY_P2C)
    foreach ($city in $cities) {
        $n = $city.name
        $s = $city.slug
        $p = $city.province
        $slug = ($slugPrefix -replace '\{slug\}', $s)
        $canonical = "$DOMAIN/pseo/$slug"
        $h1 = ($h1Prefix -replace '\{name\}', $n).Replace('{province}',$p)
        $title = ($titlePrefix -replace '\{name\}', $n).Replace('{province}',$p)
        $desc = ($descTxt -replace '\{name\}', $n).Replace('{province}',$p)
        $sub = ($subTxt -replace '\{name\}', $n).Replace('{province}',$p)
        $ctaT2 = ($ctaT -replace '\{name\}', $n).Replace('{province}',$p)
        $ctaD2 = ($ctaD -replace '\{name\}', $n).Replace('{province}',$p)
        $hash = [Math]::Abs($s.GetHashCode())
        $p1 = $p1s[$hash % $p1s.Length].Replace('{{N}}',$n).Replace('{{P}}',$p).Replace('{{B}}',$BRAND)
        $p2 = $p2s[$hash % $p2s.Length].Replace('{{N}}',$n).Replace('{{P}}',$p).Replace('{{B}}',$BRAND)
        $body = '<section class="py-12 lg:py-16 bg-white"><div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 reveal"><div class="prose prose-stone max-w-none text-stone-700 leading-relaxed">' + $p1 + $p2 + '</div>' + $CITY_BENEFITS.Replace('{{N}}',$n) + '</div></section>'
        $jsonld = Get-JSONLD 'MedicalBusiness' "Bekam di $n" $desc
        $html = Build-Page $title $desc $canonical $jsonld $h1 $sub $body $ctaT2 $ctaD2
        Write-Page "$OutDir\$slug" $html
    }
}

# ----------------------------------------------------------
# GENERATOR: Condition pages
# ----------------------------------------------------------
function Gen-ConditionPages($takeN) {
    $conds = $data.conditions
    if ($takeN -gt 0) { $conds = $conds[0..($takeN-1)] }
    $p1s = @($COND_P1A, $COND_P1B, $COND_P1C)
    $p2s = @($COND_P2A, $COND_P2B)

    # manfaat-bekam-untuk-{condition}
    Write-Host "  manfaat-bekam-untuk-{condition} ({0} pages)..." -f $conds.Count
    foreach ($c in $conds) {
        $n = $c.name; $s = $c.slug; $d = $c.desc
        $slug = "manfaat-bekam-untuk-$s.html"
        $canonical = "$DOMAIN/pseo/$slug"
        $title = "Manfaat Bekam untuk $n - Terapi Sunnah Atasi $d"
        $desc = "Ketahui manfaat bekam untuk $n ($d). Terapi bekam syariyyah oleh terapis muslimah profesional. Konsultasi gratis, booking mudah."
        $h1 = "Manfaat Bekam untuk $n"
        $sub = "Bagaimana terapi bekam sunnah dapat membantu mengatasi $d. Penjelasan lengkap oleh $BRAND."
        $hash = [Math]::Abs($s.GetHashCode())
        $p1 = $p1s[$hash % $p1s.Length].Replace('{{N}}',$n).Replace('{{D}}',$d)
        $p2 = $p2s[$hash % $p2s.Length].Replace('{{N}}',$n).Replace('{{D}}',$d)
        $body = '<section class="py-12 lg:py-16 bg-white"><div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 reveal"><div class="prose prose-stone max-w-none text-stone-700 leading-relaxed">' + $p1 + $p2 + '</div>' + $COND_NOTE.Replace('{{N}}',$n).Replace('{{D}}',$d) + '</div></section>'
        $jsonld = Get-JSONLD 'MedicalBusiness' "Manfaat Bekam untuk $n" $desc
        $html = Build-Page $title $desc $canonical $jsonld $h1 $sub $body "Atasi $n dengan Bekam Sunnah" "Konsultasi GRATIS dengan terapis muslimah kami. Booking sekarang via WhatsApp."
        Write-Page "$OutDir\$slug" $html
    }

    # bekam-untuk-{condition}
    Write-Host "  bekam-untuk-{condition} ({0} pages)..." -f $conds.Count
    foreach ($c in $conds) {
        $n = $c.name; $s = $c.slug; $d = $c.desc
        $slug = "bekam-untuk-$s.html"
        $canonical = "$DOMAIN/pseo/$slug"
        $title = "Bekam untuk $n - Solusi Sunnah $d"
        $desc = "Bekam untuk $n, solusi terapi sunnah untuk $d. Dilayani terapis muslimah profesional di $BRAND. Booking mudah via WhatsApp."
        $h1 = "Bekam untuk $n"
        $sub = "Solusi terapi sunnah untuk mengatasi $d dengan pendekatan holistik dan islami."
        $hash = [Math]::Abs(($s + "2").GetHashCode())
        $p1 = $p1s[$hash % $p1s.Length].Replace('{{N}}',$n).Replace('{{D}}',$d)
        $p2 = $p2s[$hash % $p2s.Length].Replace('{{N}}',$n).Replace('{{D}}',$d)
        $body = '<section class="py-12 lg:py-16 bg-white"><div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 reveal"><div class="prose prose-stone max-w-none text-stone-700 leading-relaxed">' + $p1 + $p2 + '</div>' + $COND_NOTE.Replace('{{N}}',$n).Replace('{{D}}',$d) + '</div></section>'
        $jsonld = Get-JSONLD 'MedicalBusiness' "Bekam untuk $n" $desc
        $html = Build-Page $title $desc $canonical $jsonld $h1 $sub $body "Atasi $n dengan Bekam" "Konsultasi GRATIS. Booking via WhatsApp."
        Write-Page "$OutDir\$slug" $html
    }
}

# ----------------------------------------------------------
# GENERATOR: Tips pages
# ----------------------------------------------------------
function Gen-TipsPages {
    $topics = $data.topics
    Write-Host "  tips-bekam-{topic} ({0} pages)..." -f $topics.Count
    $intros = @($TIPS_INTROA, $TIPS_INTROB)
    foreach ($t in $topics) {
        $n = $t.name; $s = $t.slug; $d = $t.desc
        $slug = "tips-bekam-$s.html"
        $canonical = "$DOMAIN/pseo/$slug"
        $title = "$n - $d | $BRAND"
        $desc = "Panduan lengkap $n. $d untuk muslimah. Informasi dari terapis bekam profesional $BRAND."
        $h1 = $n; $sub = $d
        $hash = [Math]::Abs($s.GetHashCode())
        $intro = $intros[$hash % $intros.Length].Replace('{{N}}',$n).Replace('{{D}}',$d).Replace('{{B}}',$BRAND)
        $bodyMain = $TIPS_BODY.Replace('{{N}}',$n).Replace('{{D}}',$d)
        $body = '<section class="py-12 lg:py-16 bg-white"><div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 reveal"><div class="prose prose-stone max-w-none text-stone-700 leading-relaxed">' + $intro + $bodyMain + '</div></div></section>'
        $jsonld = ('{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"Apa itu ' + $n + '?","acceptedAnswer":{"@type":"Answer","text":"' + $d + '"}},{"@type":"Question","name":"Bagaimana cara ' + $n + ' yang benar?","acceptedAnswer":{"@type":"Answer","text":"Silakan hubungi kami melalui WhatsApp untuk konsultasi lebih detail tentang ' + $n + '"}},{"@type":"Question","name":"Kapan waktu terbaik untuk ' + $n + '?","acceptedAnswer":{"@type":"Answer","text":"Waktu terbaik tergantung pada kondisi individual. Silakan konsultasi dengan terapis kami."}}]}')
        $html = Build-Page $title $desc $canonical $jsonld $h1 $sub $body "Punya Pertanyaan Tentang $n?" "Konsultasi GRATIS dengan terapis muslimah kami."
        Write-Page "$OutDir\$slug" $html
    }
}

# ----------------------------------------------------------
# GENERATOR: Compare pages
# ----------------------------------------------------------
function Gen-ComparePages {
    $comps = $data.comparisons
    Write-Host "  compare/{a}-vs-{b} ({0} pages)..." -f $comps.Count
    foreach ($c in $comps) {
        $as = $c.aSlug; $bs = $c.bSlug; $an = $c.a; $bn = $c.b; $ctx = $c.context
        $slug = "$as-vs-$bs.html"
        $canonical = "$DOMAIN/pseo/compare/$slug"
        $title = "$an vs $bn - Mana yang Lebih Baik? | $BRAND"
        $desc = "Perbandingan lengkap $an vs $bn dalam konteks $ctx. Mana yang lebih cocok untuk Anda? Baca perbandingannya di sini."
        $h1 = "$an vs $bn"
        $sub = "Perbandingan lengkap antara $an dan $bn dalam konteks $ctx."
        $bodyContent = $COMP_TMPL.Replace('{{A}}',$an).Replace('{{B}}',$bn).Replace('{{CTX}}',$ctx)
        $body = '<section class="py-12 lg:py-16 bg-white"><div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 reveal"><div class="prose prose-stone max-w-none text-stone-700 leading-relaxed">' + $bodyContent + '</div></div></section>'
        $jsonld = ('{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"Apa perbedaan ' + $an + ' dan ' + $bn + '?","acceptedAnswer":{"@type":"Answer","text":"' + $an + ' dan ' + $bn + ' memiliki pendekatan berbeda. Konsultasikan dengan kami untuk detail lebih lanjut."}},{"@type":"Question","name":"Mana yang lebih baik antara ' + $an + ' dan ' + $bn + '?","acceptedAnswer":{"@type":"Answer","text":"Tergantung kondisi dan kebutuhan individual. Silakan konsultasi dengan terapis kami."}}]}')
        $html = Build-Page $title $desc $canonical $jsonld $h1 $sub $body "Ingin Coba Bekam?" "Konsultasi GRATIS dengan terapis muslimah kami."
        Write-Page "$OutDir\compare\$slug" $html
    }
}

# ----------------------------------------------------------
# GENERATOR: Source Code SEO pages
# ----------------------------------------------------------
function Gen-SourceCodePages {
    $pages = $data.sourceCodePages
    Write-Host "  source-code-* ({0} pages)..." -f $pages.Count
    for ($i = 0; $i -lt $pages.Count; $i++) {
        $p = $pages[$i]
        $slug = "$($p.slug).html"
        $canonical = "$DOMAIN/pseo/$slug"
        $title = $p.title
        $h1 = ($p.title -split ' \u2014 ')[0]
        $desc = "$($p.title). Software klinik bekam siap pakai, whitelabel ready. Konsultasi via WhatsApp $PHONE."
        $sub = "Dapatkan " + $p.title.ToLower() + " untuk bisnis klinik bekam Anda."
        $bodyContent = $SC_P[$i % $SC_P.Length] + $SC_FEATURES + $SC_CTA.Replace('PHONE_PLACEHOLDER',$PHONE)
        $body = '<section class="py-12 lg:py-16 bg-white"><div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 reveal"><div class="prose prose-stone max-w-none text-stone-700 leading-relaxed">' + $bodyContent + '</div></div></section>'
        $jsonld = '{"@context":"https://schema.org","@type":"SoftwareApplication","name":"Aplikasi BekamAkhwat","applicationCategory":"BusinessApplication","operatingSystem":"Web","description":"Software manajemen klinik bekam syariyyah"}'
        $html = Build-Page $title $desc $canonical $jsonld $h1 $sub $body "Punya Aplikasi Bekam Sendiri?" "Dapatkan source code aplikasi bekam lengkap. Konsultasi via WhatsApp."
        Write-Page "$OutDir\$slug" $html
    }
}

# ============================================================
# MAIN — generate all pages
# ============================================================
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  PSEO Generator - $BRAND" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# bekam-{city} — 160 cities
Gen-CityPages 'bekam-{slug}.html' 'Bekam di {name} oleh Terapis Wanita Profesional' 'Klinik bekam khusus muslimah di {name} ({province}). Bekam kering, bekam basah, hijamah & ruqyah oleh terapis wanita bersertifikat. Privasi terjaga, booking via WhatsApp.' 'Bekam {name} - Terapi Bekam Syariyyah Khusus Muslimah di {name}' 'Layanan bekam syariyyah khusus akhwat di {name} & {province}. Terapis muslimah, privasi 100%, alat steril.' 'Booking Bekam untuk Area {name}' 'Konsultasi awal GRATIS. Booking via WhatsApp, respon cepat.' 160

# klinik-bekam-{city} — 130 cities
Gen-CityPages 'klinik-bekam-{slug}.html' 'Klinik Bekam Khusus Wanita di {name}' 'Klinik bekam khusus muslimah di {name}, {province}. Bekam kering, basah, dan ruqyah oleh terapis wanita. Alat steril, privasi aman. Booking sekarang.' 'Klinik Bekam di {name} - Klinik Bekam Sunnah Khusus Muslimah {province}' 'Tempat bekam muslimah terpercaya di {name}, {province}. Privasi terjaga, terapis wanita profesional.' 'Booking di Klinik Bekam {name}' 'Konsultasi GRATIS dengan terapis muslimah. Booking via WhatsApp.' 130

# best-bekam-{city} — 130 cities
Gen-CityPages 'best-bekam-{slug}.html' 'Tempat Bekam Terbaik di {name}' 'Rekomendasi tempat bekam terbaik di {name} ({province}) khusus muslimah. Klinik bekam syariyyah, terapis wanita bersertifikat, privasi terjaga.' 'Best Bekam {name} - Rekomendasi Tempat Bekam Terbaik di {name} {province}' 'Daftar rekomendasi klinik bekam terpercaya khusus muslimah di {name}, {province}.' 'Cari Bekam Terbaik di {name}?' 'Booking di BekamAkhwat, klinik bekam syariyyah khusus akhwat.' 130

# best-bekam-{city}-2026 — 100 cities
Gen-CityPages 'best-bekam-{slug}-2026.html' 'Klinik Bekam Terbaik di {name} 2026' 'Rekomendasi klinik bekam terbaik di {name} tahun 2026. Bekam syariyyah khusus muslimah, terapis wanita profesional, privasi terjaga.' 'Best Bekam {name} 2026 - Klinik Bekam Terbaik di {name} Tahun 2026' 'Pilihan klinik bekam khusus muslimah terbaik di {name} tahun 2026. Rekomendasi BekamAkhwat untuk akhwat.' 'Bekam Terbaik di {name} 2026' 'Dapatkan pengalaman bekam terbaik bersama terapis muslimah profesional.' 100

# best-bekam-{city}-2025 — 70 cities
Gen-CityPages 'best-bekam-{slug}-2025.html' 'Tempat Bekam Terbaik di {name} 2025' 'Kilas balik rekomendasi klinik bekam terbaik di {name} tahun 2025. Masih relevan untuk referensi Anda di tahun ini.' 'Best Bekam {name} 2025 - Tempat Bekam Terbaik di {name} Tahun 2025' 'Referensi klinik bekam muslimah terbaik di {name} sepanjang tahun 2025.' 'Cari Bekam Berkualitas di {name}?' 'Booking di BekamAkhwat, klinik bekam syariyyah khusus akhwat.' 70

# harga-bekam-{city} — 100 cities
Gen-CityPages 'harga-bekam-{slug}.html' 'Harga Bekam di {name} 2026' 'Cek harga bekam di {name} 2026. Bekam kering Rp150rb, bekam basah Rp250rb, bekam + ruqyah Rp350rb. Booking BekamAkhwat sekarang.' 'Harga Bekam di {name} 2026 - Biaya Bekam Kering, Basah & Ruqyah {province}' 'Informasi harga bekam kering, bekam basah, dan bekam + ruqyah di {name}, {province}.' 'Booking Bekam di {name} Sekarang' 'Harga terjangkau, kualitas premium. Konsultasi GRATIS.' 100

# bekam-wanita-{city} — 90 cities
Gen-CityPages 'bekam-wanita-{slug}.html' 'Bekam Wanita di {name} - Klinik Khusus Muslimah' 'Bekam khusus wanita & muslimah di {name} ({province}). Terapis wanita profesional, privasi terjaga 100%. Booking bekam kering, basah, hijamah sekarang.' 'Bekam Wanita di {name} - Terapi Bekam Syariyyah Khusus Muslimah {province}' 'Klinik bekam eksklusif untuk akhwat di {name}, {province}. Dilayani terapis muslimah profesional.' 'Bekam Khusus Wanita di {name}' 'Privasi Anda prioritas kami. Booking via WhatsApp sekarang.' 90

# terapi-bekam-{city} — 80 cities
Gen-CityPages 'terapi-bekam-{slug}.html' 'Terapi Bekam di {name} - Layanan Bekam Sunnah {province}' 'Terapi bekam di {name}, {province}. Bekam kering, bekam basah, hijamah & ruqyah oleh terapis muslimah. Booking mudah via WhatsApp.' 'Terapi Bekam di {name} - Layanan Bekam Syariyyah Khusus Muslimah' 'Layanan terapi bekam lengkap untuk muslimah di {name} & {province}. Kering, basah, dan ruqyah.' 'Terapi Bekam di {name}' 'Booking sesi terapi bekam Anda sekarang. Konsultasi GRATIS.' 80

# Condition pages — 60 conditions each
Gen-ConditionPages 60

# Tips pages
Gen-TipsPages

# Compare pages
Gen-ComparePages

# Source Code pages
Gen-SourceCodePages

# ============================================================
# RESULTS
# ============================================================
$elapsed = ((Get-Date) - $startTime).TotalSeconds
Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "  GENERATION COMPLETE!" -ForegroundColor Green
Write-Host "  Total pages : $genCount" -ForegroundColor Green
Write-Host "  Output dir  : $OutDir" -ForegroundColor Green
Write-Host ("  Elapsed     : {0:N1} detik" -f $elapsed) -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
