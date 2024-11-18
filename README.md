# Flutter Firebase Clean Architecture Template

A production-ready Flutter template using Clean Architecture, BLoC pattern, and Firebase integration. Developed to deepen my understanding of enterprise-level mobile development patterns. Through building this boilerplate, I gained practical experience with dependency injection, separation of concerns, and scalable state management. The project particularly helped me grasp how Clean Architecture's layered approach enhances code maintainability and testability, while implementing the BLoC pattern improved my understanding of reactive programming and state handling in modern mobile applications.


## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Firebase CLI
- A Firebase project

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/your-repo-name.git
   cd your-repo-name
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   ```bash
   # Install Firebase CLI if you haven't
   npm install -g firebase-tools

   # Login to Firebase
   firebase login

   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli

   # Configure Firebase for your project
   flutterfire configure
   ```

   This will:
   - Generate `firebase_options.dart`
   - Configure platform-specific Firebase files
   - Set up necessary Firebase services

4. **Run the app**
   ```bash
   flutter run
   ```

## Features

- **Authentication**: Login functionality (`login_page.dart`)
- **Home Screen**: Main app interface (`home_page.dart`)
- **Resort Management**: Resort data handling with BLoC pattern (`resort_bloc.dart`)
- **Firebase Integration**: Ready-to-use Firebase configuration

## Architecture

This project follows Clean Architecture principles:

### 1. Domain Layer
- **Repositories**: Defines data contracts (e.g., `message_repository.dart`)
- **Use Cases**: 
  - `get_message_usecase.dart`: Handles message retrieval logic
  - `get_resorts_usecase.dart`: Manages resort data fetching

### 2. Presentation Layer
- **Pages**: 
  - `login_page.dart`: Handles user authentication
  - `home_page.dart`: Main app interface
- **BLoC**: 
  - `resort_bloc.dart`: Manages resort-related state and business logic

## Configuration

### Firebase Services
This template is configured for:
- Authentication (for login functionality)
- Cloud Firestore (for resort data)
- Other Firebase services can be enabled as needed



## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Clean Architecture
- BLoC Pattern
- Firebase
- Flutter Community