
PYTHON=python
BIN=./venv/bin/

.PHONY: all print web docs install

all: print web docs

install:
	$(BIN)activate; \
    pip install -r requirements.txt; 

print:
	$(PYTHON) py/convert.py --print

web:
	$(PYTHON) py/convert.py --web

docs:
	$(PYTHON) py/convert.py --docs