from env import load_env
from myxml import Convertor, pretty_print_html, minify_html
import os


preamble=\
'''SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

CREATE TABLE IF NOT EXISTS `lekce2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rocnik` int(11) NOT NULL,
  `cislo` int(11) NOT NULL,
  `nadpis` text COLLATE utf8_czech_ci NOT NULL,
  `text` text COLLATE utf8_czech_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cislo` (`rocnik`,`cislo`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=5 ;

DELETE FROM `lekce2` WHERE rocnik=@r;

INSERT INTO `lekce2` (`rocnik`, `cislo`, `nadpis`, `text`) VALUES'''

class sqlWriter:

    def __init__(self, sqlpath, rocnik) -> None:
        self.file = open(sqlpath, "w")
        self.file.write(preamble.replace("@r", str(rocnik)))
        self.first = True

    def write(self, year, number, title, text):
        text = text.replace("'", "''")
        title = title.replace("'", "''")
        self.file.write(f"\n{'' if self.first else',' }({year},{number},'{title}','{text}')" )
        self.first = False

    def close(self):
        self.file.write(";")
        self.file.close()


def convert(input_folder, output_folder, template):
    xslt_convertor = Convertor(template)
    

    try:
        os.mkdir(output_folder)
    except:
        pass

    for folder in os.scandir(input_folder):

        try:
            int(folder.name)
        except:
            continue

        output_path = os.path.join(output_folder, folder.name)
        input_path = os.path.join(input_folder, folder.name)
        sqlpath = os.path.join(output_path, folder.name+".sql")
        sqlw = sqlWriter(sqlpath, int(folder.name))

        try:
            os.mkdir(output_path)
        except:
            pass
        
        for lesson_file in os.scandir(input_path):

            filename, ext = os.path.splitext(lesson_file.name)
            if ext != ".xml":
                continue
            new_path = os.path.join(output_path, filename) + ".html"
            
            year, num, title, html = xslt_convertor.convert_file(os.path.join(input_path, lesson_file))

            with open(new_path, "wb") as f:
                f.write(pretty_print_html(html))

            sqlw.write(year, num, title, html)

            print(f"finished converting {lesson_file.name}")
        
        sqlw.close()


if __name__ == "__main__":

    env = load_env()

    print("starting convert")

    convert(env["INPUT_DIR"], env["OUTPUT_DIR"], env["TEMPLATE"])

        



