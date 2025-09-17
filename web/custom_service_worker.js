// Custom service worker that extends Flutter's service worker with additional caching strategies

// Import and extend the Flutter service worker
importScripts('flutter_service_worker.js');

// Cache strategies for different types of assets
const CACHE_STRATEGIES = {
  // Cache images with longer expiration
  images: {
    regex: /\.(?:png|gif|jpg|jpeg|svg|webp|ico)$/,
    maxAgeSeconds: 7 * 24 * 60 * 60 // 1 week
  },
  // Cache fonts with longer expiration
  fonts: {
    regex: /\.(?:woff|woff2|ttf|otf|eot)$/,
    maxAgeSeconds: 30 * 24 * 60 * 60 // 1 month
  },
  // Cache CSS and JS with medium expiration
  staticAssets: {
    regex: /\.(?:css|js)$/,
    maxAgeSeconds: 7 * 24 * 60 * 60 // 1 week
  }
};

// Additional caching for API responses (if needed in future)
const API_CACHE = 'ifaa-api-cache-v1';
const API_CACHE_DURATION = 5 * 60 * 1000; // 5 minutes

// Enhanced caching for critical assets
const CRITICAL_ASSETS_CACHE = 'ifaa-critical-assets-v1';
const CRITICAL_ASSETS = [
  'main.dart.js',
  'flutter_bootstrap.js',
  'index.html',
  'assets/FontManifest.json'
];

// Pre-cache strategy for critical assets
self.addEventListener('install', (event) => {
  // Extend the installation to pre-cache critical assets
  event.waitUntil(
    caches.open(CRITICAL_ASSETS_CACHE).then((cache) => {
      return cache.addAll(CRITICAL_ASSETS.map(asset => `/${asset}`));
    }).then(() => {
      // Skip waiting to activate the new service worker immediately
      return self.skipWaiting();
    })
  );
});

// Enhanced fetch handler with custom caching strategies
self.addEventListener('fetch', (event) => {
  // Let Flutter's service worker handle the core logic
  if (shouldHandleWithFlutter(event)) {
    // Use Flutter's built-in caching for core app resources
    // Don't prevent default behavior for core app resources
    return;
  }
  
  // Apply custom caching strategies for other resources
  const request = event.request;
  const url = new URL(request.url);
  
  // Handle API requests with short-term caching
  if (url.pathname.startsWith('/api/') || url.hostname.includes('wp-json')) {
    event.respondWith(handleAPICaching(event));
    return;
  }
  
  // Handle static assets with custom caching
  event.respondWith(handleStaticAssetCaching(event));
});

// Determine if Flutter's service worker should handle the request
function shouldHandleWithFlutter(event) {
  const request = event.request;
  const url = new URL(request.url);
  
  // Let Flutter handle its own resources
  return (
    url.origin === self.location.origin &&
    (url.pathname === '/' || 
     url.pathname.startsWith('/flutter/') ||
     url.pathname.startsWith('/assets/') ||
     url.pathname.startsWith('/canvaskit/') ||
     url.pathname.includes('main.dart.js') ||
     url.pathname.includes('flutter.js') ||
     url.pathname.includes('index.html'))
  );
}

// Handle static asset caching with custom strategies
async function handleStaticAssetCaching(event) {
  const request = event.request;
  const url = new URL(request.url);
  
  // Try to get from cache first
  const cachedResponse = await caches.match(request);
  if (cachedResponse) {
    // Check if cached response is still valid based on our strategies
    const cacheStrategy = getCacheStrategy(url.pathname);
    if (cacheStrategy && isCacheValid(cachedResponse, cacheStrategy.maxAgeSeconds)) {
      return cachedResponse;
    }
  }
  
  // If not in cache or expired, fetch from network
  try {
    const networkResponse = await fetch(request);
    
    // Cache the response if it's successful
    if (networkResponse && networkResponse.status === 200) {
      const cache = await caches.open('ifaa-static-cache-v1');
      cache.put(request, networkResponse.clone());
    }
    
    return networkResponse;
  } catch (error) {
    // If network fails, try to serve from cache even if expired
    if (cachedResponse) {
      return cachedResponse;
    }
    
    // If nothing is available, let the request fail
    throw error;
  }
}

// Handle API caching with short-term strategy
async function handleAPICaching(event) {
  const request = event.request;
  
  // Try to get from cache first
  const cache = await caches.open(API_CACHE);
  const cachedResponse = await cache.match(request);
  
  if (cachedResponse) {
    // Check if the cached response is still fresh
    const cacheTime = new Date(cachedResponse.headers.get('cached-at') || 0).getTime();
    const now = Date.now();
    
    if (now - cacheTime < API_CACHE_DURATION) {
      return cachedResponse;
    }
  }
  
  // Fetch from network
  try {
    const networkResponse = await fetch(request);
    
    // Cache the response with timestamp if successful
    if (networkResponse && networkResponse.status === 200) {
      const responseToCache = networkResponse.clone();
      const headers = new Headers(responseToCache.headers);
      headers.append('cached-at', Date.now().toString());
      
      const cachedResponse = new Response(responseToCache.body, {
        status: responseToCache.status,
        statusText: responseToCache.statusText,
        headers: headers
      });
      
      cache.put(request, cachedResponse);
    }
    
    return networkResponse;
  } catch (error) {
    // If network fails, serve from cache even if expired
    if (cachedResponse) {
      return cachedResponse;
    }
    
    throw error;
  }
}

// Get appropriate cache strategy based on file extension
function getCacheStrategy(path) {
  for (const [type, strategy] of Object.entries(CACHE_STRATEGIES)) {
    if (strategy.regex.test(path)) {
      return strategy;
    }
  }
  return null;
}

// Check if cached response is still valid based on max age
function isCacheValid(response, maxAgeSeconds) {
  const cachedAt = response.headers.get('cached-at');
  if (!cachedAt) return false;
  
  const cachedTime = parseInt(cachedAt, 10);
  const now = Date.now();
  const maxAgeMillis = maxAgeSeconds * 1000;
  
  return (now - cachedTime) < maxAgeMillis;
}

// Clean up old caches during activation
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          // Delete old caches that don't match current cache names
          if (
            cacheName !== CACHE_NAME &&
            cacheName !== API_CACHE &&
            cacheName !== 'ifaa-static-cache-v1' &&
            cacheName !== CRITICAL_ASSETS_CACHE &&
            cacheName !== MANIFEST &&
            cacheName !== TEMP
          ) {
            return caches.delete(cacheName);
          }
        })
      );
    }).then(() => {
      // Claim clients to activate the service worker immediately
      return self.clients.claim();
    })
  );
});

console.log('Custom service worker loaded with enhanced caching strategies');