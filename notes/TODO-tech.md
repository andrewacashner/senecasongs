(Last updated 2023/02/14)

- (DONE) create Makefile

- version number and plan

# Font

- Apple Books font rendering issue
- EB Garamond Medium necessary in music?
- lilyglyphs?
- lyluatex?

# Title and frontmatter

- PDF title page fonts confirm
- Copyright page better code, layout

# Content
- glossary
- Seneca words pronounced on click
- chapter titles vs section titles vs web-page titles
- tables of contents on each page?

# XML
- AAC namespace (TEIBIB)
    - (DONE) Create aac.xsd
    - (X, DONE in HTML) Automatic table, figure reference numbers in TEI (and thence HTML)
        - Is it desirable to have the numbers hard-coded in the TEI?
- (DONE) Replace TEI with XHTML (2023/02/14)

## Bibliography (for HTML conversion only)
- (DONE) convert biblatexml to TEI
- (DONE) select only cited entries and include in document
- (DONE) pull out label strings and insert in citations
- (DONE) replace TEI workflow with XHTML, pulling in and converting biblatexml
  (2023/02/14)

# To HTML
- (DONE) cover image alt text and/or caption
- (X) colophon text: include from file rather than putting it directly in XSL
    - also, use it in LaTeX somewhere
- footer citation: 
    - should be '"Page Name" in *Book Name*'
    - no period after titles ending with questions
- docAuthor separated by commas after "Sr."
    - in TEI: one docAuthor field ("Author A and Author B") or two?
- (DONE) Add cover images to HTML in XHTML workflow
- Decide how to handle video, audio elements in book
- cover image alt text vs. title (visible on hover) - where to put caption or
  credit (footer?)

## CSS
- (DONE) create CSS for HTML
- Make author less prominent
- Why is index page smaller scaled than rest?

# To LaTeX
- (DONE) create tei-tex.xsl
- (DONE) create LaTeX class
- complex tables with styling (also to HTML)
- Make PDFs for individual site pages?

## Book
- Create true internal references with labels?
- (DONE) frontmatter, mainmatter, backmatter
- cover images  (DONE for front cover)

# Bibliography
- Author names in parenthesis
- Successive citations of same author (combine into one citation with
  years in date order)
- Handling of "Jr." in both TeX and TEI
    - the main issue is how BibLaTeX input should be written
    - and consistency between TeX and TEI-bib bib treatment
- Trailing punctuation with `<q>`, including in bibliographies (or break with
  Chicago style)
- page range: can we have free range like "1-4, 5, 19-20" or must everything
  use @start and @end? (free is ok, DONE 2023/02/14)

# Media
- Where to store media files if not in Git repository?
- How to back them up?
