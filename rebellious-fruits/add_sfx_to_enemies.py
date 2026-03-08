import os
import re
import glob

base = r"d:\GameWithGodot\my-game-pru\rebellious-fruits\scenes\enemies"
enemies = ["apple","bittergourd","carrot","chili","corn","dragonfruit","lemon","lychee","mangosteen","pear","pumpkin","starapple","starfruit","watermelon"]

sfx_node_str = "\n[node name=\"SFXPlayer\" type=\"AudioStreamPlayer\" parent=\".\"]\n"

for enemy in enemies:
    tscn_path = os.path.join(base, enemy, f"{enemy}.tscn")
    if not os.path.exists(tscn_path):
        print(f"SKIP (not found): {tscn_path}")
        continue
    
    with open(tscn_path, "r", encoding="utf-8") as f:
        content = f.read()
    
    # Skip if already has SFXPlayer
    if "SFXPlayer" in content:
        print(f"SKIP (already has SFXPlayer): {enemy}")
        continue
    
    # Append SFXPlayer node at the very end (before trailing newline if any)
    content = content.rstrip() + sfx_node_str
    
    with open(tscn_path, "w", encoding="utf-8", newline="\n") as f:
        f.write(content)
    
    print(f"Updated: {enemy}.tscn")

print("Done!")
