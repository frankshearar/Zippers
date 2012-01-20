Object subclass: #TreeZipper
	instanceVariableNames: 'focus trail'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!
!TreeZipper commentStamp: 'fbs 12/30/2010 22:41' prior: 0!
I am a zipper for navigating over a variable-arity tree, that is a tree that may have any number of children per node.

In particular, Smalltalk has a built-in tree structure, that of dependents: any Object may have any number of dependents, who may each in turn have their own dependents. Really, this allows for a directed graph rather than a tree. Further, we treat objects with no dependents as leaf nodes. Every node is its own value.

That is, I allow one to navigate arbitrarily over a tree structure, and change parts of it, where "change" means "return a structure that shares part of the original structure, but otherwise leaves the host structure unchanged".!


!TreeZipper methodsFor: 'navigating' stamp: 'fbs 12/31/2010 17:07'!
down
	"Return a Zipper focusing on the first child element of this node."
	(self focus children isEmpty)
		ifTrue: [ ^ ZipperNavigation signal: 'Down at a leaf node' ].
		
	^ TreeZipper new
		focus: focus children first
		trail: (TreeZipperNode
				path: trail
				value: focus value
				leftNodes: OrderedCollection new
				rightNodes: focus children allButFirst).! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 1/1/2011 15:37'!
left
	trail ifNil: [^ ZipperNavigation signal: 'Left at the root node'].
	trail leftNodes ifEmpty: [^ ZipperNavigation signal: 'Left at left-most sibling node'].
	
	^ TreeZipper new
		focus: trail leftNodes first
		trail: (TreeZipperNode
			path: trail path
			value: trail value
			leftNodes: (trail leftNodes allButFirst)
			rightNodes: (trail rightNodes addFirst: focus; yourself)).! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 1/1/2011 15:43'!
right
	trail ifNil: [^ ZipperNavigation signal: 'Right at the root node'].
	trail rightNodes ifEmpty: [^ ZipperNavigation signal: 'Right at the right-most sibling node'].
	
	^ TreeZipper new
		focus: trail rightNodes first
		trail: (TreeZipperNode
			path: trail path
			value: trail value
			leftNodes: (trail leftNodes addFirst: focus; yourself)
			rightNodes: trail rightNodes allButFirst).! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 12/31/2010 23:29'!
root
	"Return the possibly new/mutated tree under navigation"
	^ trail
		ifNil: [focus]
		ifNotNil: [self up root]! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 1/1/2011 14:40'!
up
	trail ifNil: [^ ZipperNavigation signal: 'Up at the root node'].
	
	^ TreeZipper new
		focus: (ZTree
			value: trail value
			children: trail leftNodes reverse, focus asOrderedCollection, trail rightNodes)
		trail: trail path.! !


!TreeZipper methodsFor: 'accessing' stamp: 'fbs 12/30/2010 22:06'!
focus
	^ focus.! !


!TreeZipper methodsFor: 'private' stamp: 'fbs 12/31/2010 16:37'!
focus: aTree trail: aTreeZipperNode
	focus := aTree.
	trail := aTreeZipperNode.! !


!TreeZipper methodsFor: 'mutating' stamp: 'fbs 12/31/2010 18:42'!
change: aBlock
	"aBlock is a unary block whose evaluated value we use to replace the current focus."
	^ TreeZipper new
		focus: (ZTree
			value: (aBlock value: focus value)
			children: focus children)
		trail: trail.! !

!TreeZipper methodsFor: 'mutating' stamp: 'fbs 12/31/2010 19:32'!
changeTo: newValue
	^ TreeZipper new
		focus: (ZTree
			value: newValue
			children: focus children)
		trail: trail.! !

!TreeZipper methodsFor: 'mutating' stamp: 'fbs 12/31/2010 23:46'!
insertDown: anObject
	^ TreeZipper new
		focus: (ZTree value: anObject)
		trail: (TreeZipperNode
			path: trail
			value: focus value
			leftNodes: OrderedCollection new
			rightNodes: focus children).! !

!TreeZipper methodsFor: 'mutating' stamp: 'fbs 1/1/2011 15:49'!
insertLeft: anObject
	trail ifNil: [^ ZipperNavigation signal: 'Insert at top'].
	^ TreeZipper new
		focus: focus
		trail: (TreeZipperNode
			path: trail path
			value: trail value
			leftNodes: (trail leftNodes copy addFirst: (ZTree value: anObject); yourself)
			rightNodes: trail rightNodes)! !

!TreeZipper methodsFor: 'mutating' stamp: 'fbs 1/1/2011 00:10'!
insertRight: anObject
	trail ifNil: [^ ZipperNavigation signal: 'Insert at top'].
	^ TreeZipper new
		focus: focus
		trail: (TreeZipperNode
			path: trail path
			value: trail value
			leftNodes: trail leftNodes
			rightNodes: (trail rightNodes copy addFirst: (ZTree value: anObject); yourself))! !

!TreeZipper methodsFor: 'mutating' stamp: 'fbs 12/31/2010 19:47'!
insertUp: anObject! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

TreeZipper class
	instanceVariableNames: ''!

!TreeZipper class methodsFor: 'instance creation' stamp: 'fbs 12/31/2010 16:36'!
on: aTree
	^ self new focus: aTree trail: nil.! !
