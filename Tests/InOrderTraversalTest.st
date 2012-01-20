TraversalTestCase subclass: #InOrderTraversalTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Tests'!

!InOrderTraversalTest methodsFor: 'running' stamp: 'fbs 2/24/2011 17:37'!
makeTraversal
	^ InOrderTraversal new.! !


!InOrderTraversalTest methodsFor: 'testing - enumerating' stamp: 'fbs 2/28/2011 17:46'!
testCollectEnumeratesCorrectly
	| i tree |
	tree := ZTree value: 1 children: {ZTree value: 2 children: {ZTree value: 3. ZTree value: 4}. ZTree value: 5}.
	i := self makeTraversal traverse: tree collecting: [:each | each].
	
	self assert: i asOrderedCollection = #(3 2 4 1 5) asOrderedCollection.! !

!InOrderTraversalTest methodsFor: 'testing - enumerating' stamp: 'fbs 4/24/2011 22:04'!
testTraversalHandlesEmptySubtrees
	| i tree |
	tree := ZTree value: 1 children: {ZTree empty. ZTree value: 2}.
	i := self makeTraversal traverseNodes: tree collecting: #value.
	
	self assert: i asOrderedCollection = #(1 2) asOrderedCollection.! !
