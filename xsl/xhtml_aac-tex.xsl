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

  <xsl:template match="/">
    <xsl:text>\documentclass{tex/senecasongs}&#xA;</xsl:text>
    
    <xsl:text>\addbibresource{</xsl:text>
    <xsl:value-of select="//xhtml:head/xhtml:meta[@name='bibliography']/@content" />
    <xsl:text>}&#xA;</xsl:text>

    <xsl:text>\setMainTitle{</xsl:text>
    <xsl:apply-templates select="//xhtml:body/xhtml:header/xhtml:h1[@class='maintitle']" />
    <xsl:text>}&#xA;</xsl:text>

    <xsl:text>\setSubTitle{</xsl:text>
    <xsl:apply-templates select="//xhtml:body/xhtml:header/xhtml:h1[@class='subtitle']" />
    <xsl:text>}&#xA;</xsl:text>

    <xsl:text>\setAuthor{</xsl:text>
    <xsl:apply-templates select="//xhtml:body/xhtml:header/xhtml:h2[@class='author']" />
    <xsl:text>}&#xA;</xsl:text>

    <xsl:text>\setPublisher{</xsl:text>
    <xsl:apply-templates select="//xhtml:head/xhtml:meta[@name='publisher']/@content" />
    <xsl:text>}&#xA;</xsl:text>

    <xsl:text>\setCopyright{</xsl:text>
    <xsl:apply-templates select="//xhtml:head/xhtml:meta[@name='copyright']/@content" />
    <xsl:text>}&#xA;</xsl:text>
    <!-- TODO CC license -->

    <!-- TODO cover image -->
    <xsl:text>\setCoverImage{</xsl:text>
    <xsl:value-of select="//xhtml:header/xhtml:img[@class='cover']/@src" />
    <xsl:text>}&#xA;</xsl:text>

    <xsl:text>\begin{document}&#xA;</xsl:text>

    <xsl:text>\frontmatter&#xA;</xsl:text>
    <xsl:text>\maketitle&#xA;</xsl:text>

    <xsl:if test="//aac:tableofcontents">
      <xsl:text>\tableofcontents&#xA;</xsl:text>
    </xsl:if>

    <xsl:text>\mainmatter&#xA;</xsl:text>
    <xsl:apply-templates select="//xhtml:main" />

    <xsl:if test="//xhtml:main/aac:bibliography">
      <xsl:text>\backmatter&#xA;</xsl:text>
      <xsl:text>\printbibliography&#xA;</xsl:text>
    </xsl:if>

    <xsl:text>\end{document}&#xA;</xsl:text>
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
  </xsl:template>

  <xsl:template match="xhtml:section[not(@class='chapter') and not(@class='part')]/xhtml:h1">
    <xsl:text>&#xA;\section{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>} \label{</xsl:text>
    <xsl:value-of select="../@id" />
    <xsl:text>}&#xA;</xsl:text>
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

  <xsl:template match="xhtml:strong">
    <xsl:text>\strong{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:strong[@class='TODO']">
    <xsl:text>\XXX[</xsl:text>
    <xsl:apply-templates />
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:a">
    <xsl:text>\href{</xsl:text>
    <xsl:value-of select="replace(@href, '#', '\\#')" />
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
    <xsl:text>\autocite</xsl:text>
    <xsl:call-template name="in-text-citation" />
  </xsl:template>
  
  <xsl:template match="aac:citationList">
    <xsl:text>\autocites</xsl:text>
    <xsl:for-each select="aac:citation">
      <xsl:call-template name="in-text-citation" />
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="in-text-citation">
    <xsl:if test="@pages"> <!-- TODO what about node text -->
      <xsl:text>[</xsl:text>
      <xsl:value-of select="concat(@pages, string())" />
      <xsl:text>]</xsl:text>
    </xsl:if>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="@key" />
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <!-- FLOATS -->


  <xsl:template match="aac:ref[@type='video']">
    <xsl:variable name="this-page-url" select="ancestor::*/@data-html-equiv" />
    <xsl:variable name="target" select="substring(@href, 2)" />
    <xsl:text>\href{</xsl:text>
    <xsl:value-of select="$this-page-url" />
    <xsl:text>/</xsl:text>
    <xsl:value-of select="replace(@href, '#', '\\#')" />
    <xsl:text>}{</xsl:text>
    <xsl:text>online video </xsl:text>
    <xsl:apply-templates select="//xhtml:figure[@class='video' and @id=$target]" mode="number" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='video']" mode="number">
    <xsl:number count="//xhtml:figure[@class='video']" level="any" />
  </xsl:template>
  
  <xsl:template match="aac:ref[@type='audio']">
    <xsl:variable name="this-page-url" select="ancestor::*/@data-html-equiv" />
    <xsl:variable name="target" select="substring(@href, 2)" />
    <xsl:text>\href{</xsl:text>
    <xsl:value-of select="$this-page-url" />
    <xsl:text>/</xsl:text>
    <xsl:value-of select="replace(@href, '#', '\\#')" />
    <xsl:text>}{</xsl:text>
    <xsl:text>online audio </xsl:text>
    <xsl:apply-templates select="//xhtml:figure[@class='audio' and @id=$target]" mode="number" />
    <xsl:text>}</xsl:text>
  </xsl:template>
 
  <xsl:template match="xhtml:figure[@class='audio']" mode="number">
    <xsl:number count="//xhtml:figure[@class='audio']" level="any" />
  </xsl:template>
  

  <xsl:template match="xhtml:figure[@class='video'] | xhtml:figure[@class='audio']">
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

  <!-- remove file extension for graphics files so web and pdf version can use different file types (e.g., svg for web and png or pdf for print) -->
  <xsl:template match="xhtml:img[not(@class='cover')]">
    <xsl:text>\includegraphics[width=\textwidth]{</xsl:text>
    <xsl:value-of select="substring-before(@src, '.')" />
      <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:caption | xhtml:figCaption">
    <xsl:text>\caption{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:table">
    <xsl:text>\begin{table}&#xA;</xsl:text>
    <xsl:apply-templates select="xhtml:caption" />
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="@id" />
    <xsl:text>}&#xA;</xsl:text>
    <xsl:text>\begin{center}&#xA;</xsl:text>
    <xsl:text>\begin{tabular}{</xsl:text>
    <xsl:for-each select="xhtml:thead/xhtml:tr[1]/xhtml:th"><xsl:text>l</xsl:text></xsl:for-each>
    <xsl:text>} \toprule&#xA;</xsl:text>
    <xsl:apply-templates select="xhtml:thead" />
    <xsl:apply-templates select="xhtml:tbody" />
    <xsl:text>\bottomrule&#xA;\end{tabular}&#xA;</xsl:text>
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
    <xsl:apply-templates />
    <xsl:text> \\&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:td | xhtml:th">
    <xsl:apply-templates />
    <xsl:if test="not(position()=last())">
      <xsl:text> &amp; </xsl:text>
    </xsl:if>
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
    <xsl:text>} </xsl:text>
  </xsl:template>

  <xsl:template match="aac:ref[@type='figure']">
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
    <xsl:text>} </xsl:text>
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
    <xsl:text>} </xsl:text>
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
    <xsl:text>$ </xsl:text>
  </xsl:template>

  <xsl:template match="aac:pitch">
    <xsl:value-of select="@pname" />
    <xsl:call-template name="accid">
      <xsl:with-param name="accid" select="@accid" />
    </xsl:call-template>
    <xsl:text>\textsubscript{</xsl:text>
    <xsl:value-of select="@oct" />
    <xsl:text>} </xsl:text>
  </xsl:template>

  <xsl:template name="accid">
    <xsl:param name="accid" />
    <xsl:choose>
      <xsl:when test="@accid='na'">
        <xsl:text>\na</xsl:text>
      </xsl:when>
      <xsl:when test="@accid='fl'">
        <xsl:text>\fl</xsl:text>
      </xsl:when>
      <xsl:when test="@accid='sh'">
        <xsl:text>\sh</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="aac:na">
    <xsl:text>\na</xsl:text>
  </xsl:template>

  <xsl:template match="aac:fl">
    <xsl:text>\fl</xsl:text>
  </xsl:template>
  
  <xsl:template match="aac:sh">
    <xsl:text>\sh</xsl:text>
  </xsl:template>

  <!-- MODULAR DESIGN (web vs. print) -->
  <xsl:template match="*[@data-medium='web']" priority="1" />

  <xsl:template match="xhtml:video" />

  <xsl:template match="xhtml:audio" /> 

  <xsl:template match="aac:youtube" />

  <xsl:template match="xhtml:div[@class='dialogue']">
    <xsl:text>\begin{dialogue}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{dialogue}&#xA;</xsl:text>
  </xsl:template>

  <!--
  <xsl:template match="xhtml:div[@class='dialogue']/xhtml:p">
    <xsl:text>\speech{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}&#xA;</xsl:text>
    </xsl:template>
  -->

    <xsl:template match="xhtml:div[@class='dialogue']//xhtml:span[@class='speaker']">
    <xsl:text>\speaker{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>} </xsl:text>
  </xsl:template>

</xsl:stylesheet>









