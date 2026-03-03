# 🐕 SHIPPER SÁT NÁCH — Game Development Roadmap
**The Barking Delivery** · Godot 4 · 2.5D Isometric · CharacterBody3D

---

## 📊 Tổng quan
| | |
|---|---|
| Engine | Godot 4.x |
| Thể loại | Arcade Action · Hài hước |
| Màn chơi | 20 màn / 3 chương |
| Ước tính | ~12 tuần (part-time) |

---

## 📅 Timeline

| Tuần | Mục tiêu | Milestone |
|------|----------|-----------|
| 1–2 | Project Setup + Player Movement | ✅ Đạp xe được trên sân phẳng |
| 3 | Package System + Level Test | ✅ Delivery zone hoạt động |
| 4–5 | Dog AI State Machine | ✅ Chó đuổi được player |
| 6 | Skills + Combat | ✅ Chuông, ném mồi, damage |
| 7 | Win/Lose + Game Loop | ✅ Chơi được 1 màn end-to-end |
| 8 | Sprites thực tế | Thay placeholder bằng sprite AI-gen |
| 9–10 | Build 20 màn chơi | 3 chương hoàn chỉnh |
| 11 | Audio + Menu + Tutorial | Ready to ship |
| 12 | Polish + Export | Phát hành itch.io / HTML5 |

---

## 🧱 Phase 1 — Core Foundation (Tuần 1–3)

- [ ] **Godot 4 Setup** — Project 3D, Forward+ renderer, Input Map: `move_up/down/left/right`, `sprint`, `bell`, `throw_item`
- [ ] **CharacterBody3D Player** — Di chuyển 8 hướng WASD, gravity, tốc độ 4.0/sprint 7.0
- [ ] **Stamina System** — Max 100, tiêu hao 20/s khi sprint, hồi 10/s khi dừng
- [ ] **Camera Isometric** — Rotation X=-45° Y=-45°, Projection: Orthogonal, lerp theo player
- [ ] **Level Test** — CSGBox3D placeholder, NavigationRegion3D baked, Area3D Start + Delivery
- [ ] **PackageSystem.gd** — `package_health: float = 100.0`, signals: `damaged`, `destroyed`

## 🐕 Phase 2 — Gameplay Loop (Tuần 4–8)

- [ ] **Dog AI State Machine** — `enum State {IDLE, PATROL, CHASE, RETURN, STUNNED}`, NavigationAgent3D
- [ ] **Line of Sight** — Area3D hình nón, phát hiện player → CHASE, ra ngoài territory → RETURN
- [ ] **3 loại tấn công** — `bite_leg` (slow 30%), `body_slam` (button-mash), `grab_package` (-15 HP)
- [ ] **DogResource (.tres)** — stats riêng từng loại, không cần sửa code khi cân bằng
- [ ] **Bell Skill (Space)** — AOE r=3m, stun 0.5s, cooldown 2s
- [ ] **Bone Decoy (E)** — Arc throw → Area3D tại điểm rơi → redirect chó 5s
- [ ] **GameManager Autoload** — timer, sao 1-3, save ConfigFile
- [ ] **Win/Lose Scenes** — Animation sao rơi vào, Retry / Next Level

## 🎨 Phase 3 — Content & Polish (Tuần 9–12)

- [ ] Sprites Player 8 hướng + Sprites Chó × 4 loại
- [ ] Tileset Isometric 2.5D (đường, hàng rào, thùng rác, cây)
- [ ] **Chương 1** — 5 màn: Ngõ Nhỏ Thân Thiện (Poodle, Chó cỏ)
- [ ] **Chương 2** — 7 màn: Chung Cư Hỗn Loạn (Becgie, Pitbull)
- [ ] **Chương 3** — 8 màn: Biệt Thự Đại Gia (Ngao Tây Tạng boss)
- [ ] Audio: BGM × 4 + SFX × 8
- [ ] Main Menu + Level Select + Tutorial popup
- [ ] Screen shake, particle effects, bug fix tổng thể

---

## 🐾 Roster Chó

