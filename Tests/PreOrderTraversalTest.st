TraversalTestCase subclass: #PreOrderTraversalTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Tests'!

!PreOrderTraversalTest methodsFor: 'testing - enumerating' stamp: 'fbs 2/25/2011 17:41'!
testCollectCollectsCorrectly
	| i tree |
	tree := ZTree value: 1 children: {ZTree value: 2 children: {ZTree value: 3. ZTree value: 4}. ZTree value: 5}.
	i := self makeTraversal collect: [:each | each * 2] using: tree zipper.
	
	self assert: i = (#(1 2 3 4 5) * 2) asOrderedCollection.! !

!PreOrderTraversalTest methodsFor: 'testing - enumerating' stamp: 'fbs 2/17/2011 22:11'!
testTreeTraversalMovesDepthFirst
	self
		assertTraversalOf: (ZTree value: 1 children: {ZTree value: 2 children: {ZTree value: 3. ZTree value: 4}. ZTree value: 5})
		 yieldsOrder: #(1 2 3 4 5).! !


!PreOrderTraversalTest methodsFor: 'running' stamp: 'fbs 2/17/2011 22:04'!
makeTraversal
	^ PreOrderTraversal new.! !
 methodsFor: 'testing - enumerating' stamp: 'fbs 2/17/2011 07:51'!
testTreeTraversalMovesDepthFirst
	| i tree |
	tree := ZTree value: 1 children: {ZTree value: 2 children: {ZTree value: 3. ZTree value: 4}. ZTree value: 5}.
	i := #() asOrderedCollection.
	PreOrderTraversal new traverse: tree doing: [:each | i add: each ].
	
	self assert: i = #(1 2 3 4 5) asOrderedCollection.! !
