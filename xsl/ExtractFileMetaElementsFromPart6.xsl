<!--

  DicomTribe project

  DicomEditFromPart15AnnexEByTagCOIDRtnTemp.xsl (2018-05-01)

  An XSLT stylesheet for generating DicomEdit script from DICOM Standard Part 15,

  by David Wikler <david.wikler@ulb.ac.be>.

  Copyright 2018 David Wikler
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  Credits:

  NEMA PS3 / ISO 12052, Digital Imaging and Communications in Medicine (DICOM)
  Standard, National Electrical Manufacturers Association, Rosslyn, VA, USA
  (available free at http://medical.nema.org/)

-->

<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:docbook="http://docbook.org/ns/docbook"
        exclude-result-prefixes="docbook"
        version="1.0">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes" indent="yes"/>

    <!-- Find DICOM Part 6 root -->
    <xsl:template match="/">
        <xsl:apply-templates select="//docbook:table"/>
    </xsl:template>

    <!-- Find DICOM Part 6 Tables -->
    <xsl:template match="//docbook:table">
        <!--Find DICOM Part 6 Table 7-1. Registry of DICOM File Meta Elements-->
        <xsl:if test="contains(docbook:caption,'Registry of DICOM File Meta Elements')">
            <xsl:element name="DicomFileMetaElements">
                <xsl:text>&#x0A;</xsl:text>
                <!-- Iterate on table's rows -->
                <xsl:apply-templates select="docbook:tbody/docbook:tr"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <!-- Find table's next row -->
    <xsl:template match="docbook:tbody/docbook:tr">

        <!--Write DICOM file meta element information in XML according to PS3.19 Native DICOM model schema-->
        <xsl:element name="DicomDataAttrbute">
            <xsl:attribute name="Tag">
                <xsl:value-of select="docbook:td[1]"/>
            </xsl:attribute>
            <xsl:attribute name="VR">
                <xsl:value-of select="docbook:td[4]"/>
            </xsl:attribute>
            <xsl:attribute name="VM">
                <xsl:value-of select="docbook:td[5]"/>
            </xsl:attribute>
            <xsl:attribute name="Keyword">
                <xsl:value-of select="docbook:td[3]"/>
            </xsl:attribute>
            <xsl:attribute name="Name">
                <xsl:value-of select="docbook:td[2]"/>
            </xsl:attribute>
            <xsl:attribute name="Comment">
                <xsl:value-of select="docbook:td[6]"/>
            </xsl:attribute>
            <!--Uncomment to add closing tag instead of self-closing tag-->
            <!--<xsl:text>&#xA0;</xsl:text>-->
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>

