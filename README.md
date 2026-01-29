# PinyaCure

PinyaCure is a Flutter app for pineapple disease detection and sweetness prediction using on-device ML (TensorFlow Lite).

## Features

- **I-Scan**: Capture a photo of a pineapple; the app detects possible diseases (top 3) and predicts sweetness level (M1–M4).
- **Listahan**: Browse disease information and treatments.
- **Kasaysayan**: View past scan results.

## Requirements

- Flutter SDK (see `pubspec.yaml` for SDK constraint)
- Android / iOS device or emulator with camera (for scan)

## Getting Started

1. **Clone and install**
   ```bash
   git clone <repo-url>
   cd pinyacure
   flutter pub get
   ```

2. **Run the app**
   ```bash
   flutter run
   ```
   Use a device or emulator with camera for the I-Scan feature.

3. **Run tests**
   ```bash
   flutter test
   ```

## Assets

- **Models** (in `assets/models/`):
  - `pineapple_disease_model.tflite` – disease detection (16 classes)
  - `sweetness_model.tflite` – sweetness regression (M1–M4)
  - `labels.txt` – disease labels for the disease model

See `CONVERT_MODEL_COLAB.md` and the Python scripts in the project root for converting/training models.

## Project structure

- `lib/main.dart` – app entry and navigation
- `lib/screens/` – home, scanner, diseases list, history, treatment
- `lib/services/` – ML inference (`ml_service.dart`), scan history
- `lib/data/` – disease treatments and labels

## License

Private / project-specific.
