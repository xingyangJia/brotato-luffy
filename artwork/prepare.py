"""Crop the atlas into game textures and lay out the Workshop cover."""

from pathlib import Path
import os

from PIL import Image, ImageDraw, ImageFont, ImageOps


ROOT = Path(__file__).resolve().parents[1]
ART = ROOT / "mods-unpacked" / "StrawHat-Luffy" / "art"
WORKSHOP = ROOT / "workshop"
FONTS = Path(os.environ.get("WINDIR", "C:/Windows")) / "Fonts"
ATLAS = Path(__file__).with_name("strawhat_atlas.png")
LANCZOS = Image.Resampling.LANCZOS


def crop_sprite(atlas, box):
    cell = atlas.crop(box)
    alpha = cell.getchannel("A").point(lambda value: 255 if value >= 24 else 0)
    left, top, right, bottom = alpha.getbbox()
    return cell.crop((left - 2, top - 2, right + 2, bottom + 2))


def game_texture(sprite, canvas_size, fit_size, bottom=None):
    fitted = ImageOps.contain(sprite, fit_size, LANCZOS)
    canvas = Image.new("RGBA", canvas_size)
    x = (canvas.width - fitted.width) // 2
    y = (canvas.height - fitted.height) // 2 if bottom is None else bottom - fitted.height
    canvas.alpha_composite(fitted, (x, y))
    return canvas


def draw_cover(body, fist):
    cover = Image.new("RGBA", (512, 512), "#1f1520")
    draw = ImageDraw.Draw(cover)
    draw.rounded_rectangle((13, 13, 498, 498), radius=28, fill="#381c31", outline="#9b503e", width=2)
    for radius in range(173, 49, -1):
        light = (173 - radius) / 123
        color = (int(95 + 57 * light), int(43 + 20 * light), int(55 - 10 * light))
        draw.ellipse((235 - radius, 208 - radius, 235 + radius, 208 + radius), fill=color)
    draw.arc((48, 21, 422, 395), 205, 337, fill="#ec9a57", width=2)
    draw.arc((48, 21, 422, 395), 12, 144, fill="#824737", width=2)
    for x, y, radius in [(74, 133, 9), (417, 94, 11), (451, 147, 5), (92, 304, 5), (361, 79, 4)]:
        draw.polygon((x, y - radius, x + radius // 2, y, x, y + radius, x - radius // 2, y),
                     fill="#ffc66b")

    ink = "#191519"
    draw.line((284, 246, 379, 226), fill=ink, width=47)
    draw.line((284, 246, 379, 226), fill="#f3ad68", width=32)
    draw.line((287, 255, 380, 235), fill="#dc9254", width=11)
    draw.line((430, 174, 462, 154), fill="#f7b261", width=4)
    draw.line((448, 191, 474, 181), fill="#f7b261", width=3)
    draw.line((451, 252, 479, 260), fill="#ed8e53", width=3)
    cover.alpha_composite(ImageOps.contain(body, (299, 307), LANCZOS), (61, 39))
    cover.alpha_composite(ImageOps.contain(fist, (126, 107), LANCZOS), (340, 165))

    draw.rounded_rectangle((44, 353, 468, 481), radius=18, fill="#241824", outline="#ad5b44", width=2)
    title = ImageFont.truetype(str(FONTS / "msyhbd.ttc"), 60)
    draw.text((256, 417), "草帽路飞", font=title, anchor="mm", fill="#ffda86",
              stroke_width=1, stroke_fill="#ffda86")
    return cover.convert("RGB")


def main():
    with Image.open(ATLAS) as atlas:
        body = crop_sprite(atlas, (0, 0, 660, 665))
        fist = crop_sprite(atlas, (660, 0, 1254, 665))
        hat = crop_sprite(atlas, (0, 665, 660, 1254))
        meat = crop_sprite(atlas, (660, 665, 1254, 1254))

    ART.mkdir(parents=True, exist_ok=True)
    WORKSHOP.mkdir(exist_ok=True)
    textures = {
        "strawhat_body": game_texture(body, (150, 150), (91, 103), bottom=108),
        "strawhat_luffy_icon": game_texture(body, (96, 96), (83, 90)),
        "strawhat_fist_sprite": game_texture(fist, (100, 50), (45, 34)),
        "strawhat_fist_icon": game_texture(fist, (96, 96), (81, 75)),
        "strawhat_hat_icon": game_texture(hat, (96, 96), (82, 80)),
        "strawhat_meat_icon": game_texture(meat, (96, 96), (81, 81)),
    }
    for name, texture in textures.items():
        texture.save(ART / (name + ".png"), optimize=True)
    draw_cover(body, fist).save(WORKSHOP / "cover.png", optimize=True)


if __name__ == "__main__":
    main()
