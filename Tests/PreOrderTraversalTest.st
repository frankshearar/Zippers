TestCase subclass: #PreOrderTraversalTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Tests'!

!PreOrderTraversalTest methodsFor: 'testing - enumerating' stamp: 'fbs 2/16/2011 07:32'!
testEmptyTraversalDoesNothing
	| i |
	i := 0.
	PreOrderTraversal new traverse: (ZTree value: 1) doing: [:each | i := i + 1].
	
	self assert: i = 1.! !

!PreOrderTraversalTest methodsFor: 'testing - enumerating' stamp: 'fbs 2/16/2011 17:57'!
testTraverseBranchingTreeCallsBlock
	| i |
	i := 0.
	PreOrderTraversal new traverse: (ZTree value: 0 children: {ZTree value: 1. ZTree value: 2}) doing: [:each | i := i + 1].
	
	self assert: i = 3.! !

!PreOrderTraversalTest methodsFor: 'testing - enumerating' stamp: 'fbs 2/14/2011 22:26'!
testTreeTraversalCallsBlock
	| i |
	i := 0.
	PreOrderTraversal new traverse: (ZTree value: 1) doing: [:each | i := i + 1].
	
	self assert: i = 1.! !

!PreOrderTraversalTest methodsFor: 'testing - enumerating' stamp: 'fbs 2/17/2011 07:51'!
testTreeTraversalMovesDepthFirst
	| i tree |
	tree := ZTree value: 1 children: {ZTree value: 2 children: {ZTree value: 3. ZTree value: 4}. ZTree value: 5}.
	i := #() asOrderedCollection.
	PreOrderTraversal new traverse: tree doing: [:each | i add: each ].
	
	self assert: i = #(1 2 3 4 5) asOrderedCollection.! !
