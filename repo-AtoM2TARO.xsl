<!-- AtoM to TARO XSLT Conversion, atom2taro, facilitates XML export from the Access to Memory (AtoM) Archival Management System to a compliant XML import into Texas Archival Resources Online (TARO) system. The stylesheet converts the DTD-based 2002 EAD XML export from AtoM and conforms the data to comply with TARO best practices and schema-based XML template. -->
<!-- Created by Sandra E. Yates, McGovern Historical Center, Texas Medical Center Library, July 14, 2021. The code is maintained and updated to address development changes in AtoM and/or TARO. Updates can be found at https://github.com/sane8s/atom2taro. Collaboration and recommendations are welcome. More details about the archival systems at https://txarchives.org/ and https://www.accesstomemory.org/. -->
<!-- The code is based on the dtd2schema.xsl EAD DTD to Schema XSLT Conversion Version 200701 Alpha. Editors: Stephen Yearl (Yale) and Daniel V. Pitti (Virginia).
There is also modified code from ead-schema-to-dtd.xsl, developed by Woodson Research Center, Fondren Library, Rice University, that converts <c> tags to <c##> hierarchy. -->
<!-- Below find more instructions on how to customize the stylesheet for your repository. -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns="urn:isbn:1-931666-22-9"
    exclude-result-prefixes="xsi">
    
    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes"
        encoding="UTF-8"/>
    <!--========== START of dtd2schema.xsl =========-->
    <!-- Resulting document: W3C ready? Or RNG (Oxygent) ready? -->
    
    <xsl:variable name="schema">
        <xsl:text>RNG</xsl:text>
        <!-- Alternatives RNG or W3C-->
    </xsl:variable>
    
    <!-- Path to schema -->
    
    <xsl:variable name="schemaPath">
        <xsl:text>/</xsl:text>
    </xsl:variable>
    
    <!-- Variables for namespace and processing instructions -->
    
    
    <xsl:variable name="oXygen_pi">
        <xsl:text>RNGSchema="</xsl:text>
        <xsl:value-of select="$schemaPath"/>
        <xsl:text>ead.rng"</xsl:text>
        <xsl:text> type="xml"</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="xlink_ns">
        <xsl:text>http://www.w3.org/1999/xlink</xsl:text>
    </xsl:variable>
    
    <xsl:strip-space elements="*"/>
    
   <!-- <xsl:template match="/">
        <xsl:if test="$schema='RNG'">
            <xsl:text>&#xA;</xsl:text>
            <xsl:processing-instruction name="oxygen">
				<xsl:value-of select="$oXygen_pi"/>
			</xsl:processing-instruction>
            <xsl:text>&#xA;</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="*|comment()|processing-instruction()"/>
    </xsl:template> Template commented out. It was adding an unnecessary tag - SEY, 2021-->
    
    <xsl:template match="ead">
        <xsl:choose>
            <xsl:when test="$schema='RNG'">
                <ead>
                    <xsl:apply-templates
                        select="*|text()|@*|processing-instruction()|comment()"/>
                </ead>
            </xsl:when>
            <xsl:when test="$schema='W3C'">
                <ead xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                    <xsl:attribute name="xsi:schemaLocation">
                        <xsl:text>urn:isbn:1-931666-22-9 </xsl:text>
                        <xsl:value-of select="$schemaPath"/>
                        <xsl:text>ead.xsd</xsl:text>
                    </xsl:attribute>                    
                    <xsl:apply-templates
                        select="*|text()|@*|processing-instruction()|comment()"/>
                </ead>
            </xsl:when>
        </xsl:choose>
    </xsl:template>    
    <xsl:template match="@*">
        <xsl:choose>
            <xsl:when test="normalize-space(.)= ''"/>
            <xsl:otherwise>
                <xsl:attribute name="{name(.)}">
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:apply-templates
                select="*|@*|comment()|processing-instruction()|text()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="comment()|processing-instruction()">
        <xsl:copy/>
    </xsl:template>
    
    <!--========== XLINK ==========-->
    
    <!-- arc-type elements-->
    <xsl:template match="arc">
        <xsl:element name="{name()}">
            <xsl:attribute name="xlink:type">arc</xsl:attribute>
            <xsl:call-template name="xlink_attrs"/>
        </xsl:element>
    </xsl:template>
    
    <!-- extended-type elements-->
    <xsl:template match="daogrp | linkgrp">
        <xsl:element name="{name()}">
            <xsl:attribute name="xlink:type">extended</xsl:attribute>
            <xsl:call-template name="xlink_attrs"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- locator-type elements-->
    <xsl:template match="daoloc | extptrloc | extrefloc | ptrloc | refloc">
        <xsl:element name="{name()}">
            <xsl:attribute name="xlink:type">locator</xsl:attribute>
            <xsl:call-template name="xlink_attrs"/>
            <xsl:call-template name="hrefHandler"/>
        </xsl:element>
    </xsl:template>
    
    <!-- resource-type elements-->
    <xsl:template match="resource">
        <xsl:element name="{name()}">
            <xsl:attribute name="xlink:type">resource</xsl:attribute>
            <xsl:call-template name="xlink_attrs"/>
        </xsl:element>
    </xsl:template>
    
    <!-- simple-type elements-->
    <xsl:template
        match="archref | bibref | dao | extptr | extref | ptr | ref | title">
        <xsl:element name="{name()}">
            <xsl:attribute name="xlink:type">simple</xsl:attribute>
            <xsl:call-template name="xlink_attrs"/>
            <xsl:call-template name="hrefHandler"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>    
  
    <!-- attribute handling -->
    <xsl:template name="xlink_attrs">
        <xsl:for-each select="@*">
            <xsl:choose>
                <xsl:when test="name()='actuate'">
                    <xsl:attribute name="xlink:actuate">
                        <xsl:choose>
                            <!--EAD's actuateother and actuatenone do not exist in xlink-->
                            <xsl:when test=".='onload'">onLoad</xsl:when>
                            <xsl:when test=".='onrequest'">onRequest</xsl:when>
                            <xsl:when test=".='actuateother'">other</xsl:when>
                            <xsl:when test=".='actuatenone'">none</xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="name()='show'">
                    <xsl:attribute name="xlink:show">
                        <xsl:choose>
                            <!--EAD's showother and shownone do not exist in xlink-->
                            <xsl:when test=".='new'">new</xsl:when>
                            <xsl:when test=".='replace'">replace</xsl:when>
                            <xsl:when test=".='embed'">embed</xsl:when>
                            <xsl:when test=".='showother'">other</xsl:when>
                            <xsl:when test=".='shownone'">none</xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when
                    test="name()='arcrole' or name()='from' or
                    name()='label' or name()='role' or
                    name()='title' or name()='to'">
                    <xsl:attribute name="xlink:{name()}">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when
                    test="name()='linktype' or name()='href' or
                    name()='xpointer' or name()='entityref'"/>
                <xsl:otherwise>
                    <xsl:apply-templates select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="hrefHandler">
        <xsl:attribute name="xlink:href">
            <xsl:choose>
                <xsl:when test="@entityref and not(@href)">
                    <!-- This will resolve the entity sysid as an absolute path. 
						If the desired result is a relative path, then use XSLT
						string functions to "reduce" the absolute path to a
						relative path.
					-->
                    <xsl:value-of select="unparsed-entity-uri(@entityref)"/>
                </xsl:when>
                <xsl:when test="@href and @entityref ">
                    <xsl:value-of select="@href"/>
                </xsl:when>
                <xsl:when test="@href and not(@entityref)">
                    <xsl:value-of select="@href"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            <xsl:value-of select="@xpointer"/>
        </xsl:attribute>
    </xsl:template>   
    <!--========== END XLINK ==========-->
    <!--========== END of dtd2schema.xsl =========-->
    
    <!-- Remove descriptions from <c> tags -->
    <xsl:template match="c/odd|physloc|controlaccess|phystech|accessrestrict|userestrict|bioghist"/> 
    <xsl:template match="c/c/did/physdesc|langmaterial|origination"></xsl:template>
    <xsl:template match="c/scopecontent/@encodinganalog"></xsl:template>
    <xsl:template match="c/did/unittitle/@encodinganalog"/>
    <xsl:template match="c/did/unitid/@encodinganalog"/>
    <xsl:template match="c/did/unitdate/@encodinganalog"/>
    <xsl:template match="container/@parent"></xsl:template>    
    <!-- END Remove descriptions from <c> tags -->
    
    <!--========== <c> to <C0#> tags. Modified from ead-schema-to-dtd.xsl ==========-->
    <!-- Copy template and add more c-levels as needed -->
    <xsl:template match="ead/archdesc/dsc/c">
        <xsl:element name="c01">
            <xsl:attribute name="id">
                <xsl:text>ser</xsl:text>
                <xsl:value-of select="count(preceding-sibling::c) + 1"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*[not(name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead/archdesc/dsc/c/c">
        <xsl:element name="c02">
            <xsl:apply-templates select="@*[not(name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead/archdesc/dsc/c/c/c">
        <xsl:element name="c03">
            <xsl:apply-templates select="@*[not(name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ead/archdesc/dsc/c/c/c/c">
        <xsl:element name="c04">
            <xsl:apply-templates select="@*[not(name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>  
    
    <xsl:template match="ead/archdesc/dsc/c/c/c/c/c">
        <xsl:element name="c05">
            <xsl:apply-templates select="@*[not(name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>  
    <!--========== END Modified from ead-schema-to-dtd.xsl ========-->
 
 <!-- ======= REPOSITORY CUSTOMIZATION ======= -->
    <!-- Modify variable values to match your repository -->
    <!-- Also, confirm or modify the following values further in the stylesheet (highlighted by comments):  @repository, @repositorySubarea, @repositoryCorpname, <unitid repositorycode="US-XXXX"> around line 338, -->
    <xsl:variable name="taroId" select="ead/archdesc/did/unitid[@label='TARO']"/><!-- Unique 5-digit TAROid identifier for each finding aid is inserted into the converted file using the Alternative Identifier field in AtoM. Modify the @label attribute XXXX to match your system settings. If you capture TAROid using another field, review the exported XML file to determine the path to value. Another option below using the @type attribute -->
    <!--<xsl:variable name="taroId" select="ead/archdesc/did/unitid[@type='alternative']"/>-->
    <xsl:variable name="repositoryUrl"><xsl:text>http://library.edu/repo/XXXX</xsl:text></xsl:variable><!-- Insert your repository URL -->
    <xsl:variable name="taroUser"><xsl:text>XXXX</xsl:text></xsl:variable> <!-- Insert your TARO Abbr name, [link to list] -->
    
    <!-- Set other TARO Template Variables -->
    <xsl:variable name="titlep" select="ead/eadheader/filedesc/titlestmt/titleproper"/>
    <xsl:variable name="title" select="ead/archdesc/did/unittitle"/>
    <xsl:variable name="identifier" select="ead/archdesc/did/unitid[@encodinganalog='3.1.1']"/>
    <xsl:variable name="extent" select="ead/archdesc/did/physdesc"/>
    <xsl:variable name="scopecontentp" select="ead/archdesc/scopecontent/p"/>
    <!-- Variables below divide repository corpname and subarea using the comma separator based on the repository field in AtoM. This may vary for your repository. You can use option to insert text directly by switching comment tags.-->
    <xsl:variable name="repository" select="ead/archdesc/did/repository/corpname"/>
    <xsl:variable name="repositorySubarea" select="substring-before($repository,',')"/>
    <xsl:variable name="repositoryCorpname" select="substring-after($repository,',')"/>  
    <!--<xsl:variable name="repositorySubarea"><xsl:text>XXXXRepo Subarea</xsl:text></xsl:variable>
    <xsl:variable name="repositoryCorpname"><xsl:text>XXXXRepo Corpname</xsl:text></xsl:variable>--> 
    
    <!-- Get variables for count totals for elements -->
    <xsl:variable name="creatorPersnameCount" select="count(ead/archdesc/did/origination/persname)"/>
    <xsl:variable name="creatorCorpnameCount" select="count(ead/archdesc/did/origination/corpname)"/>
    <xsl:variable name="creatorFamnameCount" select="count(ead/archdesc/did/origination/famname)"/>
    <xsl:variable name="creatorNameCount" select="count(ead/archdesc/did/origination/name)"/>
    <xsl:variable name="creatorCount" select="$creatorCorpnameCount+$creatorPersnameCount+$creatorFamnameCount+$creatorNameCount"/>
       
     <!-- <eadid> tag inserting values for $taroUser and 5-digit $taroId -->
    <xsl:template match="eadid">
        <eadid countrycode="US" mainagencycode="US-XXXX">urn:taro:<xsl:value-of select="$taroUser"/>.<xsl:value-of select="$taroId"/> </eadid><!-- Modify @mainagencycode to match your repository -->             
    </xsl:template>
       
    <!-- TARO Template with variable values -->    
    <xsl:template match="archdesc/did">
        <did>
            <head>Collection Summary</head>
            <xsl:call-template name="origination"/>
            <xsl:call-template name="units-abstract"/>
            <xsl:call-template name="repository"/>
            <xsl:call-template name="language"/>
        </did>
    </xsl:template>
    <xsl:template name="origination">
        <origination label="Creator:">
            <!-- Creator count test... uncomment to check if creator total are being counted correctly.                
            <name><xsl:text>Total Creators: </xsl:text><xsl:value-of select="$creatorCount"/></name>
            <persname><xsl:value-of select="$creatorPersnameCount"/></persname>
            <corpname><xsl:value-of select="$creatorCorpnameCount"/></corpname>
            <famname><xsl:value-of select="$creatorFamnameCount"/></famname>
            <name><xsl:value-of select="$creatorNameCount"/></name>-->
            <xsl:if test="$creatorCount>=1">
                <xsl:if test="$creatorPersnameCount>=1">
                    <xsl:for-each select="origination/persname">
                        <persname source="lcnaf" encodinganalog="100"><xsl:value-of select="current()"/></persname><!-- Default @source="lcnaf"-->
                        <!--<persname source="local" encodinganalog="100"><xsl:value-of select="current()"/></persname> Default @source="local"-->
                    </xsl:for-each>                    
                </xsl:if>
                <xsl:if test="$creatorCorpnameCount>=1">
                    <xsl:for-each select="origination/corpname">
                        <corpname source="lcnaf" encodinganalog="110"><xsl:value-of select="current()"/></corpname><!-- Default @source="lcnaf"-->
                        <!--<corpname source="local" encodinganalog="110"><xsl:value-of select="current()"/></corpname> Default @source="local"-->
                    </xsl:for-each>                    
                </xsl:if>
                <xsl:if test="$creatorFamnameCount>=1">
                    <xsl:for-each select="origination/famname">
                        <famname source="local" encodinganalog="100"><xsl:value-of select="current()"/></famname><!-- Default @source="local"-->
                    </xsl:for-each>                    
                </xsl:if>
                <xsl:if test="$creatorNameCount>=1">
                    <xsl:for-each select="origination/name">
                        <corpname source="lcnaf" encodinganalog="110"><xsl:value-of select="current()"/></corpname> <!-- Default @source="lcnaf"-->
                        <!--<corpname source="local" encodinganalog="110"><xsl:value-of select="current()"/></corpname> Default @source="local"-->
                    </xsl:for-each>                    
                </xsl:if>
            </xsl:if>
        </origination> 
    </xsl:template>
    <xsl:template name="units-abstract">
        <unittitle label="Title:" encodinganalog="245$a"><xsl:value-of select="$title"/></unittitle>
        <unitdate label="Dates (Bulk):" type="bulk" encodinganalog="245$g" era="ce" calendar="gregorian" normal="0000"/><!-- empty Bulk <unitdate> tag. Manually adjust after atom2taro transformation. There are no distinguishing attributes in <unitdate> in AtoM export to automatically assign bulk or inclusive.-->
        <xsl:for-each select="unitdate"><!-- Loops through all <unitdate> tags present -->
            <unitdate label="Dates:" type="inclusive" encodinganalog="245$f" era="ce" calendar="gregorian">
                <xsl:attribute name="normal">
                    <xsl:value-of select="translate(current(),'-','/')"/><!-- translate result only valid for yyyy-yyyy format -->
                </xsl:attribute>
                <xsl:value-of select="current()"/>
            </unitdate>
            <!--<unitdate label="Dates (Bulk):" type="bulk" encodinganalog="245$g" era="ce" calendar="gregorian">
                <xsl:attribute name="normal">
                    <xsl:value-of select="translate(current(),'-','/')"/>
                </xsl:attribute>
                <xsl:value-of select="current()"/>
                </unitdate> Uncomment if you want all <unitdate> tags to be listed as inclusive and bulk.-->
        </xsl:for-each>
            <unitid label="Identification:" countrycode="US" repositorycode="US-XXXX" encodinganalog="099"><xsl:value-of select="$identifier"/></unitid><!-- Change @repositorycode to match your repository [list of repo codes] -->
            <physdesc label="Quantity:" encodinganalog="300$a"><extent><xsl:value-of select="$extent"/></extent></physdesc>
            <abstract label="Abstract:" encodinganalog="520$a"><xsl:value-of select="$scopecontentp"/></abstract>  
    </xsl:template>
    <xsl:template name="repository">
        <repository label="Repository:" encodinganalog="852$a">
            <extref>
                <xsl:attribute name="xmlns:xlink" namespace="xmlns:xlink"><xsl:value-of select="$xlink_ns"/></xsl:attribute><!-- Creates a validation error. Easily fixed when you in the Finishing Up process -->
                <xsl:attribute name="xlink:type">simple</xsl:attribute>
                <xsl:attribute name="xlink:show">new</xsl:attribute>
                <xsl:attribute name="xlink:actuate">onRequest</xsl:attribute>
                <xsl:attribute name="xlink:href"><xsl:value-of select="$repositoryUrl"/></xsl:attribute>
                <corpname><subarea><xsl:value-of select="$repositorySubarea"/></subarea>,<xsl:value-of select="$repositoryCorpname"/></corpname>                
            </extref>
        </repository> 
    </xsl:template>
    <xsl:template name="language">
        <langmaterial label="Language:" encodinganalog="546$a">
             <language langcode="eng" scriptcode="Latn">English</language><!-- Default English. Modify final XML for each colleciton. Development: needs for-each loop to list mulitple languages in a collection. -->
        </langmaterial>        
    </xsl:template>
    <!-- ===== END TARO Template with variable values ===== -->   
    
    <!-- Templates that pull content for all required and recommended <archdesc> sections in TARO XML Template -->
    <xsl:template match="archdesc/odd[@type='publicationStatus']"/>  <!-- removes publication status, unnecessary -->
     
    <xsl:template match="archdesc/odd[@type='dacsCitation']">
        <prefercite encodinganalog="524">
            <head>Preferred Citation</head>
            <xsl:for-each select="p">
            <p><xsl:value-of select="current()"/></p>
            </xsl:for-each>
        </prefercite>   
    </xsl:template> 
    <xsl:template match="archdesc/odd[@type='dacsProcessingInformation']">
        <processinfo encodinganalog="583">
            <head>Processing Information</head>
            <xsl:for-each select="p">
                <p><xsl:value-of select="current()"/></p>
            </xsl:for-each>
        </processinfo>   
    </xsl:template> 
    <xsl:template match="archdesc/processinfo">
        <processinfo encodinganalog="583">
            <head>Processing Information</head>
            <xsl:for-each select="p">
                <p><xsl:value-of select="current()"/></p>
            </xsl:for-each>
        </processinfo>   
    </xsl:template> 
    <xsl:template match="archdesc/bioghist">
        <bioghist encodinganalog="545">
            <head>Biographical Note</head>
            <xsl:for-each select="note/p">
                <p><xsl:value-of select="current()"/></p>
            </xsl:for-each>             
        </bioghist>       
    </xsl:template>     
    <xsl:template match="archdesc/scopecontent">
        <scopecontent encodinganalog="520$b">
            <head>Scope and Contents Note</head>
            <xsl:for-each select="p">
                <p><xsl:value-of select="current()"/></p>
            </xsl:for-each>
        </scopecontent>        
    </xsl:template>   
    <xsl:template match="archdesc/arrangement">
        <arrangement encodinganalog="351">
            <head>Organization/Arrangement</head>
            <xsl:for-each select="p">
                <p><xsl:value-of select="current()"/></p>
            </xsl:for-each>
        </arrangement>        
    </xsl:template>  
    <xsl:template match="archdesc/accessrestrict">
        <accessrestrict encodinganalog="506">
            <head>Access Restrictions</head>
            <xsl:for-each select="p">
                <p><xsl:value-of select="current()"/></p>
            </xsl:for-each>
        </accessrestrict>        
    </xsl:template> 
    <xsl:template match="archdesc/userestrict">
        <userestrict encodinganalog="540">
            <head>Use Restrictions</head>
            <xsl:for-each select="p">
                <p><xsl:value-of select="current()"/></p>
            </xsl:for-each>
        </userestrict>        
    </xsl:template> 
    <xsl:template match="archdesc/relatedmaterial">
        <relatedmaterial encodinganalog="544 1">
            <head>Related Material</head>
            <xsl:for-each select="p">
                <p><xsl:value-of select="current()"/></p>
            </xsl:for-each>
        </relatedmaterial>        
    </xsl:template> 
    <xsl:template match="archdesc/accruals">
        <accruals encodinganalog="584">
            <head>Additions</head>
            <xsl:for-each select="p">
                <p><xsl:value-of select="current()"/></p>
            </xsl:for-each>
        </accruals>        
    </xsl:template> 
    <xsl:template match="archdesc/acqinfo">
        <acqinfo encodinganalog="541">
            <head>Acquisition Information</head>
            <xsl:for-each select="p">
                <p><xsl:value-of select="current()"/></p>
            </xsl:for-each>
        </acqinfo>        
    </xsl:template> 
    <xsl:template match="archdesc/custodhist">
        <custodhist encodinganalog="541">
            <head>Custodial History</head>
            <xsl:for-each select="p|lb">
                <p><xsl:value-of select="current()"/></p>
            </xsl:for-each>
        </custodhist>        
    </xsl:template> 
    <xsl:template match="archdesc/separatedmaterial">
        <separatedmaterial encodinganalog="544 0">
            <head>Separated Materials</head>
            <xsl:for-each select="p">
                <p><xsl:value-of select="current()"/></p>
            </xsl:for-each>
        </separatedmaterial>        
    </xsl:template> 
    <xsl:template match="archdesc/altformavail">
        <altformavail encodinganalog="530">
            <head>Other Forms Available</head>
            <xsl:for-each select="p">
                <p><xsl:value-of select="current()"/></p>
            </xsl:for-each>
        </altformavail>        
    </xsl:template> 
    <xsl:template match="archdesc/appraisal"/><!-- empty. copy and modify based on template above-->
     
    <xsl:template match="archdesc/otherfindaid"/>
    
    <!-- To be developed: Add URL to preliminary inventory if <dsc> tag not present 
    <xsl:template match="archdesc[not(dsc)]">
        <dsc type="combined">
            <head>Detailed Description of the Collection</head>
            <p><extref xmlns:xlink="http://www.w3.org/1999/xlink" xlink:type="simple" xlink:show="new" xlink:actuate="onRequest" xlink:href="https://XXXXrepo.atom.url/downloads/[coll#-slug].pdf">A preliminary inventory of the collection is available.</extref> </p>
        </dsc>          
    </xsl:template>-->     
 
    <!-- TARO Template controlaccess loops -->
    <!-- Organizes controlaccess child tags under appropriate headings. You can change the default @source -->
    <xsl:template match="archdesc/controlaccess">
        <controlaccess>
            <head>Index Terms</head>
            <xsl:choose>
                <xsl:when test="persname">
                    <controlaccess>
                        <head>Subjects (Persons)</head>
                        <xsl:for-each select="persname">
                            <persname source="lcnaf" encodinganalog="600"><xsl:value-of select="current()"/></persname>  
                        </xsl:for-each> 
                        <!--<xsl:for-each select="persname">
                            <persname source="local" encodinganalog="600"><xsl:value-of select="current()"/></persname>  
                        </xsl:for-each> -->
                    </controlaccess>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>                
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="corpname">
                    <controlaccess>
                        <head>Subjects (Organizations)</head>
                        <xsl:for-each select="corpname">
                            <corpname source="lcnaf" encodinganalog="610"><xsl:value-of select="current()"/></corpname>
                        </xsl:for-each>
                        <!--<xsl:for-each select="corpname">
                            <corpname source="local" encodinganalog="610"><xsl:value-of select="current()"/></corpname>
                        </xsl:for-each>  -->
                    </controlaccess>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="subject">
                    <controlaccess>
                        <head>Subjects</head>
                        <xsl:for-each select="subject">
                            <subject source="lcsh" encodinganalog="650"><xsl:value-of select="current()"/></subject>
                        </xsl:for-each>
                        <!--<xsl:for-each select="subject">
                            <subject source="local" encodinganalog="650"><xsl:value-of select="current()"/></subject>
                        </xsl:for-each>-->
                    </controlaccess>
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="geogname">
                    <controlaccess>
                        <head>Place</head>
                        <xsl:for-each select="geogname">
                            <geogname source="lcsh" encodinganalog="651"><xsl:value-of select="current()"/></geogname>
                        </xsl:for-each>
                        <!-- <xsl:for-each select="geogname">
                            <geogname source="local" encodinganalog="651"><xsl:value-of select="current()"/></geogname>
                        </xsl:for-each> -->
                    </controlaccess>
                </xsl:when>
                <xsl:otherwise/>      
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="genreform">
                    <controlaccess>
                        <head>Document Types</head>
                        <xsl:for-each select="genreform">
                            <genreform source="aat" encodinganalog="655"><xsl:value-of select="current()"/></genreform>
                        </xsl:for-each>                        
                    </controlaccess>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="occupation">
                    <controlaccess>
                        <head>Occupations</head>
                        <xsl:for-each select="occupation">
                            <occupation source="mesh" encodinganalog="656"><xsl:value-of select="current()"/></occupation>
                        </xsl:for-each>
                        <!--<xsl:for-each select="occupation">
                            <occupation source="lcsh" encodinganalog="656"><xsl:value-of select="current()"/></occupation>
                        </xsl:for-each>-->
                        <!--<xsl:for-each select="occupation">
                            <occupation source="local" encodinganalog="656"><xsl:value-of select="current()"/></occupation>
                        </xsl:for-each>-->
                    </controlaccess>
                </xsl:when>
                <xsl:otherwise/>                
            </xsl:choose>
        </controlaccess>        
    </xsl:template>   
</xsl:stylesheet>