| Loại chó | Tốc độ | Tầm phát hiện | Tấn công | Xuất hiện |
|----------|--------|--------------|----------|-----------|
| 🐩 Poodle | 3.0 m/s | 4 m | Cắn chân: slow 30% | Chương 1 |
| 🐕 Chó cỏ | 3.5 m/s | 4 m | Cắn chân: slow 30% | Chương 1 |
| 🦮 Becgie | 5.0 m/s | 6 m | Táp hàng: -15 HP | Chương 2 |
| 🐶 Pitbull | 6.0 m/s | 5 m | Húc: button-mash | Chương 2 |
| 🐻 Ngao Tây Tạng | 4.0 m/s | 8 m | Cả 3 loại | Chương 3 (Boss) |

---

## 🤖 AI ASSET PROMPTS

> **Hướng dẫn:** Copy nguyên văn prompt. Dùng **Leonardo.AI** (miễn phí 150 token/ngày, model: Phoenix) hoặc **Midjourney** (thêm `--ar 1:1 --v 6` vào cuối).

---

### 🚲 NHÂN VẬT — Shipper Minh

**[Shipper đứng yên — 8 hướng]** `Leonardo.AI`
```
2.5D isometric pixel art, Vietnamese delivery man standing with bicycle, wearing helmet and orange vest, holding package, 8 directional sprites on transparent background, clean pixel art style, warm colors, game asset sheet
```

**[Shipper đang đạp xe]** `Leonardo.AI`
```
2.5D isometric pixel art animation frame, Vietnamese shipper riding bicycle fast, motion blur on wheels, orange delivery vest, tilted forward, transparent background, game sprite, top-down 45 degree angle
```

**[Shipper ngã xe]** `Leonardo.AI`
```
2.5D isometric pixel art, delivery man fallen off bicycle, stars circling head, packages scattered, comic style, transparent background, 45 degree isometric view, game sprite
```

**[Shipper dùng chuông]** `Midjourney`
```
2.5D isometric pixel art, delivery man ringing bicycle bell, sound wave rings radiating outward, comic action lines, orange vest, transparent background, game sprite sheet --ar 1:1 --v 6
```

---

### 🐕 NHÂN VẬT — Các loại Chó

**[Poodle — Idle 4 frame]** `Leonardo.AI`
```
2.5D isometric pixel art, cute fluffy poodle dog standing idle, white fluffy fur, small size, tilted 45 degrees top-down view, transparent background, game character sprite, 4 frame idle animation sheet
```

**[Poodle — Run + Attack]** `Leonardo.AI`
```
2.5D isometric pixel art sprite sheet, poodle dog running fast and barking aggressively, 6 running frames + 4 attack frames on single sheet, transparent background, top-down isometric 45 degree view
```

**[Becgie — Full sheet]** `Midjourney`
```
2.5D isometric pixel art, German Shepherd dog sprite sheet, idle + run + attack animations, tan and black fur, fierce expression, transparent background, 45 degree top view, game asset --ar 2:1 --v 6
```

**[Pitbull — Full sheet]** `Leonardo.AI`
```
2.5D isometric pixel art sprite sheet, muscular pitbull dog, stocky body, charging and biting animations, dark gray fur, angry expression, 45 degree isometric view, transparent background, game asset
```

**[Ngao Tây Tạng — BOSS]** `Midjourney`
```
2.5D isometric pixel art, massive Tibetan Mastiff boss dog, huge fluffy dark brown mane, intimidating size 3x normal dog, roaring attack pose, dramatic lighting, transparent background, isometric top-down game sprite --ar 1:1 --v 6
```

---

### 🗺️ MAP & TILESET

**[Đường nhựa + vỉa hè]** `Leonardo.AI`
```
2.5D isometric tileset, Vietnamese alley street tiles, asphalt road with white lane markings, concrete sidewalk, top-down 45 degree view, seamless tiles, pixel art style, warm afternoon lighting, transparent background
```

**[Hàng rào gỗ + tường bê tông]** `Leonardo.AI`
```
2.5D isometric pixel art tileset, wooden fence panel and concrete wall sections, Vietnamese neighborhood style, weathered and slightly worn, transparent background, 45 degree isometric view, game environment tiles
```

