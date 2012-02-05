ZipperContext subclass: #RootContext
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!
!RootContext commentStamp: 'fbs 2/4/2012 22:10' prior: 0!
A context representing the start of a traversal.!


!RootContext methodsFor: 'accessing' stamp: 'fbs 10/18/2011 16:27'!
changed
	^ false.! !

!RootContext methodsFor: 'accessing' stamp: 'fbs 10/31/2011 22:01'!
leftNodes
	^ #()! !

!RootContext methodsFor: 'accessing' stamp: 'fbs 12/20/2011 20:39'!
parentNodes
	^ #().! !

!RootContext methodsFor: 'accessing' stamp: 'fbs 11/1/2011 07:59'!
path
	"This lets us avoid unsightly conditionals in the zipper: the path of no path is no path. Zipping up isn't a problem because #safeUp checks #isEnd."
	^ self.! !

!RootContext methodsFor: 'accessing' stamp: 'fbs 10/31/2011 22:00'!
rightNodes
	^ #()! !


!RootContext methodsFor: 'testing' stamp: 'fbs 2/4/2012 22:28'!
isRoot
	^ true.! !
