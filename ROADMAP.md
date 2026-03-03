# 🐕 SHIPPER SÁT NÁCH — Game Development Roadmap
**The Barking Delivery** · Godot 4 · 2D Top-down · CharacterBody2D

---

## 📊 Tổng quan dự án

| Hạng mục | Chi tiết |
|----------|----------|
| Engine | Godot 4.x |
| Thể loại | Arcade Action · Hài hước · Rượt đuổi |
| Đồ họa | **2D Top-down** (góc nhìn từ trên xuống) |
| Phương tiện | Xe đạp |
| Màn chơi | 20 màn / 3 chương |
| Ước tính | ~10 tuần (part-time, 15–20h/tuần) |
| Platform | PC · Web (HTML5) · Android |

---

## 📅 Timeline

| Tuần | Mục tiêu | Công việc chính | Milestone |
|------|----------|-----------------|-----------|
| 1–2 | Project Setup + Player | CharacterBody2D, camera follow, stamina | ✅ Đạp xe được trên màn hình |
| 3 | Package System + Level Test | Package health, HUD, TileMap test | ✅ Delivery zone hoạt động |
| 4–5 | Dog AI State Machine | NavigationAgent2D, 4 states, LOS | ✅ Chó đuổi được player |
| 6 | Skills + Combat | Chuông, ném mồi, 3 loại damage | ✅ Escape mechanics đầy đủ |
| 7 | Win/Lose + Game Loop | GameManager, 3 sao, save data | ✅ 1 màn end-to-end hoàn chỉnh |
| 8 | Sprites + Tilemap thực tế | Thay placeholder, AnimatedSprite2D | Game trông "có hồn" |
| 9–10 | Build 20 màn chơi | Chương 1 → 2 → 3 | Toàn bộ content |
| 11 | Audio + Menu + Tutorial | BGM, SFX, Main Menu, Level Select | Ready to ship |
| 12 | Polish + Export | Bug fix, game feel, export HTML5 | 🚀 Phát hành |

---

## 🗂️ CẤU TRÚC THƯ MỤC DỰ ÁN

