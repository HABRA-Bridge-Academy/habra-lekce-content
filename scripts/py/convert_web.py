#/usr/env python3

import os
import lxml.etree as ET
from build_assets import build_css
from utils import load_env
from xml_utils import XsltConvertor, HtmlConvertor, LessonXmlParser, XmlParser
from sql_utils import sqlWriter
from utils import make_folder, is_num
import json

def convert(input_folder, output_folder, template, clean = False, years = None):
    xslt_convertor = XsltConvertor(template)
    html_convertor = HtmlConvertor()
    xml_parser = XmlParser()
    lesson_xml_parser = LessonXmlParser()

    make_folder(output_folder)
    output_path = make_folder(output_folder, "web")

    check = (lambda x: True) if years is None else (lambda x: int(x) in years)
    json_articles = []
        
    for folder in os.scandir(input_folder):

        if not is_num(folder.name) or not check(folder.name):
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
            
            json_articles.append({
                "public": False,
                "meta": {
                "year": int(year),
                "number": int(num),
                    "habraLesson": True
                },
                "title": title,
                "content": html 
            })


            print(f"finished converting web version of {year}/{filename}")
        
        sqlw.close()
        json_path = os.path.join(output_folder, "articles.json")
        with open(json_path, "w") as json_file:
            json.dump(json_articles, json_file, indent=4)



def main(clean = False, years= None):
    print("starting convert web")

    convert(os.getenv("INPUT_DIR"), os.getenv("OUTPUT_DIR"), os.getenv("WEB_TEMPLATE"), clean, years)
    build_css(os.getenv("WEB_CSS"), os.path.join(os.getenv("OUTPUT_DIR"), "stylesheet.css"), compress=True)

if __name__ == "__main__":
    from utils import load_env
    load_env()
    main()
        



