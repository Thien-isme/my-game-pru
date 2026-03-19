import os
from PIL import Image

# 1. Cấu hình thư mục và tỷ lệ thu nhỏ
folder_path = "Enemies"
scale_factor = 0.5  # 0.5 tương đương với 50%

# Các định dạng ảnh muốn xử lý
valid_extensions = ('.png', '.jpg', '.jpeg', '.webp')

# 2. Duyệt qua tất cả các thư mục và file
for root, dirs, files in os.walk(folder_path):
    for file in files:
        if file.lower().endswith(valid_extensions):
            file_path = os.path.join(root, file)
            
            try:
                # 3. Mở ảnh để lấy kích thước gốc
                with Image.open(file_path) as img:
                    original_width, original_height = img.size
                    
                    # Tính toán kích thước mới (ép kiểu int vì pixel không thể là số thập phân)
                    new_width = int(original_width * scale_factor)
                    new_height = int(original_height * scale_factor)
                    
                    # Đảm bảo kích thước mới tối thiểu là 1x1 (tránh lỗi với ảnh quá nhỏ)
                    new_width = max(1, new_width)
                    new_height = max(1, new_height)

                    # 4. Resize và lưu đè
                    resized_img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
                    resized_img.save(file_path)
                    
                    print(f"Đã giảm 50%: {file.ljust(20)} | {original_width}x{original_height} -> {new_width}x{new_height}")
            except Exception as e:
                print(f"Lỗi với file {file_path}: {e}")

print("\n--- Hoàn tất thu nhỏ 50% tất cả ảnh! ---")