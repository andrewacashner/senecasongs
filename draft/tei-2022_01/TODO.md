(Last updated 2022/12/13)

- (DONE) create Makefile

- version number and plan

# Content
- glossary
- Seneca words pronounced on click
- chapter titles vs section titles vs web-page titles
- tables of contents on each page?

# To TEI
## AAC namespace (TEIBIB)
- (DONE) Create aac.xsd
- (X, DONE in HTML) Automatic table, figure reference numbers in TEI (and thence HTML)
    - Is it desirable to have the numbers hard-coded in the TEI?

## Bibliography (for HTML conversion only)
- (DONE) convert biblatexml to TEI
- (DONE) select only cited entries and include in document
- (DONE) pull out label strings and insert in citations

# To HTML
- (DONE) cover image alt text and/or caption
- (X) colophon text: include from file rather than putting it directly in XSL
    - also, use it in LaTeX somewhere
- footer citation: 
    - should be '"Page Name" in *Book Name*'
    - no period after titles ending with questions
- docAuthor separated by commas after "Sr."
    - in TEI: one docAuthor field ("Author A and Author B") or two?
## CSS
- (DONE) create CSS for HTML
- Make author less prominent
- Why is index page smaller scaled than rest?

# To LaTeX
- (DONE) create tei-tex.xsl
- (DONE) create LaTeX class
- complex tables with styling (also to HTML)

## Book
- Create true internal references with labels?
- (DONE) frontmatter, mainmatter, backmatter
- cover images 


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
  use @start and @end?
