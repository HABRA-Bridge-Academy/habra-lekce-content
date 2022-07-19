from env import load_env
from myxml import Convertor
from myxml import pretty_print_html
import os

env = load_env()

output_folder = env["OUTPUT_FOLDER"]
input_folder = env["XML_FOLDER"]
xslt_convertor = Convertor(env["XSLT_TEMPLATE"])


for folder in os.scandir(input_folder):

    output_path = os.path.join(output_folder, folder.name)
    input_path = os.path.join(input_folder, folder.name)

    try:
        os.mkdir(output_path)
    except:
        pass

    for lesson_file in os.scandir(input_path):

        filename, ext = os.path.splitext(lesson_file.name)
        if ext != ".xml":
            continue
        new_path = os.path.join(output_path, filename) + ".html"
        
        html = xslt_convertor.convert(os.path.join(input_path, lesson_file))

        with open(new_path, "wb") as f:
            f.write(pretty_print_html(html))

        print(f"finished converting {lesson_file.name}")

        



