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


!InOrderTraversal methodsFor: 'enumerating' stamp: 'fbs 4/24/2011 22:04'!
collectNodes: aBlock using: aZipper
	"A naive depth-first traversal. It fails in the presence of cycles."
	| collected left move right |
	aZipper focus isEmpty
		ifTrue: [ collected := #() asOrderedCollection ]
		ifFalse: [ collected := OrderedCollection with: (aBlock value: aZipper focus) ].
		
	move := aZipper safeDown.
	
	left := (move first = #success)
		ifTrue: [ self collectNodes: aBlock using: move second ]
		ifFalse: [ #() asOrderedCollection ].
	
	right := ((move first = #success) and: [(move := move second safeRight) first = #success])
		ifTrue: [self collectNodes: aBlock using: move second]
		ifFalse: [ #() asOrderedCollection ].

	^ left copy
		addAll: collected;
		addAll: right;
		yourself.! !
