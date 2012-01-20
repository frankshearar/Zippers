Object subclass: #BinarySearchTree
	instanceVariableNames: 'tree'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-BST'!
!BinarySearchTree commentStamp: 'fbs 2/28/2011 22:27' prior: 0!
I implement a binary search tree in a strictly functional manner. I'm pretty naive, in that I do no balancing.!


!BinarySearchTree methodsFor: 'adding' stamp: 'fbs 12/20/2011 16:40'!
add: aComparableObject
	"Add some object that understands < to our tree. aComparableObject < node goes into the left subtree; otherwise, the object goes into the right subtree."
	^ BinarySearchTree tree: (self add: aComparableObject to: tree zipper) root! !


!BinarySearchTree methodsFor: 'private' stamp: 'fbs 12/20/2011 16:41'!
add: anObject to: aZipper
	"Return a zipper with anObject inserted in the correct place: if we're at a leaf node, and <, insertDown; otherwise, move further into the tree."
	| currentValue leftChild move |
	aZipper focus isEmpty ifTrue: [ ^ aZipper insertDown: (ZTree value: anObject) ].
	
	currentValue := aZipper focus value.
	
	"Move down to the left subnode."
	move := aZipper safeDown.
	move first = #success ifFalse:
		["Leaf node. If adding a right subtree, add the empty tree as a left subtree."
		^ anObject < currentValue
			ifTrue: [ aZipper insertDown: (ZTree value: anObject) ]
			ifFalse: [ (aZipper insertDown: ZTree empty) insertRight: (ZTree value: anObject) ] ].

	leftChild := move second.
	
	"If less than, add to the left subtree."
	anObject < currentValue
		ifTrue: [ ^ self add: anObject to: leftChild ].
		
	"Otherwise, add to the right subtree."
	move := leftChild safeRight.
	^ self add: anObject to: move second.! !

!BinarySearchTree methodsFor: 'private' stamp: 'fbs 2/21/2011 22:12'!
tree: aTree
	tree := aTree.! !


!BinarySearchTree methodsFor: 'printing' stamp: 'fbs 4/24/2011 09:30'!
asDotFile
	^ tree asDotFile! !

!BinarySearchTree methodsFor: 'printing' stamp: 'fbs 4/22/2011 22:13'!
printString
	^ tree printString.! !


!BinarySearchTree methodsFor: 'converting' stamp: 'fbs 4/30/2011 22:30'!
asOrderedCollection
	^ tree asOrderedCollection.! !

!BinarySearchTree methodsFor: 'converting' stamp: 'fbs 4/30/2011 17:17'!
rebalanced
	^ self class tree: self asOrderedCollection asBalancedBinaryTree.! !

!BinarySearchTree methodsFor: 'converting' stamp: 'fbs 4/29/2011 19:10'!
rebalancedDSW
	^ self class tree: tree balanceDSW.! !

!BinarySearchTree methodsFor: 'converting' stamp: 'fbs 5/1/2011 10:16'!
rebalancedDSW2
	^ self class tree: tree balanceDSW2.! !


!BinarySearchTree methodsFor: 'enumerating' stamp: 'fbs 4/30/2011 22:30'!
collect: aBlock
	^ tree collect: aBlock.! !


!BinarySearchTree methodsFor: 'initialize-release' stamp: 'fbs 2/24/2011 17:33'!
initialize
	tree := ZTree empty.! !


!BinarySearchTree methodsFor: 'accessing' stamp: 'fbs 2/28/2011 22:26'!
zipper
	"This lets me masquerade as a ZTree: PreOrderTraversal new traverse: aBST collecting: [:each | each * 2 ]."
	^ tree zipper.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

BinarySearchTree class
	instanceVariableNames: ''!

!BinarySearchTree class methodsFor: 'instance creation' stamp: 'fbs 4/28/2011 12:46'!
tree: aBinaryTree
	^ self new tree: aBinaryTree.! !

!BinarySearchTree class methodsFor: 'instance creation' stamp: 'fbs 4/30/2011 17:08'!
with: anObject
	^ self new tree: (ZTree value: anObject).! !
