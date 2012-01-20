ZTree subclass: #ZBinaryTree
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Support'!
!ZBinaryTree commentStamp: 'fbs 4/28/2011 09:28' prior: 0!
I am a binary tree - that is, I have two children nodes. Further, I always have two children nodes, even if some of those are empty (== ZTree empty).!


!ZBinaryTree methodsFor: 'converting' stamp: 'fbs 4/29/2011 10:01'!
balance
	"Return a balanced copy of self."
	^ self asOrderedCollection asBalancedBinaryTree.! !

!ZBinaryTree methodsFor: 'converting' stamp: 'fbs 4/29/2011 10:01'!
balanceDSW
	"Return a balanced copy of self."
	^ self asMutableTree balance asImmutableTreeOfType: ZBinaryTree.! !


!ZBinaryTree methodsFor: 'initialize-release' stamp: 'fbs 4/28/2011 12:45'!
value: anObject left: leftZBinaryTree right: rightZBinaryTree
	super value: anObject children: #(leftZBinaryTree rightZBinaryTree)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ZBinaryTree class
	instanceVariableNames: ''!

!ZBinaryTree class methodsFor: 'instance creation' stamp: 'fbs 4/28/2011 09:30'!
value: anObject
	^ self value: anObject children: {ZTree empty. ZTree empty.}! !

!ZBinaryTree class methodsFor: 'instance creation' stamp: 'fbs 4/28/2011 12:57'!
value: anObject children: aCollection
	| realChildren |
	realChildren := aCollection copy.
	[realChildren size < 2] whileTrue: [realChildren add: ZTree empty].

	^ self value: anObject left: aCollection first right: aCollection second! !

!ZBinaryTree class methodsFor: 'instance creation' stamp: 'fbs 4/28/2011 09:30'!
value: anObject left: aZBinaryTree
	^ self value: anObject children: {aZBinaryTree. ZTree empty.}! !

!ZBinaryTree class methodsFor: 'instance creation' stamp: 'fbs 4/28/2011 12:59'!
value: anObject left: leftZBinaryTree right: rightZBinaryTree
	^ self new value: anObject children: {leftZBinaryTree. rightZBinaryTree}! !

!ZBinaryTree class methodsFor: 'instance creation' stamp: 'fbs 4/28/2011 09:30'!
value: anObject right: aZBinaryTree
	^ self value: anObject children: {ZTree empty. aZBinaryTree.}! !
