"""Import the Mod's textures with Godot 3 and produce a Workshop ZIP."""

import argparse
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
from tempfile import TemporaryDirectory
from zipfile import ZIP_DEFLATED, ZipFile, ZipInfo


ROOT = Path(__file__).resolve().parent
MOD_PATH = Path("mods-unpacked/StrawHat-Luffy")
SOURCE = ROOT / MOD_PATH
SOURCE_EXTENSIONS = {".gd", ".tres", ".tscn", ".json", ".png"}
PROJECT_SETTINGS = """config_version=4

[application]
config/name="StrawHat Luffy Texture Import"

[rendering]
quality/driver/driver_name="GLES2"
"""


def import_textures(godot, stage, user_data):
    (stage / "project.godot").write_text(PROJECT_SETTINGS, encoding="utf-8")
    user_data.mkdir()
    env = dict(os.environ, APPDATA=str(user_data), LOCALAPPDATA=str(user_data))
    result = subprocess.run(
        [str(godot), "--path", str(stage), "--editor", "--no-window", "--quit"],
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, encoding="utf-8",
        errors="replace", env=env, timeout=90, check=False,
    )
    if result.returncode != 0 or not re.search(r"Godot Engine v3\.", result.stdout):
        raise RuntimeError(f"Godot 3 texture import failed:\n{result.stdout}")
    return result.stdout


def texture_import_paths(png, stage):
    remap = png.with_suffix(".png.import")
    metadata = remap.read_text(encoding="utf-8")
    targets = re.findall(r'"res://(\.import/[^"]+\.stex)"', metadata)
    if not targets:
        raise RuntimeError(f"No imported texture for {png.name}")
    imports = {remap, *(stage / target for target in targets)}
    for file in imports:
        if not file.is_file():
            raise RuntimeError(f"Godot did not write {file.name}")
    return imports


def build(godot, output):
    godot = godot.resolve(strict=True)
    manifest = json.loads((SOURCE / "manifest.json").read_text(encoding="utf-8"))
    filename = f"{MOD_PATH.name}-{manifest['version_number']}.zip"
    output.mkdir(parents=True, exist_ok=True)

    with TemporaryDirectory(prefix="strawhat-luffy-", dir=output) as temporary:
        scratch = Path(temporary)
        stage = scratch / "project"
        files = set()
        for file in SOURCE.rglob("*"):
            if file.is_file() and file.suffix in SOURCE_EXTENSIONS:
                target = stage / file.relative_to(ROOT)
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(file, target)
                files.add(target)

        log = import_textures(godot, stage, scratch / "userdata")
        textures = [file for file in files if file.suffix == ".png"]
        try:
            for png in textures:
                files.update(texture_import_paths(png, stage))
        except (FileNotFoundError, RuntimeError) as exc:
            raise RuntimeError(f"Texture import did not finish:\n{log}") from exc

        archive_path = scratch / filename
        with ZipFile(archive_path, "w", compression=ZIP_DEFLATED) as archive:
            for file in sorted(files):
                entry = ZipInfo(file.relative_to(stage).as_posix())
                archive.writestr(entry, file.read_bytes(), compress_type=ZIP_DEFLATED)

        destination = output / filename
        archive_path.replace(destination)
    return destination


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--godot", required=True, type=Path, help="Path to a Godot 3 editor executable")
    parser.add_argument("--output", default=ROOT / "dist", type=Path, help="Output directory")
    args = parser.parse_args()
    print(build(args.godot, args.output.resolve()))


if __name__ == "__main__":
    main()
