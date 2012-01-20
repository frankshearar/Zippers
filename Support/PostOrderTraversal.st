DepthTraversal subclass: #PostOrderTraversal
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Support'!

!PostOrderTraversal methodsFor: 'enumerating' stamp: 'fbs 2/25/2011 17:33'!
collect: aBlock using: aZipper
	"A naive depth-first traversal. It fails in the presence of cycles."
	| collected move value |
	aZipper isEmpty ifTrue: [ ^ OrderedCollection new ].
	
	value := aBlock value: aZipper focus value.
	move := aZipper safeDown.
	collected := (move first = #success)
		ifTrue: [ (self collect: aBlock using: move second) copy add: value; yourself ]
		ifFalse: [ { value } asOrderedCollection ].
	
	move := aZipper safeRight.
	move first = #success ifTrue: [collected addAll: (self collect: aBlock using: move second)].

	^ collected.! !


!PostOrderTraversal methodsFor: 'private' stamp: 'fbs 2/21/2011 18:01'!
depthFirstTraversal: aZipper doing: aBlock
	^ (self collect: [:each | each] using: aZipper) do: aBlock.
! !
Block using: move second)].

	^ collected.! !


!PostOrderTraversal methodsFor: 'private' stamp: 'fbs 2/21/2011 18:01'!
depthFirstTraversal: aZipper doing: aBlock
	^ (self collect: [:each | each] using: aZipper) do: aBlock.
! !
