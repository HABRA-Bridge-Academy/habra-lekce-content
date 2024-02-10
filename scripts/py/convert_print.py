#/usr/env python3

import os
import lxml.etree as ET
from build_assets import build_css
from pdf_utils import PdfMerger
from utils import load_env, make_folder, is_num
from xml_utils import XsltConvertor
from pdf_utils import WkToHtmlConvertor

def generate(pdf_convertor, pdf_merger, input_folder, output_folder, template, clean = False, years = None):

    print("starting conversion to print-pdf")

    pdf_path = make_folder(output_folder, "print")

    xslt_convertor = XsltConvertor(template)

    check = (lambda x: True) if years is None else (lambda x: int(x) in years)
        
    for folder in os.scandir(input_folder):

        if not is_num(folder.name) or not check(folder.name):
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
                coverpage = ET.fromstring("<coverpage/>")
                coverpage.set("year", str(year))
                
                if intro is not None:
                    parts["intro"] = intro
                phrase = meta.xpath("phrase")[0]
                if phrase is not None:
                    book.set("phrase", phrase.text)
                    coverpage.set("phrase", phrase.text)
                yearname = meta.xpath("year-name")[0]
                if yearname is not None:
                    book.set("year-name", yearname.text)
                    coverpage.set("year-name", yearname.text)
            if not is_num(filename):
                continue
            num = int(filename)
            lesson = ET.parse(os.path.join(folder, file))
            parts[num] = lesson.getroot()

        if coverpage is None:
            continue

        if "intro" in parts:
            book.append(parts["intro"])

        for num in range(1,100):
            if num not in parts: 
                break
            book.append(parts[num])

        book_pdf_output_path = os.path.join(pdf_path, folder.name + "b.pdf")
        book_html_output_path =  os.path.join(pdf_path, folder.name + "b.html")
        book_xml_output_path =  os.path.join(pdf_path, folder.name + "b.xml")
        cover_pdf_output_path = os.path.join(pdf_path, folder.name + "c.pdf")
        cover_html_output_path =  os.path.join(pdf_path, folder.name + "c.html")
        cover_xml_output_path =  os.path.join(pdf_path, folder.name + "c.xml")

        final_pdf_output_path =  os.path.join(pdf_path, folder.name + ".pdf")

        
        book_html = xslt_convertor.convert(book)
        cover_html = xslt_convertor.convert(coverpage)
        
        with open( book_html_output_path, "w") as f:
            f.write(book_html)
        with open( cover_html_output_path, "w") as f:
            f.write(cover_html)

        if not clean:
            with open( book_xml_output_path, "wb") as f:
                f.write(ET.tostring(book, pretty_print=True, encoding='UTF-8'))
            with open( cover_xml_output_path, "wb") as f:
                f.write(ET.tostring(coverpage, pretty_print=True, encoding='UTF-8'))

        pdf_convertor.convert(book_html_output_path, book_pdf_output_path, True)
        pdf_convertor.convert(cover_html_output_path, cover_pdf_output_path, page_number=False, toc=False)

        pdf_merger.merge([cover_pdf_output_path, book_pdf_output_path], final_pdf_output_path)

        if clean:
            os.remove(book_html_output_path)
            os.remove(cover_html_output_path)
            
            
        print(f"finished converting print pdf of {year}")


def main(clean = False, years= None ):
    css_path = os.path.join(os.getenv("OUTPUT_DIR"), "print.css")
    build_css(os.getenv("PRINT_CSS"), css_path)
    wk_convertor = WkToHtmlConvertor(os.getenv("WK_PATH"), os.getenv("PRINT_WK_OPTS"), css_path,  os.getenv("PRINT_TOC_TEMPLATE"))

    merger=PdfMerger(os.getenv("SEJDA_CONSOLE_PATH"))

    generate(wk_convertor, merger, os.getenv("INPUT_DIR"),  os.path.abspath( os.getenv("OUTPUT_DIR")), os.getenv("PRINT_TEMPLATE"), clean, years)

    if clean:
        os.remove(css_path)

if __name__ == "__main__":
    from utils import load_env
    load_env()
    main()