SOURCE=ms.md
OUTPUT=global_ecol.pdf
BIB=/home/tpoisot/.pandoc/default.bib
CSL=/home/tpoisot/.pandoc/styles/oikos.csl
PFLAGS= --bibliography=$(BIB) --template pandoc.template.latex

# -H margins.sty
# --csl=$(CSL)

PHONY: all

all: $(OUTPUT)

$(OUTPUT): $(SOURCE)
	pandoc $< -o $@ $(PFLAGS)
