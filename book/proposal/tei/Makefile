tei_in 	    = $(wildcard *.tei)
tei_include = $(wildcard include/*.tei)
tex_include = $(wildcard tex/*.cls)
html_out    = $(addprefix build/,$(tei_in:%.tei=%.html))
pdf_out     = $(addprefix build/,$(tei_in:%.tei=%.pdf))
dirs 	    = aux build

saxon = java net.sf.saxon.Transform

.PHONY : all html pdf view view-web view-book clean

all : html pdf 

html : $(html_out)

pdf : $(pdf_out)

$(dirs) :
	mkdir -p $(dirs)

build/%.pdf : aux/%.pdf
	cp -ur $< $@

aux/%.pdf : aux/%.tex $(tex_include)
	latexmk -outdir=aux -pdf $<

aux/%.tex : %.tei $(tei_include) xsl/tei-tex.xsl | $(dirs)
	$(saxon) -xi:on -xsl:xsl/tei-tex.xsl -s:main.tei -o:$@

build/%.html : aux/%.tei xsl/tei-html.xsl
	$(saxon) -xsl:xsl/tei-html.xsl -s:$< -o:$@

aux/%.tei : %.tei $(tei_include) xsl/aac-tei.xsl | $(dirs)
	$(saxon) -xi:on -xsl:xsl/aac-tei.xsl -s:main.tei -o:$@

aux/%.bcf : aux/%.tex
	biber $< -O $@

aux/%.bltxml : aux/%.bcf xsl/bibexpand.sed
	biber --output-format=biblatexml $@ -O $@
	sed -f xsl/bibexpand.sed -i $@

view : view-web view-book

view-web : $(html_out)
	xdg-open $< &

view-book : $(pdf_out)
	xdg-open $< &

clean :
	rm -rf $(dirs)






