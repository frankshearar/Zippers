Object subclass: #ZipperError
	instanceVariableNames: 'error location'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!
!ZipperError commentStamp: 'fbs 2/9/2012 09:34' prior: 0!
A ZipperError represents an attempt to navigate to an impossible place in some structure - trying to go down to a child node on a leaf node, for instance.

Instance Variables
	error:		<Object>
	location:		<Zipper>

error
	- A Symbol indicating the reason for the error: #downAtLeafNode, #leftAtRootNode, etc.

location
	- The Zipper that caused the error, focused on the node where the error occurred.
!


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
