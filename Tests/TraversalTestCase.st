TestCase subclass: #TraversalTestCase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Tests'!

!TraversalTestCase methodsFor: 'testing' stamp: 'fbs 2/17/2011 22:08'!
assertTraversalOf: aTree yieldsOrder: aCollection
	| i |
	i := #() asOrderedCollection.
	self makeTraversal traverse: aTree doing: [:each | i add: each ].
	
	self assert: i = aCollection asOrderedCollection.! !


!TraversalTestCase methodsFor: 'running' stamp: 'fbs 2/17/2011 22:04'!
makeTraversal
	^ self subclassResponsibility.! !

!TraversalTestCase methodsFor: 'running' stamp: 'fbs 2/17/2011 22:04'!
setUp
	traversal := self makeTraversal.! !


!TraversalTestCase methodsFor: 'testing - enumerating' stamp: 'fbs 2/17/2011 22:05'!
testEmptyTraversalDoesNothing
	| i |
	i := 0.
	self makeTraversal traverse: (ZTree value: 1) doing: [:each | i := i + 1].
	
	self assert: i = 1.! !

!TraversalTestCase methodsFor: 'testing - enumerating' stamp: 'fbs 2/28/2011 17:45'!
testEnumeratingEmptyTreeReturnsEmptyCollection
	| items |
	items := self makeTraversal traverse: ZTree empty collecting: [:each | each ].
	self assert: items isEmpty.! !

!TraversalTestCase methodsFor: 'testing - enumerating' stamp: 'fbs 2/17/2011 22:05'!
testTraverseBranchingTreeCallsBlock
	| i |
	i := 0.
	self makeTraversal traverse: (ZTree value: 0 children: {ZTree value: 1. ZTree value: 2}) doing: [:each | i := i + 1].
	
	self assert: i = 3.! !

!TraversalTestCase methodsFor: 'testing - enumerating' stamp: 'fbs 2/17/2011 22:06'!
testTreeTraversalCallsBlock
	| i |
	i := 0.
	self makeTraversal traverse: (ZTree value: 1) doing: [:each | i := i + 1].
	
	self assert: i = 1.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

TraversalTestCase class
	instanceVariableNames: ''!

!TraversalTestCase class methodsFor: 'testing' stamp: 'fbs 2/26/2011 22:55'!
isAbstract
	^ self name = #TraversalTestCase.! !

