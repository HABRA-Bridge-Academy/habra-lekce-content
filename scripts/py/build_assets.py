
import os


def build_css(inp, out, compress=False):
    if not os.path.isfile(inp):
        ValueError("CSS file doesn't exist")


    c = "--style compressed" if compress else ""
    os.system(f"sass --sourcemap=none {inp} {out} {c}")
    print(f"sass --sourcemap=none {inp} {out} {c}")


