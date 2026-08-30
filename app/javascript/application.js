// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Registers the service worker that makes the app installable on the home screen. It caches
// nothing but the offline page, so a stale response can never stand in for real data.
if ("serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    navigator.serviceWorker.register("/service-worker").catch((error) => {
      console.error("[HouseKeep] service worker registration failed", error)
    })
  })
}
