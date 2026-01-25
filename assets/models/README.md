# ML Models Folder

Ilagay ang iyong trained TensorFlow Lite models dito.

## Kailangang Files:

### 1. Disease Detection Model (Pagtuklas ng Sakit)
- **Filename:** `disease_model.tflite`
- **Input:** Larawan (224x224 o depende sa model)
- **Output:** Classification ng sakit
- **Labels:** `labels.txt` - Isang label bawat linya

**Example `labels.txt`:**
```
Healthy
Phytophthora Heart Rot
Bacterial Heart Rot
Mealybug Wilt
Fusarium Wilt
```

### 2. Sweetness Level Model (Antas ng Tamis)
- **Filename:** `sweetness_model.tflite`
- **Input:** Larawan (224x224 o depende sa model)
- **Output:** Antas ng tamis (M1, M2, M3, M4)
- **Labels:** `labels_sweetness.txt`

**Example `labels_sweetness.txt`:**
```
M1
M2
M3
M4
```

### 3. Nutrient Deficiency Model (Kakulangan sa Nutrient) - BAGO!
- **Filename:** `nutrient_model.tflite`
- **Input:** Larawan (224x224 o depende sa model)
- **Output:** Classification ng nutrient deficiency
- **Labels:** `labels_nutrient.txt`

**Example `labels_nutrient.txt`:**
```
Walang Kakulangan
Nitrogen (N)
Phosphorus (P)
Potassium (K)
Iron (Fe)
Zinc (Zn)
Magnesium (Mg)
Calcium (Ca)
Boron (B)
```

## Folder Structure:

```
assets/
  models/
    ├── disease_model.tflite      ← Disease detection model
    ├── labels.txt                 ← Disease labels
    ├── sweetness_model.tflite     ← Sweetness prediction model
    ├── labels_sweetness.txt       ← Sweetness labels
    ├── nutrient_model.tflite      ← Nutrient deficiency model
    └── labels_nutrient.txt        ← Nutrient labels
```

## Paano i-convert ang Model sa TFLite:

```python
import tensorflow as tf

# Load ang trained model
model = tf.keras.models.load_model('your_model.h5')

# Convert to TFLite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# Save
with open('disease_model.tflite', 'wb') as f:
    f.write(tflite_model)
```

## Pagkatapos maglagay ng Models:

1. **Ilagay ang files** sa `assets/models/` folder
2. **I-run ang:** `flutter pub get`
3. **I-restart ang app**

## Notes:

- Ang `pubspec.yaml` ay naka-configure na para sa `assets/models/` folder
- Kung walang model, magpapakita ang app ng placeholder message
- Tiyakin na tama ang format ng labels file (isang label bawat linya, walang extra spaces)
