# 📸 Pose Guide App

> A Clean Architecture Flutter Camera App that helps users strike the perfect pose using "Ghost" overlays.

![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue)
![State Management](https://img.shields.io/badge/State-GetX-red)
![Architecture](https://img.shields.io/badge/Architecture-Clean-green)

## 📱 Overview

**Pose Guide** solves the awkward "I don't know how to pose" problem. It overlays professional pose outlines (ghosts) directly onto the camera viewfinder, allowing users to align themselves or their friends with the guide for the perfect shot.

## ✨ Features

* **Real-time Camera Overlay:** High-contrast white line guides over the camera feed.
* **Smart Categorization:**
    * 1 Person (Selfies/Portraits)
    * 2 Persons (Couples/Friends)
    * 3 Persons (Trios)
    * 4 Persons (Groups)
* **Randomizer:** Can't decide? Hit the Random button to get a surprise pose suggestion.
* **Instant Capture:** Take photos directly within the app.
* **Clean UI:** Minimalist interface with high-contrast controls.

## 🏗️ Architecture

This project follows strict **Clean Architecture** principles to ensure scalability and testability:

```text
lib/
├── data/           # Repositories & Data Sources
├── domain/         # Entities & Business Logic (Pure Dart)
└── presentation/   # UI (Pages) & State Management (Controllers)