Object subclass: #BreadthFirstSearch
	instanceVariableNames: 'queue visited zipper'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Support'!
!BreadthFirstSearch commentStamp: 'fbs 2/6/2012 09:38' prior: 0!
A breadth first traversal processes nodes in order of depth, and left to right.

Since a zipper excels at _local_ movement in a structure, and since I of necessity must use nonlocal movement (once it has visited all nodes in any depth n, it must leap to the leftmost node at depth n+1), I spawn zippers for each child node.

This means that unlike my depth-first cousins (which all use a single zipper), I will _not_ preserve mutations on my structure except for the very last zipper I spawn - that of the rightmost deepest node.!


!BreadthFirstSearch methodsFor: 'enumerating' stamp: 'fbs 2/6/2012 09:28'!
collect: aBlock
	| prev |
	prev := zipper.
	[self hasNext] whileTrue:
		[zipper := zipper changeTo: (aBlock value: zipper focus).
		prev := zipper.
		zipper := self next].
	^ prev.! !

!BreadthFirstSearch methodsFor: 'enumerating' stamp: 'fbs 2/6/2012 09:29'!
traverse: anObject collecting: aBlock
	queue := OrderedCollection new.
	visited := OrderedCollection new.
	zipper := anObject zipper.
	self addUnmarkedChildren: zipper.
	
	^ self collect: aBlock.! !

!BreadthFirstSearch methodsFor: 'enumerating' stamp: 'fbs 2/4/2012 23:38'!
traverse: anObject doing: aBlock
	"Throw away the return value."
	self traverse: anObject collecting: aBlock.! !


!BreadthFirstSearch methodsFor: 'private' stamp: 'fbs 2/6/2012 09:26'!
addUnmarkedChildren: aZipper
	self trampoline: aZipper safeDown into: [ :zl |
		zl
			either: [ :z |
				(visited includes: (z focus))
					ifFalse: [queue addLast: z].
				[z safeRight]]
			or: [ :noChildrenError | noChildrenError location]]! !

!BreadthFirstSearch methodsFor: 'private' stamp: 'fbs 2/4/2012 23:26'!
hasNext
	^ zipper trail isEnd not! !

!BreadthFirstSearch methodsFor: 'private' stamp: 'fbs 2/4/2012 23:37'!
next
	self hasNext ifFalse: [^ zipper].
	queue ifEmpty: [^ zipper := zipper class new
		focus: zipper value
		trail: (EndOfTraversalContext trail: zipper trail)].
	
	visited addLast: zipper value.
	
	zipper := queue first.
	queue := queue allButFirst.
	self addUnmarkedChildren: zipper.
	^ zipper.! !

!BreadthFirstSearch methodsFor: 'private' stamp: 'fbs 2/6/2012 09:25'!
trampoline: initialValue into: aUnaryBlock
	| v |
	v := [initialValue].
	[v isBlock] whileTrue: [v := aUnaryBlock value: v value].
	^ v.! !
