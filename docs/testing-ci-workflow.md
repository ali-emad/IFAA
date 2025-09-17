# Testing CI Workflow Locally

This document explains how to test the GitHub Actions CI workflow locally before pushing to GitHub.

## Prerequisites

1. Flutter SDK (>= 3.22.0)
2. Node.js (for asset compression)
3. Python (for validation scripts)

## Local Testing Options

### Option 1: Manual Step-by-Step Testing

Test each step of the CI workflow manually:

```bash
# 1. Setup Flutter environment
flutter pub get

# 2. Build web application
flutter build web --release

# 3. Compress assets
node scripts/compress-assets.js

# 4. Verify compressed files exist
ls build/web/*.gz
```

### Option 2: Run Automated Test Script

Use the provided test script:

```bash
# Run the comprehensive test
scripts/test-ci-locally.bat
```

### Option 3: Validate YAML Syntax

Check that the workflow file is syntactically correct:

```bash
# Simple YAML validation
python -c "import yaml; f=open('.github/workflows/deploy.yml'); yaml.safe_load(f); print('YAML is valid')"
```

## What the CI Workflow Does

1. **Builds the Flutter web app** with release optimizations
2. **Compresses all static assets** using gzip (reduces file sizes by up to 80%)
3. **Deploys to GitHub Pages** automatically

## Validation Checklist

Before pushing to GitHub, ensure:

- [ ] Flutter builds successfully (`flutter build web --release`)
- [ ] Asset compression works (`node scripts/compress-assets.js`)
- [ ] YAML syntax is valid
- [ ] All required environment variables are set
- [ ] No sensitive information is committed

## Troubleshooting

### Common Issues

1. **Node.js not found**: Install Node.js from https://nodejs.org/
2. **Flutter not found**: Ensure Flutter is in your PATH
3. **Permission errors**: Run as administrator on Windows
4. **Compression fails**: Check that build/web directory exists

### Debugging Steps

1. Run each step individually to identify failures
2. Check the build logs for specific error messages
3. Verify all dependencies are installed
4. Ensure sufficient disk space is available

## After Pushing

Monitor the GitHub Actions workflow:

1. Go to your repository's Actions tab
2. Watch the workflow run in real-time
3. Check for any failures and review logs
4. Verify deployment to GitHub Pages

The workflow should complete successfully and deploy your optimized app with compressed assets.