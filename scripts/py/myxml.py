import lxml.etree as ET
from bs4 import BeautifulSoup

def pretty_print_html(html_string):
    
    return BeautifulSoup(html_string, "html.parser").prettify(formatter="minimal", encoding="utf-8")



class Convertor:

    def __init__(self, template_path) -> None:
        self.transform = ET.XSLT( ET.parse(template_path))

    def convert(self, file_path):
        return str(self.transform(ET.parse(file_path)))
