Object subclass: #TreeZipperNode
	instanceVariableNames: 'leftNodes rightNodes path changed visitedNodes'
	classVariableNames: 'End'
	poolDictionaries: ''
	category: 'Zippers'!
!TreeZipperNode commentStamp: 'fbs 1/1/2011 18:01' prior: 0!
I am a recursive structure that describes a path through a tree.

  self path

 refers to the previous position in the path, itself a TreeZipperNode. The first entry in a path has

  self path == nil

Being part of a zipper, I naturally represent a context-with-a-hole - that part of a tree minus the part currently under focus.!


!TreeZipperNode methodsFor: 'accessing' stamp: 'fbs 10/17/2011 17:52'!
changed
	^ changed.! !

!TreeZipperNode methodsFor: 'accessing' stamp: 'fbs 12/31/2010 00:19'!
leftNodes
	^ leftNodes! !

!TreeZipperNode methodsFor: 'accessing' stamp: 'fbs 12/20/2011 12:22'!
parentNode
	^ visitedNodes last.! !

!TreeZipperNode methodsFor: 'accessing' stamp: 'fbs 12/31/2010 16:22'!
path
	^ path.! !

!TreeZipperNode methodsFor: 'accessing' stamp: 'fbs 12/31/2010 00:19'!
rightNodes
	^ rightNodes.! !

!TreeZipperNode methodsFor: 'accessing' stamp: 'fbs 10/17/2011 18:00'!
visitedNodes
	^ visitedNodes! !


!TreeZipperNode methodsFor: 'private' stamp: 'fbs 12/20/2011 11:45'!
path: aTreeZipperTrail leftNodes: leftCollection rightNodes: rightCollection visitedNodes: someObjects changed: aBoolean
	path := aTreeZipperTrail.
	leftNodes := leftCollection.
	rightNodes := rightCollection.
	visitedNodes := someObjects.
	changed := aBoolean.! !



!TreeZipperNode methodsFor: 'testing' stamp: 'fbs 10/18/2011 16:20'!
isEnd
	^ false.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

TreeZipperNode class
	instanceVariableNames: ''!

!TreeZipperNode class methodsFor: 'instance creation' stamp: 'fbs 10/18/2011 08:17'!
end
	^ End.! !

!TreeZipperNode class methodsFor: 'instance creation' stamp: 'fbs 12/20/2011 11:47'!
path: aTreeZipperTrail leftNodes: leftCollection rightNodes: rightCollection visitedNodes: someObjects changed: aBoolean
	^ self new
		path: aTreeZipperTrail
		leftNodes: leftCollection
		rightNodes: rightCollection
		visitedNodes: someObjects
		changed: aBoolean.! !


!TreeZipperNode class methodsFor: 'class initialization' stamp: 'fbs 10/18/2011 16:19'!
initialize
	End := TreeZipperNodeEndContext new.! !


TreeZipperNode initialize!
eZipperNodeEndContext new.! !


TreeZipperNode initialize!
tNodes: leftCollection
		rightNodes: rightCollection
		parentNodes: someObjects
		changed: aBoolean.! !


!TreeZipperNode class methodsFor: 'class initialization' stamp: 'fbs 10/18/2011 16:19'!
initialize
	End := TreeZipperNodeEndContext new.! !


TreeZipperNode initialize!
