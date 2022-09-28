from build_assets import build_css
from utils import load_env
from xml_utils import XsltConvertor, HtmlConvertor, LessonXmlParser, XmlParser
import os
from sql_utils import sqlWriter
from utils import make_folder, is_num
import lxml.etree as ET


def convert(input_folder, output_folder, template, clean = False):
    xslt_convertor = XsltConvertor(template)
    html_convertor = HtmlConvertor()
    xml_parser = XmlParser()
    lesson_xml_parser = LessonXmlParser()

    make_folder(output_folder)
    output_path = make_folder(output_folder, "web")

    for folder in os.scandir(input_folder):
        
        if not is_num(folder.name):
            continue

        html_output_path = None
        if not clean:
            html_output_path = make_folder(output_folder, "web", folder.name)
        sqlpath = os.path.join(output_path, folder.name+".sql")        
        sqlw = sqlWriter(sqlpath, int(folder.name))
        
        for lesson_file in os.scandir(folder):
            filename, ext = os.path.splitext(lesson_file.name)
            
            if filename == "meta":
                meta = ET.parse(lesson_file).getroot()
                intro = meta.xpath("intro")[0]
                if intro is not None:
                    intro = xslt_convertor.convert(intro)
                sqlw.write(year, 0, "Úvod", intro)

            if ext != ".xml" or len(filename) != 2:
                continue

            lesson = xml_parser.parse_file(lesson_file)
            year, num, title = lesson_xml_parser.get_lesson_metadata(lesson)
            html = xslt_convertor.convert_file(lesson_file)

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
        



