# Makefile for Songs at the Woods' Edge book and website
# Andrew Cashner, 2022/06/06
#
# Written in TEI-XML with some custom elements (= "AAC-XML")
# Output to (1) full TEI, (2) PDF, (3) HTML.
#
# We use LaTeX to process the bibliography and convert to Biblatexml before
# converting that to TEI.

dirs        = aux build build/media build/fonts

teibib_in      = $(wildcard *.teibib)
teibib_include = $(wildcard include/*.teibib)

tei_in      = $(wildcard *.tei)
tei_include = $(wildcard include/*.tei)

xsl         = $(wildcard xsl/*.xsl)

tex_bib	    = $(wildcard tex/*.bib)
tex_lib	    = $(wildcard tex/*.cls) 
biber_conf  = tex/biber-sort.conf

tei_out     = $(addprefix build/,$(teibib_in:%.teibib=%.tei) $(tei_in))
tei_bib     = $(addprefix aux/,$(teibib_in:%.teibib=%-bib.tei))

pdf_out     = $(tei_out:%.tei=%.pdf)
html_out    = $(tei_out:%.tei=%.html)

css_in      = $(wildcard css/*.css)
css_out     = $(addprefix build/,$(notdir $(css_in)))

media_in    = $(wildcard media/*.*)
media_out   = $(addprefix build/,$(media_in))

fonts_in    = $(wildcard fonts/*.*)
fonts_out   = $(addprefix build/,$(fonts_in))

saxon       = java net.sf.saxon.Transform

.PHONY: all tei pdf html clean

all : pdf tei html

pdf : $(pdf_out)

tei : $(tei_out) $(tei_bib) 

html : $(html_out) $(css_out) $(media_out) $(fonts_out)

$(dirs) : 
	mkdir -p $(dirs)

# AAC XML to PDF via LaTeX
## XML to LaTeX
aux/%.tex : %.tei $(teibib_include) $(xsl) | $(dirs)
	$(saxon) -xi:on -xsl:xsl/teibib-tex.xsl -s:$< -o:$@

aux/%.tex : %.teibib $(teibib_include) $(xsl) | $(dirs)
	$(saxon) -xi:on -xsl:xsl/teibib-tex.xsl -s:$< -o:$@

## LaTeX to PDF
aux/%.pdf aux/%.bcf : aux/%.tex $(tex_lib) $(tex_bib)
	latexmk -outdir=aux -pdf -quiet $*

build/%.pdf : aux/%.pdf
	cp -ur $< $@

## LaTeX bibliography to TEI bibliography
### Generate sorted subset biblatex file of only works cited in latex file
aux/%.bib : aux/%.bcf $(biber_conf)
	biber --quiet --configfile=$(biber_conf) --output_format=bibtex \
		--output-resolve-crossrefs -O $@ $<

### Convert subset bib file to XML
aux/%.bltxml : aux/%.bib
	biber --tool --quiet --output-format=biblatexml --no-bltxml-schema -O $@ $<

# AAC XML to TEI
## First pass, add xi:include for tei bibliography to main
aux/%.teibib : %.teibib $(teibib_include) $(xsl) | $(dirs)
	$(saxon) -xi:on -xsl:xsl/teibib-tei_pass1.xsl -s:$< -o:$@

## Bibliography
aux/%-bib.tei : aux/%.bltxml $(xsl) | $(dirs)
	$(saxon) -xsl:xsl/bltxml-tei.xsl -s:$< -o:$@

## Second pass: Main document with bibliography
build/%.tei : aux/%.teibib aux/%-bib.tei $(xsl)
	$(saxon) -xi:on -xsl:xsl/teibib-tei_pass2.xsl -s:$< -o:$@

build/%.tei : %.tei $(xsl)
	$(saxon) -xi:on -xsl:xsl/teibib-tei_pass2.xsl -s:$< -o:$@

# TEI to HTML
## (TEI complete document including bibliography and resolved citations)
build/%.html : build/%.tei $(xsl) | $(dirs)
	$(saxon) -xsl:xsl/tei-html.xsl -s:$< -o:$@

build/%.css : css/%.css
	cp -ur $< $@

build/media/% : media/%
	cp -ur $< $@

build/fonts/% : fonts/%
	cp -ur $< $@

# View output and clean up
view-book : pdf
	evince $(pdf_out) &

view-web : html
	firefox $(html_out) &

clean :
	rm -rf $(dirs)
