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

def patch_node(content, node_header_pattern, changes: dict) -> str:
    node_re = re.compile(r'\[node [^\]]+\]')
    block_end_re = re.compile(r'\n(?=\[node |\[connection |\Z)', re.MULTILINE)

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
    bullet_filename = filename.replace('.tscn', '_bullet.tscn')
    tscn_path = os.path.join(base, folder, bullet_filename)
    if not os.path.exists(tscn_path):
        # try the dragronfruit typo
        if 'dragonfruit' in folder:
            bullet_filename = 'dragronfruit_bullet.tscn'
            tscn_path = os.path.join(base, folder, bullet_filename)
        
    if not os.path.exists(tscn_path):
        print(f"SKIP (not found): {tscn_path}")
        continue

    with open(tscn_path, "r", encoding="utf-8") as f:
        content = f.read()

    original = content

    content = patch_node(
        content,
        r'name="AnimatedSprite2D"',
        {"autoplay": '"fly"'}
    )

    if content != original:
        with open(tscn_path, "w", encoding="utf-8", newline="\n") as f:
            f.write(content)
        print(f"Updated: {folder}/{bullet_filename}")
    else:
        print(f"No change needed: {folder}/{bullet_filename}")

print("\nAll done!")
