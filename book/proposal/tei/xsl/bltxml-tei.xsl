<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:bltx="http://biblatex-biber.sourceforge.net/biblatexml">

  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <xsl:strip-space elements="*" />

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text()" priority="0.1">
    <xsl:call-template name="expand-tex-macros" />
  </xsl:template>

  <xsl:template name="expand-tex-macros">
    <xsl:call-template name="expand-mkbibquote" />
  </xsl:template>

  <xsl:template name="expand-mkbibquote">
    <xsl:analyze-string select="string()" regex="\\mkbibquote\{{([^\}}]*)\}}">
      <xsl:matching-substring>
        <q><xsl:value-of select="regex-group(1)" /></q>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:call-template name="expand-mkbibemph" />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template name="expand-mkbibemph">
    <xsl:analyze-string select="string()" regex="\\mkbibemph\{{([^\}}]*)\}}">
      <xsl:matching-substring>
        <emph><xsl:value-of select="regex-group(1)" /></emph>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:call-template name="expand-mkbibparens" />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template name="expand-mkbibparens">
    <xsl:analyze-string select="string()" regex="\\mkbibparens\{{([^\}}]*)\}}">
      <xsl:matching-substring>
        <xsl:text>(</xsl:text>
        <xsl:value-of select="regex-group(1)" />
        <xsl:text>)</xsl:text>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:call-template name="remove-tex-braces" />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template name="remove-tex-braces">
    <xsl:analyze-string select="string()" regex="\{{([^\}}]*)\}}">
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(1)" />
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:call-template name="remove-tex-backslashes" />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template name="remove-tex-backslashes">
    <xsl:value-of select="replace(., '\\', '')" />
  </xsl:template>

</xsl:stylesheet>


