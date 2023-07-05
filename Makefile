dirs		= aux build build/css build/css/fonts build/media

xhtml_in	= $(wildcard src/*.xhtml)
html_out	= $(addprefix build/,$(notdir $(xhtml_in:%.xhtml=%.html)))
xhtml_include	= $(wildcard src/articles/*.xhtml src/tables/*.xhtml)

bibtex		= $(wildcard *.bib)
bibxml		= $(addprefix aux/,$(bibtex:%.bib=%.bltxml))
biber_log	= aux/biber.blg

# For now, only making PDF of whole book, not indiv. pages
latex		= aux/book.tex
pdf_out		= $(addprefix build/,$(notdir $(latex:%.tex=%.pdf)))
tex_lib		= $(wildcard lib/tex/*)

media_in	= $(wildcard media/*)
css_in		= $(wildcard lib/css/* lib/css/fonts/*)
html_deps_out	= $(addprefix build/,$(media_in) $(css_in:lib/%=%))

music_in	= $(wildcard src/music-examples/*.ly)
ly_lib		= $(wildcard lib/ly/*.ly)
music_svg_out	= $(addprefix build/media/,$(notdir $(music_in:%.ly=%.svg)))
music_pdf_out   = $(addprefix aux/,$(notdir $(music_in:%.ly=%.pdf)))
music_out 	= $(music_svg_out) $(music_pdf_out)

xsl		= $(wildcard lib/xsl/*.xsl)

saxon 		= $(HOME)/bin/saxon

lilypond	= lilypond -I $(PWD)/lib/ly -dcrop -o aux/

define copy
cp -ur $< $@
endef

.SECONDARY : $(bibxml) $(latex) $(music_svg_out) $(music_pdf_out)

.PHONY : all html pdf ly view view-pdf deploy clean ly

all : html pdf

html : $(html_out) $(html_deps_out)

pdf : $(pdf_out)

ly : $(music_out)


build/% : % 
	$(copy)

build/% : lib/% 
	$(copy)

build/%.html : src/%.xhtml $(xhtml_include) $(bibxml) $(xsl) $(music_svg_out) $(dirs)
	$(saxon) -xi:on -xsl:lib/xsl/xhtml_aac-html.xsl -s:$< -o:$@

aux/%.bltxml : %.bib | $(dirs)
	biber --tool --quiet --output-format=biblatexml \
		--output-resolve-crossrefs --no-bltxml-schema \
		--logfile $(biber_log) \
		-O $@ $<

build/%.pdf : aux/%.pdf
	$(copy)

aux/%.pdf : aux/%.tex $(bibtex) $(tex_lib) $(music_pdf_out)
	latexmk -outdir=aux -pdfxe $<

aux/%.tex : src/%.xhtml $(xhtml_include) $(xsl) | $(dirs)
	$(saxon) -xi:on -xsl:lib/xsl/xhtml_aac-tex.xsl -s:$< -o:$@

build/media/%.svg : aux/%.cropped.svg 
	$(copy)

aux/%.pdf : aux/%.cropped.pdf
	mv $< $@

aux/%.cropped.svg : src/music-examples/%.ly $(ly_lib) | $(dirs)
	$(lilypond) --svg $<

aux/%.cropped.pdf : src/music-examples/%.ly | $(dirs)
	$(lilypond) $<

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


