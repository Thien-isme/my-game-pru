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

def patch_node(content, node_header_pattern, changes: dict) -> str:
    """
    For each [node ...] block whose header matches node_header_pattern:
    - For each key in changes: if the key exists in the block, overwrite it;
      if it doesn't exist and value is not None, insert it right after the [node ...] line.
    - The block ends at the next [node or [connection or EOF.
    """
    node_re = re.compile(r'\[node [^\]]+\]')
    block_end_re = re.compile(r'\n(?=\[node |\[connection |\Z)', re.MULTILINE)

    # Need to iterate backwards or rebuild string safely
    matches = list(node_re.finditer(content))
    for m in reversed(matches):
        header = m.group(0)
        if not re.search(node_header_pattern, header):
            continue

        end_match = block_end_re.search(content, m.end())
        block_end = end_match.start() if end_match else len(content)

        block = content[m.start():block_end]

        for key, value in changes.items():
            existing = re.search(rf'^{re.escape(key)}\s*=.*$', block, re.MULTILINE)
            if value is None:
                if existing:
                    block = re.sub(rf'\n{re.escape(key)}\s*=.*', '', block)
            else:
                if existing:
                    block = re.sub(rf'^{re.escape(key)}\s*=.*$', f'{key} = {value}', block, flags=re.MULTILINE)
                else:
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

    # 1. DetectZone (Area2D) -> position=(0,0), visible=None (remove visible=false so it shows)
    content = patch_node(
        content,
        r'name="DetectZone"',
        {"position": "Vector2(0, 0)", "visible": None}
    )

    # 2. CollisionShape2D inside DetectZone -> position=(0,0)
    content = patch_node(
        content,
        r'name="CollisionShape2D".*?parent="DetectZone"',
        {"position": "Vector2(0, 0)"}
    )

    # 3. AttackZone (Area2D) -> position=(0,0), visible=None
    content = patch_node(
        content,
        r'name="AttackZone"',
        {"position": "Vector2(0, 0)", "visible": None}
    )

    # 4. CollisionShape2D inside AttackZone -> position=(0,0)
    content = patch_node(
        content,
        r'name="CollisionShape2D".*?parent="AttackZone"',
        {"position": "Vector2(0, 0)"}
    )

    if content != original:
        with open(tscn_path, "w", encoding="utf-8", newline="\n") as f:
            f.write(content)
        print(f"Updated: {folder}/{filename}")
    else:
        print(f"No change needed: {folder}/{filename}")

print("\nAll done!")
