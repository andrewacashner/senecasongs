(2022/05/10)

- (DONE) create Makefile

# To TEI
## AAC namespace
- Create aac.xsd

## Bibliography (for HTML conversion only)
- convert biblatexml to TEI
- select only cited entries and include in document
- pull out label strings and insert in citations

# To HTML
- create CSS for HTML

# To LaTeX
- (DONE) create tei-tex.xsl
- (DONE) create LaTeX class

## Book
- Create true internal references with labels?
- frontmatter, mainmatter, backmatter


# Bibliography
- Deal with handling of "Jr." in both TeX and TEI
    - the main issue is how BibLaTeX input should be written
    - and consistency between TeX and TEI-bib bib treatment
- Trailing punctuation with `<q>`, including in bibliographies (or break with
  Chicago style)
