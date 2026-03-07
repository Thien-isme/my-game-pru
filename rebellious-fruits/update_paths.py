import os
import glob

directory = r"d:\GameWithGodot\my-game-pru\rebellious-fruits"

replacements = {
    "res://scenes/enemies/enemy_script.gd": "res://scenes/enemies/base_scripts/enemy_script.gd",
    "res://scenes/enemies/enemy_bullet.gd": "res://scenes/enemies/base_scripts/enemy_bullet.gd",
    "res://scenes/enemies/enemy_spawner_controller.tscn": "res://scenes/enemies/spawner/enemy_spawner_controller.tscn",
    "res://scenes/enemies/enemy_spawner_controller.gd": "res://scenes/enemies/spawner/enemy_spawner_controller.gd",
    "res://scenes/enemies/enemy_spawner_item.gd": "res://scenes/enemies/spawner/enemy_spawner_item.gd"
}

for root, _, files in os.walk(directory):
    for f in files:
        if f.endswith(".tscn") or f.endswith(".gd") or f.endswith(".tres"):
            filepath = os.path.join(root, f)
            try:
                with open(filepath, "r", encoding="utf-8") as file:
                    content = file.read()
                
                new_content = content
                for old, new in replacements.items():
                    new_content = new_content.replace(old, new)
                
                if new_content != content:
                    with open(filepath, "w", encoding="utf-8", newline='\n') as file:
                        file.write(new_content)
                    print(f"Updated {filepath}")
            except Exception as e:
                print(f"Error reading {filepath}: {e}")
