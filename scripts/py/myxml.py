import lxml.etree as ET
from bs4 import BeautifulSoup
import htmlmin


def pretty_print_html(html_string):
    
    return BeautifulSoup(html_string, "html.parser").prettify(formatter="minimal", encoding="utf-8")

def minify_html(html_string):
    return htmlmin.minify(html_string)

class Convertor:

    def __init__(self, template_path) -> None:
        self.transform = ET.XSLT( ET.parse(template_path))

    def parse_file(self, file_path):
        return ET.parse(file_path)

    def convert_file(self, file_path):

        lesson = ET.parse(file_path)
        return lesson.xpath('@year')[0], lesson.xpath('@number')[0], lesson.xpath('@title')[0], str(self.transform(lesson))

