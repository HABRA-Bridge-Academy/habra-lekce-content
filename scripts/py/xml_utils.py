import lxml.etree as ET
from bs4 import BeautifulSoup
import htmlmin

class HtmlConvertor:

    def pretty_print_html(self, html_string):
        return BeautifulSoup(html_string, "html.parser").prettify(formatter="minimal", encoding="utf-8")

    def minify_html(self, html_string):
        return htmlmin.minify(html_string)


class XsltConvertor:

    def __init__(self, template_path) -> None:
        self.transform = ET.XSLT(ET.parse(template_path))
        self.xml_parser = XmlParser()

    def convert_file(self, file_path):
        return self.convert(self.xml_parser.parse_file(file_path))

    def convert(self, el):
        return str(self.transform(el))


class XmlParser:

    def parse_file(self, file_path):
        return ET.parse(file_path)

    def parse(self, string):
        return ET.parse(string)

class LessonXmlParser:
    def get_lesson_metadata(self, lesson):
        return lesson.xpath('@year')[0], lesson.xpath('@number')[0], lesson.xpath('@title')[0]


