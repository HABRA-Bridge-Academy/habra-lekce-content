import os

class WkToHtmlConvertor:

    def __init__(self, wkpath, options, css_file, toc_path = None) -> None:
        self.path = wkpath
        self.options = options
        self.css = css_file
        self.toc = toc_path

    def convert(self, input_html, output_file, page_number=False, toc = True):
        toc1 = f"--xsl-style-sheet {self.toc}" if  toc and self.toc else ""
        toc2 = "toc" if toc and self.toc else ""
        pages = "--footer-center [page]  --footer-font-size 10" if page_number else ""
        command =f"wkhtmltopdf --quiet --page-offset 1 {self.options} {pages} --user-style-sheet  {self.css}   \"{input_html}\" {toc2} {toc1}  \"{output_file}\""
        os.system(command)


class PdfMerger: 

    def __init__(self, sejda) -> None:
        self.sejda_path = sejda

    def merge(self, inputs, output):
        # TOC links will be invalid
        command = f"{self.sejda_path} merge --overwrite -b retain -f {' '.join(inputs)} -o {output} >{os.devnull}"
        os.system(command)