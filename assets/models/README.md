# ML Models Folder

Place your trained TensorFlow Lite models here.

## Required Files:

### 1. Disease Detection Model
- **Filename:** `disease_model.tflite`
- **Input:** Image (224x224 or your model's input size)
- **Output:** Disease classification

### 2. Sweetness Level Model
- **Filename:** `sweetness_model.tflite`
- **Input:** Image (224x224 or your model's input size)
- **Output:** Sweetness level (M1, M2, M3, M4)

### 3. Labels File
- **Filename:** `labels.txt`
- **Format:** One label per line

Example `labels.txt` for diseases:
```
Healthy
Phytophthora Heart Rot
Bacterial Heart Rot
Mealybug Wilt
Fusarium Wilt
```

Example `labels_sweetness.txt`:
```
M1
M2
M3
M4
```

## How to Convert Your Model to TFLite:

```python
import tensorflow as tf

# Load your trained model
model = tf.keras.models.load_model('your_model.h5')

# Convert to TFLite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# Save
with open('disease_model.tflite', 'wb') as f:
    f.write(tflite_model)
```

## After Adding Models:

Run `flutter pub get` to register the assets.
