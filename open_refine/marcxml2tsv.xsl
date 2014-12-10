<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    exclude-result-prefixes="marc">
    
    <!-- Converts MARC XML to tab-delimited format for import into OpenRefine. -->
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:variable name="fields">
        <xsl:for-each-group select="/marc:collection/marc:record/marc:datafield" group-by="@tag">
            <xsl:sort select="@tag"/>
            <xsl:for-each select="marc:subfield">
                <xsl:sort select="if (translate(@code,'1234567890','') = '') then 'z' else (@code)" data-type="text"/>
                <field tag="{current-grouping-key()}" code="{@code}" ind1="{../@ind1}" ind2="{../@ind2}">a</field>
            </xsl:for-each>
        </xsl:for-each-group>
    </xsl:variable>
    
    <xsl:template match="/">
        <!-- header -->
        <xsl:text>leader</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>001</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>005</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:if test="//marc:controlfield[@tag = '007']">
            <xsl:text>007</xsl:text>
            <xsl:text>&#9;</xsl:text>
        </xsl:if>        
        <xsl:text>008</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:for-each select="$fields/field">
            <xsl:value-of select="@tag"/>
            <xsl:value-of select="if (@ind1 = ' ') then '_' else (@ind1)"/>
            <xsl:value-of select="if (@ind2 = ' ') then '_' else (@ind2)"/>
            <xsl:value-of select="concat('$',@code)"/>
            <xsl:if test="position()!=last()">
                <xsl:text>&#9;</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
        <!-- data -->
        <xsl:for-each select="marc:collection/marc:record">
            <xsl:variable name="current-record" select="." />
            <xsl:value-of select="marc:leader"/>
            <xsl:text>&#9;</xsl:text>
            <xsl:value-of select="marc:controlfield[@tag = '001']"/>               
            <xsl:text>&#9;</xsl:text>
            <xsl:value-of select="marc:controlfield[@tag = '005']"/>               
            <xsl:text>&#9;</xsl:text>
            <xsl:choose>
                <xsl:when test="marc:controlfield[@tag = '007']">
                    <xsl:value-of select="marc:controlfield[@tag = '007']"/>               
                    <xsl:text>&#9;</xsl:text>
                </xsl:when>
                <xsl:otherwise>                                  
                    <xsl:text>&#9;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>            
            <xsl:value-of select="marc:controlfield[@tag = '008']"/>               
            <xsl:text>&#9;</xsl:text>            
            <xsl:for-each select="$fields/field">
                <xsl:value-of select="$current-record/marc:datafield[@tag=current()/@tag]/marc:subfield[@code=current()/@code]" separator="|"/>
                <xsl:if test="position()!=last()">
                    <xsl:text>&#9;</xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test="position()!=last()">
                <xsl:text>&#10;</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>