SOURCE=ms.md
OUTPUT=datamining_ecology_ms.pdf
BIB=/home/tpoisot/.pandoc/default.bib
CSL=/home/tpoisot/.pandoc/styles/oikos.csl
PFLAGS= --bibliography=$(BIB) --template pandoc.template.tex

# -H margins.sty
# --csl=$(CSL)

PHONY: all

all: $(OUTPUT)

$(OUTPUT): $(SOURCE)
	pandoc $< -o $@ $(PFLAGS)
