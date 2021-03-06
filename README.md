AtoM 2 TARO XSLT Conversion (atom2taro)
=====
See [atom2taro-documentation.pdf](atom2taro-documentation.pdf)

## About
AtoM to TARO XSLT Conversion (atom2taro) facilitates XML export from the Access to Memory (AtoM) Archival Management System to a compliant XML import into Texas Archival Resources Online (TARO) system. The stylesheet converts the EAD02002 XML export from AtoM and conforms the data to comply with TARO best practices and schema-based XML template.

Created by Sandra Yates, [McGovern Historical Center, Texas Medical Center Library](https://archives.library.tmc.edu/), July 14, 2021. The code is maintained and updated to address development changes in AtoM and/or TARO. Updates can be found at [github.com/sane8s/atom2taro](https://github.com/sane8s/atom2taro). Collaboration and recommendations are welcome. More details about the archival systems at [txarchives.org](https://txarchives.org/) and [accesstomemory.org](https://www.accesstomemory.org/).

The code is based on the dtd2schema.xsl EAD DTD to Schema XSLT Conversion Version 200701 Alpha. Editors: Stephen Yearl (Yale) and Daniel V. Pitti (Virginia).
There is also modified code from ead-schema-to-dtd.xsl, developed by Woodson Research Center, Fondren Library, Rice University, that converts c tags to <c##> hierarchy.

## How to Use
1. Download and save atom2taro.xsl to an accessible file location for staff.
2. Customize atom2taro.xsl for your repository according to the options outlined above (in documentation pdf).
3. Change ‘repo-’ to your repository abbreviation to indicate that it is your customized version.
4. Create transformation scenarios in your XML editor (like, Oxygen)
5. Export XML file(s) from AtoM site and save file(s) to computer or accessible location for staff.
6. Open exported XML file in XML Editor (like Oxygen)
7. Run atom2taro
8. After atom2taro, review, modify, and validate new XML file. See Finishing Up section in [atom2taro-documentation.pdf](atom2taro-documentation.pdf)
    1. Modify ead tag attributes (line 2)
    2. Review eadid tag. Confirm TARO User and 5-digit TARO# (line 4)
    3. Modify archdesc tag attributes (line 30)
    4. Review <origination> to determine appropriate @source, lcnaf or local. Delete extra <*name> tags (line 35)
    5. Validate extref tag (line 47)
    6. Review controlaccess child tags to determine appropriate values for source attribute.
    7. (optional for collection-level descriptions) Add dsc tag at the end of archdesc tag that links to uploaded PDF inventory. (bottom of XML file)

Contact: Sandra for support.
