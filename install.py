from pathlib import Path
import itertools
import os


def file_sorting_key(path: str) -> int:
    basename = os.path.basename(path)
    return int(basename[:2])


def listdir(dir: str) -> list[str]:
    return [entry.path for entry in os.scandir(dir)]


def absolute(paths: list[str]) -> list[str]:
    return [os.path.abspath(p) for p in paths]


def escape_backslash(paths: list[str]) -> list[str]:
    return [p.replace("\\", "\\\\") for p in paths]


def quoted(paths: list[str]) -> list[str]:
    return [f'"{p}"' for p in paths]


def indented(paths: list[str], size: int = 2) -> list[str]:
    spaces = " " * size
    return [f"{spaces}{p},\n" for p in paths]


def formatted(paths: list[str]) -> list[str]:
    return indented(quoted(escape_backslash(absolute(paths))))


def main():
    with open("./alacritty.toml", "rt") as template:
        lines = template.readlines()

    with_imports = lines.copy()

    generic_paths = listdir("./alacritty")
    generic_paths.sort(key=file_sorting_key)
    generic_paths = formatted(generic_paths)

    os_specific_paths = listdir("./windows" if os.name == "nt" else "./linux")
    os_specific_paths.sort(key=file_sorting_key)
    os_specific_paths = formatted(os_specific_paths)

    for i, line in enumerate(lines):
        if "{generic}" in line:
            with_imports[i] = generic_paths
            continue
        if "{os_specific}" in line:
            with_imports[i] = os_specific_paths

    flatten = list(itertools.chain.from_iterable(with_imports))

    prefix = Path(os.getenv("APPDATA") if os.name == "nt" else os.getenv("HOME"))

    with open(prefix / "alacritty" / "alacritty.toml", "wt") as output:
        output.writelines(flatten)


if __name__ == "__main__":
    main()
