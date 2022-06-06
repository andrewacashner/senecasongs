<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:bltx="http://biblatex-biber.sourceforge.net/biblatexml"
  exclude-result-prefixes="bltx">

  <xsl:template match="text()">
    <xsl:variable name="string">
      <xsl:value-of select="string()" />
    </xsl:variable>
    <xsl:variable name="lettered">
      <xsl:call-template name="expand-tex-letter-macros">
        <xsl:with-param name="string" select="$string" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="quoted">
      <xsl:call-template name="expand-mkbibquote">
        <xsl:with-param name="string" select="$lettered" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="emphasized">
      <xsl:call-template name="expand-mkbibemph">
        <xsl:with-param name="string" select="$quoted" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="parenthesized">
      <xsl:call-template name="expand-mkbibparens">
        <xsl:with-param name="string" select="$emphasized" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="debraced">
      <xsl:call-template name="remove-tex-braces">
        <xsl:with-param name="string" select="$parenthesized" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="deslashed">
      <xsl:call-template name="remove-tex-backslashes">
        <xsl:with-param name="string" select="$debraced" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:copy-of select="$deslashed" />
  </xsl:template>

  <xsl:template name="expand-tex-letter-macros">
    <xsl:param name="string" />
    <xsl:variable name="em-dashes">
      <xsl:value-of select="replace($string, '---', '—')" />
    </xsl:variable>
    <xsl:variable name="en-dashes">
      <xsl:value-of select="replace($em-dashes, '--', '–')" />
    </xsl:variable>
    <xsl:variable name="apostrophes">
      <xsl:value-of select="replace($en-dashes, '''', '’')" />
    </xsl:variable>
    <xsl:value-of select="$apostrophes" />
  </xsl:template>

  <xsl:variable name="within-braces">\{([^\}]*)\}</xsl:variable>

  <xsl:template name="expand-mkbibquote">
    <xsl:param name="string" />
    <xsl:analyze-string select="$string" regex="(.*)\\mkbibquote{$within-braces}(.*)"> 
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(1)" />
        <q><xsl:value-of select="regex-group(2)" /></q>
        <xsl:value-of select="regex-group(3)" />
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:copy-of select="$string" />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template name="expand-mkbibemph">
    <xsl:param name="string" />
    <xsl:analyze-string select="$string" regex="(.*)\\mkbibemph{$within-braces}(.*)">
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(1)" />
        <emph><xsl:value-of select="regex-group(2)" /></emph>
        <xsl:value-of select="regex-group(3)" />
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:copy-of select="$string" />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template name="expand-mkbibparens">
    <xsl:param name="string" />
    <xsl:analyze-string select="$string" regex="(.*)\\mkbibparens{$within-braces}(.*)">
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(1)" />
        <xsl:text>(</xsl:text>
        <xsl:value-of select="regex-group(2)" />
        <xsl:text>)</xsl:text>
        <xsl:value-of select="regex-group(3)" />
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:copy-of select="$string" />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template name="remove-tex-braces">
    <xsl:param name="string" />
    <xsl:analyze-string select="$string" regex="(.*){$within-braces}(.*)">
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(1)" />
        <xsl:value-of select="regex-group(2)" />
        <xsl:value-of select="regex-group(3)" />
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:copy-of select="$string" />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template name="remove-tex-backslashes">
    <xsl:param name="string" />
    <xsl:analyze-string select="$string" regex="(.*)\\(.*)">
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(1)" />
        <xsl:value-of select="regex-group(2)" />
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:copy-of select="$string" />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

</xsl:stylesheet>
