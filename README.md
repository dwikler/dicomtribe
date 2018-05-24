<!-- ![XSLT.1.0](https://img.shields.io/badge/XSLT-1.0-brightgreen.svg)
![standard.DICOM](https://img.shields.io/badge/standard-DICOM-lightgrey.svg)
![license.apache-2.0](https://img.shields.io/badge/license-apache--2.0-blue.svg)
-->

![XSLT.1.0](https://github.com/dwikler/dicomtribe/badges/XSLT-1.0-brightgreen.svg)
![standard.DICOM](https://github.com/dwikler/dicomtribe/badges/standard-DICOM-lightgrey.svg)
![license.apache-2.0](https://github.com/dwikler/dicomtribe/badges/license-apache--2.0-blue.svg)

# DICOM Tribe

XSLT stylesheets to convert DICOM standard DocBook XML to formats useful for programmers.

## Introduction

Tribal knowledge is a concept I learned while participating in DICOM activities. This project is a tentative to share some of this knowledge and some associated tools.

### Prerequisites

[The DICOM standard DocBook XML version `dicom`](https://www.dicomstandard.org/current/)

An XSLT processor (xsltproc, Xalan, Saxon, ...)

### Installing

Download or Checkout the XSL stylesheets from the GitHub repository.

```
$ git clone https://github.com/dwikler/dicomtribe
```

Verify that you have an XSLT processor such as xsltproc available 

```
$ xsltproc --version
```

Download the latest versions of DICOM standard in DocBook XML to the standard folder 

```
$ cd standard
$ curl -O http://dicom.nema.org/medical/dicom/current/source/docbook/part06/part06.xml
```

Process the DocBook XML document using one of the stylesheet
```
$ cd ..
$ xsltproc -o output/PS3.6_DataElements.xml xsl/ExtractDataElementsFromPart6.xsl standard/part06.xml
```

### Documentation

[see Wiki](../../wiki)

 
## Authors

* **David Wikler** - [dwikler](https://github.com/dwikler)

## License

Copyright 2018 David Wikler
  
This project is licensed under the Apache License, Version 2.0 - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

Great projects linked to this work

* [David Clunie Documentation and Code `dclunie`](http://www.dclunie.com/)
* [Mathieu Malaterre Code `malaterre`](https://github.com/malaterre)
* [Kevin A. Archie scripts `DicomEdit`](https://bitbucket.org/xnatdcm/dicom-edit4)
* [XNAT project `XNAT`](https://www.xnat.org/)

