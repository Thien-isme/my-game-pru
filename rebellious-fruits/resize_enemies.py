import os
from PIL import Image

# Configuration
target_directory = os.path.join("assets", "sprites", "enemies")
scale_factor = 0.5
valid_extensions = ('.png', '.jpg', '.jpeg', '.webp')

def resize_images(directory, scale):
    if not os.path.exists(directory):
        print(f"Error: Directory '{directory}' not found.")
        return

    print(f"Starting resize in: {directory}")
    print(f"Scale factor: {scale}")
    
    count = 0
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.lower().endswith(valid_extensions):
                file_path = os.path.join(root, file)
                try:
                    with Image.open(file_path) as img:
                        original_width, original_height = img.size
                        
                        new_width = max(1, int(original_width * scale))
                        new_height = max(1, int(original_height * scale))
                        
                        # Resize using high-quality LANCZOS filter
                        resized_img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
                        resized_img.save(file_path)
                        
                        count += 1
                        print(f"[{count}] Resized {file_path}: {original_width}x{original_height} -> {new_width}x{new_height}")
                except Exception as e:
                    print(f"Error processing {file_path}: {e}")

    print(f"\nCompleted! Total images resized: {count}")

if __name__ == "__main__":
    resize_images(target_directory, scale_factor)
