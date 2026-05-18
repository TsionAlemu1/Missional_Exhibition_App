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
<img width="385" height="721" alt="Screenshot 2026-05-18 114310" src="https://github.com/user-attachments/assets/dfdb78c5-a200-4ea5-b49a-8923b4bc2d1b" />


## Home Screen

<img width="501" height="944" alt="Screenshot 2026-05-17 170937" src="https://github.com/user-attachments/assets/2109b1d2-508d-4d51-a721-1373a2ef793d" />


## Add Material Screen

<img width="376" height="722" alt="Screenshot 2026-05-18 115021" src="https://github.com/user-attachments/assets/c53da2e7-af85-4c44-8eaf-5cdefc8fe33b" />


## Adding material success message 
<img width="387" height="732" alt="Screenshot 2026-05-18 115208" src="https://github.com/user-attachments/assets/03764a36-7c77-4852-bcf7-649673a292b0" />

## Edit Material Screen

<img width="375" height="720" alt="Screenshot 2026-05-18 115302" src="https://github.com/user-attachments/assets/198f64b4-7bcc-48af-a07d-e6f47ed17aa1" />

## Edit success message 
<img width="384" height="720" alt="Screenshot 2026-05-18 115324" src="https://github.com/user-attachments/assets/5cca75fe-6c9a-47ef-b208-351c5168f5b2" />

## Delete Material Screen

---
<img width="378" height="726" alt="Screenshot 2026-05-18 115401" src="https://github.com/user-attachments/assets/3c1cc38d-daef-4118-ba04-caf14e24dafa" />
## Delete success message 
<img width="389" height="719" alt="Screenshot 2026-05-18 115420" src="https://github.com/user-attachments/assets/eaceeb97-6890-4cf1-adfd-43ddba3ddf4f" />


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


