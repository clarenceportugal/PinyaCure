"""
Convert sweetness.keras to TFLite format
"""
import tensorflow as tf
import os
import sys

if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

model_path = "assets/models/sweetness.keras"
output_path = "assets/models/sweetness_model.tflite"

try:
    print("Loading sweetness model...")
    model = tf.keras.models.load_model(model_path, compile=False)
    print("Model loaded successfully")
    print(f"  Input shape: {model.input_shape}")
    print(f"  Output shape: {model.output_shape}")

    print("\nConverting to TFLite with quantization...")
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    tflite_model = converter.convert()

    with open(output_path, 'wb') as f:
        f.write(tflite_model)

    file_size = os.path.getsize(output_path) / (1024 * 1024)
    print("Conversion successful!")
    print(f"  Output: {output_path}")
    print(f"  Size: {file_size:.2f} MB")
except Exception as e:
    print(f"Error: {e}")
    import traceback
    traceback.print_exc()
