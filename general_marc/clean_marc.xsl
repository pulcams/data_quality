<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:clean="clean" exclude-result-prefixes="xs clean" version="3.0">

    <xsl:output method="xml" encoding="UTF-8"/>
    
    <!-- Include cleaning functions. -->
    <xsl:include href="clean_marc_functions.xsl"/>  

    <!-- Identity template. -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Correct ISBD punctuation for 245 subfield $a. -->
    <xsl:template match="marc:datafield[@tag = '245']/marc:subfield[@code = 'a']">     
        <xsl:choose>
            <xsl:when test="../marc:subfield[@code = 'b'] and not(../marc:subfield[@code = 'c']) and not(../marc:subfield[@code = 'n'])">
                <marc:subfield code="a">
                    <xsl:value-of select="clean:marc245a(., 'b')"/>    
                </marc:subfield>   
            </xsl:when>
            <xsl:when test="../marc:subfield[@code = 'c'] and not(../marc:subfield[@code = 'b']) and not(../marc:subfield[@code = 'n'])">
                <marc:subfield code="a">
                    <xsl:value-of select="clean:marc245a(., 'c')"/>    
                </marc:subfield>
            </xsl:when>
            <xsl:when test="../marc:subfield[@code = 'b'] and ../marc:subfield[@code = 'c'] and not(../marc:subfield[@code = 'n'])">
                <marc:subfield code="a">
                    <xsl:value-of select="clean:marc245a(., 'b')"/>    
                </marc:subfield>   
            </xsl:when>
            <xsl:when test="../marc:subfield[@code = 'n']">
                <marc:subfield code="a">
                    <xsl:value-of select="clean:marc245a(., 'n')"/>    
                </marc:subfield>
            </xsl:when>
            <xsl:otherwise>
                <marc:subfield code="a">
                    <xsl:value-of select="clean:marc245a(., '')"/>    
                </marc:subfield> 
            </xsl:otherwise>
        </xsl:choose>                                    
    </xsl:template>
    
    <!-- Correct ISBD punctuation for 245 subfield $b. -->
    <xsl:template match="marc:datafield[@tag = '245']/marc:subfield[@code = 'b']">             
        <xsl:choose>
            <xsl:when test="../marc:subfield[@code = 'c']">
                <marc:subfield code="b">
                    <xsl:value-of select="clean:marc245b(., 'c')"/>
                </marc:subfield>
            </xsl:when>
            <xsl:otherwise>
                <marc:subfield code="b">
                    <xsl:value-of select="clean:marc245b(., '')"/>
                </marc:subfield>
            </xsl:otherwise>
        </xsl:choose>                
    </xsl:template>

    <!-- Correct ISBD punctuation for 264 subfield $a. -->
    <xsl:template match="marc:datafield[@tag = '264']/marc:subfield[@code = 'a']">     
        <xsl:choose>
            <xsl:when test="following-sibling::*[1][self::marc:subfield[@code = 'a']]">
                <marc:subfield code="a">
                    <xsl:value-of select="clean:marc264a(., 'a')"/>    
                </marc:subfield>
            </xsl:when>
            <xsl:otherwise>
                <marc:subfield code="a">
                    <xsl:value-of select="clean:marc264a(., '')"/>    
                </marc:subfield>  
            </xsl:otherwise>            
        </xsl:choose>                                     
    </xsl:template>
    
    <!-- Correct ISBD punctuation for 264 subfield $b. --> 
    <xsl:template match="marc:datafield[@tag = '264']/marc:subfield[@code = 'b']">        
        <xsl:choose>
            <xsl:when test="following-sibling::*[1][self::marc:subfield[@code = 'a']]">
                <marc:subfield code="b">
                    <xsl:value-of select="clean:marc264b(., 'a')"/>    
                </marc:subfield>
            </xsl:when>
            <xsl:otherwise>
                <marc:subfield code="b">
                    <xsl:value-of select="clean:marc264b(., '')"/>    
                </marc:subfield>  
            </xsl:otherwise>
        </xsl:choose>                               
    </xsl:template>
    
</xsl:stylesheet>
