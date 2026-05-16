# Mission Exhibition 5K

A Flutter mobile application developed for managing mission exhibition materials and resources for university fellowship mission programs.

This project was built as part of a Flutter CRUD API assignment using Bloc state management and Dio for network communication.

---

# Project Overview

Mission Exhibition 5K is designed to support a university fellowship mission exhibition program that contains six major mission sections:

1. Mission in Old Testament
2. Mission in New Testament
3. Mission History
4. Ethiopian Missionaries
5. 10/40 Window Unreached People
6. Mission in Campus

The application allows users to manage mission exhibition materials and resources through CRUD operations.

---

# Features

* View all mission exhibition materials
* View material details
* Add new exhibition materials
* Update existing materials
* Delete materials
* Mission category organization
* Clean and responsive UI
* Loading and error handling states
* REST API integration using Dio
* Bloc state management implementation

---

# Technologies Used

* Flutter
* Dart
* Flutter Bloc
* Equatable
* Dio
* REST API

---

# API Used

This project uses the public API from:

https://fakestoreapi.com/

---

# CRUD Operations

| Operation | HTTP Method |
| --------- | ----------- |
| Create    | POST        |
| Read      | GET         |
| Update    | PUT/PATCH   |
| Delete    | DELETE      |

---

# Project Structure

```bash
lib/
│
├── core/
│   ├── constants/
│   ├── errors/
│   └── network/
│
├── features/
│   └── materials/
│       ├── data/
│       │   ├── models/
│       │   ├── repositories/
│       │   └── services/
│       │
│       ├── domain/
│       │
│       └── presentation/
│           ├── bloc/
│           ├── screens/
│           └── widgets/
│
└── main.dart
```

---

# Screenshots

## Splash Screen

not yet

## Home Screen

not yet

## Materials Screen

not yet

## Material Details Screen

not yet

## Add Material Screen

not yet

## Edit Material Screen

not yet

---

# Getting Started

## Clone the repository

```bash
git clone https://github.com/TsionAlemu1/Missional_Exhibition_App.git
```

## Install dependencies

```bash
flutter pub get
```

## Run the application

```bash
flutter run
```

---

# Dependencies

```yaml
flutter_bloc:
dio:
equatable:
```

---

# Assignment Requirements Covered

* CRUD API consumption
* Dio package integration
* Bloc state management
* Clean architecture
* Error handling
* Loading states
* GitHub repository management

---

# Future Improvements

* Authentication system
* Dark mode
* Search functionality
* Material filtering by category
* Offline caching
* Push notifications
* Admin dashboard

---

# Author

Developed by Tsion Alemu


