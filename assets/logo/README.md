# Logo Folder

This folder is for storing your PinyaCure logo files.

## Supported Formats
- PNG (recommended for app icons)
- SVG (recommended for scalable graphics)
- JPG/JPEG

## Usage in Flutter

After adding your logo file (e.g., `logo.png`), you can use it in your app like this:

```dart
Image.asset('assets/logo/logo.png')
```

Or in an AppBar:
```dart
AppBar(
  leading: Image.asset('assets/logo/logo.png'),
)
```

## Recommended Sizes
- App Icon: 1024x1024px
- AppBar Logo: 200x200px or smaller
- Splash Screen: 512x512px or larger

## Note
Make sure to run `flutter pub get` after adding new assets to ensure they are properly registered.
