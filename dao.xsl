<xsl:stylesheet
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- root template -->
  <xsl:template match="/|comment()|processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="dao[not(parent::did)]">
    <xsl:variable name="plusone">
      <xsl:value-of select="number(substring(name(..),2,2))+1"/>
    </xsl:variable>
    <xsl:element name="c0{$plusone}">
      <did>
        <unittitle><xsl:value-of select="daodesc/p"/></unittitle>
        <dao href="{@href}"/>
      </did>
    </xsl:element>
  </xsl:template>

  <!-- identity -->
  <xsl:template match="node()|@*">
    <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
