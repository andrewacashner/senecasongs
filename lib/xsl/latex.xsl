<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  version="2.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:aac="https://www.senecasongs.earth">

  <xsl:output method="text" encoding="utf-8" indent="no" />
  
  <xsl:strip-space elements="*" />

  <!-- Convert newlines in XML input to spaces 
    (avoid spurious paragraph breaks) -->
  <xsl:template match="text()">
    <xsl:variable name="newline">
      <xsl:value-of select="replace(., '&#10;', ' ')" />
    </xsl:variable>
    <xsl:variable name="space">
      <xsl:value-of select="replace($newline, '  ', ' ')" />
    </xsl:variable>
    <xsl:value-of select="$space" />
  </xsl:template>
 
  <xsl:template match="comment()" priority="1" />
  <xsl:template match="aac:comment" />

  <xsl:template match="/">
    <xsl:text>\documentclass{lib/tex/senecasongs}&#xA;</xsl:text>
    
    <xsl:text>\addbibresource{</xsl:text>
    <xsl:value-of select="//xhtml:head/xhtml:meta[@name='bibliography']/@content" />
    <xsl:text>}&#xA;</xsl:text>

    <xsl:text>\setMainTitle{</xsl:text>
    <xsl:apply-templates select="//xhtml:body/xhtml:header/xhtml:h1[@class='maintitle']" />
    <xsl:text>}&#xA;</xsl:text>

    <xsl:text>\setSubTitle{</xsl:text>
    <xsl:apply-templates select="//xhtml:body/xhtml:header/xhtml:h1[@class='subtitle']" />
    <xsl:text>}&#xA;</xsl:text>
    
    <xsl:if test="//xhtml:meta[@name='availability' and @content='draft']">
      <xsl:text>\drafttrue&#xA;</xsl:text>
    </xsl:if>

    <xsl:text>\setAuthor{</xsl:text>
    <xsl:apply-templates select="//xhtml:body/xhtml:header/xhtml:h2[@class='author']" />
    <xsl:text>}&#xA;</xsl:text>

    <xsl:text>\setLocation{</xsl:text>
    <xsl:apply-templates select="//xhtml:head/xhtml:meta[@name='location']/@content" />
    <xsl:text>}&#xA;</xsl:text>
 
    <xsl:text>\setPublisher{</xsl:text>
    <xsl:apply-templates select="//xhtml:head/xhtml:meta[@name='publisher']/@content" />
    <xsl:text>}&#xA;</xsl:text>

    <xsl:text>\setYear{</xsl:text>
    <xsl:apply-templates select="//xhtml:head/xhtml:meta[@name='year']/@content" />
    <xsl:text>}&#xA;</xsl:text>

    <xsl:text>\setCopyright{</xsl:text>
    <xsl:variable name="version" select="//xhtml:meta[@name='version']/@content" />
    <xsl:if test="$version">
      <xsl:value-of select="$version" />
      <xsl:text>.\\</xsl:text>
    </xsl:if>
    <xsl:value-of select="//xhtml:head/xhtml:meta[@name='copyright']/@content" />
    <xsl:text>. </xsl:text>
    <xsl:if test="//xhtml:meta[@name='license' and @content='CC-BY-NC-ND']">
      <xsl:text>\CClicense</xsl:text>
    </xsl:if>
    <xsl:text>}&#xA;</xsl:text>

    <xsl:text>\setCoverImage{</xsl:text>
    <xsl:value-of select="//xhtml:header/xhtml:img[@class='cover']/@src" />
    <xsl:text>}&#xA;</xsl:text>

    <xsl:text>\begin{document}&#xA;</xsl:text>

    <xsl:apply-templates select="//xhtml:main" />


    <xsl:text>\end{document}&#xA;</xsl:text>
  </xsl:template>
  
  <xsl:template match="xhtml:section[@class='frontmatter']">
      <xsl:text>\frontmatter&#xA;</xsl:text>
      <xsl:apply-templates />
      <xsl:text>\mainmatter&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="aac:titlepages">
    <xsl:text>\maketitle&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="aac:tableofcontents">
    <xsl:text>\tableofcontents&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:meta[@name='version']">
    <xsl:text>\begin{center}</xsl:text>
    <xsl:text>Version </xsl:text>
    <xsl:value-of select="@content" />
    <xsl:if test="//xhtml:meta[@name='updated']">
      <xsl:text> (</xsl:text>
      <xsl:value-of select="//xhtml:meta[@name='updated']/@content" />
      <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:text>\end{center}\vspace{2em}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:article">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="xhtml:section[@class='part']/xhtml:h1">
    <xsl:text>&#xA;\part{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>} \label{</xsl:text>
    <xsl:value-of select="../@id" />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:section[@class='chapter']/xhtml:h1">
    <xsl:text>&#xA;\chapter{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>} \label{</xsl:text>
    <xsl:value-of select="../@id" />
    <xsl:text>}&#xA;</xsl:text>
    <xsl:if test="../@data-html-equiv">
      <xsl:call-template name="web-equiv-link">
        <xsl:with-param name="url" select="../@data-html-equiv" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="xhtml:section[not(@class='chapter') and not(@class='part')]/xhtml:h1">
    <xsl:text>&#xA;\section{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>} \label{</xsl:text>
    <xsl:value-of select="../@id" />
    <xsl:text>}&#xA;</xsl:text>
    <xsl:if test="../@data-html-equiv">
      <xsl:call-template name="web-equiv-link">
        <xsl:with-param name="url" select="../@data-html-equiv" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="xhtml:section[@class='backmatter']">
    <xsl:text>\backmatter&#xA;</xsl:text>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="aac:bibliography">
    <xsl:text>\aacReferences&#xA;</xsl:text>
  </xsl:template>

  <xsl:template name="web-equiv-link">
    <xsl:param name="url" />
    <xsl:text>\MediaCallout{</xsl:text>
    <xsl:value-of select="$url" />
    <xsl:text>}{</xsl:text>
    <xsl:text>\WebEquivIcon</xsl:text>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:section/xhtml:h2">
    <xsl:text>\subsection{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>} \label{</xsl:text>
    <xsl:value-of select="../@id" />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:section/xhtml:h3">
    <xsl:text>\subsubsection{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>} \label{</xsl:text>
    <xsl:value-of select="../@id" />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:section/xhtml:h4">
    <xsl:text>\paragraph{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>} \label{</xsl:text>
    <xsl:value-of select="../@id" />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:p">
    <xsl:text>&#xA;</xsl:text>
    <xsl:if test="@class='continue'">
      <xsl:text>\noindent </xsl:text>
    </xsl:if>
    <xsl:apply-templates />
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:em">
    <xsl:text>\emph{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:cite">
    <xsl:text>\wtitle{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <xsl:template match="xhtml:q">
    <xsl:text>\quoted{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:blockquote">
    <xsl:text>\begin{quotation}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{quotation}&#xA;</xsl:text>
  </xsl:template>

  <!-- TODO keep any bold in print version? -->
  <xsl:template match="xhtml:strong">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="xhtml:strong[@class='TODO']">
    <xsl:text>\XXX[</xsl:text>
    <xsl:apply-templates />
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:a">
    <xsl:text>\href{</xsl:text>
    <xsl:value-of select="replace(replace(@href, '#', '\\#'), '%', '\\%')" />
    <xsl:text>}{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:ol">
    <xsl:text>\begin{enumerate}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{enumerate}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:ul">
    <xsl:text>\begin{itemize}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{itemize}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:li">
    <xsl:text>\item{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <!-- CITATIONS -->
  <xsl:template match="aac:citation">
    <xsl:text> \autocite</xsl:text>
    <xsl:call-template name="in-text-citation" />
  </xsl:template>
  
  <xsl:template match="aac:citationList">
    <xsl:text> \autocites</xsl:text>
    <xsl:for-each select="aac:citation">
      <xsl:call-template name="in-text-citation" />
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="in-text-citation">
    <xsl:if test="@pre">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="@pre" />
      <xsl:text>]</xsl:text>
    </xsl:if>
    <xsl:if test="@pages or string()"> 
      <xsl:text>[</xsl:text>
      <xsl:if test="@pages"> 
        <xsl:value-of select="@pages" />
      </xsl:if>
      <xsl:if test="string()">
        <xsl:apply-templates />
      </xsl:if>
      <xsl:text>]</xsl:text>
    </xsl:if>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="@key" />
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <!-- FLOATS -->

  <xsl:variable name="book-media-url">
    <xsl:text>https://www.senecasongs.earth/book-media.html</xsl:text>
  </xsl:variable>
  
  <xsl:template match="aac:ref[@type='video']">
    <!--
      <xsl:variable name="this-page-url" select="ancestor::xhtml:section[@data-html-equiv][1]/@data-html-equiv" />
    -->
      <xsl:variable name="target" select="substring(@href, 2)" />
      <xsl:text>\MediaCallout{</xsl:text>
      <xsl:value-of select="$book-media-url" />
      <xsl:value-of select="replace(@href, '#', '\\#')" />
      <xsl:text>}{</xsl:text>
      <xsl:text>\VideoIcon\ </xsl:text>
      <xsl:apply-templates select="//xhtml:figure[@class='video' and @id=$target and not(@data-medium='no-book')]" mode="number" />
      <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='video']" mode="number">
    <xsl:number count="//xhtml:section[@class='chapter']" level="any"/>
    <xsl:text>.</xsl:text>
    <xsl:number count="//xhtml:figure[@class='video']" from="xhtml:article" level="any" />
  </xsl:template>
  
  <xsl:template match="aac:ref[@type='audio']">
    <!--
    <xsl:variable name="this-page-url" select="ancestor::xhtml:section[@data-html-equiv][1]/@data-html-equiv" />
    -->
    <xsl:variable name="target" select="substring(@href, 2)" />
    <xsl:text>\MediaCallout{</xsl:text>
    <xsl:value-of select="$book-media-url" />
    <xsl:value-of select="replace(@href, '#', '\\#')" />
    <xsl:text>}{</xsl:text>
    <xsl:text>\AudioIcon\ </xsl:text>
    <xsl:apply-templates select="//xhtml:figure[@class='audio' and @id=$target]" mode="number" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='audio']" mode="number">
    <xsl:number count="//xhtml:section[@class='chapter']" level="any"/>
    <xsl:text>.</xsl:text>
    <xsl:number count="//xhtml:figure[@class='audio']" from="xhtml:article" level="any" />
  </xsl:template>

  <xsl:template match="*[@data-medium='no-book'] | xhtml:figure[@class='video'] | xhtml:figure[@class='audio']">
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='music']">
    <xsl:text>\begin{example}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="@id" />
    <xsl:text>}&#xA;</xsl:text>
    <xsl:text>\end{example}&#xA;</xsl:text>
  </xsl:template>
  
  <xsl:template match="xhtml:figure[@class='diagram']">
    <xsl:text>\begin{diagram}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="@id" />
    <xsl:text>}&#xA;</xsl:text>
    <xsl:text>\end{diagram}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='image']">
    <xsl:text>\begin{figure}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="@id" />
    <xsl:text>}&#xA;</xsl:text>
    <xsl:text>\end{figure}&#xA;</xsl:text>
  </xsl:template>

  <xsl:function name="aac:media-filename">
    <xsl:param name="filename" />
    <xsl:value-of select="substring-after(substring-before($filename, '.'), 'media/')" />
  </xsl:function>

  <!-- remove file extension for graphics files so web and pdf version can use different file types (e.g., svg for web and png or pdf for print) -->
  <xsl:template match="xhtml:img[not(@class='cover') and not(@class='inline')]">
    <xsl:choose>
      <xsl:when test="@data-width='narrow'">
        <xsl:text>\includegraphics[width=\NarrowImageWidth]{</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>\includegraphics[width=\textwidth]{</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="aac:media-filename(@src)" />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:img[@class='inline']">
    <xsl:text>\inlinegraphics{</xsl:text>
    <xsl:value-of select="aac:media-filename(@src)" />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="aac:inlineMusic">
    <xsl:variable name="scale-factor">
      <xsl:choose>
        <xsl:when test="@type='staff' or @type='rhythm-threelines'">3</xsl:when>
        <xsl:when test="@type='rhythm-lyrics' or @type='rhythm-twolines'">2</xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:text>\inlinegraphics</xsl:text>
    <xsl:if test="not($scale-factor=1)">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="$scale-factor" />
      <xsl:text>]</xsl:text>
    </xsl:if>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="aac:media-filename(@src)" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='chapter-cover']">
    <xsl:text>\begin{coverImage}&#xA;</xsl:text>
    <xsl:apply-templates mode="chapter-cover"/>
    <xsl:text>\end{coverImage}&#xA;&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='chapter-cover']/xhtml:img" mode="chapter-cover">
    <xsl:text>\includeCoverImage{</xsl:text>
    <xsl:value-of select="@src" />
    <xsl:text>}&#xA;&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='chapter-cover']/xhtml:figCaption" mode="chapter-cover">
    <xsl:text>\coverImageCaption{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <!-- no indent after chapter cover image -->
  <xsl:template match="xhtml:article[preceding-sibling::xhtml:figure[@class='cover']]/xhtml:section[1]/xhtml:p[1]">
    <xsl:text>\noindent </xsl:text>
    <xsl:apply-templates />
    <xsl:text>&#xA;&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:caption | xhtml:figCaption">
    <xsl:text>\caption{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <!-- you can use @data-cols="lll" (for example) to specify TeX tabular columns or it will automatically create a column specification from the table header row (all left aligned) -->
  <xsl:template match="xhtml:table[not(@class='simple' or @class='pitch_matrix')]">

    <xsl:variable name="colspec">
      <xsl:text>{</xsl:text>
      <xsl:choose>
        <xsl:when test="@data-cols">
          <xsl:value-of select="@data-cols" />
        </xsl:when>
        <xsl:when test="xhtml:thead/xhtml:tr/xhtml:th[@scope='col']">
          <xsl:for-each select="xhtml:thead/xhtml:tr[1]/xhtml:th[@scope='col']">
            <xsl:text>l</xsl:text>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="xhtml:tbody/xhtml:tr[1]/xhtml:td | xhtml:tbody/xhtml:tr[1]/xhtml:th">
            <xsl:text>l</xsl:text>
          </xsl:for-each>
      </xsl:otherwise>
      </xsl:choose>
      <xsl:text>}</xsl:text>
    </xsl:variable>

    <xsl:variable name="tabular-begin-env">
      <xsl:choose>
        <xsl:when test="contains(@data-cols, 'X')">
          <xsl:text>\begin{tabularx}{\textwidth}</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>\begin{tabular}</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="tabular-end-env">
      <xsl:choose>
        <xsl:when test="contains(@data-cols, 'X')">
          <xsl:text>\end{tabularx}&#xA;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>\end{tabular}&#xA;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>


    <xsl:text>\begin{table}&#xA;</xsl:text>
    <xsl:apply-templates select="xhtml:caption" />
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="@id" />
    <xsl:text>}&#xA;</xsl:text>
    <xsl:text>\begin{center}&#xA;</xsl:text>
    <xsl:copy-of select="$tabular-begin-env" />
    <xsl:copy-of select="$colspec" />
    <xsl:text>\toprule&#xA;</xsl:text>
    <xsl:apply-templates select="xhtml:thead" />
    <xsl:apply-templates select="xhtml:tbody" />
    <xsl:text>\bottomrule&#xA;</xsl:text>
    <xsl:copy-of select="$tabular-end-env" />
    <xsl:text>\end{center}&#xA;</xsl:text>
    <xsl:text>\end{table}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:thead">
    <xsl:apply-templates />
    <xsl:text>\midrule&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:tbody">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="xhtml:tr">
    <xsl:if test="@class='line-above'">
      <xsl:text>\midrule </xsl:text>
    </xsl:if>
    <xsl:apply-templates />
    <xsl:text> \\&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:td | xhtml:th">
    <xsl:apply-templates />
    <xsl:if test="following-sibling::*">
      <xsl:text> &amp; </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="xhtml:th[@scope='row']">
    <xsl:text>\strong{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>} </xsl:text>
    <xsl:if test="following-sibling::*">
      <xsl:text>&amp; </xsl:text>
    </xsl:if>
  </xsl:template>


  <xsl:template match="xhtml:table[@class='simple']">
    <xsl:text>\begin{tabular}[t]{</xsl:text>
    <xsl:value-of select="@data-cols" />
    <xsl:text>}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{tabular}&#xA;</xsl:text>
  </xsl:template>


  <xsl:template match="xhtml:table[@class='pitch_matrix']">
    <xsl:text>\begin{table}&#xA;</xsl:text>
    <xsl:apply-templates select="xhtml:caption" />
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="@id" />
    <xsl:text>}&#xA;</xsl:text>
    <xsl:text>\footnotesize&#xA;</xsl:text>
    <xsl:text>\begin{center}&#xA;</xsl:text>
    <xsl:apply-templates select="aac:pitch_matrix" />
    <xsl:text>\end{center}&#xA;</xsl:text>
    <xsl:text>\end{table}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="aac:pitch_matrix">
    <xsl:text>\begin{pitchMatrix}{</xsl:text>
    <xsl:value-of select="aac:replace-accidentals(replace(@gamut, ' ', ', '))" />
    <xsl:text>}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{pitchMatrix}&#xA;</xsl:text>
  </xsl:template>

  <xsl:function name="aac:replace-accidentals">
    <xsl:param name="input" />
    <xsl:variable name="flat" select="replace($input, '♭', '\\fl{}')" />
    <xsl:variable name="sharp" select="replace($flat, '♯', '\\sh{}')" />
    <xsl:variable name="natural" select="replace($sharp, '♮', '\\na{}')" />
    <xsl:value-of select="$natural" />
  </xsl:function>

  <xsl:template match="aac:mrow">
    <xsl:text>\pcset{</xsl:text>
    <xsl:value-of select="@n" />
    <xsl:text>}{</xsl:text>
    <xsl:value-of select="replace(@pcset, ' ', ', ')" />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:tr[@class='two-row']">
    <xsl:text>\begin{tabular}{</xsl:text>
    <xsl:for-each select="xhtml:td[@class='seneca']/xhtml:span">
      <xsl:text>l</xsl:text>
    </xsl:for-each>
    <xsl:text>}&#xA;</xsl:text>
    <xsl:for-each select="xhtml:td[@class='seneca']">
      <xsl:for-each select="xhtml:span">
        <xsl:text>\strong{</xsl:text>
        <xsl:apply-templates />
        <xsl:text>}</xsl:text>
        <xsl:if test="not(position() = last())">
          <xsl:text> &amp; </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text> \\&#xA;</xsl:text>
    </xsl:for-each>
    <xsl:for-each select="xhtml:td[@class='english']">
      <xsl:for-each select="xhtml:span">
        <xsl:apply-templates />
        <xsl:if test="not(position() = last())">
          <xsl:text> &amp; </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text> \\[1ex]&#xA;</xsl:text>
    </xsl:for-each>
    <xsl:text>\end{tabular} \\&#xA;</xsl:text>
  </xsl:template>

  <!-- CROSS-REFERENCES -->
  <xsl:template match="aac:ref[@type='table']">
    <xsl:choose>
      <xsl:when test="string()">
        <xsl:apply-templates />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>table</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> \ref{</xsl:text>
    <xsl:value-of select="substring(@href, 2)" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="aac:ref[@type='image']">
    <xsl:choose>
      <xsl:when test="string()">
        <xsl:apply-templates />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>figure</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> \ref{</xsl:text>
    <xsl:value-of select="substring(@href, 2)" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="aac:ref[@type='music']">
    <xsl:choose>
      <xsl:when test="string()">
        <xsl:apply-templates />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>example</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> \ref{</xsl:text>
    <xsl:value-of select="substring(@href, 2)" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="aac:ref[@type='diagram']">
    <xsl:choose>
      <xsl:when test="string()">
        <xsl:apply-templates />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>diagram</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> \ref{</xsl:text>
    <xsl:value-of select="substring(@href, 2)" />
    <xsl:text>} </xsl:text>
  </xsl:template>

  <!-- SPECIAL CHARACTERS and FORMATTED EXPRESSIONS -->
  <xsl:template match="aac:pcset">
    <xsl:text>\code{/</xsl:text>
    <xsl:value-of select="@n" />
    <xsl:text>/} </xsl:text>
  </xsl:template>

  <xsl:template match="aac:degree">
    <xsl:call-template name="accid">
      <xsl:with-param name="accid" select="@accid" />
    </xsl:call-template>
    <xsl:text>$\hat </xsl:text>
    <xsl:value-of select="@n" />
    <xsl:text>$</xsl:text>
  </xsl:template>

  <xsl:template match="aac:pitch">
    <xsl:text>\pitch{</xsl:text>
    <xsl:value-of select="@pname" />
    <xsl:text>}</xsl:text>
    <xsl:if test="@accid">
      <xsl:text>[</xsl:text>
      <xsl:call-template name="accid">
        <xsl:with-param name="accid" select="@accid" />
      </xsl:call-template>
    </xsl:if>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="@oct" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template name="accid">
    <xsl:param name="accid" />
    <xsl:choose>
      <xsl:when test="@accid='na'">
        <xsl:call-template name="natural" />
      </xsl:when>
      <xsl:when test="@accid='fl'">
        <xsl:call-template name="flat" />
      </xsl:when>
      <xsl:when test="@accid='sh'">
        <xsl:call-template name="sharp" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="natural" match="aac:na">
    <xsl:text>\na{}</xsl:text>
  </xsl:template>

  <xsl:template name="flat" match="aac:fl">
    <xsl:text>\fl{}</xsl:text>
  </xsl:template>
  
  <xsl:template name="sharp" match="aac:sh">
    <xsl:text>\sh{}</xsl:text>
  </xsl:template>

  <xsl:template match="aac:ampersand">
    <xsl:text>\&amp;{}</xsl:text>
  </xsl:template>

  <!-- MODULAR DESIGN (web vs. print) -->
  <xsl:template match="*[@data-medium='web']" priority="1" />

  <xsl:template match="xhtml:video" />

  <xsl:template match="xhtml:audio" /> 

  <xsl:template match="aac:youtube" />

  <xsl:template match="xhtml:blockquote[@class='dialogue']">
    <xsl:text>\begin{dialogue}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{dialogue}&#xA;</xsl:text>
  </xsl:template>

    <xsl:template match="xhtml:blockquote[@class='dialogue']//xhtml:span[@class='speaker']">
    <xsl:text>\speaker{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>} </xsl:text>
  </xsl:template>

  <xsl:template match="aac:usd">
    <xsl:text>\$</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:span[@class='ipa']">
    <xsl:text>\ipa{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

    <xsl:template match="xhtml:div[@class='figure-group']">
    <xsl:text>\begin{figureGroup}</xsl:text>
    <xsl:apply-templates select="xhtml:figure[1]/xhtml:figCaption" mode="figuregroup" />
    <xsl:apply-templates select="xhtml:figure" mode="figuregroup"/>
    <xsl:text>\end{figureGroup}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='image']/xhtml:figCaption" mode="figuregroup">
    <xsl:text>\captionof{figure}{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="../@id" />
    <xsl:text>}</xsl:text>
  </xsl:template>


  <xsl:template match="xhtml:figure[@class='music']/xhtml:figCaption" mode="figuregroup">
    <xsl:text>\captionof{example}{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="../@id" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:figure" mode="figuregroup">
    <xsl:apply-templates select="xhtml:img" />
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>
  


  <xsl:template match="aac:prime">
    <xsl:text>$'$</xsl:text>
  </xsl:template>

  <xsl:template match="aac:repeat">
    <xsl:text>\music{}</xsl:text> <!-- U+E040, start repeat -->
    <xsl:apply-templates />
    <xsl:text>\music{}</xsl:text> <!-- U+E041, end repeat -->
  </xsl:template>


  <!-- Optional markup for parentheses, usable anywhere, but parentheses will be omitted if the contents are audio/video refs (since these are omitted from body text in the book) -->
  <xsl:template match="aac:paren">
    <xsl:choose>
      <xsl:when test="descendant::aac:ref[@type='audio' or @type='video']">
        <xsl:apply-templates />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>(</xsl:text>
        <xsl:apply-templates />
        <xsl:text>)</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Remove trailing space before removed audio-visual refs -->
  <xsl:function name="aac:trim-trailing-space">
    <xsl:param name="str" />
    <xsl:value-of select="replace(substring($str, 1, string-length($str) - 1), '\s+ $', '')" />
  </xsl:function>

  <xsl:template match="text()[following-sibling::aac:paren[descendant::aac:ref[@type='video' or @type='audio']]]">
    <xsl:value-of select="aac:trim-trailing-space(.)" />
  </xsl:template>

  <xsl:template match="aac:dots">
    <xsl:text>\Dots{}</xsl:text>
  </xsl:template>

  <xsl:template match="aac:TODO">
    <xsl:text>\todoFlag{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
    <xsl:apply-templates select="@*" />
  </xsl:template>

  <xsl:template match="@note">
    <xsl:text>\todoNote{</xsl:text>
    <xsl:value-of select="." />
    <xsl:text>} </xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:br">
    <xsl:text>\\ &#xA;</xsl:text>
  </xsl:template>


</xsl:stylesheet>

