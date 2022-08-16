from build_assets import build_css
from utils import load_env
from xml_utils import LessonXsltConvertor, HtmlConvertor
import os
from sql_utils import sqlWriter
from utils import make_folder

def convert(input_folder, output_folder, template, clean = False):
    xslt_convertor = LessonXsltConvertor(template)
    html_convertor = HtmlConvertor()

    try:
        os.mkdir(output_folder)
    except:
        pass

    for folder in os.scandir(input_folder):

        try:
            int(folder.name)
        except:
            continue

        output_path = make_folder(output_folder, "web")
        html_output_path = None
        if not clean:
            html_output_path = make_folder(output_folder, "web", folder.name)
        input_path = make_folder(input_folder, folder.name)
        sqlpath = os.path.join(output_path, folder.name+".sql")

        try:
            os.mkdir(output_path)
        except:
            pass
        
        sqlw = sqlWriter(sqlpath, int(folder.name))
        
        for lesson_file in os.scandir(input_path):

            filename, ext = os.path.splitext(lesson_file.name)
            if ext != ".xml" or len(filename) != 2:
                continue
            
            year, num, title, html = xslt_convertor.convert_file(os.path.join(input_path, lesson_file))

            if not clean:
                html_file_path = os.path.join(html_output_path, filename) + ".html"

                with open(html_file_path, "wb") as f:
                    f.write(html_convertor.pretty_print_html(html))

            sqlw.write(year, num, title, html)

            print(f"finished converting web version of {year}/{filename}")
        
        sqlw.close()



def main(clean = False):
    env = load_env()
    print("starting convert web")
    convert(env["INPUT_DIR"], env["OUTPUT_DIR"], env["WEB_TEMPLATE"], clean)
    build_css(env["WEB_CSS"], os.path.join(env["OUTPUT_DIR"], "stylesheet.css"), compress=True)

if __name__ == "__main__":
    main()
        



