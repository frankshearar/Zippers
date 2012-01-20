Object subclass: #TreeZipperTrail
	instanceVariableNames: 'value zipper'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!

!TreeZipperTrail methodsFor: 'accessing' stamp: 'fbs 12/30/2010 23:45'!
value
	^ value.! !

!TreeZipperTrail methodsFor: 'accessing' stamp: 'fbs 12/30/2010 23:48'!
zipper
	^ zipper.! !


!TreeZipperTrail methodsFor: 'private' stamp: 'fbs 12/30/2010 23:47'!
value: anObject zipper: aListZipper
	value := anObject.
	zipper := aListZipper.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

TreeZipperTrail class
	instanceVariableNames: ''!

!TreeZipperTrail class methodsFor: 'instance creation' stamp: 'fbs 12/30/2010 23:46'!
value: anObject zipper: aListZipper
	^ self new value: anObject zipper: aListZipper.! !
