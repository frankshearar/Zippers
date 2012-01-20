DepthTraversal subclass: #InOrderTraversal
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Support'!

!InOrderTraversal methodsFor: 'as yet unclassified' stamp: 'fbs 2/24/2011 22:42'!
collect: aBlock using: aZipper
	"A naive depth-first traversal. It fails in the presence of cycles."
	| left move right value |
	aZipper focus isEmpty ifTrue: [^ OrderedCollection new ].
	
	value := aBlock value: aZipper focus value.
	move := aZipper safeDown.
	
	left := (move first = #success)
		ifTrue: [ self collect: aBlock using: move second ]
		ifFalse: [ #() asOrderedCollection ].
	
	right := ((move first = #success) and: [(move := move second safeRight) first = #success])
		ifTrue: [self collect: aBlock using: move second]
		ifFalse: [ #() asOrderedCollection ].

	^ left copy
		add: value;
		addAll: right;
		yourself.! !


!InOrderTraversal methodsFor: 'private' stamp: 'fbs 2/25/2011 10:18'!
depthFirstTraversal: aZipper doing: aBlock
	^ (self collect: [:each | each] using: aZipper) do: aBlock.! !
s: aBlock using: move second]
		ifFalse: [ #() asOrderedCollection ].

	^ left copy
		addAll: collected;
		addAll: right;
		yourself.! !


!InOrderTraversal methodsFor: 'private' stamp: 'fbs 2/25/2011 10:18'!
depthFirstTraversal: aZipper doing: aBlock
	^ (self collect: [:each | each] using: aZipper) do: aBlock.! !
