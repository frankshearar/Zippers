TraversalTestCase subclass: #PreOrderTraversalTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Tests'!

!PreOrderTraversalTest methodsFor: 'testing - enumerating' stamp: 'fbs 2/28/2011 17:47'!
testCollectCollectsCorrectly
	| i tree |
	tree := ZTree value: 1 children: {ZTree value: 2 children: {ZTree value: 3. ZTree value: 4}. ZTree value: 5}.
	i := self makeTraversal traverse: tree collecting: [:each | each * 2].
	
	self assert: i asOrderedCollection = (#(1 2 3 4 5) * 2) asOrderedCollection.! !

!PreOrderTraversalTest methodsFor: 'testing - enumerating' stamp: 'fbs 4/24/2011 21:56'!
testTraversalHandlesEmptySubtrees
	| i tree |
	tree := ZTree value: 1 children: {ZTree empty. ZTree value: 2}.
	i := self makeTraversal traverseNodes: tree collecting: #value.
	
	self assert: i asOrderedCollection = #(1 2) asOrderedCollection.! !

!PreOrderTraversalTest methodsFor: 'testing - enumerating' stamp: 'fbs 2/17/2011 22:11'!
testTreeTraversalMovesDepthFirst
	self
		assertTraversalOf: (ZTree value: 1 children: {ZTree value: 2 children: {ZTree value: 3. ZTree value: 4}. ZTree value: 5})
		 yieldsOrder: #(1 2 3 4 5).! !


!PreOrderTraversalTest methodsFor: 'running' stamp: 'fbs 2/17/2011 22:04'!
makeTraversal
	^ PreOrderTraversal new.! !