**[Thùng rác + cột điện + phụ kiện]** `Leonardo.AI`
```
2.5D isometric pixel art props, Vietnamese street props set: green garbage bin, utility power pole with wires, fire hydrant, all transparent background, top-down 45 degree view, game asset sprite sheet
```

**[Cây bụi + chậu hoa]** `Midjourney`
```
2.5D isometric pixel art, tropical garden props, lush green bush, potted bougainvillea, banana tree, Vietnamese style garden, transparent background, top-down 45 degree view, colorful game assets --ar 2:1 --v 6
```

**[Background Chương 1 — Ngõ nhỏ]** `Leonardo.AI`
```
2.5D isometric pixel art scene, narrow Vietnamese alley background, old brick walls, tropical plants, warm golden afternoon light, simple straight path, cozy neighborhood feel, game level background
```

**[Background Chương 2 — Chung cư]** `Leonardo.AI`
```
2.5D isometric pixel art, Vietnamese apartment complex courtyard, multiple building entrances, tight corridors, mailboxes, parked motorbikes, urban crowded feel, game level environment
```

**[Background Chương 3 — Biệt thự]** `Midjourney`
```
2.5D isometric pixel art, Vietnamese luxury villa with garden maze, fancy iron gate, manicured hedges, marble pathways, ornate fountain, intimidating wealthy estate, game level background --ar 16:9 --v 6
```

**[Cổng tự động]** `Leonardo.AI`
```
2.5D isometric pixel art, automatic iron security gate, sliding mechanism, red warning light when closed, green when open, modern Vietnamese villa entrance, transparent background, game interactive prop
```

---

### 🖥️ UI & HUD

**[Icon kỹ năng]** `Leonardo.AI`
```
pixel art UI icons set, bicycle bell icon with sound waves, bone icon, sausage icon, all on dark rounded square button background, game UI style, clean simple design, 64x64 pixels each
```

**[Thanh HP hàng hóa]** `Leonardo.AI`
```
pixel art game UI, package health bar with cardboard box icon, gradient fill green to red, clean game HUD element, transparent background, flat design with subtle outline
```

**[Icon 1-2-3 sao]** `Leonardo.AI`
```
pixel art game star rating icons, 3 variations: 3 gold stars, 2 stars 1 empty, 1 star 2 empty, shiny golden color with dark outline, game reward UI, transparent background
```

**[Logo game title]** `Midjourney`
```
game logo design, 'Shipper Sat Nach' text, cartoon Vietnamese delivery man on bicycle being chased by angry dog, comic action style, bold playful font, orange and yellow color scheme, transparent background --ar 3:1 --v 6
```

---

### ✨ VFX — Hiệu ứng

**[Aura chuông xe]** `Leonardo.AI`
```
pixel art visual effect, bicycle bell sound waves radiating outward in concentric rings, yellow-white color, transparent background, animation sprite sheet 6 frames, game VFX asset
```

**[Bụi đạp xe]** `Leonardo.AI`
```
pixel art dust cloud effect sprite sheet, small puff of dust particles, 4 frame animation, beige-brown color, transparent background, game movement trail VFX
```

**[Chó bị choáng]** `Leonardo.AI`
```
pixel art dizzy stars spinning in circle, 3 small yellow stars, 6 frame animation loop, transparent background, cartoon game stun effect VFX sprite sheet
```

**[Kiện hàng bị hư]** `Leonardo.AI`
```
pixel art damage effect, cardboard box cracking with pieces flying, red impact flash, spark particles, 4 frame animation, transparent background, game damage VFX
```

---

## 🔗 Tài nguyên miễn phí

| Loại | Link | Ghi chú |
|------|------|---------|
| AI Image | leonardo.ai | 150 token/ngày miễn phí |
| AI Image | bing.com/images/create | DALL-E 3, hoàn toàn miễn phí |
| Tileset | kenney.nl/assets | CC0, isometric tileset đầy đủ |
| Sprites | itch.io/game-assets | Tìm "isometric pixel art free" |
| SFX | freesound.org | Filter: Creative Commons 0 |
| Nhạc | pixabay.com/music | Miễn phí, không cần attribution |
| Tutorial | gdquest.com | Godot 4 chuyên nghiệp nhất |