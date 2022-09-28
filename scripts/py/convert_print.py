
import os
from build_assets import build_css
from utils import load_env, make_folder, is_num
from xml_utils import XsltConvertor, HtmlConvertor, XmlParser, LessonXmlParser
from pdf_utils import WkToHtmlConvertor
import lxml.etree as ET


def generate(pdf_convertor, input_folder, output_folder, template, clean = False):

    print("starting conversion to print-pdf")

    pdf_path = make_folder(output_folder, "print")

    xslt_convertor = XsltConvertor(template)
    html_convertor = HtmlConvertor()
    xml_parser = XmlParser()
    lesson_xml_parser = LessonXmlParser()
        
    for folder in os.scandir(input_folder):

        if not is_num(folder.name):
            continue

        year = int(folder.name)
        book = ET.Element("book", { "year": str(year)})
        files = os.scandir(folder)
        parts = {}
        
        for file in files:
            filename, ext = os.path.splitext(file.name)
            if ext != ".xml":
                continue  

            if filename == "meta":
                meta = ET.parse(os.path.join(folder, file)).getroot()
                intro = meta.xpath("intro")[0]
                if intro is not None:
                    parts["intro"] = intro
                phrase = meta.xpath("phrase")[0]
                if phrase is not None:
                    book.set("phrase", phrase.text)
                yearname = meta.xpath("year-name")[0]
                if yearname is not None:
                    book.set("year-name", yearname.text)
            try:
                num = int(filename)
            except:
                continue
            num = int(filename)
            lesson = ET.parse(os.path.join(folder, file))
            parts[num] = lesson.getroot()

        if "intro" in parts:
            book.append(parts["intro"])

        for num in range(1,100):
            if num not in parts: 
                break
            book.append(parts[num])

        book_pdf_output_path = os.path.join(pdf_path, folder.name + ".pdf")
        book_html_output_path =  os.path.join(pdf_path, folder.name + ".html")
        book_xml_output_path =  os.path.join(pdf_path, folder.name + ".xml")
        html = xslt_convertor.convert(book)

        with open( book_html_output_path, "w") as f:
            f.write(html)

        if not clean:
            with open( book_xml_output_path, "wb") as f:
                f.write(ET.tostring(book, pretty_print=True, encoding='UTF-8'))

        pdf_convertor.convert(book_html_output_path, book_pdf_output_path)

        if clean:
            os.remove(book_html_output_path)

        print(f"finished converting print pdf of {year}")


def main(clean = False):
    env = load_env()
    css_path = os.path.join(env["OUTPUT_DIR"], "print.css")
    build_css(env["PRINT_CSS"], css_path)
    wk_convertor = WkToHtmlConvertor(env["WK_PATH"], env["PRINT_WK_OPTS"], css_path,  env["PRINT_TOC_TEMPLATE"])
    generate(wk_convertor, env["INPUT_DIR"],  os.path.abspath( env["OUTPUT_DIR"]), env["PRINT_TEMPLATE"], clean)

    if clean:
        os.remove(css_path)

if __name__ == "__main__":
    main()