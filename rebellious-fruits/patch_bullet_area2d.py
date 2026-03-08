import os
import re

base = r"d:\GameWithGodot\my-game-pru\rebellious-fruits\scenes\enemies"
enemies = {
    "apple": "apple.tscn",
    "bittergourd": "bittergourd.tscn",
    "carrot": "carrot.tscn",
    "chili": "chili.tscn",
    "corn": "corn.tscn",
    "dragonfruit": "dragonfruit.tscn", # or dragronfruit.tscn
    "eggplant": "eggplant.tscn",
    "lemon": "lemon.tscn",
    "lychee": "lychee.tscn",
    "mangosteen": "mangosteen.tscn",
    "pear": "pear.tscn",
    "pumpkin": "pumpkin.tscn",
    "starapple": "starapple.tscn",
    "starfruit": "starfruit.tscn",
    "watermelon": "watermelon.tscn",
}

for folder, filename in enemies.items():
    bullet_filename = filename.replace('.tscn', '_bullet.tscn')
    tscn_path = os.path.join(base, folder, bullet_filename)
    if not os.path.exists(tscn_path):
        if 'dragonfruit' in folder:
            bullet_filename = 'dragronfruit_bullet.tscn'
            tscn_path = os.path.join(base, folder, bullet_filename)
        
    if not os.path.exists(tscn_path):
        print(f"SKIP (not found): {tscn_path}")
        continue

    with open(tscn_path, "r", encoding="utf-8") as f:
        content = f.read()

    original = content

    # Replace the node type of the root node (first node)
    # The root node in a Godot scene usually looks like:
    # [node name="apple_bullet" type="CharacterBody2D"]
    # We want to change it to type="Area2D"
    
    # Simple regex to replace type="CharacterBody2D" in [node ] blocks that don't have parent
    # The root node never has a parent="..." attribute.
    
    def replace_root_node(match):
        block = match.group(0)
        if 'parent="' not in block:
            # It's a root node or similar
            return block.replace('type="CharacterBody2D"', 'type="Area2D"')
        return block

    content = re.sub(r'\[node name="[^"]+" type="CharacterBody2D"[^\]]*\]', replace_root_node, content)

    if content != original:
        with open(tscn_path, "w", encoding="utf-8", newline="\n") as f:
            f.write(content)
        print(f"Updated: {folder}/{bullet_filename}")
    else:
        print(f"No change needed: {folder}/{bullet_filename}")

print("\nAll done!")
