DepthTraversal subclass: #PostOrderTraversal
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Support'!
!PostOrderTraversal commentStamp: 'fbs 2/26/2011 23:11' prior: 0!
I provide a post-order traversal of an n-tree: I traverse all child nodes before processing the current node.!


!PostOrderTraversal methodsFor: 'enumerating' stamp: 'fbs 4/24/2011 21:55'!
collectNodes: aBlock using: aZipper
	"A naive depth-first traversal. It fails in the presence of cycles."
	| collected move value |
	aZipper focus isEmpty
		ifTrue: [ collected := OrderedCollection new ]
		ifFalse:
			[value := aBlock value: aZipper focus.
			move := aZipper safeDown.
	
			collected := (move first = #success)
				ifTrue: [ (self collectNodes: aBlock using: move second) copy add: value; yourself ]
				ifFalse: [ { value } asOrderedCollection ]].
	
	move := aZipper safeRight.
	move first = #success ifTrue: [collected addAll: (self collectNodes: aBlock using: move second)].

	^ collected.! !


!PostOrderTraversal methodsFor: 'private' stamp: 'fbs 2/21/2011 18:01'!
depthFirstTraversal: aZipper doing: aBlock
	^ (self collect: [:each | each] using: aZipper) do: aBlock.
! !
