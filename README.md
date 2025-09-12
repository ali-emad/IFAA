# IFAA Template Flutter App

This repository contains a modern Flutter application template modelled after the structure of the Iranian Football Association Australia (IFAA) website.  It is intended as a starting point for building a responsive web/mobile application that mirrors the key pages and functionality of the site.

## Overview

The app uses Flutter with Material 3 and implements responsive navigation through `go_router` and a custom shell.  It includes example pages for:

- Home: A hero card and quick links to the membership form and events.
- About: Description of the association and its mission.
- Vision: Bullet points for the organisation’s vision.
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