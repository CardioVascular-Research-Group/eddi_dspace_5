<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:doc="http://www.lyncode.com/xoai"
	version="1.0">
	<xsl:output method="text" />

<xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>
<xsl:variable name='tab'><xsl:text>   </xsl:text></xsl:variable>
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='type']/doc:element/doc:field[@name='value']/text() = 'article'">
				<xsl:text>TY  - RPRT</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>TY  - JOUR</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$newline"></xsl:value-of>
			
		<xsl:text>TI  - </xsl:text>
		<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='title']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
			
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='uri']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>AN  - </xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='uri']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>
		
		<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='author']/doc:element/doc:field[@name='value']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>AU  - </xsl:text>
			<xsl:value-of select="."></xsl:value-of>
		</xsl:for-each>
			
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='source']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>T2  - </xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='source']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>
			
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='date']/doc:element[@name='issued']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>PY  - </xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='date']/doc:element[@name='issued']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>
		
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='date']/doc:element[@name='issued']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>DA  - </xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='date']/doc:element[@name='issued']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>
		
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='source']/doc:element[@name='volume']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>VL  - </xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='source']/doc:element[@name='volume']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>
		
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='source']/doc:element[@name='issue']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>IS  - </xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='source']/doc:element[@name='issue']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>
			
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='description']/doc:element[@name='abstract']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>AB  - </xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='description']/doc:element[@name='abstract']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>
			
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='description']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>AB  - </xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='description']/doc:element[@name='abstract']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>
		
		<xsl:value-of select="$newline"></xsl:value-of>
		<xsl:text>DB  - Electrophysiology Data Discovery Index (EDDI)</xsl:text>
		
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='doi']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>DO  - </xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='doi']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>
			
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='uri']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>UR  -  URI to cite or link to this item: </xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='uri']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>
			
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='pmid']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>UR  - Pubmed ID: http://www.ncbi.nlm.nih.gov/pubmed/?term=</xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='pmid']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>
		
		<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='datasets']/doc:element/doc:field[@name='value']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>UR  - Referenced Datasets: http://hdl.handle.net/</xsl:text>
			<xsl:value-of select="."></xsl:value-of>
		</xsl:for-each>	
			
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='accessurl']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>UR  - Data Access URL(s): </xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='accessurl']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>	
			
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='citationpub']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>UR  - Data Use Citation: </xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='citationpub']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>	
			
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='piname']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>N1  - P.I. Name: </xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='piname']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>		
			
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='piemail']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>N1  - P.I. Email: </xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='piemail']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>		
			
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='piaffiliation']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>N1  - P.I. Affiliation: </xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='piaffiliation']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>		
			
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='dataformat']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>N1  - Data Format: </xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='dataformat']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>	
			
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='accessrestrictions']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>N1  - Access Restrictions: </xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='accessrestrictions']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>
			
		<xsl:if test="doc:metadata/doc:element[@name='dc']/doc:element[@name='language']/doc:element[@name='iso']">
			<xsl:value-of select="$newline"></xsl:value-of>
			<xsl:text>LA  - </xsl:text>
			<xsl:value-of select="doc:metadata/doc:element[@name='dc']/doc:element[@name='language']/doc:element[@name='iso']/doc:element/doc:field[@name='value']/text()"></xsl:value-of>
		</xsl:if>
			
		<xsl:value-of select="$newline"></xsl:value-of>
		<xsl:text>ER  - </xsl:text>
	</xsl:template>
</xsl:stylesheet>