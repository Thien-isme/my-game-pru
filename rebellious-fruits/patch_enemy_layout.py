import os
import re

base = r"d:\GameWithGodot\my-game-pru\rebellious-fruits\scenes\enemies"
enemies = {
    "apple": "apple.tscn",
    "bittergourd": "bittergourd.tscn",
    "carrot": "carrot.tscn",
    "chili": "chili.tscn",
    "corn": "corn.tscn",
    "dragonfruit": "dragronfruit.tscn",
    "lemon": "lemon.tscn",
    "lychee": "lychee.tscn",
    "mangosteen": "mangosteen.tscn",
    "pear": "pear.tscn",
    "pumpkin": "pumpkin.tscn",
    "starapple": "starapple.tscn",
    "starfruit": "starfruit.tscn",
    "watermelon": "watermelon.tscn",
}

def patch_node(content, node_header_pattern, changes: dict) -> str:
    """
    For each [node ...] block whose header matches node_header_pattern:
    - For each key in changes: if the key exists in the block, overwrite it;
      if it doesn't exist and value is not None, insert it right after the [node ...] line.
    - The block ends at the next [node or [connection or EOF.
    """
    result = []
    pos = 0
    node_re = re.compile(r'\[node [^\]]+\]')
    block_end_re = re.compile(r'\n(?=\[node |\[connection |\Z)', re.MULTILINE)

    for m in node_re.finditer(content):
        header = m.group(0)
        if not re.search(node_header_pattern, header):
            continue

        # find end of this block
        end_match = block_end_re.search(content, m.end())
        block_end = end_match.start() if end_match else len(content)

        block = content[m.start():block_end]

        for key, value in changes.items():
            existing = re.search(rf'^{re.escape(key)}\s*=.*$', block, re.MULTILINE)
            if value is None:
                # Remove the line
                if existing:
                    block = re.sub(rf'\n{re.escape(key)}\s*=.*', '', block)
            else:
                if existing:
                    block = re.sub(rf'^{re.escape(key)}\s*=.*$', f'{key} = {value}', block, flags=re.MULTILINE)
                else:
                    # Insert after the [node ...] header line
                    first_line_end = block.index('\n') + 1 if '\n' in block else len(block)
                    block = block[:first_line_end] + f'{key} = {value}\n' + block[first_line_end:]

        content = content[:m.start()] + block + content[block_end:]

    return content


for folder, filename in enemies.items():
    tscn_path = os.path.join(base, folder, filename)
    if not os.path.exists(tscn_path):
        print(f"SKIP (not found): {tscn_path}")
        continue

    with open(tscn_path, "r", encoding="utf-8") as f:
        content = f.read()

    original = content

    # 1. Reset position of CollisionShape2D (direct child of root, parent=".")
    content = patch_node(
        content,
        r'name="CollisionShape2D".*?parent="\."',
        {"position": "Vector2(0, 0)"}
    )

    # 2. Reset position of AnimatedSprite2D (direct child of root, parent=".")
    content = patch_node(
        content,
        r'name="AnimatedSprite2D".*?parent="\."',
        {"position": "Vector2(0, 0)"}
    )

    # 3. Hide DetectZone
    content = patch_node(
        content,
        r'name="DetectZone"',
        {"visible": "false"}
    )

    # 4. Hide AttackZone
    content = patch_node(
        content,
        r'name="AttackZone"',
        {"visible": "false"}
    )

    if content != original:
        with open(tscn_path, "w", encoding="utf-8", newline="\n") as f:
            f.write(content)
        print(f"Updated: {folder}/{filename}")
    else:
        print(f"No change needed: {folder}/{filename}")

print("\nAll done!")
