Object subclass: #ZipperError
	instanceVariableNames: 'error location'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!

!ZipperError methodsFor: 'accessing' stamp: 'fbs 2/5/2012 08:18'!
error
	^ error.! !

!ZipperError methodsFor: 'accessing' stamp: 'fbs 2/5/2012 08:18'!
location
	^ location.! !


!ZipperError methodsFor: 'private' stamp: 'fbs 2/5/2012 08:19'!
error: aSymbol location: aZipper
	error := aSymbol.
	location := aZipper.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ZipperError class
	instanceVariableNames: ''!

!ZipperError class methodsFor: 'instance creation' stamp: 'fbs 2/5/2012 08:18'!
error: aSymbol location: aZipper
	^ self new error: aSymbol location: aZipper.! !
