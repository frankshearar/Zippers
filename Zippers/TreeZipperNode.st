Object subclass: #TreeZipperNode
	instanceVariableNames: 'leftNodes rightNodes path value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!
!TreeZipperNode commentStamp: 'fbs 12/31/2010 18:37' prior: 0!
I am a recursive structure that describes a path through a tree.

  self path

 refers to the previous position in the path, itself a TreeZipperNode. The first entry in a path has

  self path == nil!


!TreeZipperNode methodsFor: 'accessing' stamp: 'fbs 12/31/2010 00:19'!
leftNodes
	^ leftNodes! !

!TreeZipperNode methodsFor: 'accessing' stamp: 'fbs 12/31/2010 16:22'!
path
	^ path.! !

!TreeZipperNode methodsFor: 'accessing' stamp: 'fbs 12/31/2010 00:19'!
rightNodes
	^ rightNodes.! !

!TreeZipperNode methodsFor: 'accessing' stamp: 'fbs 12/31/2010 17:06'!
value
	^ value.! !


!TreeZipperNode methodsFor: 'private' stamp: 'fbs 12/31/2010 17:07'!
path: aTreeZipperTrail value: anObject leftNodes: leftCollection rightNodes: rightCollection
	path := aTreeZipperTrail.
	value := anObject.
	leftNodes := leftCollection.
	rightNodes := rightCollection.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

TreeZipperNode class
	instanceVariableNames: ''!

!TreeZipperNode class methodsFor: 'instance creation' stamp: 'fbs 12/31/2010 17:07'!
path: aTreeZipperTrail value: anObject leftNodes: leftCollection rightNodes: rightCollection
	^ self new
		path: aTreeZipperTrail
		value: anObject
		leftNodes: leftCollection
		rightNodes: rightCollection.! !
	^ rightNodes.! !


!TreeZipperNode methodsFor: 'testing' stamp: 'fbs 10/18/2011 16:20'!
isEnd
	^ false.! !


!TreeZipperNode methodsFor: 'private' stamp: 'fbs 12/20/2011 20:36'!
path: aTreeZipperTrail leftNodes: leftCollection rightNodes: rightCollection parentNodes: someObjects changed: aBoolean
	path := aTreeZipperTrail.
	leftNodes := leftCollection.
	rightNodes := rightCollection.
	visitedNodes := someObjects.
	changed := aBoolean.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

TreeZipperNode class
	instanceVariableNames: ''!

!TreeZipperNode class methodsFor: 'instance creation' stamp: 'fbs 10/18/2011 08:17'!
end
	^ End.! !

!TreeZipperNode class methodsFor: 'instance creation' stamp: 'fbs 12/20/2011 20:37'!
path: aTreeZipperTrail leftNodes: leftCollection rightNodes: rightCollection parentNodes: someObjects changed: aBoolean
	^ self new
		path: aTreeZipperTrail
		leftNodes: leftCollection
		rightNodes: rightCollection
		parentNodes: someObjects
		changed: aBoolean.! !


!TreeZipperNode class methodsFor: 'class initialization' stamp: 'fbs 10/18/2011 16:19'!
initialize
	End := TreeZipperNodeEndContext new.! !


TreeZipperNode initialize!
