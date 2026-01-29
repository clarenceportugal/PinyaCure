"""
Simple script para i-convert ang Keras model sa TFLite format
"""
import tensorflow as tf
import os
import sys

# Fix encoding for Windows console
if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

print("Loading Keras model...")
model_path = "assets/models/disease_model.keras"
output_path = "assets/models/pineapple_disease_model_quantized.tflite"

try:
    # Load the Keras model without compiling (to avoid custom loss function issues)
    print(f"Loading from: {model_path}")
    model = tf.keras.models.load_model(model_path, compile=False)
    print("✓ Model loaded successfully")
    print(f"  Input shape: {model.input_shape}")
    print(f"  Output shape: {model.output_shape}")
    
    # Convert to TFLite with quantization (para mas maliit ang size)
    print("\nConverting to TFLite format with quantization...")
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    
    tflite_model = converter.convert()
    
    # Save
    with open(output_path, 'wb') as f:
        f.write(tflite_model)
    
    file_size = os.path.getsize(output_path) / (1024 * 1024)
    print("✓ Conversion successful!")
    print(f"  Output: {output_path}")
    print(f"  Size: {file_size:.2f} MB")
    print("\n✓ Done! Ilagay na ito sa assets/models/ folder")
    
except Exception as e:
    print(f"Error: {e}")
    import traceback
    traceback.print_exc()
