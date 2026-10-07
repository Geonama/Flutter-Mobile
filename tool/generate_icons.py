"""Generate the geometric Counter Lab app icon (requires Pillow)."""

import json
from pathlib import Path

from PIL import Image, ImageDraw


ROOT = Path(__file__).resolve().parents[1]
icon = Image.new("RGB", (1024, 1024), "#18243B")
draw = ImageDraw.Draw(icon)
draw.rounded_rectangle((180, 180, 844, 844), radius=150, fill="#0054A6")
draw.line((330, 704, 704, 330), fill="#8DBBEB", width=26)
draw.rounded_rectangle((563, 294, 599, 458), radius=18, fill="#F58220")
draw.rounded_rectangle((499, 358, 663, 394), radius=18, fill="#F58220")
draw.rounded_rectangle((311, 630, 475, 666), radius=18, fill="white")


def save_icon(relative_path: str, size: int) -> None:
    path = ROOT / relative_path
    path.parent.mkdir(parents=True, exist_ok=True)
    icon.resize((size, size), Image.Resampling.LANCZOS).save(path)


for density, size in {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}.items():
    save_icon(f"android/app/src/main/res/mipmap-{density}/ic_launcher.png", size)

ios_directory = "ios/Runner/Assets.xcassets/AppIcon.appiconset"
contents = json.loads((ROOT / ios_directory / "Contents.json").read_text())
for entry in contents["images"]:
    size = round(float(entry["size"].split("x")[0]) * float(entry["scale"].removesuffix("x")))
    save_icon(f"{ios_directory}/{entry['filename']}", size)

save_icon("web/favicon.png", 32)
for size in [192, 512]:
    save_icon(f"web/icons/Icon-{size}.png", size)
    save_icon(f"web/icons/Icon-maskable-{size}.png", size)

print("Counter Lab icons generated for Android, iOS, and web.")
