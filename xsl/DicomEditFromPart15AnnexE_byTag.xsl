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

  NRG DICOM Edit 4 library is written and maintained by the Neuroinformatics
  Research Group at the Washington University School of Medicine. They are made
  available for general use under the 2-clause or Simplified BSD license.

  NEMA PS3 / ISO 12052, Digital Imaging and Communications in Medicine (DICOM)
  Standard, National Electrical Manufacturers Association, Rosslyn, VA, USA
  (available free at http://medical.nema.org/)

  Hints:

  X - remove                                - (gggg,eeee)

  Z - replace with a zero length value      (gggg,eeee) := ""
                                            (gggg,eeee) ~ ".+" : (gggg,eeee) := ""
  D - replace with a non-zero length value
                                            (0010,0020) := session    // Patient ID
                                            (0010,0010) := subject    // Patient's Name
                                            (0008,1030) := project    // Study Description
  U - replace with a non-zero length UID    (gggg,eeee) ~ "\\d[\\d\\.]+" : (gggg,eeee) := hashUID[(gggg,eeee)]
                                            (gggg,eeee) := new UID

-->

<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:docbook="http://docbook.org/ns/docbook"
        exclude-result-prefixes="docbook"
        version="1.0">

    <xsl:strip-space elements="*"/>
    <xsl:output method="text" encoding="utf-8"/>

    <!-- Link to XML extract from DICOM Part 6 -->
    <xsl:variable name="Part6" select="document('../output/PS3.6_AllElements.xml')/DicomElements"/>

    <!-- Find DICOM Part 15 root -->
    <xsl:template match="/">

        <!-- Iterate on document's tables -->
        <xsl:apply-templates select="//docbook:table"/>
    </xsl:template>

    <!-- Find DICOM Part 15 Tables -->
    <xsl:template match="//docbook:table">

        <!--Find DICOM Part 15 Appendix E Table E.1-1 -->
        <xsl:if test="contains(docbook:caption,'Application Level Confidentiality Profile Attributes')">

            <!-- Write header block comments -->
            <xsl:text>// DicomEdit deidentification script automatically generated from DICOM PS3.15</xsl:text>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:text>// by David Wikler</xsl:text><xsl:text disable-output-escaping="yes">&#x20;&lt;</xsl:text><xsl:text>dwikler@ulb.ac.be</xsl:text><xsl:text
                disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:text>&#x0A;//&#x0A;</xsl:text>
            <xsl:text>// Basic Application Level Confidentiality Profile</xsl:text>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:text>//&#x0A;</xsl:text>
            <xsl:text>//     D - replace with a non-zero length value that may be a dummy value and consistent with the VR &#x0A;//     Z - replace with a zero length value, or a non-zero length value that may be a dummy value and consistent with the VR &#x0A;//     X - remove &#x0A;//     U - replace with a non-zero length UID that is internally consistent within a set of Instances &#x0A;//     Z/D - Z unless D is required to maintain IOD conformance (Type 2 versus Type 1) &#x0A;//     X/Z - X unless Z is required to maintain IOD conformance (Type 3 versus Type 2) &#x0A;//     X/D - X unless D is required to maintain IOD conformance (Type 3 versus Type 1) &#x0A;//     X/Z/D - X unless Z or D is required to maintain IOD conformance (Type 3 versus Type 2 versus Type 1) &#x0A;//     X/Z/U* - X unless Z or replacement of contained instance UIDs (U) is required to maintain IOD conformance (Type 3 versus Type 2 versus Type 1 sequences containing UID references) &#x0A;&#x0A;</xsl:text>

            <!-- Set De-identification Method Attribute -->
            <xsl:text>(0012,0062) := "YES"                                                // Patient Identity Removed"&#x0A;</xsl:text>
            <xsl:text>(0012,0063) := "NRG DicomBrowser 1.5.2, DICOM Basic Profile script" // De-identification Method</xsl:text>
            <xsl:text>&#x0A;&#x0A;</xsl:text>

            <!-- Iterate on table's rows -->
            <xsl:apply-templates select="docbook:tbody/docbook:tr">
                <!-- Sort rows by DICOM Tag -->
                <xsl:sort select="docbook:td[2]"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

    <!-- Find table's next row -->
    <xsl:template match="docbook:tbody/docbook:tr">

        <!-- Remove any extra spaces from DICOM tags -->
        <xsl:variable name="tag" select="translate(docbook:td[2],' &#x9;&#xa;','')"/>

        <!-- Basic Application Level Confidentiality Options:
            Add docbook:td[6] != 'K'  for Retain Safe Private Option
            Add docbook:td[7] != 'K'  for Retain UIDs
            Add docbook:td[8] != 'K'  for Retain Device Identity Option
            Add docbook:td[9] != 'K'  for Retain Institution Identity Option
            Add docbook:td[10] != 'K' for Retain Patient Characteristics Option
            Add docbook:td[11] != 'K' for Retain Longitudinal Temporal Information with Full Dates Option
            Add docbook:td[12] != 'K' for Retain Longitudinal Temporal Information with Modified Dates Option
        -->

        <!-- Select rows corresponding to some criteria you define. Here, all except private elements -->
        <xsl:if test="not(contains($tag, '(gggg,eeee)'))">

            <!-- Set each selected DICOM attribute -->
            <xsl:value-of select="$tag"/>

            <!--Write Basic Confidentiality Profile information, VR and Name as comment-->
            <xsl:text>&#x9;&#x9;//&#x20;</xsl:text>
            <xsl:value-of select="docbook:td[5]"/>
            <xsl:call-template name="spaces">
                <xsl:with-param name="n" select="6 - string-length(docbook:td[5])"/>
            </xsl:call-template>
            <xsl:text>&#x20; - &#x20;</xsl:text>
            <xsl:value-of select="$Part6/DicomDataAttrbute[@Tag=$tag]/@VR"/>
            <xsl:text>&#x20;</xsl:text>
            <xsl:value-of select="docbook:td[1]"/>
            <xsl:text>&#x0A;</xsl:text>

        </xsl:if>
    </xsl:template>

    <!-- Write n spaces -->
    <xsl:template name="spaces">
        <xsl:param name="n"/>
        <xsl:if test="$n > 0">
            <xsl:call-template name="spaces">
                <xsl:with-param name="n" select="$n - 1"/>
            </xsl:call-template>
            <xsl:text>&#x20;</xsl:text>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>