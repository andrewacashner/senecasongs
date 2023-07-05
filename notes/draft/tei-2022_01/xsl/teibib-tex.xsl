<?xml version="1.0" encoding="utf-8"?>
<!-- XSL transformation from TEI with custom bibliography extension to LaTeX

For Seneca Songs book

Andrew A. Cashner, 2022/12/12

Input is a TEI file that uses listBibl[@type='auto'] and bibl[@type='auto'] as placeholders for bibliography entries and citations, and convert to a LaTeX file using the same citation keys.
LaTeX does the rest of the bibliography processsing.

The LaTeX is written for the local TeX classes and packages (in the tex/ directory).
-->
<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  exclude-result-prefixes="tei">

  <xsl:output method="text" encoding="utf-8" indent="no" />

  <xsl:strip-space elements="*" />

  <!-- Convert newlines in XML input to spaces 
    (avoid spurious paragraph breaks) -->
  <xsl:template match="text()" priority="1">
    <xsl:variable name="newline">
      <xsl:value-of select="replace(., '&#10;', ' ')" />
    </xsl:variable>
    <xsl:variable name="space">
      <xsl:value-of select="replace($newline, '  ', ' ')" />
    </xsl:variable>
    <xsl:value-of select="$space" />
  </xsl:template>
 
  <xsl:template match="comment()" priority="1" />

  <!-- Shortcuts for TeX newlines and blank spaces (paragraph delimiters) -->
  <xsl:variable name="newline">
    <xsl:text>&#xA;</xsl:text>
  </xsl:variable>
  
  <xsl:variable name="par">
    <xsl:text>&#xA;&#xA;</xsl:text>
  </xsl:variable>

  <!-- Enclose `contents` in a TeX brace-delimited argument -->
  <xsl:template name="enbrace">
    <xsl:param name="contents" />
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$contents" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!-- Given a `csname` and `arg`, generate a command of the form 
    `\csname{arg}`; with no newline after -->
  <xsl:template name="tex-command-inline">
    <xsl:param name="csname" />
    <xsl:param name="arg" />
    <xsl:text>\</xsl:text>
    <xsl:value-of select="$csname" />
    <xsl:call-template name="enbrace">
      <xsl:with-param name="contents" select="$arg" />
    </xsl:call-template>
  </xsl:template>

  <!-- Generate a TeX command from `csname` and `arg` followed by a newline -->
  <xsl:template name="tex-command">
    <xsl:param name="csname" />
    <xsl:param name="arg" />
    <xsl:call-template name="tex-command-inline">
      <xsl:with-param name="csname" select="$csname" />
      <xsl:with-param name="arg" select="$arg" />
    </xsl:call-template>
    <xsl:value-of select="$newline" />
  </xsl:template>

  <!-- Main document structure
    - Use either custom book or article class depending on `tei:div` structure
    - The bibliography file must be given as the `@source` attribute of the `tei:listBibl`
    - 
  -->
  <xsl:template match="/">
    <xsl:variable name="title" select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title" />
    <xsl:variable name="titlePage" select="//tei:text/tei:front/tei:titlePage" />
    <xsl:variable name="body" select="//tei:text/tei:body" />
    <xsl:variable name="fileDesc" select="//tei:teiHeader/tei:fileDesc" />
    <xsl:variable name="bibliography" select="//tei:listBibl[@type='auto' and @subtype='biblio']" />
    <xsl:variable name="refList" select="//tei:div[@id='references']" />

    <xsl:choose>
      <xsl:when test="//tei:div[@type='chapter']">
        <xsl:text>\documentclass{tex/senecasongs-book}&#xA;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>\documentclass{tex/senecasongs-article}&#xA;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="bibresource">
      <xsl:with-param name="bibfile" select="$bibliography/@source" />
    </xsl:call-template>
    <xsl:call-template name="setupTitle">
      <xsl:with-param name="titlePage" select="$titlePage" />
      <xsl:with-param name="fileDesc" select="$fileDesc" />
    </xsl:call-template>
    <xsl:text>\begin{document}&#xA;</xsl:text>

    <xsl:if test="//tei:div[@type='chapter']">
      <xsl:text>\frontmatter&#xA;</xsl:text>
    </xsl:if>

    <xsl:text>\maketitle&#xA;</xsl:text>

    <xsl:if test="//tei:div1">
      <xsl:text>\tableofcontents&#xA;</xsl:text>
    </xsl:if>

    <xsl:apply-templates select="//tei:front/tei:div" />

    <xsl:if test="//tei:div[@type='chapter']">
      <xsl:text>\mainmatter&#xA;</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="$body" />
    
    <xsl:if test="//tei:div[@type='chapter']">
      <xsl:text>\backmatter&#xA;</xsl:text>
    </xsl:if>
    <xsl:text>\printbibliography</xsl:text>
    <xsl:if test="$refList">
      <xsl:text>[title={</xsl:text>
      <xsl:value-of select="$refList/tei:head" />
      <xsl:text>}]</xsl:text>
    </xsl:if>
    <xsl:text>&#xA;\end{document}</xsl:text>
  </xsl:template>

  <xsl:template name="makeTitlePage">
    <xsl:param name="titleData" />
  </xsl:template>

  <xsl:template name="bibresource">
    <xsl:param name="bibfile" />
    <xsl:if test="$bibfile">
      <xsl:call-template name="tex-command">
        <xsl:with-param name="csname">addbibresource</xsl:with-param>
        <xsl:with-param name="arg" select="$bibfile" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Create the commands used in the custom TeX classes to generate the title -->
  <xsl:template name="setupTitle">
    <xsl:param name="titlePage" />
    <xsl:param name="fileDesc" />

    <xsl:variable name="docTitle" select="$titlePage/tei:docTitle" />
    <xsl:variable name="maintitle" select="$docTitle/tei:titlePart[@type='main' or @type='']" />
    <xsl:variable name="subtitle" select="$docTitle/tei:titlePart[@type='sub']" />
    <xsl:variable name="author" select="$titlePage/tei:docAuthor" />
    <xsl:variable name="cover-image" select="$titlePage/tei:figure[@type='cover']" />

    <xsl:call-template name="tex-command">
      <xsl:with-param name="csname">setMainTitle</xsl:with-param>
      <xsl:with-param name="arg" select="$maintitle" />
    </xsl:call-template>
    <xsl:call-template name="tex-command">
      <xsl:with-param name="csname">setSubTitle</xsl:with-param>
      <xsl:with-param name="arg" select="$subtitle" />
    </xsl:call-template>
    <xsl:call-template name="tex-command">
      <xsl:with-param name="csname">setAuthor</xsl:with-param>
      <xsl:with-param name="arg">
        <xsl:value-of select="$author" separator=" and "/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="tex-command">
      <xsl:with-param name="csname">setPublisher</xsl:with-param>
      <xsl:with-param name="arg">
        <xsl:call-template name="publisher">
          <xsl:with-param name="fileDesc" select="$fileDesc" />
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="tex-command">
      <xsl:with-param name="csname">setCopyright</xsl:with-param>
      <xsl:with-param name="arg" select="$fileDesc/tei:publicationStmt/tei:availability" />
    </xsl:call-template>
    <xsl:if test="$cover-image">
      <xsl:call-template name="tex-command">
        <xsl:with-param name="csname">setCoverImage</xsl:with-param>
        <xsl:with-param name="arg" select="$cover-image/tei:graphic/@url" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="publisher">
    <xsl:param name="fileDesc" />
    <xsl:variable name="date" select="$fileDesc/tei:publicationStmt/tei:date/@when" />
    <xsl:variable name="title" select="$fileDesc/tei:titleStmt/tei:title" />
    <xsl:variable name="place" select="$fileDesc/tei:publicationStmt/tei:pubPlace" />
    <xsl:variable name="publisher" select="$fileDesc/tei:publicationStmt/tei:publisher" />
    <xsl:apply-templates select="$place" />
    <xsl:text>: </xsl:text>
    <xsl:apply-templates select="$publisher" />
    <xsl:text>, </xsl:text>
    <xsl:apply-templates select="$date" />
  </xsl:template>

  <!-- Keep track of original sectional elements in comments -->
  <xsl:template match="tei:div | tei:div1 | tei:div2 | tei:div3 | tei:div4">
    <xsl:text>% </xsl:text>
    <xsl:value-of select="name()" />
    <xsl:value-of select="$newline" />
    <xsl:apply-templates />
  </xsl:template>

  <!-- Section headings -->
  <xsl:template match="tei:div[@type='chapter']/tei:head">
    <xsl:call-template name="tex-command">
      <xsl:with-param name="csname">chapter</xsl:with-param>
      <xsl:with-param name="arg" select="." />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tei:div1/tei:head">
    <xsl:call-template name="tex-command">
      <xsl:with-param name="csname">section</xsl:with-param>
      <xsl:with-param name="arg" select="." />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tei:div2/tei:head">
    <xsl:call-template name="tex-command">
      <xsl:with-param name="csname">subsection</xsl:with-param>
      <xsl:with-param name="arg" select="." />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tei:div3/tei:head">
    <xsl:call-template name="tex-command">
      <xsl:with-param name="csname">subsubsection</xsl:with-param>
      <xsl:with-param name="arg" select="." />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tei:div4/tei:head">
    <xsl:call-template name="tex-command">
      <xsl:with-param name="csname">paragraph</xsl:with-param>
      <xsl:with-param name="arg" select="." />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tei:p">
    <xsl:value-of select="$par" />
    <xsl:apply-templates />
    <xsl:value-of select="$par" />
  </xsl:template>

  <!-- Inline semantic markup -->
  <xsl:template match="tei:title[@type='m' or @type='']">
    <xsl:call-template name="tex-command-inline">
      <xsl:with-param name="csname">wtitle</xsl:with-param>
      <xsl:with-param name="arg" select="." />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tei:title[@type='a']">
    <xsl:call-template name="tex-command-inline">
      <xsl:with-param name="csname">ptitle</xsl:with-param>
      <xsl:with-param name="arg" select="." />
    </xsl:call-template>
  </xsl:template>

  <!-- TODO mark language -->
  <xsl:template match="tei:foreign">
    <xsl:call-template name="tex-command-inline">
      <xsl:with-param name="csname">foreign</xsl:with-param>
      <xsl:with-param name="arg" select="." />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tei:mentioned">
    <xsl:call-template name="tex-command-inline">
      <xsl:with-param name="csname">mentioned</xsl:with-param>
      <xsl:with-param name="arg" select="." />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tei:q">
    <xsl:call-template name="tex-command-inline">
      <xsl:with-param name="csname">quoted</xsl:with-param>
      <xsl:with-param name="arg" select="." />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tei:hi">
    <xsl:call-template name="tex-command-inline">
      <xsl:with-param name="csname">strong</xsl:with-param>
      <xsl:with-param name="arg" select="." />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tei:hi[@type='TODO']">
    <xsl:text>\XXX[</xsl:text>
    <xsl:apply-templates />
    <xsl:text>]</xsl:text>
  </xsl:template>

  <!-- Cross references -->
  <xsl:template match="tei:ref[not(@type='auto') and not(@type='internal')]">
    <xsl:text>\href{</xsl:text>
    <xsl:value-of select="@target" />
    <xsl:text>}{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!-- Make internal links point to website. TODO true internal references with labels? --> 
  <xsl:template match="tei:ref[not(@type='auto') and @type='internal']">
    <xsl:text>\href{</xsl:text>
    <xsl:value-of select="concat('https://www.senecasongs.earth/', replace(@target, '.tei', '.html'))" />
    <xsl:text>}{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!-- Bibliography citations: Remove `#` from URL to get BibTeX key -->
  <xsl:template match="tei:ref[@type='auto']">
    <xsl:apply-templates />
    <xsl:text>~</xsl:text>
    <xsl:call-template name="tex-command-inline">
      <xsl:with-param name="csname">ref</xsl:with-param>
      <xsl:with-param name="arg" select="substring(@target, 2)" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tei:bibl[@type='auto']">
    <xsl:text> \Autocite</xsl:text>
    <xsl:if test="string()">
      <xsl:text>[</xsl:text>
      <xsl:apply-templates />
      <xsl:text>]</xsl:text>
    </xsl:if>
    <xsl:call-template name="citeKey" />
  </xsl:template>

  <xsl:template match="tei:listBibl[@type='auto' and @subtype='intext']">
    <xsl:text> \Autocites</xsl:text>
    <xsl:for-each select="tei:bibl">
      <xsl:call-template name="citeKey" />
    </xsl:for-each>
  </xsl:template>

  <!-- Citation key enclosed in braces as argument to `\Autocite` 
        - remove `#` from cross-ref URL 
  -->
  <xsl:template name="citeKey">
    <xsl:text>{</xsl:text>
    <xsl:value-of select="substring(@corresp, 2)" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!-- Lists -->
  <xsl:template match="tei:list[@rend='numbered']">
    <xsl:text>\begin{enumerate}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{enumerate}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="tei:list[@rend='bulleted']">
    <xsl:text>\begin{itemize}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{itemize}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="tei:item">
    <xsl:call-template name="tex-command">
      <xsl:with-param name="csname">item</xsl:with-param>
      <xsl:with-param name="arg">
        <xsl:apply-templates />
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Figures
        TODO add id as label
  -->
  <xsl:template match="tei:figure[not(@type='cover')]">
    <xsl:text>\begin{figure}&#xA;</xsl:text>
    <xsl:call-template name="tex-command">
      <xsl:with-param name="csname">includegraphics[width=\textwidth]</xsl:with-param>
      <xsl:with-param name="arg" select="tei:graphic/@url" />
    </xsl:call-template>
    <xsl:call-template name="tex-command">
      <xsl:with-param name="csname">caption</xsl:with-param>
      <xsl:with-param name="arg" select="tei:figDesc" />
    </xsl:call-template>
    <xsl:call-template name="tex-command">
      <xsl:with-param name="csname">label</xsl:with-param>
      <xsl:with-param name="arg" select="@xml:id" />
    </xsl:call-template>
    <xsl:text>\end{figure}&#xA;</xsl:text>
  </xsl:template>

  <!-- Tables
        TODO more complex tables require much more than this; or you could generate tables with TeX and just include graphics
  -->
  <xsl:template match="tei:table">
    <xsl:text>\begin{table}&#xA;</xsl:text>
    <xsl:call-template name="tex-command">
      <xsl:with-param name="csname">caption</xsl:with-param>
      <xsl:with-param name="arg">
        <xsl:apply-templates select="tei:head" />
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="tex-command">
      <xsl:with-param name="csname">label</xsl:with-param>
      <xsl:with-param name="arg">
        <xsl:value-of select="@xml:id" />
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>\begin{tabular}{</xsl:text>
    <xsl:for-each select="1 to @cols">l</xsl:for-each>
    <xsl:text>} \toprule&#xA;</xsl:text>
    <xsl:apply-templates select="tei:row" />
    <xsl:text>\bottomrule&#xA;\end{tabular}&#xA;</xsl:text>
    <xsl:text>\end{table}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="tei:row">
    <xsl:apply-templates />
    <xsl:text> \\</xsl:text>
    <xsl:value-of select="$newline" />
  </xsl:template>

  <xsl:template match="tei:cell">
    <xsl:apply-templates />
    <xsl:if test="not(position()=last())">
      <xsl:text> &amp; </xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
