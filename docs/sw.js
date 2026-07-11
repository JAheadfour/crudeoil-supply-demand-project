const CACHE_NAME = 'oil101-understanding-v6';
const ASSETS = [
  './index.html',
  './chapters.html',
  './assets/site.css',
  './assets/site.js',
  './assets/platform.css',
  './assets/platform.js',
  './assets/home.js',
  './assets/figures/eia-wti-negative-2020.svg',
  './assets/figures/module-01/crude-fractional-distillation.jpg',
  './assets/figures/module-02/ch06-seven-events.png',
  './assets/figures/module-03/ch07-distillation-tower-cuts.jpg',
  './assets/figures/module-03/ch11-north-american-pipelines-map.png',
  './assets/figures/module-03/ch13-refinery-maintenance-turnaround.jpg',
  './assets/figures/module-04/crude-quality-matrix-api-sulfur.png',
  './assets/figures/module-04/global-crude-benchmark-map.png',
  './assets/figures/module-06/ch20-hedged-vs-unhedged.png',
  './assets/figures/module-07/strait-of-hormuz-map.jpg',
  './assets/figures/module-08/us-ethane-ethylene-derivative-exports.svg',
  './assets/figures/module-09/strait-of-hormuz-map.jpg',
  './learn/inventory-curve.html',
  './learn/module.html',
  './data/oil101-understanding/session-meta.json',
  './data/oil101-understanding/catalog.json',
  './data/oil101-understanding/module-01-barrel-journey.json',
  './data/oil101-understanding/module-02-supply-demand-balance.json',
  './data/oil101-understanding/module-03-local-shortages.json',
  './data/oil101-understanding/module-04-what-is-oil-price.json',
  './data/oil101-understanding/module-05-inventory-curve.json',
  './data/oil101-understanding/module-06-risk-management.json',
  './data/oil101-understanding/module-07-producers-opec-shale.json',
  './data/oil101-understanding/module-08-products-petrochem-transition.json',
  './data/oil101-understanding/module-09-industry-synthesis-lab.json',
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
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(ASSETS))
      .then(() => self.skipWaiting())
  );
});
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(key => key !== CACHE_NAME).map(key => caches.delete(key))))
      .then(() => self.clients.claim())
  );
});
self.addEventListener('fetch', event => {
  if (event.request.method !== 'GET') return;
  event.respondWith(
    caches.match(event.request, { ignoreSearch: true }).then(cached => cached || fetch(event.request).then(response => {
      if (response.ok) {
        const copy = response.clone();
        caches.open(CACHE_NAME).then(cache => cache.put(event.request, copy));
      }
      return response;
    }))
  );
});