```
ShipperSatNach/
│
├── 📁 scenes/
│   ├── 📁 characters/
│   │   ├── Player.tscn                  # CharacterBody2D — xe đạp + shipper
│   │   ├── 📁 dogs/
│   │   │   ├── DogBase.tscn             # Scene gốc, các loại chó kế thừa
│   │   │   ├── DogPoodle.tscn
│   │   │   ├── DogCo.tscn               # Chó cỏ
│   │   │   ├── DogBecgie.tscn
│   │   │   ├── DogPitbull.tscn
│   │   │   └── DogBoss.tscn             # Ngao Tây Tạng
│   │   └── 📁 items/
│   │       ├── BoneDecoy.tscn           # Xương — đánh lạc hướng chó
│   │       └── SausageDecoy.tscn        # Xúc xích — đánh lạc hướng chó
│   │
│   ├── 📁 levels/
│   │   ├── 📁 chapter_1/                # Ngõ Nhỏ Thân Thiện
│   │   │   ├── Level_1_1.tscn
│   │   │   ├── Level_1_2.tscn
│   │   │   ├── Level_1_3.tscn
│   │   │   ├── Level_1_4.tscn
│   │   │   └── Level_1_5.tscn
│   │   ├── 📁 chapter_2/                # Chung Cư Hỗn Loạn
│   │   │   ├── Level_2_1.tscn
│   │   │   ├── Level_2_2.tscn
│   │   │   ├── Level_2_3.tscn
│   │   │   ├── Level_2_4.tscn
│   │   │   ├── Level_2_5.tscn
│   │   │   ├── Level_2_6.tscn
│   │   │   └── Level_2_7.tscn
│   │   └── 📁 chapter_3/                # Biệt Thự Đại Gia
│   │       ├── Level_3_1.tscn
│   │       ├── Level_3_2.tscn
│   │       ├── Level_3_3.tscn
│   │       ├── Level_3_4.tscn
│   │       ├── Level_3_5.tscn
│   │       ├── Level_3_6.tscn
│   │       ├── Level_3_7.tscn
│   │       └── Level_3_8.tscn
│   │
│   ├── 📁 ui/
│   │   ├── HUD.tscn                     # HP, stamina, package bar, timer, skill cooldown
│   │   ├── MainMenu.tscn
│   │   ├── LevelSelect.tscn             # Chọn màn, hiển thị sao đã đạt
│   │   ├── WinScreen.tscn               # Animation 3 sao rơi vào
│   │   ├── LoseScreen.tscn
│   │   ├── PauseMenu.tscn
│   │   └── Tutorial.tscn                # Popup hướng dẫn màn 1
│   │
│   └── 📁 environment/
│       ├── DeliveryZone.tscn            # Area2D — điểm giao hàng
│       ├── AutoGate.tscn                # Cổng tự động (Chương 3)
│       └── WaterTrap.tscn               # Bẫy nước tưới (Chương 3)
│
├── 📁 scripts/
│   ├── 📁 characters/
│   │   ├── player.gd                    # Di chuyển, stamina, kỹ năng
│   │   ├── player_combat.gd             # Nhận damage, knockdown minigame
│   │   └── 📁 dogs/
│   │       ├── dog_base.gd              # State machine gốc (kế thừa)
│   │       ├── dog_poodle.gd            # Override stats
│   │       ├── dog_co.gd
│   │       ├── dog_becgie.gd
│   │       ├── dog_pitbull.gd
│   │       └── dog_boss.gd              # Logic boss đặc biệt
│   │
│   ├── 📁 systems/
│   │   ├── game_manager.gd              # Autoload — state toàn cục
│   │   ├── save_manager.gd              # Autoload — đọc/ghi ConfigFile
│   │   ├── audio_manager.gd             # Autoload — BGM + SFX
│   │   ├── package_system.gd            # Độ bền hàng hóa, signals
│   │   └── star_calculator.gd           # Tính 1–3 sao
│   │
│   ├── 📁 ui/
│   │   ├── hud.gd
│   │   ├── win_screen.gd
│   │   ├── level_select.gd
│   │   └── tutorial.gd
│   │
│   └── 📁 environment/
│       ├── delivery_zone.gd
│       ├── auto_gate.gd
│       └── patrol_path.gd               # Gán waypoints Path2D cho chó
│
├── 📁 resources/
│   ├── 📁 dogs/
│   │   ├── DogData.gd                   # Resource class (base stats)
│   │   ├── data_poodle.tres
│   │   ├── data_co.tres
│   │   ├── data_becgie.tres
│   │   ├── data_pitbull.tres
│   │   └── data_boss.tres
│   └── 📁 levels/
│       ├── LevelData.gd                 # Resource class
│       ├── level_1_1.tres               # target_time, star_thresholds
│       └── ...                          # (1 file .tres mỗi màn)
│
├── 📁 assets/
│   ├── 📁 sprites/
│   │   ├── 📁 player/
│   │   │   ├── shipper_idle.png
│   │   │   ├── shipper_ride_up.png      # 4 hướng: up/down/left/right
│   │   │   ├── shipper_ride_down.png
│   │   │   ├── shipper_ride_left.png
│   │   │   ├── shipper_ride_right.png
│   │   │   └── shipper_fall.png
│   │   │
│   │   ├── 📁 dogs/
│   │   │   ├── 📁 poodle/
│   │   │   │   ├── poodle_idle.png
│   │   │   │   ├── poodle_run.png
│   │   │   │   └── poodle_attack.png
│   │   │   ├── 📁 co/
│   │   │   ├── 📁 becgie/
│   │   │   ├── 📁 pitbull/
│   │   │   └── 📁 boss/
│   │   │
│   │   ├── 📁 items/
│   │   │   ├── bone.png
│   │   │   ├── sausage.png
│   │   │   └── package_box.png
│   │   │
│   │   └── 📁 vfx/
│   │       ├── bell_wave.png            # Sprite sheet hiệu ứng chuông
│   │       ├── dust_run.png             # Bụi đạp xe
│   │       ├── stun_stars.png           # Sao quay khi chó bị choáng
│   │       └── damage_flash.png         # Flash khi hàng bị hư
│   │
│   ├── 📁 tilesets/
│   │   ├── tileset_chapter1.png         # Ngõ nhỏ: đường, tường, cây
│   │   ├── tileset_chapter1.tres        # TileSet resource Godot
│   │   ├── tileset_chapter2.png         # Chung cư: sàn gạch, hành lang
│   │   ├── tileset_chapter2.tres
│   │   ├── tileset_chapter3.png         # Biệt thự: sân vườn, đá hoa
│   │   ├── tileset_chapter3.tres
│   │   └── tileset_props.png            # Thùng rác, hàng rào, chậu cây
│   │
│   ├── 📁 ui/
│   │   ├── icon_bell.png
│   │   ├── icon_bone.png
│   │   ├── icon_sausage.png
│   │   ├── star_filled.png
│   │   ├── star_empty.png
│   │   ├── bar_health.png
│   │   ├── bar_stamina.png
│   │   └── logo_title.png
│   │
│   └── 📁 audio/
│       ├── 📁 bgm/
│       │   ├── bgm_menu.ogg
│       │   ├── bgm_chapter1.ogg
│       │   ├── bgm_chapter2.ogg
│       │   ├── bgm_chapter3.ogg
│       │   └── bgm_chase.ogg            # Nhạc căng thẳng khi bị đuổi
│       └── 📁 sfx/
│           ├── sfx_dog_bark_1.ogg
│           ├── sfx_dog_bark_2.ogg
│           ├── sfx_dog_growl.ogg
│           ├── sfx_bell.ogg
│           ├── sfx_throw.ogg
│           ├── sfx_bike_ride.ogg
│           ├── sfx_fall.ogg
│           ├── sfx_delivery_success.ogg
│           └── sfx_star_pop.ogg
│
├── 📁 addons/                           # Plugin Godot (nếu dùng)
│
├── project.godot
├── .gitignore
└── ROADMAP.md                           # ← File này
```

