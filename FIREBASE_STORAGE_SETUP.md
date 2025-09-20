# Firebase Storage Setup Instructions

## Prerequisites
1. Make sure you're logged into the correct Google account
2. Ensure you have owner/admin access to the Firebase project

## Setup Steps

### 1. Initialize Firebase Storage
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **ifaa-54ebf**
3. Click on **Storage** in the left sidebar
4. Click **Get Started**
5. Click **Next**
6. Select your location (closest region to your users)
7. Click **Done**

### 2. Apply Storage Rules
After initializing Storage, apply the security rules:

1. In the Firebase Console, go to **Storage**
2. Click on the **Rules** tab
3. Replace the existing rules with the content below:

```
rules_version = '2';
service firebase.storage {
  match /b/ifaa-54ebf.appspot.com/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
    
    // Add CORS headers to allow web access
    match /news_images/{imageId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

4. Click **Publish**

### 3. Apply CORS Configuration
Run the CORS setup script:

```bash
setup_cors.bat
```

If the script fails, manually apply CORS using gsutil:

```bash
gsutil cors set cors.json gs://ifaa-54ebf.appspot.com
```

### 4. Test the Setup
1. Restart your Flutter web app:
   ```bash
   flutter run -d chrome
   ```

2. Try uploading an image in the news management section

## Troubleshooting

### If you get "Bucket not found" errors:
- Make sure you've completed step 1 (Initialize Firebase Storage)
- Verify the bucket name is correct: `ifaa-54ebf.appspot.com`

### If you get CORS errors:
- Make sure you've run the CORS setup script
- Check that the CORS configuration allows your domain

### If you get permission errors:
- Verify you're logged into the correct Google account
- Ensure you have owner/admin access to the Firebase project