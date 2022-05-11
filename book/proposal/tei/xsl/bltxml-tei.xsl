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
    <xsl:call-template name="mkbibquote" />
  </xsl:template>

  <xsl:template name="mkbibquote">
    <xsl:param name="string" select="string(.)" />
    <xsl:analyze-string select="$string" regex="\\mkbibquote\{{([^\}}]*)\}}">
      <xsl:matching-substring>
        <q><xsl:value-of select="regex-group(1)" /></q>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="." />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

</xsl:stylesheet>


