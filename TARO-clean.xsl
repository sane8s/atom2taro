<!-- TARO-clean.xsl is a basic stylesheet to clean up some loose ends in the newly transformed XML file created by atom2taro.xsl This file still doesn't address everything, and it is optional. -->
<!-- Created by Sandra Yates at the McGovern Historical Center, Texas Medical Center Library, July 14, 2021. -->
<!-- XPath isn't working the way it did in atom2taro.xsl, paths to specific nodes did not work. Propbably a simple fix to make this stylesheet more useful. -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns="urn:isbn:1-931666-22-9"
    exclude-result-prefixes="xsi">
    
    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>
    
 <!-- Remove all empty elements, like children of orgination, unitdate@type=bulk. NOTE: Review the <unitdate> tags before running the TARO-clean transformation, so you can have the appropriate attributes for any bulk dates listed.-->
    <xsl:template match="node()|@*">
        <xsl:if test="normalize-space(string(.)) != ''">
            <xsl:copy>
                <xsl:apply-templates select="node()|@*"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
     
    <!-- Add attributes to <ead>-->      
    <xsl:template match="/">
        <ead xmlns="urn:isbn:1-931666-22-9" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink" xsi:schemaLocation="urn:isbn:1-931666-22-9 http://www.loc.gov/ead/ead.xsd" relatedencoding="MARC21">
            <xsl:copy>
                <xsl:apply-templates select="child::node()|@*"/>
            </xsl:copy>
        </ead>        
    </xsl:template>
    
    <!-- Add attributes to <archdesc>. As of July 2021, the template was not successful and using batch find and replace was effecient enough. -->
 
</xsl:stylesheet>