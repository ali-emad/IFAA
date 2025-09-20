# IFAA Template Flutter App

This repository contains a modern Flutter application template modelled after the structure of the Iranian Football Association Australia (IFAA) website. It is intended as a starting point for building a responsive web/mobile application that mirrors the key pages and functionality of the site.

## 🌐 Live Demo

View the live application at: [https://your-username.github.io/ifaa_app_template](https://your-username.github.io/ifaa_app_template)

## 🚀 GitHub Pages Deployment

This app is automatically deployed to GitHub Pages using GitHub Actions. Every push to the `main` branch triggers a new deployment.

### Manual Deployment

To deploy manually:

```bash
# Build for web with proper base href
flutter build web --release --base-href "/ifaa_app_template/"

# Deploy the build/web folder to GitHub Pages
```

## ⚡ Performance Optimizations

This app includes several caching technologies to decrease loading time:

### Service Worker Enhancements
- Custom service worker with advanced caching strategies
- Resource-based caching with different expiration times
- Critical assets pre-caching for instant loading
- API response caching with timestamp validation

### Asset Compression
- Gzip compression for all static assets (JS, CSS, HTML, JSON, etc.)
- Automated compression scripts
- Up to 80% reduction in asset sizes

### HTTP Optimization
- Custom server that serves compressed assets with proper headers
- Long-term caching headers for static assets
- CORS support for API requests

### Resource Preloading
- HTML preloading directives for critical resources
- Prefetching for secondary resources

## 🧪 Testing CI Workflow Locally

Before pushing changes, you can test the GitHub Actions workflow locally:

```bash
# Run the comprehensive test
scripts/test-ci-locally.bat

# Or validate YAML syntax only
python -c "import yaml; f=open('.github/workflows/deploy.yml'); yaml.safe_load(f); print('YAML is valid')"
```

See [docs/testing-ci-workflow.md](docs/testing-ci-workflow.md) for detailed instructions.

## 🔧 Firebase Storage CORS Fix

If you encounter CORS errors when uploading images in the web version:

1. **Automated setup (Windows)**: Double-click on `setup_cors.bat` in your project directory
2. **Manual setup**: Follow the detailed instructions in [STORAGE_CORS_FIX.md](STORAGE_CORS_FIX.md)
3. **Alternative solution**: Configure Firebase Storage rules directly in the Firebase Console using the [storage.rules](storage.rules) file

## Features

### 🔐 Modern Authentication System
- Google Sign-In integration (demo mode)
- User profile management
- Session handling with logout

### 👤 Member Dashboard
- **Dashboard**: Quick stats and recent activity
- **Profile**: Complete profile management with photo upload
- **Payments**: Payment processing and history tracking
- **History**: Timeline of membership activities

### 💳 Payment System
- Demo payment processing
- Payment history with status tracking
- Multiple payment methods support
- Real-time payment confirmations

### 📄 Content Pages
- **Home**: Hero section with community stats and features
- **About**: Organization information and mission
- **Vision**: Three pillars with expandable details
- **Events**: Featured tournament with registration
- **Gallery**: Image showcase
- **Contact**: Committee information with contact actions
- **News**: Articles with in-page viewing

### 🎨 Modern Design
- Iranian flag color scheme
- Material 3 design system
- Responsive layout for all devices
- Professional animations and transitions

## Getting Started

1. Ensure you have Flutter installed (version >= 3.22).  Run `flutter doctor` to verify your environment.
2. Clone this repository:

   ```bash
   git clone https://github.com/your-username/ifaa_app_template.git
   cd ifaa_app_template
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run -d chrome
   ```

## Deployment to GitHub Pages

### Automatic Deployment (Recommended)

1. **Fork or create** this repository on GitHub
2. **Enable GitHub Pages** in repository settings:
   - Go to Settings → Pages
   - Source: Deploy from a branch
   - Branch: `gh-pages` / `/ (root)`
3. **Push to main branch** - GitHub Actions will automatically build and deploy

### Manual Deployment

1. **Build the web version**:
   ```bash
   flutter build web --release --web-renderer html --base-href "/ifaa_app_template/"
   ```

2. **Deploy to GitHub Pages**:
   ```bash
   # Install gh-pages if you haven't
   npm install -g gh-pages
   
   # Deploy
   gh-pages -d build/web
   ```

### Repository Settings for GitHub Pages

1. **Repository name**: Should match the base-href (e.g., `ifaa_app_template`)
2. **GitHub Pages settings**:
   - Source: Deploy from a branch
   - Branch: `gh-pages`
   - Folder: `/ (root)`

### Custom Domain (Optional)

To use a custom domain:

1. **Add CNAME file** in `web/` folder:
   ```
   your-domain.com
   ```

2. **Update base href** in workflow and index.html:
   ```yaml
   --base-href "/"
   ```

3. **Configure DNS** to point to GitHub Pages

## Environment Configuration

### Development
```bash
flutter run -d chrome --web-port 3000
```

### Production Build
```bash
# For GitHub Pages
flutter build web --release --web-renderer html --base-href "/ifaa_app_template/"

# For custom domain
flutter build web --release --web-renderer html --base-href "/"
```

## Technology Stack

- **Flutter**: >= 3.22.0
- **Dart**: >= 3.4.0
- **State Management**: Riverpod
- **Routing**: go_router
- **HTTP Client**: Dio
- **Image Caching**: cached_network_image
- **URL Launcher**: url_launcher
- **Internationalization**: intl
- **SVG Support**: flutter_svg

## Project Structure

```
lib/
├── src/
│   ├── models/          # Data models
```