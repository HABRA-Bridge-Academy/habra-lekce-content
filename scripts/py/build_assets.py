
import os


def build_css(inp, out, compress=False):
    if not os.path.isfile(inp):
        ValueError("CSS file doesn't exist")


    c = "--style compressed" if compress else ""
    print(f"sass \"{inp}\" \"{out}\" {c}")
    os.system(f"sass \"{inp}\" \"{out}\" {c}")
    os.system(f"postcss \"{out}\" --replace --use autoprefixer")


