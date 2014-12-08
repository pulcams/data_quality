<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:clean="clean" exclude-result-prefixes="xs clean" version="3.0">

    <!-- Functions for cleaning MARC XML. -->

    <xsl:function name="clean:marc245a" as="xs:string?">
        <xsl:param name="a" as="xs:string?"/>
        <xsl:param name="sibling" as="xs:string?"/>
        <xsl:variable name="last-one" select="substring($a, string-length($a))"/>
        <xsl:variable name="last-two" select="substring($a, string-length($a) - 1)"/>
        <xsl:variable name="last-three" select="substring($a, string-length($a) - 2)"/>
        
        <xsl:choose>
            <xsl:when test="$sibling = 'b'">
                <xsl:sequence
                    select="
                    if ($last-two != ' :' and string-length(translate($last-one, '.,;/', '')) = 0)            
                    then concat(substring($a, 1, string-length($a) - 1), ' :') 
                    else if ($last-two != ' =' and $last-one = '=')
                    then concat(substring($a, 1, string-length($a) - 1), ' =')    
                    else if ($last-two != ' :' and $last-one = ':')
                    then concat(substring($a, 1, string-length($a) - 1), ' :')
                    else if (string-length(translate($last-one, '.,;:/=', '')) = 1)
                    then concat($a, ' :')
                    else ($a)
                    "/>                  
            </xsl:when>
            <xsl:when test="$sibling = 'c'">
                <xsl:sequence
                    select="
                    if ($last-two != (' /') and string-length(translate($last-one, '.,;:/', '')) = 0 
                    and string-length(translate($last-three, '...', '')) &gt; 1)            
                    then concat(substring($a, 1, string-length($a) - 1), ' /')   
                    else if (string-length(translate($last-three, '...', '')) = 0)
                    then concat($a, ' /')
                    else if ($last-two != ' /' and $last-one = '/')
                    then concat(substring($a, 1, string-length($a) - 1), ' /')
                    else if (string-length(translate($last-one, '.,;:/', '')) = 1)
                    then concat($a, ' /')
                    else ($a)
                    "/>  
            </xsl:when> 
            <xsl:when test="$sibling = 'n'">
                <xsl:sequence
                    select="
                    if ($last-one != '.' and string-length(translate($last-one, ',;:', '')) = 0) 
                    then concat(substring($a, 1, string-length($a) - 1), '.')                                     
                    else if (string-length(translate($last-one, '.,;:', '')) = 1)
                    then concat($a, '.')
                    else ($a)
                    "/>
            </xsl:when> 
            <xsl:otherwise>
                <xsl:sequence
                    select="
                    if (string-length(translate($last-one, '.,;:/', '')) = 1)            
                    then concat($a, '.')
                    else ($a)                    
                    "/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:function>    
    
    <xsl:function name="clean:marc245b" as="xs:string?">
        <xsl:param name="b" as="xs:string?"/>
        <xsl:param name="sibling" as="xs:string?"/>
        <xsl:variable name="last-one" select="substring($b, string-length($b))"/>
        <xsl:variable name="last-two" select="substring($b, string-length($b) - 1)"/>
        <xsl:variable name="last-three" select="substring($b, string-length($b) - 2)"/>
        
        <xsl:choose>
            <xsl:when test="$sibling = 'c'">
                <xsl:sequence
                    select="
                    if ($last-two != ' /' and string-length(translate($last-one, '.,;:/', '')) = 0
                    and string-length(translate($last-three, '...', '')) &gt; 1)
                    then concat(substring($b, 1, string-length($b) - 1), ' /')
                    else if (string-length(translate($last-three, '...', '')) = 0)
                    then concat($b, ' /')
                    else if ($last-two != ' /' and $last-one = '/')
                    then concat(substring($b, 1, string-length($b) - 1), ' /')
                    else if (string-length(translate($last-one, '.,;:/', '')) = 1)
                    then concat($b, ' /')
                    else ($b)
                    "/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence
                    select="
                    if ($last-one != '.' and string-length(translate($last-one, ',;:', '')) = 0) 
                    then concat(substring($b, 1, string-length($b) - 1), '.')                                     
                    else if (string-length(translate($last-one, '.,;:', '')) = 1)
                    then concat($b, '.')
                    else ($b)
                    "/>
            </xsl:otherwise>
        </xsl:choose>
        
        
    </xsl:function>
    
    
    <xsl:function name="clean:marc264a" as="xs:string?">
        <xsl:param name="a" as="xs:string?"/>
        <xsl:param name="sibling" as="xs:string?"/>
        <xsl:variable name="last-one" select="substring($a, string-length($a))"/>
        <xsl:variable name="last-two" select="substring($a, string-length($a) - 1)"/>
        
        <xsl:choose>
            <xsl:when test="$sibling = 'a'">
                <xsl:sequence
                    select="
                    if ($last-two != ' ;' and string-length(translate($last-one, '.,;:', '')) = 0) 
                    then concat(substring($a, 1, string-length($a) - 1), ' ;')
                    else if ($last-two != ' ;' and $last-one = ';')
                    then concat(substring($a, 1, string-length($a) - 1), ' ;')
                    else if (string-length(translate($last-one, '.,;:', '')) = 1)
                    then concat($a, ' ;')
                    else ($a)
                    "/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence
                    select="
                    if ($last-two != ' :' and string-length(translate($last-one, '.,;:', '')) = 0) 
                    then concat(substring($a, 1, string-length($a) - 1), ' :')
                    else if ($last-two != ' :' and $last-one = ':')
                    then concat(substring($a, 1, string-length($a) - 1), ' :')
                    else if (string-length(translate($last-one, '.,;:', '')) = 1)
                    then concat($a, ' :')
                    else ($a)
                    "/>
            </xsl:otherwise>
        </xsl:choose>
               
    </xsl:function>

    <xsl:function name="clean:marc264b" as="xs:string?">
        <xsl:param name="b" as="xs:string?"/>
        <xsl:param name="sibling" as="xs:string?"/>
        <xsl:variable name="last-one" select="substring($b, string-length($b))"/>
        <xsl:variable name="last-two" select="substring($b, string-length($b) - 1)"/>
        
        <xsl:choose>
            <xsl:when test="$sibling = 'a'">
                <xsl:sequence
                    select="
                    if ($last-two != ' ;' and string-length(translate($last-one, '.,;:', '')) = 0) 
                    then concat(substring($b, 1, string-length($b) - 1), ' ;')
                    else if ($last-two != ' ;' and $last-one = ';')
                    then concat(substring($b, 1, string-length($b) - 1), ' ;')
                    else if (string-length(translate($last-one, '.,;:', '')) = 1)
                    then concat($b, ' ;')
                    else ($b)
                    "/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence
                    select="
                    if ($last-one != ',' and string-length(translate($last-one, '.:', '')) = 0) 
                    then concat(substring($b, 1, string-length($b) - 1), ',')                                     
                    else if (string-length(translate($last-one, ',;', '')) = 1)
                    then concat($b, ',')
                    else ($b)
                    "/>
            </xsl:otherwise>
        </xsl:choose>              
        
    </xsl:function>

</xsl:stylesheet>
