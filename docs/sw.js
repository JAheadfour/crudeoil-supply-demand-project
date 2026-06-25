const CACHE_NAME = 'oil101-kb-v1';
const ASSETS = [
  './index.html',
  './assets/site.css',
  './assets/site.js',
  './manifest.webmanifest',
  './pages/part-one-oil-fundamentals--01-history.html',
  './pages/part-one-oil-fundamentals--02-crude-oil-assay.html',
  './pages/part-one-oil-fundamentals--03-components.html',
  './pages/part-one-oil-fundamentals--04-chemistry.html',
  './pages/part-one-oil-fundamentals--05-industry-overview.html',
  './pages/part-one-oil-fundamentals--06-exploration-production.html',
  './pages/part-one-oil-fundamentals--07-refining.html',
  './pages/part-one-oil-fundamentals--08-standards.html',
  './pages/part-one-oil-fundamentals--09-finished-products.html',
  './pages/part-one-oil-fundamentals--10-petrochemicals.html',
  './pages/part-one-oil-fundamentals--11-transporting-oil.html',
  './pages/part-one-oil-fundamentals--12-storage.html',
  './pages/part-one-oil-fundamentals--13-seasonality.html',
  './pages/part-one-oil-fundamentals--14-reserves.html',
  './pages/part-one-oil-fundamentals--15-environmental.html',
  './pages/part-one-oil-fundamentals--16-engine-technologies.html',
  './pages/part-two-oil-markets--17-oil-prices.html',
  './pages/part-two-oil-markets--18-futures-swaps.html',
  './pages/part-two-oil-markets--19-options.html',
  './pages/part-two-oil-markets--20-risk-management.html',
  './pages/part-three-modern-era--21-shale-revolution.html',
  './pages/part-three-modern-era--22-opec-plus.html',
  './pages/part-three-modern-era--23-negative-prices.html',
  './pages/part-three-modern-era--24-us-lng.html',
  './pages/part-three-modern-era--25-energy-transition.html',
  './pages/part-three-modern-era--26-iran-strait.html',
  './pages/appendices--A1-forward-markets-mechanics.html',
  './pages/appendices--A2-conversion-factors.html',
  './pages/appendices--A3-perpetual-futures.html'
];
self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE_NAME).then(cache => cache.addAll(ASSETS)));
});
self.addEventListener('fetch', event => {
  event.respondWith(caches.match(event.request).then(cached => cached || fetch(event.request)));
});