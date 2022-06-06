# Makefile for Songs at the Woods' Edge book and website
# Andrew Cashner, 2022/06/06
#
# Written in TEI-XML with some custom elements (= "AAC-XML")
# Output to (1) full TEI, (2) PDF, (3) HTML.
#
# We use LaTeX to process the bibliography and convert to Biblatexml before
# converting that to TEI.

project     = main
dirs        = aux build

aac_in      = $(project).xml
aac_include = $(wildcard include/*.xml)

tex_lib	    = $(wildcard tex/*.cls) 
tex_bib	    = $(project).bib
tex_tmp     = aux/$(project).xml
biber_bcf   = aux/$(project).bcf
biber_xml   = aux/$(project)-bib.bltxml

tei_out     = build/$(project).tei
tei_bib     = aux/$(project)-bib.tei

pdf_out     = build/$(project).pdf
html_out    = build/$(project).html

css_in      = css/$(project).css
css_out     = build/$(project).css

saxon       = java net.sf.saxon.Transform

.PHONY: all tei pdf html clean

all : pdf tei html

tei : $(tei_out) $(tei_bib)

pdf : $(pdf_out)

html : $(html_out) $(css_out)

$(dirs) : 
	mkdir -p $(dirs)

# AAC XML to PDF via LaTeX
## XML to LaTeX
aux/%.tex : %.xml $(aac_include) xsl/aac-tex.xsl | $(dirs)
	$(saxon) -xi:on -xsl:xsl/aac-tex.xsl -s:$< -o:$@

## LaTeX to PDF
aux/%.pdf aux/%.bcf : aux/%.tex $(tex_lib) $(tex_bib)
	latexmk -outdir=aux -pdf -silent $*

build/%.pdf : aux/%.pdf
	cp -ur $< $@

## LaTeX bibliography to TEI bibliography
aux/%-bib.bltxml : aux/%.bcf $(tex_bib)
	biber --output-format=biblatexml -O $@ $<

# AAC XML to TEI
## Main document
build/%.tei : %.xml $(aac_include) aux/%-bib.tei xsl/aac-tei.xsl | $(dirs)
	$(saxon) -xi:on -xsl:xsl/aac-tei.xsl -s:main.xml -o:build/main.tei

## Bibliography
aux/%-bib.tei : aux/%-bib.bltxml xsl/bltxml-tei.xsl | $(dirs)
	$(saxon) -xsl:xsl/bltxml-tei.xsl -s:$< -o:$@

# TEI to HTML
build/%.html : build/%.tei xsl/tei-html.xsl | $(dirs)
	$(saxon) -xsl:xsl/tei-html.xsl -s:build/main.tei -o:build/main.html

build/%.css : css/%.css
	cp -ur $< $@

# View output and clean up
view-book : pdf
	xdg-open $(pdf_out) &

view-web : html
	xdg-open $(html_out) &

clean :
	rm -rf $(dirs)
