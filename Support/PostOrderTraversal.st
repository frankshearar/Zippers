DepthTraversal subclass: #PostOrderTraversal
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Support'!
!PostOrderTraversal commentStamp: 'fbs 2/26/2011 23:11' prior: 0!
I provide a post-order traversal of an n-tree: I traverse all child nodes before processing the current node.!


!PostOrderTraversal methodsFor: 'enumerating' stamp: 'fbs 2/5/2012 22:15'!
collectNodes: aBlock using: aZipper
	"A naive depth-first traversal. It fails in the presence of cycles."
	| collected value |
	aZipper focus isEmpty
		ifTrue: [ collected := OrderedCollection new ]
		ifFalse:
			[value := aBlock value: aZipper focus.
			collected := aZipper safeDown
				either: [:z | (self collectNodes: aBlock using: z) copy add: value; yourself]
				or: [:unusedError | { value } asOrderedCollection]].
	
	aZipper safeRight
		either: [:z |  collected addAll: (self collectNodes: aBlock using: z)]
		or: [:unusedError | "do nothing"].

	^ collected.! !


!PostOrderTraversal methodsFor: 'private' stamp: 'fbs 2/21/2011 18:01'!
depthFirstTraversal: aZipper doing: aBlock
	^ (self collect: [:each | each] using: aZipper) do: aBlock.
! !
 | each] using: aZipper) do: aBlock.
! !
