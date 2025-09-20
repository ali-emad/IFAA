# Firebase Storage CORS Configuration Fix

## Issue
When running the Flutter web app locally, you may encounter CORS (Cross-Origin Resource Sharing) errors when trying to upload images to Firebase Storage:

```
Access to fetch at 'https://firebasestorage.googleapis.com/v0/b/...' from origin 'http://localhost:XXXXX' has been blocked by CORS policy
```

## Solution

### Automated Setup (Recommended)

For Windows users, you can use the provided batch script to automatically set up CORS:

1. Double-click on `setup_cors.bat` in your project directory
2. Follow the on-screen instructions

### Manual Setup

#### Prerequisites
1. Install the Google Cloud SDK:
   - Visit https://cloud.google.com/sdk/docs/install and follow installation instructions
   - For Windows, download the installer and run it
   - Make sure to select "Add to PATH" during installation
   - Restart your command prompt after installation

2. Verify installation:
   ```bash
   gcloud --version
   ```

3. If gcloud is not recognized after installation, you may need to add it to your PATH manually:
   - Open System Properties → Advanced → Environment Variables
   - Add the Google Cloud SDK bin directory to your PATH (typically `C:\Users\[USERNAME]\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin`)
   - Restart your command prompt

4. Initialize gcloud:
   ```bash
   gcloud init
   ```

5. Install gsutil component (usually included with Google Cloud SDK):
   ```bash
   gcloud components install gsutil
   ```

6. Authenticate with Google Cloud:
   ```bash
   gcloud auth login
   ```

### Steps to Fix CORS

1. Make sure you're in your project directory:
   ```bash
   cd your-project-directory
   ```

2. Set your project ID:
   ```bash
   gcloud config set project ifaa-472315
   ```

3. Apply the CORS configuration using the exact bucket name from your Firebase configuration:
   ```bash
   gsutil cors set cors.json gs://ifaa-472315.firebasestorage.app
   ```

### Finding Your Project ID and Storage Bucket Name

1. Go to the Firebase Console: https://console.firebase.google.com/
2. Select your project
3. In the project settings (gear icon), find your Project ID and Storage Bucket name
4. Use the exact Storage Bucket name as shown in the Firebase console

### Alternative Method: Using Firebase Console

If you continue to have issues with gsutil, you can manually configure CORS through the Firebase Console:

1. Go to https://console.firebase.google.com/
2. Select your project
3. Click on "Storage" in the left sidebar
4. Click on the "Rules" tab
5. Replace the existing rules with the following:
   ```json
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       match /{allPaths=**} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```
6. Click "Publish" to save the rules

### Verification

After applying the CORS configuration, restart your Flutter web app:
```bash
flutter run -d chrome
```

The image upload should now work without CORS errors.

## Notes

- The `cors.json` file has already been created in your project directory
- For production environments, you should restrict the origins to your specific domain instead of using "*"
- If you continue to experience issues, try clearing your browser cache and restarting the development server