# Wallpi iOS App

<p align="center">
  <img src="https://github.com/isml/wallpi_iOS/blob/main/WPI_Assets/WPIGif.gif" alt="Wallpi App">
</p>

## Screenshots

<p align="center">
  <img src="https://github.com/isml/wallpi_iOS/blob/main/WPI_Assets/WPIHome.PNG" width="200">
  <img src="https://github.com/isml/wallpi_iOS/blob/main/WPI_Assets/WPICategoriesHome.PNG" width="200">
  <img src="https://github.com/isml/wallpi_iOS/blob/main/WPI_Assets/WPIDetail.PNG" width="200">
</p>

## Description

Wallpi is an iOS app that allows you to discover and download beautiful wallpapers. The app uses the Pexels API to fetch high-quality images from various categories.

## Features

- Browse a vast collection of wallpapers.
- Explore wallpapers by categories.
- View detailed information about each wallpaper.
- Download wallpapers to your device.

## Installation

To run the app locally, follow these steps:

1. Clone this repository.
2. Open the project in Xcode.
3. Build and run the app on a simulator or a physical device.

## Pexels API Key

In order to use the Pexels API, you need to obtain an API key. Add your API key to the `PexelsAPI.swift` file.

```swift
struct PexelsAPI {
    static let apiKey = "YOUR_PEXELS_API_KEY"
}
