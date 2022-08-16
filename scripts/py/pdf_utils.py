import os
import weasyprint

class WkToHtmlConvertor:

    def __init__(self, wkpath, options, css_file, toc_path = None) -> None:
        self.path = wkpath
        self.options = options
        self.css = css_file
        self.toc = toc_path

    def convert(self, input_html, output_file):
        toc1 = f"--xsl-style-sheet {self.toc}" if self.toc else ""
        toc2 = "toc" if self.toc else ""
        command =f"wkhtmltopdf --quiet --user-style-sheet  {self.css} {self.options}  \"{input_html}\" {toc2} {toc1}  \"{output_file}\""
        os.system(command)



class WeasyConvertor:

    def __init__(self, css_file) -> None:
        self.css = [weasyprint.CSS(css_file)]

    def convert(self, input_html, output_file):
        
        pdf = weasyprint.HTML(input_html).write_pdf(stylesheets=self.css)

        with open(output_file, "wb") as f:
            f.write(pdf)