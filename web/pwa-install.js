// PWA Install Prompt for IFAA App
let deferredPrompt;
let installButton;

// Wait for the page to load
window.addEventListener('load', () => {
  initializePWAInstall();
});

function initializePWAInstall() {
  // Create install banner
  createInstallBanner();
  
  // Listen for beforeinstallprompt event
  window.addEventListener('beforeinstallprompt', (e) => {
    console.log('PWA install prompt available');
    
    // Prevent the mini-infobar from appearing on mobile
    e.preventDefault();
    
    // Save the event so it can be triggered later
    deferredPrompt = e;
    
    // Show custom install banner
    showInstallBanner();
  });

  // Listen for app installed event
  window.addEventListener('appinstalled', (e) => {
    console.log('IFAA PWA was installed');
    hideInstallBanner();
    
    // Track installation (you can add analytics here)
    if (typeof gtag !== 'undefined') {
      gtag('event', 'pwa_install', {
        event_category: 'engagement',
        event_label: 'IFAA PWA Install'
      });
    }
  });

  // Check if app is already installed
  if (window.matchMedia('(display-mode: standalone)').matches) {
    console.log('IFAA PWA is already installed');
    return;
  }

  // For iOS Safari - show custom banner after delay
  if (isIOS() && !isInStandaloneMode()) {
    setTimeout(() => {
      showIOSInstallBanner();
    }, 3000);
  }
}

function createInstallBanner() {
  // Create the install banner HTML
  const bannerHTML = `
    <div id="pwa-install-banner" class="pwa-banner hidden">
      <div class="pwa-banner-content">
        <div class="pwa-banner-info">
          <img src="icons/Icon-192.png" alt="IFAA Logo" class="pwa-banner-icon">
          <div class="pwa-banner-text">
            <h3>Install IFAA App</h3>
            <p>Get quick access to IFAA on your home screen!</p>
          </div>
        </div>
        <div class="pwa-banner-actions">
          <button id="pwa-install-btn" class="pwa-install-button">Install</button>
          <button id="pwa-dismiss-btn" class="pwa-dismiss-button">×</button>
        </div>
      </div>
    </div>

    <div id="ios-install-banner" class="ios-banner hidden">
      <div class="ios-banner-content">
        <div class="ios-banner-info">
          <img src="icons/Icon-192.png" alt="IFAA Logo" class="ios-banner-icon">
          <div class="ios-banner-text">
            <h3>Install IFAA App</h3>
            <p>Tap <span class="ios-share-icon">⎙</span> then "Add to Home Screen"</p>
          </div>
        </div>
        <button id="ios-dismiss-btn" class="ios-dismiss-button">×</button>
      </div>
    </div>
  `;

  // Add banner to body
  document.body.insertAdjacentHTML('beforeend', bannerHTML);

  // Add event listeners
  installButton = document.getElementById('pwa-install-btn');
  if (installButton) {
    installButton.addEventListener('click', installPWA);
  }

  const dismissButton = document.getElementById('pwa-dismiss-btn');
  if (dismissButton) {
    dismissButton.addEventListener('click', dismissInstallBanner);
  }

  const iosDismissButton = document.getElementById('ios-dismiss-btn');
  if (iosDismissButton) {
    iosDismissButton.addEventListener('click', dismissIOSBanner);
  }
}

function showInstallBanner() {
  const banner = document.getElementById('pwa-install-banner');
  if (banner && !localStorage.getItem('pwa-dismissed')) {
    banner.classList.remove('hidden');
    
    // Auto-hide after 10 seconds
    setTimeout(() => {
      if (banner && !banner.classList.contains('hidden')) {
        hideInstallBanner();
      }
    }, 10000);
  }
}

function hideInstallBanner() {
  const banner = document.getElementById('pwa-install-banner');
  if (banner) {
    banner.classList.add('hidden');
  }
}

function showIOSInstallBanner() {
  const banner = document.getElementById('ios-install-banner');
  if (banner && !localStorage.getItem('ios-pwa-dismissed')) {
    banner.classList.remove('hidden');
    
    // Auto-hide after 8 seconds
    setTimeout(() => {
      if (banner && !banner.classList.contains('hidden')) {
        dismissIOSBanner();
      }
    }, 8000);
  }
}

function dismissInstallBanner() {
  hideInstallBanner();
  localStorage.setItem('pwa-dismissed', 'true');
}

function dismissIOSBanner() {
  const banner = document.getElementById('ios-install-banner');
  if (banner) {
    banner.classList.add('hidden');
  }
  localStorage.setItem('ios-pwa-dismissed', 'true');
}

async function installPWA() {
  if (!deferredPrompt) {
    console.log('No deferred prompt available');
    return;
  }

  // Show the install prompt
  deferredPrompt.prompt();

  // Wait for the user to respond to the prompt
  const { outcome } = await deferredPrompt.userChoice;
  
  if (outcome === 'accepted') {
    console.log('User accepted the install prompt');
  } else {
    console.log('User dismissed the install prompt');
  }

  // Clear the deferred prompt
  deferredPrompt = null;
  hideInstallBanner();
}

// Helper functions
function isIOS() {
  return /iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream;
}

function isInStandaloneMode() {
  return window.matchMedia('(display-mode: standalone)').matches || window.navigator.standalone;
}

function isMobile() {
  return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
}