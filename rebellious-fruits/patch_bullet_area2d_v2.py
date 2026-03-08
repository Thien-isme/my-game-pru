import os
import re

base = r"d:\GameWithGodot\my-game-pru\rebellious-fruits\scenes\enemies"
enemies = {
    "apple": "apple.tscn",
    "bittergourd": "bittergourd.tscn",
    "carrot": "carrot.tscn",
    "chili": "chili.tscn",
    "corn": "corn.tscn",
    "dragonfruit": "dragonfruit.tscn",
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
            continue

    with open(tscn_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original = content
    
    # Simple replace for the node definition line
    content = re.sub(
        r'(\[node name="[^"]+" type=")CharacterBody2D("\])',
        r'\g<1>Area2D\g<2>',
        content,
        count=1
    )

    if content != original:
        with open(tscn_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated: {tscn_path}")
    else:
        print(f"No change: {tscn_path}")
print("Done")
