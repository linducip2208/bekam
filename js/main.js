document.addEventListener('DOMContentLoaded', function () {
    const menuToggle = document.getElementById('menu-toggle');
    const mobileMenu = document.getElementById('mobile-menu');

    if (menuToggle && mobileMenu) {
        menuToggle.addEventListener('click', function () {
            mobileMenu.classList.toggle('hidden');
        });

        document.addEventListener('click', function (e) {
            if (!menuToggle.contains(e.target) && !mobileMenu.contains(e.target)) {
                mobileMenu.classList.add('hidden');
            }
        });
    }

    const observer = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                observer.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    });

    document.querySelectorAll('.reveal').forEach(function (el) {
        observer.observe(el);
    });

    var ctaBtn = document.querySelector('a[href*="wa.me"]');
    if (ctaBtn) {
        ctaBtn.addEventListener('click', function () {
            if (typeof gtag !== 'undefined') {
                gtag('event', 'click_whatsapp', { event_category: 'booking' });
            }
        });
    }

    // --- Visitor Stats Counter ---
    (function() {
        var currentPage = window.location.pathname || '/';

        function formatNumber(n) {
            if (n >= 1000000) return (n / 1000000).toFixed(1).replace('.0', '') + 'jt';
            if (n >= 1000) return (n / 1000).toFixed(1).replace('.0', '') + 'rb';
            return String(n);
        }

        function updateStats(data) {
            var elOnline = document.getElementById('stat-online');
            var elToday = document.getElementById('stat-today');
            var elTotal = document.getElementById('stat-total');
            var elPageviews = document.getElementById('stat-pageviews');

            if (elOnline) elOnline.textContent = data.online;
            if (elToday) elToday.textContent = formatNumber(data.today_visitors);
            if (elTotal) elTotal.textContent = formatNumber(data.total_visitors);
            if (elPageviews) elPageviews.textContent = formatNumber(data.total_pageviews);

            // Tambah class pop animasi
            [elOnline, elToday, elTotal, elPageviews].forEach(function(el) {
                if (el) {
                    el.classList.add('stats-pop');
                    setTimeout(function() { el.classList.remove('stats-pop'); }, 400);
                }
            });
        }

        function showError(msg) {
            var errEl = document.getElementById('stats-error');
            if (errEl) {
                errEl.textContent = msg;
                errEl.classList.remove('hidden');
            }
        }

        function fetchStats() {
            var xhr = new XMLHttpRequest();
            xhr.open('GET', '/counter.php?action=get&_=' + Date.now(), true);
            xhr.timeout = 5000;
            xhr.onload = function() {
                if (xhr.status === 200) {
                    try {
                        var data = JSON.parse(xhr.responseText);
                        updateStats(data);
                    } catch (e) {
                        showError('Gagal memuat statistik');
                    }
                }
            };
            xhr.onerror = function() {
                showError('Statistik tidak tersedia (server tidak mendukung PHP)');
            };
            xhr.send();
        }

        function trackPageview() {
            var xhr = new XMLHttpRequest();
            xhr.open('GET', '/counter.php?action=track&page=' + encodeURIComponent(currentPage), true);
            xhr.timeout = 3000;
            xhr.onload = function() {
                if (xhr.status === 200) {
                    try {
                        var data = JSON.parse(xhr.responseText);
                        updateStats(data);
                    } catch (e) {}
                }
            };
            xhr.send();
        }

        // Track pageview dulu, lalu polling stats tiap 15 detik
        trackPageview();
        setInterval(fetchStats, 15000);
    })();
});
