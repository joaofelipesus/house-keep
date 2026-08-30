// HouseKeep is a read-write app over live financial data, so nothing here caches a response:
// a stale invoice or balance would be worse than no answer at all. The fetch handler exists to
// pass requests straight through - and because an installable PWA is required to have one - plus
// to answer a failed navigation with the offline page instead of the browser's error screen.

const OFFLINE_URL = "/offline.html"
const CACHE = "housekeep-shell-v1"

self.addEventListener("install", (event) => {
  event.waitUntil(caches.open(CACHE).then((cache) => cache.add(OFFLINE_URL)))
  self.skipWaiting()
})

self.addEventListener("activate", (event) => {
  // Drop any shell cached by an earlier version before taking over open tabs.
  event.waitUntil(
    caches
      .keys()
      .then((keys) => Promise.all(keys.filter((key) => key !== CACHE).map((key) => caches.delete(key))))
      .then(() => self.clients.claim())
  )
})

self.addEventListener("fetch", (event) => {
  if (event.request.mode !== "navigate") return

  event.respondWith(
    fetch(event.request).catch(() => caches.match(OFFLINE_URL))
  )
})
