dirs		= aux build build/css build/css/fonts build/media

xhtml_in	= $(wildcard *.xhtml)
xhtml_include	= $(wildcard include/*.xhtml)
html_out	= $(addprefix build/,$(xhtml_in:%.xhtml=%.html))

bibtex		= $(wildcard *.bib)
bibxml		= $(addprefix aux/,$(bibtex:%.bib=%.bltxml))
biber_log	= aux/biber.blg

# For now, only making PDF of whole book, not indiv. pages
latex		= aux/book.tex
pdf_out		= $(addprefix build/media/,$(notdir $(latex:%.tex=%.pdf)))
tex_lib		= $(wildcard tex/*)

html_deps_in	= $(wildcard css/* css/fonts/* media/*)
html_deps_out	= $(addprefix build/,$(html_deps_in))

xsl		= $(wildcard xsl/*.xsl)

saxon 		= java -cp ".:$(HOME)/saxon/saxon-he-12.0.jar" net.sf.saxon.Transform

.SECONDARY : $(bibxml) $(latex)

.PHONY : all html pdf view view-pdf deploy clean

all : html pdf

html : $(html_out) $(html_deps_out)

pdf : $(pdf_out)

build/% : %
	cp -ur $< $@

build/%.html : %.xhtml $(xhtml_include) $(bibxml) $(xsl) | $(dirs)
	$(saxon) -xi:on -xsl:xsl/xhtml_aac-html.xsl -s:$< -o:$@

aux/%.bltxml : %.bib | $(dirs)
	biber --tool --quiet --output-format=biblatexml \
		--output-resolve-crossrefs --no-bltxml-schema \
		--logfile $(biber_log) \
		-O $@ $<

build/%.pdf : aux/%.pdf
	cp -u $< $@

aux/%.pdf : aux/%.tex $(bibtex) $(tex_lib)
	latexmk -outdir=aux -pdf $<

aux/%.tex : %.xhtml $(xhtml_include) $(xsl) | $(dirs)
	$(saxon) -xi:on -xsl:xsl/xhtml_aac-tex.xsl -s:$< -o:$@

$(dirs) : 
	mkdir -p $(dirs)

view : html
	firefox $(html_out)

view-pdf : pdf
	evince $(pdf_out)

deploy : html
	cp -ur build/* $(HOME)/Websites/senecasongs.earth/www/

clean :
	rm -rf $(dirs)


