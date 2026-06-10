# Rick and Morty Flutter App

A mobile application built with Flutter that displays character information from the Rick and Morty REST API.

## Features

### Basic Requirements (Grade 4.0)
- **Two Screens**: Character list and Character details.
- **REST API Integration**: Fetches list of characters and individual character details.
- **Offline Mode**: Uses `sqflite` for local data persistence. If there's no internet, the app loads data from the local database.
- **State Management**: Uses `Provider` to handle loading states and data updates.
- **Error Handling**: Displays user-friendly error messages with retry options.
- **UI/UX**: Clean and readable Material 3 design.

### Advanced Requirements (Grade 5.0)
- **Four Screens**: List, Details, Favorites, and Settings.
- **Favorites**: Users can save their favorite characters locally.
- **Settings**: Basic settings screen with profile and app information.
- **Manual Refresh**: Support for "Pull to Refresh" on the character list.
- **Firebase Ready**: Dependencies added for Analytics and Crashlytics (requires `google-services.json` for full activation).

## Technologies Used
- **Framework**: Flutter
- **State Management**: Provider
- **Local Database**: Sqflite
- **Network**: Http
- **Image Caching**: CachedNetworkImage
- **Connectivity**: ConnectivityPlus

## API Used
- [Rick and Morty API](https://rickandmortyapi.com/)

## Installation
1. Clone the repository.
2. Run `flutter pub get`.
3. Run the app on an emulator or physical device.
