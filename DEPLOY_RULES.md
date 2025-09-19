# Firebase Security Rules Deployment Instructions

## Prerequisites

1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```

2. Login to Firebase:
   ```bash
   firebase login
   ```

## Deploy Security Rules

Run the following command from the project root directory:

```bash
firebase deploy --only firestore:rules
```

This will deploy the security rules defined in `firestore.rules` file to your Firebase project.

## Security Rules Overview

The current rules allow:
- Users to read, create, and update their own documents in the `users` collection
- Admin users to read any user document (once admin role is properly set)
- Default deny for all other operations

## Troubleshooting

If you encounter permission errors:
1. Make sure you're logged into the correct Firebase account
2. Verify that the Firebase project ID in `web/firebase-config.js` matches your Firebase project
3. Check that you have the necessary permissions to deploy rules to the project