---

## 🧱 Phase 1 — Core Foundation (Tuần 1–3)

> **Mục tiêu:** Xe đạp di chuyển được, có camera follow và collision. Nền tảng cho mọi thứ.

### Checklist

- [ ] Tải Godot 4.x, tạo project **2D**, cấu hình Input Map
- [ ] `Player.tscn` — `CharacterBody2D` → `CollisionShape2D` + `AnimatedSprite2D`
- [ ] Script di chuyển 4 hướng WASD, tốc độ 150/sprint 250 px/s
- [ ] Hệ thống Stamina — max 100, tiêu hao 20/s, hồi 10/s
- [ ] Camera2D follow player với `smoothing_enabled = true`
- [ ] TileMap test đơn giản + `NavigationRegion2D` baked
- [ ] `Area2D` điểm Start và Delivery Zone
- [ ] `PackageSystem.gd` — `package_health: float = 100.0`

### Lưu ý kỹ thuật

```
CharacterBody2D (Player)
├── CollisionShape2D       ← Hình tròn nhỏ ở bánh xe
├── AnimatedSprite2D       ← Sprite 4 hướng
├── Area2D (HitBox)        ← Nhận damage từ chó
└── Camera2D               ← Follow player, zoom 2.0
```

---

## 🐕 Phase 2 — Gameplay Loop (Tuần 4–8)

> **Mục tiêu:** Dog AI, skills, win/lose đầy đủ. Đây là phần **khó và quan trọng nhất**.

### Checklist

- [ ] `DogBase.tscn` — `CharacterBody2D` + `NavigationAgent2D`
- [ ] State Machine: `enum State {IDLE, PATROL, CHASE, RETURN, STUNNED}`
- [ ] Line of Sight — `RayCast2D` hoặc `Area2D` hình nêm phía trước
- [ ] 3 loại tấn công: `bite_leg`, `body_slam`, `grab_package`
- [ ] `DogResource` (.tres) — stats riêng từng loại chó
- [ ] **Bell Skill (Space)** — `Area2D` AOE r=120px, stun 0.5s, cooldown 2s
- [ ] **Bone Decoy (E)** — spawn `BoneDecoy`, redirect chó gần nhất 5s
- [ ] Button-mash minigame khi bị húc
- [ ] `GameManager` Autoload — timer, win/lose, tính sao
- [ ] Save dữ liệu bằng `ConfigFile` → `user://saves.cfg`

