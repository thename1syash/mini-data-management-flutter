# mini_data_management

A new Flutter project.

## Getting Started

# Mini Data Management App (Flutter)

A Flutter application built to demonstrate **app navigation, local authentication,
persistent data storage, and clean UI/UX practices**.  
This project is designed as an **intern-level assessment app** showcasing real-world Flutter fundamentals.



##  App Overview

The Mini Data Management App allows users to:
- Experience a **one-time onboarding flow**
- **Sign up and log in locally** (no backend)
- Stay logged in across app restarts
- Add and manage personal address data
- Persist all data locally using SharedPreferences

All data remains available even after closing and reopening the app.

---

##  Features

### 🔹 Onboarding Flow
- Displays only on **first app launch**
- Never appears again once completed
- Uses local storage to track onboarding state

### 🔹 Authentication Local
- Signup and login functionality
- Multiple users supported
- Only registered users can log in
- Auto-login if user is already authenticated

### 🔹 Persistent Data Management
- Users can add multiple addresses
- Each address contains:
  - Address Line 1
  - Address Line 2
- Data is stored **per user**
- Addresses remain after app restart

### 🔹 UI / UX Enhancements
- Gradient-based modern UI
- Material Design 3 components
- Loading indicators
- Success & error feedback 
- Confirmation dialog on logout
- Empty state UI when no data exists

---

## 🛠️ Tech Stack

- **Flutter**
- **Dart**
- **SharedPreferences** 
- **Material Design 3**

---

##  How to Run the App

###  Clone the Repository
```bash
git clone https://github.com/thename1syash/mini-data-management-flutter.git
cd mini-data-management-flutter
flutter pub get
flutter run

You can run it on:
Android Emulator
Physical Android device
Chrome (web)
Windows desktop
Home Screen

Enter:
Address Line 1
Address Line 2
Tap Done

Address is saved and displayed in a list

If no address exists:

An empty-state message is shown

Logout
Tap logout icon
Confirm logout via dialog

User is redirected to login screen