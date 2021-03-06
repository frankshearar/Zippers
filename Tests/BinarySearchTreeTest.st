TestCase subclass: #BinarySearchTreeTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Tests'!

!BinarySearchTreeTest methodsFor: 'testing - adding' stamp: 'fbs 5/1/2011 14:01'!
testAddToEmptyTreeAdds
	| items tree |
	tree := (BinarySearchTree tree: ZTree empty) add: 1.
	items := InOrderTraversal new traverse: tree collecting: #yourself.
	
	self assert: #(1) asOrderedCollection = items.! !

!BinarySearchTreeTest methodsFor: 'testing - adding' stamp: 'fbs 5/1/2011 14:00'!
testAddingLargerPreservesOrder
	"The in-order traversal of a binary tree always yields a sorted collection."
	| items tree |
	tree := (BinarySearchTree with: 2) add: 3.
	items := InOrderTraversal new traverse: tree collecting: #yourself.
	
	self assert: #(2 3) asOrderedCollection = items.! !

!BinarySearchTreeTest methodsFor: 'testing - adding' stamp: 'fbs 5/1/2011 14:00'!
testAddingPreservesOrder
	"The in-order traversal of a binary tree always yields a sorted collection."
	| items tree |
	tree := ((BinarySearchTree with: 1) add: 3) add: 2.
	items := InOrderTraversal new traverse: tree collecting: #yourself.
	
	self assert: #(1 2 3) asOrderedCollection = items.! !

!BinarySearchTreeTest methodsFor: 'testing - adding' stamp: 'fbs 5/1/2011 14:00'!
testAddingSmallerPreservesOrder
	"The in-order traversal of a binary tree always yields a sorted collection."
	| items tree |
	tree := (BinarySearchTree with: 2) add: 1.
	items := InOrderTraversal new traverse: tree collecting: #yourself.
	
	self assert: #(1 2) asOrderedCollection = items.! !

!BinarySearchTreeTest methodsFor: 'testing - adding' stamp: 'fbs 2/24/2011 17:32'!
testNewTreeIsBlank
	self assert: BinarySearchTree new asOrderedCollection = #() asOrderedCollection.! !


!BinarySearchTreeTest methodsFor: 'testing - instance creation' stamp: 'fbs 2/24/2011 22:52'!
testWithReturnsSingleNodeTree
	| bst value |
	value := 1.
	bst := BinarySearchTree with: value.
	self assert: (bst collect: [:each | each]) = #(1) asOrderedCollection.
	! !


!BinarySearchTreeTest methodsFor: 'testing - enumerating' stamp: 'fbs 2/26/2011 22:50'!
testCollectExecutesBlockOncePerNode
	| items t |
	t := ((BinarySearchTree with: 2) add: 3) add: 1.
	items := t collect: [:each | each * 2].
	self assert: items = (#(1 2 3) * 2) asOrderedCollection.! !


!BinarySearchTreeTest methodsFor: 'testing - converting' stamp: 'fbs 4/30/2011 17:52'!
testRebalance
	| bst zipper |
	bst := BinarySearchTree tree: ZTree empty.
	"Construct a degenerate BST."
	1 to: 10 do: [:i | bst := bst add: i].
	
	zipper := bst rebalanced zipper.
	self assert: zipper root isBalanced.
	self assert: (1 to: 10) asOrderedCollection = (InOrderTraversal new collect: #yourself using: zipper) asOrderedCollection.! !
 root isBalanced.
	self assert: (1 to: 10) asOrderedCollection = (InOrderTraversal new collect: #yourself using: zipper) asOrderedCollection.! !
self assert: zipper down focus value = 4.
	self assert: zipper down right focus value = 9.! !
