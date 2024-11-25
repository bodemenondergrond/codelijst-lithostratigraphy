<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:fun="http://www.gezever.be/functions/"
    xmlns:beo="https://data.vlaanderen.be/ns/bodemenondergrond#">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" />
    <xsl:param name="path"/>
 

    <xsl:variable name="mapdoc-lithostratigraphy" select="document('/tmp/li-description.rdf')//*[self::rdf:Description | self::skos:Concept]" as="element()*"/>
    <xsl:function name="fun:nlc-str-eq" as="xs:boolean">
        <xsl:param name="str1" as="xs:string"/>
        <xsl:param name="str2" as="xs:string"/>
        <xsl:sequence select="lower-case(normalize-space($str1)) eq lower-case(normalize-space($str2))"/>
    </xsl:function>
    <xsl:function name="fun:lithostratigraphy-uri">
        <xsl:param name="prefLabel"/>
        <xsl:variable name="formatie_lid" 
            select="$mapdoc-lithostratigraphy
            [skos:inScheme[@rdf:resource = 'https://data.bodemenondergrond.vlaanderen.be/id/conceptscheme/lithostratigraphy']]
            [skos:prefLabel[fun:nlc-str-eq(., $prefLabel)]]"/>
       
        <xsl:choose>
            <xsl:when test="exists($formatie_lid)">
                <xsl:value-of select="normalize-space($formatie_lid[1]/@rdf:about)"/>   
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat('https://data.bodemenondergrond.vlaanderen.be/id/concept/lithostratigraphy/',replace(lower-case(normalize-space($prefLabel)),' ', '-'))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function> 
    <xsl:template match="/xml">
        <rdf:RDF>
            <rdf:Description>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="fun:lithostratigraphy-uri(a/strong)"/>
                </xsl:attribute>  
                <rdfs:seeAlso>
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="a/@href"/>
                    </xsl:attribute>  
                </rdfs:seeAlso>
            <xsl:apply-templates  select="table/tbody/tr" />
            </rdf:Description>     
        </rdf:RDF>
    </xsl:template>  
    <xsl:template match="tr" >
            <xsl:if test="td[2] != ''">
                <xsl:choose>
                    <xsl:when test="td[2]/i != ''">
                        <xsl:variable name="property" 
                            select="concat('beo:',replace(lower-case(normalize-space(td[1]/strong)),' ', '_'))"/>
                        <xsl:element name="{$property}"><xsl:value-of select="td[2]/i"/></xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="property" 
                            select="concat('beo:',replace(lower-case(normalize-space(td[1]/strong)),' ', '_'))"/>
                        <xsl:element name="{$property}"><xsl:value-of select="td[2]"/></xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
    </xsl:template>   
</xsl:stylesheet>
