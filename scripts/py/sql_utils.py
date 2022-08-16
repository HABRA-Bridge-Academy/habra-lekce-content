
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