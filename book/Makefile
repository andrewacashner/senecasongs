# Andrew Cashner
# 2022/12/12

dirs		= aux/ build/ build/css build/media/ 

tex_bib		= tex/indigenous.bib
tex_config	= $(wildcard tex/*.cls tex/*.sty)
xsl 		= $(wildcard xsl/*.xsl)

teibib_in  	= $(wildcard *.teibib)
tei_include 	= $(wildcard include/*.teibib)

tei_out		= $(addprefix build/,$(teibib_in:%.teibib=%.tei))
html_out	= $(tei_out:%.tei=%.html)
pdf_out		= $(tei_out:%.tei=%.pdf)

html_deps_in	= $(wildcard css/* media/*)
web_include_in  = $(wildcard web-include/*)
web_include_out = $(addprefix build/,$(notdir $(web_include)))
html_deps_out   = $(addprefix build/,$(html_deps_in)) $(web_include_out)

saxon   	= java -cp ".:$(HOME)/saxon/saxon-he-12.0.jar" net.sf.saxon.Transform

.PHONY : all tei html pdf clean

all :  tei html pdf

html : $(html_out) $(html_deps_out)

tei : $(tei_out)

pdf : $(pdf_out)

$(dirs) :
	mkdir -p $(dirs)

# TEI-XML
## TEIbib to TEI: Process bibliography and citations, xi:includes
build/%.tei : %.teibib $(tei_include) $(xsl) | $(dirs) build/biblio.tei
	$(saxon) -xi:on -xsl:xsl/teibib-tei.xsl -s:$< -o:$@

# Bibliography
## Convert XML bibliography to TEI
build/biblio.tei : aux/biblio.bltxml $(xsl)
	$(saxon) -xsl:xsl/bltxml-tei.xsl -s:$< -o:$@

## Convert BibTeX bibliography to XML
aux/biblio.bltxml : $(tex_bib) | $(dirs)
	biber --tool --quiet --output-format=biblatexml --output-resolve-crossrefs \
		--no-bltxml-schema -O $@ $<

# HTML
## Convert TEI output to HTML
build/%.html : build/%.tei $(xsl) $(html_deps_out)
	$(saxon) -xsl:xsl/tei-html.xsl -s:$< -o:$@

## Copy HTML dependencies (CSS, media, fonts, etc.)
build/% : %
	cp -ur $< $@

build/% : web-include/%
	cp -ur $< $@

# PDF
build/%.pdf : aux/%.pdf
	cp -u $< $@

## LaTeX to PDF
aux/%.pdf : aux/%.tex $(tex_bib) $(tex_config)
	latexmk -quiet -outdir=aux -pdf $<

## TEIbib to LaTeX (no bibliography processing needed; LaTeX will do it)
aux/%.tex : %.teibib $(xsl) | $(dirs)
	$(saxon) -xi:on -xsl:xsl/teibib-tex.xsl -s:$< -o:$@


# Utilities
view : html
	firefox build/index.html

view-book : build/book.pdf
	xdg-open $<

clean :
	rm -rf $(dirs)




