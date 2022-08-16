
import os
from utils import load_env, make_folder
from xml_utils import LessonXsltConvertor, HtmlConvertor
from pdf_utils import WkToHtmlConvertor
from build_assets import build_css

def generate(pdf_convertor, input_folder, output_folder, template, clean = False):

    print("starting conversion to pdf")

    pdf_path = make_folder(output_folder, "pdf")

    xslt_convertor = LessonXsltConvertor(template)
    html_convertor = HtmlConvertor()
        
    for folder in os.scandir(input_folder):

        try:
            int(folder.name)
        except:
            continue

        year_pdf_output_path = make_folder(pdf_path, folder.name)
        year_xml_input_path = make_folder(input_folder, folder.name)
        
        for lesson_file in os.scandir(year_xml_input_path):

            filename, ext = os.path.splitext(lesson_file.name)
            if ext != ".xml" or len(filename) != 2:
                continue            
            year, num, title, html = xslt_convertor.convert_file(os.path.join(year_xml_input_path, lesson_file))

            htmlfilename = os.path.join(year_pdf_output_path, filename + ".html")

            with open(htmlfilename, "w") as f:
                f.write(html_convertor.minify_html(html))

            pdf_convertor.convert(htmlfilename, os.path.join(year_pdf_output_path, filename + ".pdf"))

            if clean:
                os.remove(htmlfilename)

            print(f"finished converting pdf {year}/{filename}")


def main(clean = False):
    env = load_env()
    css_path = os.path.join(env["OUTPUT_DIR"], "doc.css")
    build_css(env["DOC_CSS"], css_path)
    wk_convertor = WkToHtmlConvertor(env["WK_PATH"], env["DOC_WK_OPTS"], css_path)
    generate(wk_convertor, env["INPUT_DIR"],  os.path.abspath( env["OUTPUT_DIR"]), env["DOC_TEMPLATE"], clean)

    if clean:
        os.remove(css_path)

if __name__ == "__main__":
    main()