### Dog AI Node Tree

```
CharacterBody2D (DogBase)
├── CollisionShape2D
├── AnimatedSprite2D
├── NavigationAgent2D      ← Pathfinding 2D
├── Area2D (DetectionZone) ← Phát hiện player (hình nêm)
├── Area2D (AttackZone)    ← Tầm cắn (hình tròn nhỏ)
├── RayCast2D              ← Kiểm tra tầm nhìn bị chặn
└── Timer (AggroTimer)     ← Reset aggro sau X giây
```

---

## 🎨 Phase 3 — Content & Polish (Tuần 9–12)

> ⚠️ **Không bắt đầu phase này khi gameplay chưa fun. Làm fun trước, đẹp sau!**

### Checklist

- [ ] Sprites Player 4 hướng (idle + ride + fall)
- [ ] Sprites Chó × 5 loại (idle + run + attack)
- [ ] TileMap Chương 1, 2, 3 (tileset riêng mỗi chương)
- [ ] **Chương 1** — 5 màn: đường thẳng, Poodle & Chó cỏ
- [ ] **Chương 2** — 7 màn: mê cung, hàng dễ vỡ, Becgie & Pitbull
- [ ] **Chương 3** — 8 màn: cổng tự động, boss Ngao Tây Tạng
- [ ] BGM × 5 + SFX × 9
- [ ] Main Menu + Level Select + Tutorial popup màn 1
- [ ] Screen shake (`Camera2D` offset Tween)
- [ ] `GPUParticles2D`: bụi đạp xe, sao khi ngã
- [ ] Playtest toàn bộ 20 màn + fix bug

---

## 🐾 Roster Chó & Thông số

| Loại chó | Tốc độ | Tầm phát hiện | Kiểu tấn công | Chương |
|----------|--------|--------------|---------------|--------|
| 🐩 Poodle | 90 px/s | 150 px | Cắn chân: slow 30% | 1 |
| 🐕 Chó cỏ | 100 px/s | 150 px | Cắn chân: slow 30% | 1 |
| 🦮 Becgie | 160 px/s | 220 px | Táp hàng: -15 HP | 2 |
| 🐶 Pitbull | 190 px/s | 180 px | Húc: button-mash | 2 |
| 🐻 Ngao Tây Tạng | 130 px/s | 280 px | Cả 3 loại | 3 (Boss) |

---

## 💻 Code Mẫu — Godot 4 GDScript (2D)

### player.gd

```gdscript
extends CharacterBody2D

const SPEED        = 150.0
const SPRINT_SPEED = 250.0
var stamina: float = 100.0
var speed_multiplier: float = 1.0   # Giảm khi bị cắn chân

func _physics_process(delta):
    var dir = Vector2.ZERO
    if Input.is_action_pressed("move_right"): dir.x += 1
    if Input.is_action_pressed("move_left"):  dir.x -= 1
    if Input.is_action_pressed("move_down"):  dir.y += 1
    if Input.is_action_pressed("move_up"):    dir.y -= 1
    dir = dir.normalized()

    var sprinting = Input.is_action_pressed("sprint") and stamina > 0
    var spd = (SPRINT_SPEED if sprinting else SPEED) * speed_multiplier

    stamina = clamp(stamina + (-20 if sprinting else 10) * delta, 0, 100)
    velocity = dir * spd
    move_and_slide()

    if Input.is_action_just_pressed("bell"):
        ring_bell()
    if Input.is_action_just_pressed("throw_item"):
        throw_decoy()

func ring_bell():
    for dog in get_tree().get_nodes_in_group("dogs"):
        if global_position.distance_to(dog.global_position) < 120.0:
            dog.stun(0.5)
```

### dog_base.gd

