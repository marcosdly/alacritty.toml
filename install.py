import os
import itertools
from pathlib import Path
import shutil
from pprint import pformat

NOTICE = """\
# THIS FILE WAS GENERATED AUTOMATICALLY
# DO NOT CHANGE IT
# See: github.com/marcosdly/allacritty.toml
# License: MIT
# Please drop a star, feedback or suggestion.
"""


def sortkey(filename: Path):
    return int(filename.stem[:2])


def main():
    config_dir = Path(os.environ["APPDATA"].strip()).joinpath("alacritty")

    with os.scandir("alacritty") as generic_paths:
        generic = [Path(entry.path) for entry in generic_paths]

    with os.scandir("windows" if os.name == "nt" else "linux") as os_paths:
        os_specific = [Path(entry.path) for entry in os_paths]

    generic.sort(key=sortkey)
    os_specific.sort(key=sortkey)

    src_all = list(itertools.chain(generic, os_specific))
    dest_all = [config_dir.joinpath(src_file.name) for src_file in src_all]

    os.makedirs(config_dir, exist_ok=True)
    for src, dest in zip(src_all, dest_all):
        shutil.copyfile(str(src.absolute()), str(dest.absolute()))

    literal_paths = [str(p.absolute()) for p in dest_all]
    # width=0 makes every token (bracket, string, etc) ocupy its own line
    text = f"{NOTICE}\nimport = {pformat(literal_paths, indent=2, width=0)}"
    config_dir.joinpath("alacritty.toml").write_text(text, encoding="utf-8")


if __name__ == "__main__":
    main()
