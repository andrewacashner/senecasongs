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

tex_bib	    = tex/$(project).bib
tex_lib	    = $(wildcard tex/*.cls) 
biber_conf  = tex/biber-sort.conf

tei_out     = build/$(project).tei
tei_bib     = aux/$(project)-bib.tei

pdf_out     = build/$(project).pdf
html_out    = build/$(project).html

css_in      = css/$(project).css
css_out     = build/$(project).css

saxon       = java net.sf.saxon.Transform

.PHONY: all tei pdf html clean

all : pdf tei html

pdf : $(pdf_out)

tei : $(tei_out) $(tei_bib) 

html : $(html_out) $(css_out) 

$(dirs) : 
	mkdir -p $(dirs)

# AAC XML to PDF via LaTeX
## XML to LaTeX
aux/%.tex : %.xml $(aac_include) xsl/aac-tex.xsl | $(dirs)
	$(saxon) -xi:on -xsl:xsl/aac-tex.xsl -s:$< -o:$@

## LaTeX to PDF
aux/%.pdf aux/%.bcf : aux/%.tex $(tex_lib) $(tex_bib)
	latexmk -outdir=aux -pdf -quiet $*

build/%.pdf : aux/%.pdf
	cp -ur $< $@

## LaTeX bibliography to TEI bibliography
### Generate sorted subset biblatex file of only works cited in latex file
aux/%.bib : aux/%.bcf $(biber_conf)
	biber $< --quiet --configfile=$(biber_conf) --output_format=bibtex \
		--output-resolve-crossrefs -O $@

### Convert subset bib file to XML
aux/%.bltxml : aux/%.bib
	biber --tool --quiet --output-format=biblatexml --no-bltxml-schema -O $@ $<

# AAC XML to TEI
## First pass, add xi:include for tei bibliography to main
aux/%.tei : %.xml $(aac_include) xsl/aac-tei_pass1.xsl | $(dirs)
	$(saxon) -xi:on -xsl:xsl/aac-tei_pass1.xsl -s:$< -o:$@

## Bibliography
aux/%-bib.tei : aux/%.bltxml xsl/bltxml-tei.xsl | $(dirs)
	$(saxon) -xsl:xsl/bltxml-tei.xsl -s:$< -o:$@

## Second pass: Main document with bibliography
build/%.tei : aux/%.tei aux/%-bib.tei xsl/aac-tei_pass2.xsl 
	$(saxon) -xi:on -xsl:xsl/aac-tei_pass2.xsl -s:$< -o:$@


# TEI to HTML
## (TEI complete document including bibliography and resolved citations)
build/%.html : build/%.tei xsl/tei-html.xsl xsl/tei-html_bib.xsl | $(dirs)
	$(saxon) -xsl:xsl/tei-html.xsl -s:$< -o:$@

build/%.css : css/%.css
	cp -ur $< $@

# View output and clean up
view-book : pdf
	xdg-open $(pdf_out) &

view-web : html
	xdg-open $(html_out) &

clean :
	rm -rf $(dirs)
