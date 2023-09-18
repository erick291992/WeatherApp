# Weather App

## Overview

This Weather App is a simple iOS application that provides users with up-to-date weather information for their current location and allows them to search for weather information in different cities. The app follows the MVVM (Model-View-ViewModel) design pattern to maintain a clean and organized codebase.

## Notes

- **Loading Indicators**: We are continuously working on improving the user experience. In future updates, we plan to enhance the app by adding loading indicators for views that populate data obtained from location services and storage.


## Features

- Display the current weather conditions for the user's current location.
- Allow users to search for weather information in different cities.
- Check user location permissions and, if disabled, load the last searched location to retrieve the weather for that location.
- Load weather icons using the `SDWebImageSwiftUI` library.

## Dependencies

### SDWebImageSwiftUI

We use the `SDWebImageSwiftUI` library to efficiently load and display weather icons. This library simplifies the process of asynchronously downloading and caching images from the web.

To include `SDWebImageSwiftUI` in this project, we're using Swift Package Manager (SPM). If you're working on your own project and want to add this library, follow these steps:

1. Open your Xcode project.
2. Go to "File" > "Add Package..."
3. In the search bar, enter "https://github.com/SDWebImage/SDWebImageSwiftUI" and select the appropriate package from the search results.
4. Follow the prompts to add the package to your project.
