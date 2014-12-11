<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim">
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- File path parameter. -->
    <xsl:param name="filePath">PATH OF TSV FILE GOES HERE (e.g., "open-refine-export.tsv")</xsl:param>

    <!-- Main template that parses the TSV and creates structured XML. -->
    <xsl:template match="/*">
        <marc:collection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">

            <!-- Read in TSV file. -->
            <xsl:variable name="text" select="unparsed-text($filePath,'UTF-8')"/>

            <xsl:variable name="header">
                <xsl:analyze-string select="$text" regex="(..*)">
                    <xsl:matching-substring>
                        <xsl:if test="position()=1">
                            <xsl:value-of select="replace(regex-group(1),'\t','|')"/>
                        </xsl:if>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:variable>
            <xsl:variable name="headerTokens" select="tokenize($header,'\|')"/>
            <xsl:variable name="recordBody">
                <xsl:analyze-string select="$text" regex="(..*)">
                    <xsl:matching-substring>
                        <xsl:if test="not(position()=1)">

                            <!-- Begin creating the records. 
                                 Assign column headers to field elements as @name attributes. -->
                            <xsl:analyze-string select="." regex="([^\t][^\t]*)\t?|\t">
                                <xsl:matching-substring>
                                    <xsl:variable name="pos" select="position()"/>
                                    <xsl:variable name="headerToken" select="$headerTokens[$pos]"/>
                                    <xsl:if test="regex-group(1)[position() = 1]">
                                        <field name="{normalize-space($headerToken)}"
                                            nbr="{substring(tokenize(normalize-space($headerToken),'[^0-9]')[1],1,3)}">
                                            <xsl:value-of select="regex-group(1)"/>
                                        </field>
                                    </xsl:if>
                                </xsl:matching-substring>
                            </xsl:analyze-string>
                        </xsl:if>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:variable>
            <!-- Split into record chunks. -->
            <xsl:variable name="recompile">
                <xsl:for-each-group select="$recordBody/field"
                    group-starting-with="field[@name='leader'][string()]">
                    <record>
                        <xsl:copy-of select="current-group()"/>
                    </record>
                </xsl:for-each-group>
            </xsl:variable>

            <!-- Rebuild MARC record. -->
            <xsl:for-each select="$recompile/record">
                <marc:record>
                    <marc:leader>
                        <xsl:apply-templates select="field[@name='leader']"/>
                    </marc:leader>
                    <xsl:apply-templates select="*[@name=('001','005','007','008')]"
                        mode="controlfield"/>
                    <xsl:variable name="datafields">
                        <xsl:for-each-group select="field[number(@nbr) >= 20]" group-adjacent="@nbr">
                            <xsl:variable name="firstName" select="current-group()[1]/@name"/>
                            <xsl:for-each-group select="current-group()"
                                group-starting-with="*[@name=$firstName]">
                                <marc:datafield tag="{@nbr}"
                                    ind1="{if (substring(@name,4,1) = '_') 
                                    then ' ' 
                                    else substring(@name, 4, 1)}"
                                    ind2="{if (substring(@name, 5, 1) = '_') 
                                    then ' ' 
                                    else substring(@name, 5, 1)}">
                                    <xsl:for-each select="current-group()">
                                        <marc:subfield code="{substring(@name, 7, 1)}">
                                            <xsl:apply-templates select="."/>
                                        </marc:subfield>
                                    </xsl:for-each>
                                </marc:datafield>
                            </xsl:for-each-group>
                        </xsl:for-each-group>
                    </xsl:variable>
                    <xsl:perform-sort select="$datafields/*">
                        <xsl:sort select="@tag"/>
                    </xsl:perform-sort>
                </marc:record>
            </xsl:for-each>
        </marc:collection>
    </xsl:template>

    <xsl:template match="field" mode="controlfield">
        <marc:controlfield tag="{@name}">
            <xsl:value-of select="."/>
        </marc:controlfield>
    </xsl:template>

    <xsl:template match="field">
        <xsl:value-of select="."/>
    </xsl:template>

</xsl:stylesheet>
