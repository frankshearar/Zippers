DepthTraversal subclass: #InOrderTraversal
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Support'!
!InOrderTraversal commentStamp: 'fbs 2/26/2011 23:07' prior: 0!
In-order traversal only really makes sense for binary trees: with n-ary trees, "in order" means "process the first child, then the current node, then the remaining child nodes."!


!InOrderTraversal methodsFor: 'private' stamp: 'fbs 2/25/2011 10:18'!
depthFirstTraversal: aZipper doing: aBlock
	^ (self collect: [:each | each] using: aZipper) do: aBlock.! !


!InOrderTraversal methodsFor: 'enumerating' stamp: 'fbs 2/5/2012 22:23'!
collectNodes: aBlock using: aZipper
	"A naive depth-first traversal. It fails in the presence of cycles."
	| collected left right |
	right := #() asOrderedCollection.
	left := #() asOrderedCollection.
	collected := aZipper focus isEmpty
		ifTrue: [#() asOrderedCollection]
		ifFalse: [OrderedCollection with: (aBlock value: aZipper focus)].
		
	aZipper safeDown
		either: [:leftChild |
			left := self collectNodes: aBlock using: leftChild.
			leftChild safeRight
				either: [:rightChild |
					right := self collectNodes: aBlock using: rightChild]
				or: [:unusedError | "do nothing"]]
		or: [:unusedError | "do nothing"].

	^ left copy
		addAll: collected;
		addAll: right;
		yourself.! !
: right;
		yourself.! !
