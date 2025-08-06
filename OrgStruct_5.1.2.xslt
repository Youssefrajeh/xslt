<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="associate">
      <xsl:copy>
        Associate: <xsl:value-of select ="./@name"/>
        This associate manages the following personnel:
        <xsl:for-each select="manager-for/associate">
          <xsl:value-of select ="./@name"/>
        </xsl:for-each>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:template>
  
</xsl:stylesheet>
