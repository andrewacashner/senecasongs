tex_in  = $(wildcard *.tex)
tex_lib = $(wildcard *.cls) $(wildcard *.bib)
dirs	= aux build
pdf_out = $(addprefix build/,$(tex_in:%.tex=%.pdf))

.PHONY : all view clean

all : $(pdf_out)

build/%.pdf : aux/%.pdf
	cp -u $< $@

aux/%.pdf : %.tex $(tex_lib) | $(dirs)
	latexmk -outdir=aux -pdf $<

$(dirs) :
	mkdir -p $(dirs)

view : all
	evince $(pdf_out) &

clean : 
	rm -rf $(dirs)
