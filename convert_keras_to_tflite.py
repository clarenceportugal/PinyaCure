"""
Script para i-convert ang Keras model (.h5 o .keras) sa TensorFlow Lite format (.tflite)
Para sa PinyaCure app.

Usage:
    python convert_keras_to_tflite.py --input your_model.h5 --output disease_model.tflite
"""

import tensorflow as tf
import argparse
import os

def convert_keras_to_tflite(input_path, output_path, quantize=False):
    """
    Convert Keras model to TensorFlow Lite format
    
    Args:
        input_path: Path to input Keras model (.h5 or .keras)
        output_path: Path to output TFLite model (.tflite)
        quantize: If True, apply quantization to reduce model size
    """
    print(f"Loading Keras model from: {input_path}")
    
    # Load the Keras model
    try:
        model = tf.keras.models.load_model(input_path)
        print(f"✓ Model loaded successfully")
        print(f"  Input shape: {model.input_shape}")
        print(f"  Output shape: {model.output_shape}")
    except Exception as e:
        print(f"✗ Error loading model: {e}")
        return False
    
    # Convert to TFLite
    print(f"\nConverting to TensorFlow Lite format...")
    try:
        converter = tf.lite.TFLiteConverter.from_keras_model(model)
        
        # Apply quantization if requested (reduces model size)
        if quantize:
            print("  Applying quantization...")
            converter.optimizations = [tf.lite.Optimize.DEFAULT]
        
        # Convert
        tflite_model = converter.convert()
        
        # Save the converted model
        with open(output_path, 'wb') as f:
            f.write(tflite_model)
        
        file_size = os.path.getsize(output_path) / (1024 * 1024)  # Size in MB
        print(f"✓ Conversion successful!")
        print(f"  Output: {output_path}")
        print(f"  Size: {file_size:.2f} MB")
        
        return True
        
    except Exception as e:
        print(f"✗ Error during conversion: {e}")
        return False

def main():
    parser = argparse.ArgumentParser(
        description='Convert Keras model to TensorFlow Lite format'
    )
    parser.add_argument(
        '--input', '-i',
        type=str,
        required=True,
        help='Input Keras model file (.h5 or .keras)'
    )
    parser.add_argument(
        '--output', '-o',
        type=str,
        required=True,
        help='Output TFLite model file (.tflite)'
    )
    parser.add_argument(
        '--quantize', '-q',
        action='store_true',
        help='Apply quantization to reduce model size (recommended for mobile)'
    )
    
    args = parser.parse_args()
    
    # Validate input file
    if not os.path.exists(args.input):
        print(f"✗ Error: Input file not found: {args.input}")
        return
    
    # Validate output directory
    output_dir = os.path.dirname(args.output)
    if output_dir and not os.path.exists(output_dir):
        os.makedirs(output_dir)
        print(f"Created output directory: {output_dir}")
    
    # Convert
    success = convert_keras_to_tflite(args.input, args.output, args.quantize)
    
    if success:
        print(f"\n✓ Done! Ilagay ang {args.output} sa assets/models/ folder")
    else:
        print(f"\n✗ Conversion failed")

if __name__ == '__main__':
    main()
