TraversalTestCase subclass: #PostOrderTraversalTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Tests'!

!PostOrderTraversalTest methodsFor: 'running' stamp: 'fbs 2/18/2011 07:24'!
makeTraversal
	^ PostOrderTraversal new.! !


!PostOrderTraversalTest methodsFor: 'testing - enumerating' stamp: 'fbs 2/28/2011 17:47'!
testCollectCollectsCorrectly
	| i tree |
	tree := ZTree value: 1 children: {ZTree value: 2 children: {ZTree value: 3. ZTree value: 4}. ZTree value: 5}.
	i := self makeTraversal traverse: tree collecting: [:each | each * 2].
	
	self assert: i asOrderedCollection = (#(3 4 2 5 1) * 2) asOrderedCollection.! !

!PostOrderTraversalTest methodsFor: 'testing - enumerating' stamp: 'fbs 2/28/2011 17:47'!
testCollectEnumeratesCorrectly
	| i tree |
	tree := ZTree value: 1 children: {ZTree value: 2 children: {ZTree value: 3. ZTree value: 4}. ZTree value: 5}.
	i := self makeTraversal traverse: tree collecting: [:each | each].
	
	self assert: i asOrderedCollection = #(3 4 2 5 1) asOrderedCollection.! !

!PostOrderTraversalTest methodsFor: 'testing - enumerating' stamp: 'fbs 4/24/2011 21:30'!
testCollectNodesEnumeratesCorrectly
	| i tree |
	tree := ZTree value: 1 children: {ZTree value: 2 children: {ZTree value: 3. ZTree value: 4}. ZTree value: 5}.
	i := self makeTraversal traverseNodes: tree collecting: #value.
	
	self assert: i asOrderedCollection = #(3 4 2 5 1) asOrderedCollection.! !

!PostOrderTraversalTest methodsFor: 'testing - enumerating' stamp: 'fbs 4/24/2011 21:35'!
testTraversalHandlesEmptySubtrees
	| i tree |
	tree := ZTree value: 1 children: {ZTree empty. ZTree value: 2}.
	i := self makeTraversal traverseNodes: tree collecting: #value.
	
	self assert: i asOrderedCollection = #(2 1) asOrderedCollection.! !

!PostOrderTraversalTest methodsFor: 'testing - enumerating' stamp: 'fbs 2/18/2011 07:26'!
testTreeTraversalMovesDepthFirst
	self
		assertTraversalOf: (ZTree value: 1 children: {ZTree value: 2 children: {ZTree value: 3. ZTree value: 4}. ZTree value: 5})
		 yieldsOrder: #(3 4 2 5 1).! !

!PostOrderTraversalTest methodsFor: 'testing - enumerating' stamp: 'fbs 2/18/2011 07:51'!
testTreeTraversalMovesDepthFirstOnTriangleTree
	self
		assertTraversalOf: (ZTree value: 1 children: {ZTree value: 2. ZTree value: 3})
		 yieldsOrder: #(2 3 1).! !
