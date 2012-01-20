TreeZipperNode subclass: #TreeZipperNodeEndContext
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!

!TreeZipperNodeEndContext methodsFor: 'accessing' stamp: 'fbs 10/18/2011 16:27'!
changed
	^ false.! !

!TreeZipperNodeEndContext methodsFor: 'accessing' stamp: 'fbs 10/31/2011 22:01'!
leftNodes
	^ #()! !

!TreeZipperNodeEndContext methodsFor: 'accessing' stamp: 'fbs 11/1/2011 07:59'!
path
	"This lets us avoid unsightly conditionals in the zipper: the path of no path is no path. Zipping up isn't a problem because #safeUp checks #isEnd."
	^ self.! !

!TreeZipperNodeEndContext methodsFor: 'accessing' stamp: 'fbs 10/31/2011 22:00'!
rightNodes
	^ #()! !

!TreeZipperNodeEndContext methodsFor: 'accessing' stamp: 'fbs 10/18/2011 16:26'!
visitedNodes
	^ #().! !


!TreeZipperNodeEndContext methodsFor: 'testing' stamp: 'fbs 10/18/2011 16:20'!
isEnd
	^ true.! !
