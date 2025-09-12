# 🚀 GitHub Pages Deployment Guide for IFAA App

## Quick Start Deployment

### Method 1: Automatic Deployment (Recommended)

1. **Create GitHub Repository**
   ```bash
   # Create new repository on GitHub named 'ifaa_app_template'
   # Or fork this repository
   ```

2. **Upload Your Code**
   ```bash
   git init
   git add .
   git commit -m "Initial IFAA app commit"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/ifaa_app_template.git
   git push -u origin main
   ```

3. **Enable GitHub Pages**
   - Go to your repository on GitHub
   - Click **Settings** → **Pages**
   - Source: **Deploy from a branch**
   - Branch: **gh-pages** (will be created automatically)
   - Folder: **/ (root)**
   - Click **Save**

4. **Wait for Deployment**
   - GitHub Actions will automatically build and deploy
   - Check the **Actions** tab for build progress
   - Your app will be available at: `https://YOUR_USERNAME.github.io/ifaa_app_template`

### Method 2: Manual Deployment

1. **Build the App**
   ```bash
   # Run the build script
   ./scripts/build-and-deploy.sh    # Linux/Mac
   ./scripts/build-and-deploy.bat   # Windows
   
   # Or manually:
   flutter build web --release --web-renderer html --base-href "/ifaa_app_template/"
   ```

2. **Deploy to GitHub Pages**
   ```bash
   # Install gh-pages globally
   npm install -g gh-pages
   
   # Deploy
   gh-pages -d build/web
   ```

## Repository Configuration

### Required Files Structure
```
your-repo/
├── .github/
│   └── workflows/
│       └── deploy.yml          # Auto-deployment workflow
├── web/
│   ├── index.html             # Updated base href
│   ├── manifest.json          # PWA configuration
│   └── favicon.ico            # App icon
├── scripts/
│   ├── build-and-deploy.sh    # Build script (Linux/Mac)
│   └── build-and-deploy.bat   # Build script (Windows)
├── pubspec.yaml               # Updated homepage URL
├── .gitignore                 # Flutter gitignore
└── README.md                  # Updated documentation
```

### Important Configuration Updates

1. **pubspec.yaml**: Homepage URL updated
2. **web/index.html**: Base href set to repository name
3. **GitHub Actions**: Automated deployment workflow
4. **Build scripts**: Easy deployment commands

## Custom Domain Setup (Optional)

### If you want to use your own domain:

1. **Add CNAME file** in web/ folder:
   ```
   your-custom-domain.com
   ```

2. **Update base href** in all files:
   ```yaml
   # In .github/workflows/deploy.yml
   --base-href "/"
   ```
   ```html
   <!-- In web/index.html -->
   <base href="/">
   ```

3. **Configure DNS**:
   - Add CNAME record pointing to: `YOUR_USERNAME.github.io`
   - Or A records pointing to GitHub Pages IPs

## Troubleshooting

### Common Issues:

1. **404 Error on GitHub Pages**
   - Check base href in index.html matches repository name
   - Ensure GitHub Pages is enabled and source is set correctly

2. **Build Failures**
   - Run `flutter doctor` to check Flutter installation
   - Ensure all dependencies are installed: `flutter pub get`

3. **Images/Assets Not Loading**
   - Verify assets are in pubspec.yaml
   - Check asset paths in code
   - Ensure base href is correctly set

4. **Routing Issues**
   - GitHub Pages doesn't support client-side routing by default
   - Consider using hash routing for complex apps

### Build Commands Reference

```bash
# Development build
flutter run -d chrome --web-port 3000

# Production build for GitHub Pages
flutter build web --release --web-renderer html --base-href "/ifaa_app_template/"

# Production build for custom domain
flutter build web --release --web-renderer html --base-href "/"

# Clean build
flutter clean && flutter pub get && flutter build web --release
```

## GitHub Actions Workflow

The included workflow automatically:
1. ✅ Checks out your code
2. ✅ Sets up Flutter environment
3. ✅ Installs dependencies
4. ✅ Builds the web app
5. ✅ Deploys to GitHub Pages

### Workflow Triggers:
- Push to `main` branch
- Pull requests to `main` branch

## Security Notes

- No sensitive data is exposed (using sample data)
- GitHub Actions uses repository secrets
- All builds are public (GitHub Pages limitation for free accounts)

## Next Steps

1. **Customize the base href** to match your repository name
2. **Update the homepage URL** in pubspec.yaml
3. **Push to GitHub** and enable Pages
4. **Monitor deployment** in Actions tab
5. **Access your live app** at the GitHub Pages URL

Your IFAA app will be live and accessible worldwide! 🌍