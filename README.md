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
│   ├── ui/
│   │   ├── pages/       # App pages
│   │   └── shell/       # Navigation shell
│   ├── theme.dart       # App theme
│   └── router.dart      # App routing
└── main.dart            # Entry point

web/
├── index.html           # Web entry point
├── manifest.json        # PWA manifest
└── favicon.ico          # App icon

.github/
└── workflows/
    └── deploy.yml       # GitHub Actions deployment

scripts/                 # Performance optimization scripts
├── build-and-compress.bat
├── compress-assets.js
├── serve-compressed.bat
├── serve-compressed.py
├── test-ci-locally.bat
├── validate-github-actions.py
└── validate-workflow.bat

docs/                    # Documentation
├── caching-optimizations.md
├── performance-optimizations.md
└── testing-ci-workflow.md
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is open source and available under the [MIT License](LICENSE).

## Overview

The app uses Flutter with Material 3 and implements responsive navigation through `go_router` and a custom shell.  It includes example pages for:

- Home: A hero card and quick links to the membership form and events.
- About: Description of the association and its mission.
- Vision: Bullet points for the organisation's vision.
- Events: Card-based listing of upcoming events with a detail route.
- Gallery: Simple grid of sample images.
- Membership: A form capturing user details, including name, contact info and football registration preferences.
- Contact: Address, email and phone details with mail launcher.
- News: List of news posts with a detail view.

This template uses `Riverpod` for future state management, `Dio` for REST API calls (stubbed) and `cached_network_image` for images.  Replace the API endpoints in `ApiService` with your CMS (e.g., WordPress) endpoints and integrate data providers as needed.

## Getting Started

1. Ensure you have Flutter installed (version >= 3.22).  Run `flutter doctor` to verify your environment.
2. Create a new Flutter project:

   ```sh
   flutter create ifaa_app
   cd ifaa_app
   ```

3. Replace the `pubspec.yaml` and `lib/` folder with the content of this template.
4. Run `flutter pub get` to install dependencies.
5. Start the app on a device or emulator:

   ```sh
   flutter run
   ```

## Customisation

- Update the `seedColor` in `src/theme.dart` to match your brand.
- Point the `baseUrl` in `src/services/api_service.dart` to your WordPress or headless CMS.
- Replace the mock data constructors in `Post` and `EventModel` with data models matching your API structure.
- To deploy on the web, run `flutter build web` and host the `build/web` directory on your chosen platform.

## Deployment Issues

For common deployment issues and their solutions, see [DEPLOYMENT.md](DEPLOYMENT.md).