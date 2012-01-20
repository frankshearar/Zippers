Object subclass: #BinarySearchTree
	instanceVariableNames: 'tree'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-BST'!
!BinarySearchTree commentStamp: 'fbs 2/5/2011 23:10' prior: 0!
I implement a binary search tree in a strictly functional manner.!


!BinarySearchTree methodsFor: 'adding' stamp: 'fbs 2/21/2011 22:12'!
add: aComparableObject
	"Add some object that understands < to our tree. aComparableObject < node goes into the left subtree; otherwise, the object goes into the right subtree."
	^ BinarySearchTree tree: (self add: aComparableObject to: tree zipper)! !


!BinarySearchTree methodsFor: 'private' stamp: 'fbs 2/25/2011 21:32'!
add: anObject to: aZipper
	"If we're at a leaf node, and <, insertDown."
	"If we're not at a leaf node, move further into the tree."
	| currentValue insertPoint move |
	aZipper focus isEmpty ifTrue: [ ^ (aZipper insertDown: anObject) root ].
	
	currentValue := aZipper focus value.
	
	"Move down to the left subnode."
	move := aZipper safeDown.
	move first = #success ifFalse:
		["Leaf node"
		^ (anObject < currentValue
			ifTrue: [ aZipper insertDown: anObject ]
			ifFalse: [ (aZipper insertDown: ZTree empty) insertRight: anObject ]) root ].
	
	
	insertPoint := move second.
	
	"If less than, add to the left subtree."
	anObject < currentValue
		ifTrue: [ ^ self add: anObject to: insertPoint ].
		
	"Otherwise, add to the right subtree."
	move := insertPoint safeRight.
	^ self add: anObject to: move second.! !

!BinarySearchTree methodsFor: 'private' stamp: 'fbs 2/21/2011 22:12'!
tree: aTree
	tree := aTree.! !


!BinarySearchTree methodsFor: 'converting' stamp: 'fbs 2/24/2011 17:32'!
asOrderedCollection
	^ self collect: [:each | each ].! !


!BinarySearchTree methodsFor: 'enumerating' stamp: 'fbs 2/24/2011 22:37'!
collect: aBlock
	| traversal |
	traversal := InOrderTraversal new collect: aBlock using: tree zipper.
	^ traversal collect: aBlock.! !


!BinarySearchTree methodsFor: 'initialize-release' stamp: 'fbs 2/24/2011 17:33'!
initialize
	tree := ZTree empty.! !


!BinarySearchTree methodsFor: 'accessing' stamp: 'fbs 2/25/2011 21:36'!
zipper
	^ tree zipper.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

BinarySearchTree class
	instanceVariableNames: ''!

!BinarySearchTree class methodsFor: 'instance creation' stamp: 'fbs 2/21/2011 22:12'!
tree: aTree
	^ self new tree: aTree.! !

!BinarySearchTree class methodsFor: 'instance creation' stamp: 'fbs 2/23/2011 21:04'!
with: anObject
	^ self new tree: (ZTree value: anObject).! !
e methodsFor: 'enumerating' stamp: 'fbs 4/30/2011 22:30'!
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
