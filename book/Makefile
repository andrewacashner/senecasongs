# Makefile for Songs at the Woods' Edge book and website
# Andrew Cashner, 2022/09
#
# Written in TEI-XML with some custom elements (= "AAC-XML")
# Output to (1) full TEI, (2) PDF, (3) HTML.
#
# We use LaTeX to process the bibliography and convert to Biblatexml before
# converting that to TEI.
#
# In detail:
# 1. Convert TEI-bib to LaTeX (teibib-tex.xsl)
# 2. Compile LaTeX to PDF; along the way Biber generates bcf bibliography file
# 3. Use Biber to generate subset bibliography
# 4. Use Biber to convert that bibliography to bltxml using bcf file
# 5. Convert bltxml to TEI (bltxml-tei.xsl)
# 6. Convert TEI-bib to TEI, first pass: add command to include TEI bibliography file
# 	(teibib-tei_pass1.xsl)
# 7. Convert TEI-bib to TEI, second pass: replace citations with text linked
# 	to bibliography (teibib-tei_pass2.xsl)
# 8. Convert generated TEI to HTML5 including bibliography (tei-html.xsl)
#
# - LaTeX generates the bibliography, citations, and automatic numbering for
#   the PDF version, all from the original TEI-bib input format.
# - The XSL-generated TEI includes the expanded bibliography and citations but not
#   the automatic numbering. (TODO should it?)
# - The XSL-generated HTML5 includes automatic numbering, generated from the
#   TEI.

dirs        = aux build build/media build/fonts

teibib_in      = $(wildcard *.teibib)
teibib_include = $(wildcard include/*.teibib)

tei_in      = $(wildcard *.tei)
tei_include = $(wildcard include/*.tei)

xsl         = $(wildcard xsl/*.xsl)

tex_bib	    = $(wildcard tex/*.bib)
tex_lib	    = $(wildcard tex/*.cls) 
biber_conf  = tex/biber-sort.conf

web_include = $(wildcard web-include/*)
web_include_out = $(addprefix build/,$(notdir $(web_include)))

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

.SECONDARY:

all : pdf tei html

pdf : $(pdf_out)

tei : $(tei_out) $(tei_bib) 

html : $(html_out) $(css_out) $(media_out) $(fonts_out) $(web_include_out) 

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

# Bibliography
## BibTeX to Biblatexml
aux/biblio.bltxml : $(tex_bib) | $(dirs)
	biber --tool --quiet --output-format=biblatexml --output-resolve-crossrefs \
		--no-bltxml-schema -O $@ $< 

## Biblatexml to TEI
aux/biblio.tei : aux/biblio.bltxml $(xsl) | $(dirs)
	$(saxon) -xsl:xsl/bltxml-tei.xsl -s:$< -o:$@

# TEIBIB to TEI
## Main document with bibliography
build/%.tei : %.tei aux/biblio.tei $(teibib_include) $(xsl)
	$(saxon) -xi:on -xsl:xsl/teibib-tei.xsl -s:$< -o:$@

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

build/% : web-include/%
	cp -ur $< $@

# View output and clean up
view-book : pdf
	evince $(pdf_out) &

view-web : html
	firefox $(html_out) &

clean :
	rm -rf $(dirs)

deploy :
	rsync -avuzh --delete ./build/ $(HOME)/Websites/senecasongs.earth/www/
