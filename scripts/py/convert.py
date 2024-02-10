#!/usr/env python3

import convert_doc, convert_print, convert_web
import argparse
from utils import load_env


def main(args): 
    clean = not args.dirty
    
    if args.web:
        convert_web.main(clean)
    if args.print:
        convert_print.main(clean)
    if args.doc:
        convert_doc.main(clean)
    
if __name__ == "__main__":
    load_env()
    
    parser = argparse.ArgumentParser()

    parser.add_argument('-p', '--print', default=False,action="store_true", help="generate print files")
    parser.add_argument("-d", "--doc", default=False,action="store_true", help="generate pdf files for individual lessons")
    parser.add_argument("-w", "--web", default=False,action="store_true", help="generate web files")
    parser.add_argument("--dirty", default=False,action="store_true", help="keep meta files")
    
    main(parser.parse_args())