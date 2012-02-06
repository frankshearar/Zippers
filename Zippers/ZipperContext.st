Object subclass: #ZipperContext
	instanceVariableNames: 'leftNodes rightNodes path changed visitedNodes'
	classVariableNames: 'Root'
	poolDictionaries: ''
	category: 'Zippers'!
!ZipperContext commentStamp: 'fbs 12/20/2011 20:42' prior: 0!
I am a recursive structure that describes a path through a tree.

  self path

 refers to the previous position in the path, itself a TreeZipperNode. The first entry in a path has

  self path == nil

Being part of a zipper, I naturally represent a context-with-a-hole - that part of a tree minus the part currently under focus.

leftNodes: my siblings to the left (or, those siblings processed before me in a pre-order traversal)
rightNodes: my siblings to the right
parentNodes: an array containing the reverse path needed to reach the original node visited by my zipper.
changed: true if I represent a changed context - the addition or removal of a sibling, etc.!


!ZipperContext methodsFor: 'accessing' stamp: 'fbs 10/17/2011 17:52'!
changed
	^ changed.! !

!ZipperContext methodsFor: 'accessing' stamp: 'fbs 12/31/2010 00:19'!
leftNodes
	^ leftNodes! !

!ZipperContext methodsFor: 'accessing' stamp: 'fbs 12/20/2011 12:22'!
parentNode
	^ visitedNodes last.! !

!ZipperContext methodsFor: 'accessing' stamp: 'fbs 12/20/2011 20:38'!
parentNodes
	^ visitedNodes! !

!ZipperContext methodsFor: 'accessing' stamp: 'fbs 12/31/2010 16:22'!
path
	^ path.! !

!ZipperContext methodsFor: 'accessing' stamp: 'fbs 12/31/2010 00:19'!
rightNodes
	^ rightNodes.! !


!ZipperContext methodsFor: 'private' stamp: 'fbs 12/20/2011 20:36'!
path: aTreeZipperTrail leftNodes: leftCollection rightNodes: rightCollection parentNodes: someObjects changed: aBoolean
	path := aTreeZipperTrail.
	leftNodes := leftCollection.
	rightNodes := rightCollection.
	visitedNodes := someObjects.
	changed := aBoolean.! !



!ZipperContext methodsFor: 'testing' stamp: 'fbs 10/18/2011 16:20'!
isEnd
	^ false.! !

!ZipperContext methodsFor: 'testing' stamp: 'fbs 2/4/2012 22:38'!
isRoot
	^ false.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ZipperContext class
	instanceVariableNames: ''!

!ZipperContext class methodsFor: 'instance creation' stamp: 'fbs 12/20/2011 20:37'!
path: aTreeZipperTrail leftNodes: leftCollection rightNodes: rightCollection parentNodes: someObjects changed: aBoolean
	^ self new
		path: aTreeZipperTrail
		leftNodes: leftCollection
		rightNodes: rightCollection
		parentNodes: someObjects
		changed: aBoolean.! !

!ZipperContext class methodsFor: 'instance creation' stamp: 'fbs 2/4/2012 22:43'!
root
	^ Root.! !


!ZipperContext class methodsFor: 'class initialization' stamp: 'fbs 2/4/2012 22:43'!
initialize
	Root := RootContext new.! !


ZipperContext initialize!
 stamp: 'fbs 2/4/2012 22:43'!
initialize
	Root := RootContext new.! !


ZipperContext initialize!
