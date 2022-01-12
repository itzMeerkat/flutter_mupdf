<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

read, render, create or modify pdf, all in one(but not all implemented yet).

## Features
* Read PDF
* Get page count of a pdf.
* Rasterize PDF page to `ui.Image`
* Extract texts and its format information from PDF.

## Getting started
Since this package is a wrapper, it is not very dart. But no worries, MuPdf has neat API design and its already easy to use.
Basically all you need to pay attention is, always call `clearMuPdf` for every unused `MuPdfInst`. Otherwise there will be memory leak.

## Usage
Please refer to test for now.

## Additional information
Since MuPdf is licensed under AGPLv3, this package will also licensed under the same license.
