# IFAA App Deployment Guide

## Firebase Domain Authorization Fix

If you encounter the following error when trying to sign in:
```
Firebase Auth Error: unauthorized-domain - This domain is not authorized for OAuth operations for your Firebase project.
```

### Solution Steps:

1. **Access Firebase Console**:
   - Go to https://console.firebase.google.com/
   - Select your IFAA project

2. **Navigate to Authentication Settings**:
   - Click on "Authentication" in the left sidebar
   - Click on the "Settings" tab
   - Find "Authorized domains" section

3. **Add Your Domain**:
   - Click "Add domain"
   - Add your GitHub Pages domain: `ali-emad.github.io`
   - Click "Add"

4. **Verify Domain**:
   - The domain should now appear in the authorized domains list
   - Wait a few minutes for the changes to propagate

## PWA Icon Issues

If the PWA icons are not showing correctly when installing the app on Windows:

### Solution Steps:

1. **Check Icon Files**:
   - Ensure `assets/icons/ifaa-1.png` exists and is a valid image
   - Verify the GitHub Actions workflow is correctly generating all required icon sizes

2. **Clear Browser Cache**:
   - Clear your browser cache and service worker cache
   - Uninstall the PWA if already installed
   - Reinstall the PWA

3. **Verify Manifest**:
   - Check that `web/manifest.json` has correct icon paths
   - Ensure all icon files exist in the deployed build

## Common Deployment Issues

### 1. GitHub Actions Workflow Failures

If the deployment workflow fails:

1. Check the error message in the Actions tab
2. Common fixes:
   - Update Flutter version in `.github/workflows/deploy.yml`
   - Ensure all required dependencies are installed
   - Check file paths in the workflow

### 2. Missing Assets

If images or icons are missing:

1. Verify all assets are in the `assets/` directory
2. Check that `pubspec.yaml` includes the assets
3. Ensure the GitHub Actions workflow copies assets correctly

### 3. Performance Issues

If the app loads slowly:

1. Check that asset compression is working
2. Verify the service worker is caching assets properly
3. Ensure critical resources are preloaded in `index.html`

## Testing Locally

Before deploying, test the app locally:

```bash
# Test web version
flutter run -d chrome

# Build for web
flutter build web --release

# Test the build locally
cd build/web
python -m http.server 8000
```

## Monitoring Deployment

After deployment:

1. Check the GitHub Actions workflow for success
2. Verify the app loads correctly at your GitHub Pages URL
3. Test all functionality including authentication
4. Check that PWA features work correctly

## Troubleshooting

### Authentication Issues

If authentication fails:

1. Verify Firebase configuration in `web/firebase-config.js`
2. Check that the domain is authorized in Firebase Console
3. Ensure the Google Sign-In client ID is correct
4. Test with different browsers

### PWA Installation Issues

If PWA installation fails:

1. Check browser compatibility (Chrome, Edge recommended)
2. Verify all PWA requirements are met
3. Check console for PWA-related errors
4. Ensure all manifest icons are accessible

### Performance Issues

If the app is slow:

1. Check network tab for slow-loading resources
2. Verify asset compression is working
3. Check service worker caching
4. Optimize images and other assets