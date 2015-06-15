SOURCE=ms.md
OUTPUT=datamining_ecology_ms.pdf
BIB=/home/tpoisot/.pandoc/default.bib
CSL=/home/tpoisot/.pandoc/styles/oikos.csl
PFLAGS= --bibliography=$(BIB) --csl=$(CSL) --template pandoc.template.tex

PHONY: all

all: $(OUTPUT)

$(OUTPUT): $(SOURCE)
	# Critic markup
	perl critic.pl $< > marked_$(SOURCE)
	# Compile
	pandoc marked_$(SOURCE) -o $@ $(PFLAGS)
	# Clean
	rm marked_$(SOURCE)
