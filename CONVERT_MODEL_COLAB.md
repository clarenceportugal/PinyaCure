# Paano i-convert ang Keras Model sa TFLite (Google Colab)

## Option 1: Google Colab (Pinakamadali)

1. **Buksan ang Google Colab:** https://colab.research.google.com/

2. **I-upload ang `disease_model.keras` file:**
   - Click sa folder icon sa left sidebar
   - Click "Upload" button
   - Piliin ang `disease_model.keras` file

3. **I-run ang code na ito sa Colab:**

```python
import tensorflow as tf
import os

# Load the Keras model
print("Loading Keras model...")
model = tf.keras.models.load_model('disease_model.keras')
print(f"✓ Model loaded!")
print(f"  Input shape: {model.input_shape}")
print(f"  Output shape: {model.output_shape}")

# Convert to TFLite with quantization
print("\nConverting to TFLite...")
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]

tflite_model = converter.convert()

# Save
output_path = 'pineapple_disease_model_quantized.tflite'
with open(output_path, 'wb') as f:
    f.write(tflite_model)

file_size = os.path.getsize(output_path) / (1024 * 1024)
print(f"✓ Conversion successful!")
print(f"  Output: {output_path}")
print(f"  Size: {file_size:.2f} MB")

# Download the file
from google.colab import files
files.download(output_path)
```

4. **I-download ang converted file** at ilagay sa `assets/models/` folder

## Option 2: Local Python (kung may working TensorFlow)

Kung may working TensorFlow installation ka:

```bash
python convert_model.py
```

## Pagkatapos ma-convert:

1. Ilagay ang `pineapple_disease_model_quantized.tflite` sa `assets/models/` folder
2. I-run: `flutter clean && flutter pub get`
3. I-restart ang app
