ZipperContext subclass: #EndOfTraversalContext
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Support'!
!EndOfTraversalContext commentStamp: 'fbs 2/4/2012 22:10' prior: 0!
A context representing the end of a traversal.!


!EndOfTraversalContext methodsFor: 'testing' stamp: 'fbs 2/4/2012 22:29'!
isEnd
	^ true.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

EndOfTraversalContext class
	instanceVariableNames: ''!

!EndOfTraversalContext class methodsFor: 'instance creation' stamp: 'fbs 2/4/2012 23:27'!
trail: aZipperContext
	^ self
		path: aZipperContext path
		leftNodes: aZipperContext leftNodes
		rightNodes: aZipperContext rightNodes
		parentNodes: aZipperContext parentNodes
		changed: aZipperContext changed.! !