```gdscript
extends CharacterBody2D

enum State { IDLE, PATROL, CHASE, RETURN, STUNNED }
var state = State.IDLE
var player: Node2D
var home_pos: Vector2
var dog_speed: float     = 160.0
var territory_radius: float = 350.0

@onready var nav   = $NavigationAgent2D
@onready var anim  = $AnimatedSprite2D

func _ready():
    add_to_group("dogs")
    player   = get_tree().get_first_node_in_group("player")
    home_pos = global_position

func _physics_process(_delta):
    match state:
        State.CHASE:  _do_chase()
        State.RETURN: _do_return()
        State.PATROL: _do_patrol()

func _do_chase():
    nav.target_position = player.global_position
    var dir = (nav.get_next_path_position() - global_position).normalized()
    velocity = dir * dog_speed
    move_and_slide()
    anim.play("run")
    if player.global_position.distance_to(home_pos) > territory_radius:
        state = State.RETURN

func _do_return():
    nav.target_position = home_pos
    var dir = (nav.get_next_path_position() - global_position).normalized()
    velocity = dir * (dog_speed * 0.6)
    move_and_slide()
    if global_position.distance_to(home_pos) < 8.0:
        velocity = Vector2.ZERO
        state = State.IDLE
        anim.play("idle")

func _do_patrol():
    pass  # Override trong subclass với Path2D waypoints

func stun(duration: float):
    state = State.STUNNED
    velocity = Vector2.ZERO
    anim.play("idle")
    await get_tree().create_timer(duration).timeout
    state = State.PATROL

func _on_detection_zone_body_entered(body):
    if body.is_in_group("player") and state != State.STUNNED:
        state = State.CHASE
```

---

## 🤖 AI Asset Prompts (2D)

> **Tool khuyến nghị:** Leonardo.AI (miễn phí 150 token/ngày, model: **Phoenix** hoặc **Anime Pastel Dream**)
> Với Midjourney thêm `--ar 1:1 --v 6` vào cuối prompt.

---

### 🚲 Nhân vật — Shipper Minh

**[Idle + 4 hướng đạp xe]** · `Leonardo.AI`
```
2D top-down pixel art, Vietnamese delivery man on bicycle, riding in 4 directions (up/down/left/right), sprite sheet on single image, transparent background, warm colors, orange vest and helmet, cute chibi proportions, game character asset
```

**[Ngã xe]** · `Leonardo.AI`
```
2D top-down pixel art, delivery man fallen off bicycle, lying on ground, stars circling above head, packages scattered, comic style, transparent background, cute chibi proportions, game sprite
```

**[Dùng chuông]** · `Midjourney`
```
2D top-down pixel art, delivery man ringing bicycle bell, sitting on bike, sound wave rings radiating outward in circle, orange vest, transparent background, cute game sprite --ar 1:1 --v 6
```

---

### 🐕 Nhân vật — Các loại Chó

**[Poodle — sprite sheet]** · `Leonardo.AI`
```
2D top-down pixel art, fluffy white poodle dog sprite sheet, idle 4 frames + run 6 frames + bark attack 4 frames, top-down view, transparent background, cute style, game character asset
```

**[Chó cỏ — sprite sheet]** · `Leonardo.AI`
```
2D top-down pixel art, small mixed-breed Vietnamese street dog, brown and white fur, sprite sheet idle + run + attack animations, top-down view, transparent background, game asset
```

**[Becgie — sprite sheet]** · `Midjourney`
```
2D top-down pixel art, German Shepherd dog sprite sheet, tan and black fur, fierce expression, idle + run + lunge attack frames, top-down overhead view, transparent background, game asset --ar 2:1 --v 6
```

**[Pitbull — sprite sheet]** · `Leonardo.AI`
```
2D top-down pixel art, stocky pitbull dog, gray fur, muscular body, charging and biting sprite sheet, idle + run + ram attack, top-down view, transparent background, game asset
```

**[Ngao Tây Tạng BOSS]** · `Midjourney`
```
2D top-down pixel art, massive Tibetan Mastiff boss dog, giant dark brown fluffy fur, 3x size of normal dog, roaring attack animation sprite sheet, dramatic shadow underneath, top-down view, transparent background --ar 2:1 --v 6
```

---

### 🗺️ Tileset & Map

**[Tileset Chương 1 — Ngõ nhỏ]** · `Leonardo.AI`
```
2D top-down pixel art tileset, Vietnamese narrow alley tiles, asphalt path, cracked concrete sidewalk, old brick walls, seamless tiles, warm afternoon colors, transparent background, 16x16 or 32x32 tile size, game tileset asset
```

