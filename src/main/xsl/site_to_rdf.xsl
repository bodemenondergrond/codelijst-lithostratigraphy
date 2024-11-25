<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:dct="http://purl.org/dc/terms/">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" />

    <xsl:template match="/">
        <rdf:RDF>
            <skos:ConceptScheme rdf:about="https://data.bodemenondergrond.vlaanderen.be/id/conceptscheme/lithostratigraphy">
                <skos:prefLabel xml:lang="nl">Conceptschema Lithostratigraphie</skos:prefLabel>
            </skos:ConceptScheme>
            <xsl:apply-templates  select="li" />
        </rdf:RDF>
    </xsl:template>

    <xsl:template match="li" >
        <skos:narrower>
            <skos:Concept>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="replace(replace(a/@href,'ncs.naturalsciences.be','data.bodemenondergrond.vlaanderen.be/id/concept'),'/$', '')"/>
                </xsl:attribute>
                <skos:prefLabel xml:lang="en">
                    <xsl:value-of select="a"/>
                </skos:prefLabel>
                <skos:inScheme rdf:resource="https://data.bodemenondergrond.vlaanderen.be/id/conceptscheme/lithostratigraphy"/>
                <dct:source>
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="a/@href"/>
                    </xsl:attribute>
                </dct:source>
                <xsl:apply-templates  select="li" />
            </skos:Concept>
        </skos:narrower>
    </xsl:template>
    <xsl:template match='li[@class="level1"]' >
        <skos:narrower>
            <skos:Concept>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="replace(a/@href,'ncs.naturalsciences.be','data.bodemenondergrond.vlaanderen.be/id/concept')"/>
                </xsl:attribute>
                <skos:prefLabel xml:lang="en">
                    <xsl:value-of select="a"/>
                </skos:prefLabel>
                <skos:inScheme rdf:resource="https://data.bodemenondergrond.vlaanderen.be/id/conceptscheme/lithostratigraphy"/>
                <skos:topConceptOf rdf:resource="https://data.bodemenondergrond.vlaanderen.be/id/conceptscheme/lithostratigraphy"/>
                <dct:source>
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="a/@href"/>
                    </xsl:attribute>
                </dct:source>
                <xsl:apply-templates  select="li" />
            </skos:Concept>
        </skos:narrower>
    </xsl:template>
</xsl:stylesheet>
