import os
import re

base = r"d:\GameWithGodot\my-game-pru\rebellious-fruits\scenes\enemies"
enemies = {
    "apple": "apple.tscn",
    "bittergourd": "bittergourd.tscn",
    "carrot": "carrot.tscn",
    "chili": "chili.tscn",
    "corn": "corn.tscn",
    "dragonfruit": "dragronfruit.tscn",  # typo in original filename
    "lemon": "lemon.tscn",
    "lychee": "lychee.tscn",
    "mangosteen": "mangosteen.tscn",
    "pear": "pear.tscn",
    "pumpkin": "pumpkin.tscn",
    "starapple": "starapple.tscn",
    "starfruit": "starfruit.tscn",
    "watermelon": "watermelon.tscn",
}

TARGET_RADIUS = 26.0
TARGET_HEIGHT = 70.0

for folder, filename in enemies.items():
    tscn_path = os.path.join(base, folder, filename)
    if not os.path.exists(tscn_path):
        print(f"SKIP (not found): {tscn_path}")
        continue

    with open(tscn_path, "r", encoding="utf-8") as f:
        content = f.read()
    
    original = content

    # Find all sub_resource blocks that define a CapsuleShape2D
    # Update radius and height inside CapsuleShape2D blocks
    def patch_capsule(m):
        block = m.group(0)
        block = re.sub(r'radius\s*=\s*[\d.]+', f'radius = {TARGET_RADIUS}', block)
        block = re.sub(r'height\s*=\s*[\d.]+', f'height = {TARGET_HEIGHT}', block)
        return block

    # Find all CapsuleShape2D sub_resources; they span until the next [tag]
    content = re.sub(
        r'\[sub_resource type="CapsuleShape2D"[^\]]*\][^\[]*',
        patch_capsule,
        content
    )

    # If enemy uses RectangleShape2D for body (not DetectZone/Attack), replace it with CapsuleShape2D
    # We'll only target the FIRST CollisionShape2D (body hitbox), not DetectZone or AttackZone ones.
    # Check if there IS a CapsuleShape2D already
    if 'CapsuleShape2D' not in content:
        print(f"  → No CapsuleShape2D found, checking for other shape types...")
        # Look for the first sub_resource shape (body capsule) in the file
        # Find the id used by the root CollisionShape2D node
        root_collision_match = re.search(
            r'\[node name="CollisionShape2D".*?parent="\.".*?shape\s*=\s*SubResource\("([^"]+)"\)',
            content, re.DOTALL
        )
        if root_collision_match:
            shape_id = root_collision_match.group(1)
            print(f"  → Root body CollisionShape2D uses: {shape_id}")
            # Find and replace whatever shape that is with a CapsuleShape2D
            content = re.sub(
                rf'\[sub_resource type="[^"]*" id="{re.escape(shape_id)}"\][^\[]*',
                f'[sub_resource type="CapsuleShape2D" id="{shape_id}"]\nradius = {TARGET_RADIUS}\nheight = {TARGET_HEIGHT}\n\n',
                content
            )
    
    if content != original:
        with open(tscn_path, "w", encoding="utf-8", newline="\n") as f:
            f.write(content)
        print(f"Updated: {folder}/{filename}")
    else:
        print(f"No change: {folder}/{filename}")

print("\nAll done!")
