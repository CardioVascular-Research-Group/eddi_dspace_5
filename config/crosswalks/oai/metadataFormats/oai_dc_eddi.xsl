<?xml version="1.0" encoding="UTF-8" ?>
<!-- 


    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/
	Developed by DSpace @ Lyncode <dspace@lyncode.com>
	
	> http://www.openarchives.org/OAI/2.0/oai_dc.xsd

 -->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:doc="http://www.lyncode.com/xoai"
	version="1.0">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes" />
	
	<xsl:template match="/">
		<oai_dc_eddi:dc xmlns:oai_dc_eddi="http://www.cvrgrid.org/files/oai_dc_eddi/" 
			xmlns:dc="http://purl.org/dc/elements/1.1/" 
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
			xsi:schemaLocation="http://www.cvrgrid.org/files/oai_dc_eddi/ http://www.cvrgrid.org/files/oai_dc_eddi/oai_dc_eddi_v0.2.xsd">
			<!-- dc.title -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='title']/doc:element/doc:field[@name='value']">
				<dc:title><xsl:value-of select="." /></dc:title>
			</xsl:for-each>
			<!-- dc.title.* -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='title']/doc:element/doc:element/doc:field[@name='value']">
				<dc:title><xsl:value-of select="." /></dc:title>
			</xsl:for-each>
			<!-- dc.creator -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='creator']/doc:element/doc:field[@name='value']">
				<dc:creator><xsl:value-of select="." /></dc:creator>
			</xsl:for-each>
			<!-- dc.contributor.author -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='author']/doc:element/doc:field[@name='value']">
				<dc:creator><xsl:value-of select="." /></dc:creator>
			</xsl:for-each>
			<!-- dc.contributor.* (!author) -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name!='author']/doc:element/doc:field[@name='value']">
				<dc:contributor><xsl:value-of select="." /></dc:contributor>
			</xsl:for-each>
			<!-- dc.contributor -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element/doc:field[@name='value']">
				<dc:contributor><xsl:value-of select="." /></dc:contributor>
			</xsl:for-each>
			<!-- dc.subject -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='subject']/doc:element/doc:field[@name='value']">
				<dc:subject><xsl:value-of select="." /></dc:subject>
			</xsl:for-each>
			<!-- dc.subject.* -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='subject']/doc:element/doc:element/doc:field[@name='value']">
				<dc:subject><xsl:value-of select="." /></dc:subject>
			</xsl:for-each>
			<!-- dc.description -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='description']/doc:element/doc:field[@name='value']">
				<dc:description><xsl:value-of select="." /></dc:description>
			</xsl:for-each>
			<!-- dc.description.* (not provenance)-->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='description']/doc:element[@name!='provenance']/doc:element/doc:field[@name='value']">
				<dc:description><xsl:value-of select="." /></dc:description>
			</xsl:for-each>
			<!-- dc.date.accessioned (remove this field from display)-->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='date']/doc:element[@name='accessioned']/doc:element/doc:field[@name='value']">
			</xsl:for-each>
			<!-- dc.date.issued -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='date']/doc:element[@name='issued']/doc:element/doc:field[@name='value']">
				<dc:date_published><xsl:value-of select="." /></dc:date_published>
			</xsl:for-each>
			<!-- dc.date.available -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='date']/doc:element[@name='available']/doc:element/doc:field[@name='value']">
				<dc:date_eddi-indexed><xsl:value-of select="." /></dc:date_eddi-indexed>
			</xsl:for-each>
			<!-- dc.type -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='type']/doc:element/doc:field[@name='value']">
				<dc:type><xsl:value-of select="." /></dc:type>
			</xsl:for-each>
			<!-- dc.type.* -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='type']/doc:element/doc:element/doc:field[@name='value']">
				<dc:type><xsl:value-of select="." /></dc:type>
			</xsl:for-each>
			<!-- dc.identifier -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element/doc:field[@name='value']">
				<dc:identifier><xsl:value-of select="." /></dc:identifier>
			</xsl:for-each>
			<!-- dc.identifier.* -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element/doc:element/doc:field[@name='value']">
				<dc:identifier><xsl:value-of select="." /></dc:identifier>
			</xsl:for-each>
			<!-- dc.language -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='language']/doc:element/doc:field[@name='value']">
				<dc:language><xsl:value-of select="." /></dc:language>
			</xsl:for-each>
			<!-- dc.language.* -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='language']/doc:element/doc:element/doc:field[@name='value']">
				<dc:language><xsl:value-of select="." /></dc:language>
			</xsl:for-each>
			<!-- dc.relation -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='relation']/doc:element/doc:field[@name='value']">
				<dc:relation><xsl:value-of select="." /></dc:relation>
			</xsl:for-each>
			<!-- dc.relation.* -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='relation']/doc:element/doc:element/doc:field[@name='value']">
				<dc:relation><xsl:value-of select="." /></dc:relation>
			</xsl:for-each>
			<!-- dc.rights -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field[@name='value']">
				<dc:rights><xsl:value-of select="." /></dc:rights>
			</xsl:for-each>
			<!-- dc.rights.* -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:element/doc:field[@name='value']">
				<dc:rights><xsl:value-of select="." /></dc:rights>
			</xsl:for-each>
			<!-- dc.format -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='format']/doc:element/doc:field[@name='value']">
				<dc:format><xsl:value-of select="." /></dc:format>
			</xsl:for-each>
			<!-- dc.format.* -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='format']/doc:element/doc:element/doc:field[@name='value']">
				<dc:format><xsl:value-of select="." /></dc:format>
			</xsl:for-each>
			<!-- ? -->
			<xsl:for-each select="doc:metadata/doc:element[@name='bitstreams']/doc:element[@name='bitstream']/doc:field[@name='format']">
				<dc:format><xsl:value-of select="." /></dc:format>
			</xsl:for-each>
			<!-- dc.coverage -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='coverage']/doc:element/doc:field[@name='value']">
				<dc:coverage><xsl:value-of select="." /></dc:coverage>
			</xsl:for-each>
			<!-- dc.coverage.* -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='coverage']/doc:element/doc:element/doc:field[@name='value']">
				<dc:coverage><xsl:value-of select="." /></dc:coverage>
			</xsl:for-each>
			<!-- dc.publisher -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='publisher']/doc:element/doc:field[@name='value']">
				<dc:publisher><xsl:value-of select="." /></dc:publisher>
			</xsl:for-each>
			<!-- dc.publisher.* -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='publisher']/doc:element/doc:element/doc:field[@name='value']">
				<dc:publisher><xsl:value-of select="." /></dc:publisher>
			</xsl:for-each>
			<!-- dc.source -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='source']/doc:element/doc:field[@name='value']">
				<dc:source><xsl:value-of select="." /></dc:source>
			</xsl:for-each>
			<!-- dc.source.* -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='source']/doc:element/doc:element/doc:field[@name='value']">
				<dc:source><xsl:value-of select="." /></dc:source>
			</xsl:for-each>
			<!-- dc.ecg.* -->
