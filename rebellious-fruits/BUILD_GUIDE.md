# Build Instructions for Rebellious Fruits

This project is built using the **Godot Engine (v4.3)**. Follow these steps to export the game to an executable file (EXE) for Windows.

## 1. Prerequisites
- **Godot Engine**: Download **Godot 4.3** from the [official website](https://godotengine.org/download/windows/). Make sure to get the standard version (unless you are using C#, but this project appears to use GDScript).
- **Export Templates**: You will need to download the export templates within the Godot editor.

## 2. Opening the Project
1. Run the Godot Engine.
2. Click **Import**.
3. Browse to the project folder: `e:\FPT\Ky_7\PRU\my-game-pru\rebellious-fruits`.
4. Select the `project.godot` file and click **Open**.
5. Click **Import & Edit**.

## 3. Installing Export Templates
If this is your first time exporting a game in Godot 4.3:
1. Go to **Editor** -> **Manage Export Templates...**
2. Click **Download and Install**.
3. Wait for the process to complete.

## 4. Exporting to Windows
1. Go to **Project** -> **Export...**
2. In the Export window, you should see a preset named **"Windows Desktop"** (already configured in the project).
3. If "Windows Desktop" is not there, click **Add...** and select **Windows Desktop**.
4. Check for any red warnings at the bottom. If you see "Export templates for this platform are missing", refer to Step 3.
5. Click **Export Project...** at the bottom of the window.
6. Choose a destination folder (e.g., a new `build` folder).
7. Uncheck **Export with Debug** if you want a production build.
8. Click **Save**.

## 5. Exporting via Command Line (Advanced)
If you have Godot in your system PATH, you can export the project without opening the editor UI. Run this command in your terminal from the project root:

```powershell
godot --headless --export-release "Windows Desktop" build/rebellious_fruits.exe
```
*(Make sure to create the `build` folder first)*

## 6. Troubleshooting
- **Missing Assets**: Ensure the `assets` folder is intact.
- **Main Scene**: The main scene is set to `res://ui/intro/intro_scene.tscn`.
- **Drivers**: The project is configured to use **Direct3D 12** on Windows. If the game doesn't run, try switching the rendering method to **Compatibility** in `Project Settings` before exporting.
- **Export Path**: In the existing `export_presets.cfg`, the path is set to `../../rebellious_fruits.exe`. If you use the UI, you can change this to any location you prefer.

---

*Note: The project is currently set to export the .exe to `../../rebellious_fruits.exe` by default in the presets. You can change this path in the Export window.*
