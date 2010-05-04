<xsl:stylesheet 
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ead="urn:isbn:1-931666-22-9">

<xsl:param name="dsc-type" select="'combined'"/>
<xsl:param name="repositorycode" select="/ead:ead/ead:eadheader/ead:eadid/@mainagencycode"/>
<xsl:param 
	name="countrycode" 
	select="translate(
		/ead:ead/ead:eadheader/ead:eadid/@countrycode,
		'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' )" />

<!-- root template -->
<xsl:template match="/|comment()|processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
</xsl:template>

<!-- add dsc/@type -->
<xsl:template match="ead:dsc[parent::ead:archdesc and position()=1]">
  <xsl:element name="{name()}">
    <xsl:apply-templates select="@*"/>
    <xsl:if test="not(@type)">
      <xsl:attribute name="type">
        <xsl:value-of select="$dsc-type"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- copy repositorycode and countrycode from eadid to unitid in
     archdesc/did/unittitle
-->
<xsl:template match="ead:unitid[parent::ead:did and not(ancestor::ead:dsc)]">
  <xsl:element name="{name()}">
    <xsl:apply-templates select="@*"/>
    <xsl:if test="not(@repositorycode)">
      <xsl:attribute name="repositorycode">
        <xsl:value-of select="$repositorycode"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="not(@countrycode)">
      <xsl:attribute name="countrycode">
        <xsl:value-of select="$countrycode"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- upper-case the country code -->
<xsl:template match="@countrycode[parent::ead:eadid]">
  <xsl:attribute name="countrycode">
    <xsl:value-of select="$countrycode"/>
  </xsl:attribute>
</xsl:template>

<!-- strip out overloaded container labels -->
<xsl:template match="@label[local-name(..)='container']"/>

<!-- identity -->
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
<!--

Copyright (c) 2010, Regents of the University of California
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

- Redistributions of source code must retain the above copyright notice, 
  this list of conditions and the following disclaimer.
- Redistributions in binary form must reproduce the above copyright notice, 
  this list of conditions and the following disclaimer in the documentation 
  and/or other materials provided with the distribution.
- Neither the name of the University of California nor the names of its
  contributors may be used to endorse or promote products derived from this 
  software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.
-->