<!-- 			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element/doc:element/doc:field[@name='value']">
				<dc:ecg><xsl:value-of select="." /></dc:ecg>
			</xsl:for-each> -->
			<!-- dc.ecg.description -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='description']/doc:element/doc:field[@name='value']">
				<dc:eddi_description><xsl:value-of select="." /></dc:eddi_description>
			</xsl:for-each>
			<!-- dc.ecg.accessurl -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='accessurl']/doc:element/doc:field[@name='value']">
				<dc:eddi_accessurl><xsl:value-of select="." /></dc:eddi_accessurl>
			</xsl:for-each>
			<!-- dc.ecg.accessrestrictions -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='accessrestrictions']/doc:element/doc:field[@name='value']">
				<dc:eddi_accessrestrictions><xsl:value-of select="." /></dc:eddi_accessrestrictions>
			</xsl:for-each>
			<!-- dc.ecg.datatype -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='datatype']/doc:element/doc:field[@name='value']">
				<dc:eddi_datatype><xsl:value-of select="." /></dc:eddi_datatype>
			</xsl:for-each>
			<!-- dc.ecg.dataformat -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='dataformat']/doc:element/doc:field[@name='value']">
				<dc:eddi_dataformat><xsl:value-of select="." /></dc:eddi_dataformat>
			</xsl:for-each>
			<!-- dc.ecg.pubmedsearch -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='pubmedsearch']/doc:element/doc:field[@name='value']">
				<dc:eddi_pubmedsearch><xsl:value-of select="." /></dc:eddi_pubmedsearch>
			</xsl:for-each>
			<!-- dc.ecg.dataaccessurl -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='dataaccessurl']/doc:element/doc:field[@name='value']">
				<dc:eddi_dataaccessurl><xsl:value-of select="." /></dc:eddi_dataaccessurl>
			</xsl:for-each>
			<!-- dc.ecg.piname -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='piname']/doc:element/doc:field[@name='value']">
				<dc:eddi_piname><xsl:value-of select="." /></dc:eddi_piname>
			</xsl:for-each>
			<!-- dc.ecg.piemail -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='piemail']/doc:element/doc:field[@name='value']">
				<dc:eddi_piemail><xsl:value-of select="." /></dc:eddi_piemail>
			</xsl:for-each>
			<!-- dc.ecg.piaffiliation -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='piaffiliation']/doc:element/doc:field[@name='value']">
				<dc:eddi_piaffiliation><xsl:value-of select="." /></dc:eddi_piaffiliation>
			</xsl:for-each>
			<!-- dc.ecg.granttitle -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='granttitle']/doc:element/doc:field[@name='value']">
				<dc:eddi_granttitle><xsl:value-of select="." /></dc:eddi_granttitle>
			</xsl:for-each>
			<!-- dc.ecg.grantnumber -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='grantnumber']/doc:element/doc:field[@name='value']">
				<dc:eddi_grantnumber><xsl:value-of select="." /></dc:eddi_grantnumber>
			</xsl:for-each>
			<!-- dc.ecg.citationpub -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='citationpub']/doc:element/doc:field[@name='value']">
				<dc:eddi_citationpub><xsl:value-of select="." /></dc:eddi_citationpub>
			</xsl:for-each>
			<!-- dc.ecg.datasets -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='datasets']/doc:element/doc:field[@name='value']">
				<dc:eddi_datasets><xsl:value-of select="." /></dc:eddi_datasets>
			</xsl:for-each>
			<!-- dc.ecg.globusendpointname -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='globusendpointname']/doc:element/doc:field[@name='value']">
				<dc:eddi_globusendpointname><xsl:value-of select="." /></dc:eddi_globusendpointname>
			</xsl:for-each>
			<!-- dc.ecg.globusendpointpath -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='ecg']/doc:element[@name='globusendpointpath']/doc:element/doc:field[@name='value']">
				<dc:eddi_globusendpointpath><xsl:value-of select="." /></dc:eddi_globusendpointpath>
			</xsl:for-each>
		</oai_dc_eddi:dc>
	</xsl:template>
</xsl:stylesheet>
