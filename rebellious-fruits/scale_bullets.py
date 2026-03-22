import re
import os

scenes_dir = r'e:\FPT\Ky_7\PRU\my-game-pru\rebellious-fruits\scenes'

# Find all bullet tscn files
bullet_files = []
for root, dirs, files in os.walk(scenes_dir):
    for f in files:
        if 'bullet' in f and f.endswith('.tscn'):
            bullet_files.append(os.path.join(root, f))

print(f'Found {len(bullet_files)} bullet files')

for filepath in bullet_files:
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    lines = content.split('\n')
    new_content = []
    in_animated_sprite = False
    changed = False

    for line in lines:
        # Detect entering AnimatedSprite2D node
        if '[node' in line and 'type="AnimatedSprite2D"' in line:
            in_animated_sprite = True
        elif '[node' in line and 'type="AnimatedSprite2D"' not in line:
            in_animated_sprite = False

        if in_animated_sprite and line.strip().startswith('scale = Vector2('):
            m = re.match(r'(\s*scale = Vector2\()(-?[\d.]+)(,\s*)(-?[\d.]+)(\))', line)
            if m:
                x = float(m.group(2))
                y = float(m.group(4))
                new_x = round(x * 2, 8)
                new_y = round(y * 2, 8)
                new_line = f'{m.group(1)}{new_x}{m.group(3)}{new_y}{m.group(5)}'
                print(f'  [{os.path.basename(filepath)}] scale: ({x}, {y}) -> ({new_x}, {new_y})')
                new_content.append(new_line)
                changed = True
                continue

        new_content.append(line)

    if changed:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write('\n'.join(new_content))
    else:
        print(f'  [{os.path.basename(filepath)}] WARNING: No AnimatedSprite2D scale found!')

print('\nDone!')
