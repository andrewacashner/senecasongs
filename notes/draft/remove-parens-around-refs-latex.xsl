  <!-- Remove parentheses in text around video or audio references (also remove trailing space before or after the parentheses-->
  <xsl:template match="text()[
  following-sibling::node()[1][self::aac:ref[@type='video' or @type='audio']] 
  and ends-with(., '(')
  and not(preceding-sibling::node()[1][self::aac:ref[@type='audio' or @type='video']])
  ]">
    <xsl:value-of select="replace(substring(., 1, string-length(.) - 2), '\s+$', '')" />
  </xsl:template>

  <!-- And if there is a ref on both sides of the text node? yuck -->
  <xsl:template match="text()[
  preceding-sibling::node()[1][self::aac:ref[@type='audio' or @type='video']] 
  and starts-with(., ')') 
  and following-sibling::node()[1][self::aac:ref[@type='video' or @type='audio']] 
  and ends-with(., '(')
  ]">
    <xsl:value-of select="replace(replace(substring(., 2, string-length(.) - 3), '\s+$', ''), '$\s+', '')" />
  </xsl:template>

  <xsl:template match="text()[
  preceding-sibling::node()[1][self::aac:ref[@type='audio' or @type='video']] 
  and starts-with(., ')') 
  and not(following-sibling::node()[1][self::aac:ref[@type='video' or @type='audio']])]">
    <xsl:value-of select="replace(substring(., 2), '$\s+', '')" />
  </xsl:template>