**[Tileset Chương 2 — Chung cư]** · `Leonardo.AI`
```
2D top-down pixel art tileset, Vietnamese apartment complex floor tiles, checkered lobby tiles, gray concrete hallway, staircase top-down view, seamless tiles, urban feel, 32x32 pixel, transparent background, game tileset
```

**[Tileset Chương 3 — Biệt thự]** · `Midjourney`
```
2D top-down pixel art tileset, luxury Vietnamese villa garden tiles, marble floor, manicured grass, stone pathway, decorative hedge top-view, seamless, 32x32 pixels, transparent background, game tileset --ar 2:1 --v 6
```

**[Props tổng hợp]** · `Leonardo.AI`
```
2D top-down pixel art props sheet, Vietnamese street objects: green trash bin, wooden fence section, potted bougainvillea flower, utility pole top-view, parked bicycle, all on transparent background, 32x32 each, game props asset
```

**[Cổng tự động]** · `Leonardo.AI`
```
2D top-down pixel art, automatic security gate top-down view, iron bars sliding open/closed, 4 frame animation, red indicator light when locked, green when open, transparent background, game interactive prop
```

---

### 🖥️ UI & HUD

**[Thanh HP hàng hóa + Stamina]** · `Leonardo.AI`
```
pixel art game UI bars, package health bar with cardboard box icon on left, stamina bar with lightning bolt icon, both bars with gradient fill and dark outline, transparent background, flat game HUD style
```

**[Icon kỹ năng]** · `Leonardo.AI`
```
pixel art game skill icons, 64x64 each: bicycle bell with sound rings, dog bone, sausage link, all on dark rounded square frame, highlighted border when active, game HUD icons transparent background
```

**[1–3 sao rating]** · `Leonardo.AI`
```
pixel art star rating icons, 3 variations on transparent background: 3 gold shiny stars, 2 gold stars + 1 gray empty star, 1 gold star + 2 gray empty stars, bold dark outline, game UI reward icons
```

**[Logo game]** · `Midjourney`
```
2D game logo, cartoon style, Vietnamese delivery man on bicycle being chased by barking dog, bold playful Vietnamese comic font for 'Shipper Sat Nach', orange yellow color scheme, action speed lines, transparent background --ar 3:1 --v 6
```

---

### ✨ VFX Hiệu ứng

**[Sóng chuông xe]** · `Leonardo.AI`
```
2D pixel art visual effect sprite sheet, circular sound wave rings expanding outward from center, 6 animation frames, yellow-white color, transparent background, game bell VFX
```

**[Bụi đạp xe]** · `Leonardo.AI`
```
2D pixel art dust puff effect sprite sheet, small cloud of dust particles, 4 frame animation, beige-brown color, transparent background, game movement trail VFX
```

**[Chó bị choáng]** · `Leonardo.AI`
```
2D pixel art stun effect sprite sheet, 3 small yellow stars spinning in orbit, 6 frame loop animation, above character position, transparent background, cartoon dizzy game VFX
```

**[Hàng bị hư]** · `Leonardo.AI`
```
2D pixel art damage effect, cardboard box cracking with debris flying, red impact flash, 4 frame animation, transparent background, game damage VFX sprite sheet
```

---

## 🔗 Tài nguyên miễn phí

| Loại | Link | Ghi chú |
|------|------|---------|
| AI Image | leonardo.ai | 150 token/ngày, model Phoenix |
| AI Image | bing.com/images/create | DALL-E 3, hoàn toàn miễn phí |
| Tileset | kenney.nl/assets | CC0, top-down tileset 2D đầy đủ |
| Sprites | itch.io/game-assets | Tìm "top-down pixel art free" |
| SFX | freesound.org | Filter: Creative Commons 0 |
| Nhạc nền | pixabay.com/music | Miễn phí, không cần credit |
| Tutorial | gdquest.com | Godot 4 chuyên nghiệp |
| Tutorial | youtube/@Brackeys | Series Godot cho người mới |

---

## 💡 Quy tắc vàng

> **Fun trước → Đẹp sau → Rồi mới polish.**
> 1 màn chơi thực sự fun > 20 màn chơi đẹp mà nhàm.
> Giữ placeholder đến khi cơ chế ổn định hoàn toàn.
