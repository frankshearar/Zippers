Object subclass: #BinaryTreeZipper
	instanceVariableNames: 'internalZipper'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!
!BinaryTreeZipper commentStamp: 'fbs 4/30/2011 16:12' prior: 0!
I am a zipper that walks over a binary tree. I differ from TreeZipper in my semantics:

  - my "left" means "down" in a TreeZipper
  - my "right" means "down right" in a TreeZipper
  - my "down" means "down" in a TreeZipper (to seamlessly support the Traversals)

I wrap a normal TreeZipper, implementing the above semantic difference.!


!BinaryTreeZipper methodsFor: 'accessing' stamp: 'fbs 4/30/2011 15:18'!
focus
	^ internalZipper focus.! !


!BinaryTreeZipper methodsFor: 'mutating' stamp: 'fbs 11/1/2011 08:00'!
insertDown: anObject
	^ internalZipper focus isEmpty
		ifTrue: [internalZipper changeTo: anObject]
		ifFalse: [internalZipper insertDown: anObject].! !

!BinaryTreeZipper methodsFor: 'mutating' stamp: 'fbs 4/30/2011 16:37'!
insertLeft: anObject
	"Insert anObject as the left subtree, and focus on this new node."
	^ internalZipper insertDown: anObject.! !

!BinaryTreeZipper methodsFor: 'mutating' stamp: 'fbs 4/30/2011 17:07'!
insertRight: anObject
	"Insert anObject as the right subtree, and focus on this new node."
	"If this is the empty tree, 'insert' means 'make a node'."
	internalZipper isEmpty ifTrue: [ ^ internalZipper insertDown: anObject ].
	
	^ (internalZipper focus hasChildren
		ifTrue: [internalZipper down]
		ifFalse: [internalZipper insertDown: ZTree empty])
			insertRight: anObject.! !


!BinaryTreeZipper methodsFor: 'navigating' stamp: 'fbs 4/30/2011 15:25'!
left
	^ internalZipper down.! !

!BinaryTreeZipper methodsFor: 'navigating' stamp: 'fbs 4/30/2011 15:37'!
right
	"'Right subtree' for a ZTree means 'second child'."
	internalZipper focus hasChildren ifFalse: [ ZipperNavigation signal: #noRightSubtree ].
	^ internalZipper down right.! !

!BinaryTreeZipper methodsFor: 'navigating' stamp: 'fbs 4/30/2011 09:29'!
root
	"Return the root of the (possibly) mutated tree."! !

!BinaryTreeZipper methodsFor: 'navigating' stamp: 'fbs 4/30/2011 16:11'!
safeDown
	^ self safeLeft.! !

!BinaryTreeZipper methodsFor: 'navigating' stamp: 'fbs 2/5/2012 22:33'!
safeLeft
	"Return a pair (successfully moved, zipper on new location)."
	"'Left' means 'down to the first child'."
	^ internalZipper safeDown
		either: [:z | z focus isEmpty
			ifTrue: [Left value: (ZipperError error: #noLeftSubtree location: self)]
			ifFalse: [Right value: z]]
		or: [:error | Left value: (ZipperError error: #noLeftSubtree location: self)].! !

!BinaryTreeZipper methodsFor: 'navigating' stamp: 'fbs 2/5/2012 22:29'!
safeRight
	"Return a pair (successfully moved, zipper on new location)."
	^ internalZipper safeDown
		either: [:leftChild |
			leftChild safeRight
				either: [:rightChild |
					rightChild value focus isEmpty
						ifTrue: [Left value: (ZipperError error: #noRightSubtree location: self)]
						ifFalse: [Right value: rightChild]]
				or: [:error | Left value: (ZipperError error: #noRightSubtree location: self)]]
		or: [:error | Left value: (ZipperError error: #rightAtLeafNode location: self)]! !

!BinaryTreeZipper methodsFor: 'navigating' stamp: 'fbs 4/30/2011 16:03'!
safeUp
	^ internalZipper safeUp.! !

!BinaryTreeZipper methodsFor: 'navigating' stamp: 'fbs 4/30/2011 16:01'!
up
	^ internalZipper up.! !


!BinaryTreeZipper methodsFor: 'private' stamp: 'fbs 4/30/2011 15:18'!
using: aZipper
	internalZipper := aZipper.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

BinaryTreeZipper class
	instanceVariableNames: ''!

!BinaryTreeZipper class methodsFor: 'instance creation' stamp: 'fbs 4/30/2011 15:18'!
on: aTree
	^ self new using: aTree zipper.! !
