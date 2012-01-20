Object subclass: #TreeZipper
	instanceVariableNames: 'focus trail'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!
!TreeZipper commentStamp: 'fbs 1/1/2011 18:01' prior: 0!
I am a zipper for navigating over a variable-arity tree, that is a tree that may have any number of children per node.

That is, I allow one to navigate arbitrarily over a tree structure (a ZTree), and change parts of it, where "change" means "return a structure that shares part of the original structure, but otherwise leaves the host structure unchanged".!


!TreeZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 17:33'!
down
	"Return a Zipper focusing on the first child element of this node."
	^ self move: #safeDown.! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 17:37'!
downOrElse: aBlock
	^ self move: #safeDown orElse: aBlock.! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 17:34'!
left
	^ self move: #safeLeft.! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 17:36'!
leftOrElse: aBlock
	^ self move: #safeLeft orElse: aBlock.! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 17:34'!
right
	^ self move: #safeRight.! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 17:36'!
rightOrElse: aBlock
	^ self move: #safeRight orElse: aBlock.! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 12/31/2010 23:29'!
root
	"Return the possibly new/mutated tree under navigation"
	^ trail
		ifNil: [focus]
		ifNotNil: [self up root]! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 07:54'!
safeDown
	"Return a pair whose first element tells us whether successfully went down, and a Zipper. If yes, a Zipper focusing on the first child element of this node. If not, a Zipper focused on where we are."
	| success zipper |
	success := self focus children isEmpty
		ifTrue: [ #downAtLeafNode ]
		ifFalse: [ #success ].
	
	zipper := (success = #success) ifTrue:
		[TreeZipper new
			focus: focus children first
			trail: (TreeZipperNode
					path: trail
					value: focus value
					leftNodes: OrderedCollection new
					rightNodes: focus children allButFirst)
		] ifFalse: [self copy].
	^ {success. zipper.}! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 07:58'!
safeLeft
	| success zipper |
	trail
		ifNil: [ success := #leftAtRootNode ]
		ifNotNil: [trail leftNodes ifEmpty: [ success := #leftAtLeftmostSibling ]].
	success ifNil: [ success := #success ].
	
	zipper := (success = #success) ifTrue:
		[TreeZipper new
			focus: trail leftNodes first
			trail: (TreeZipperNode
				path: trail path
				value: trail value
				leftNodes: (trail leftNodes allButFirst)
				rightNodes: (trail rightNodes addFirst: focus; yourself))]
		ifFalse: [ self copy ].
	^ {success. zipper.}! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 17:27'!
safeRight
	| success zipper |
	trail
		ifNil: [ success := #rightAtRootNode ]
		ifNotNil: [ trail rightNodes ifEmpty: [ success := #rightAtRightmostSibling ]].
	success ifNil: [ success := #success ].
	
	zipper := (success = #success)
		ifTrue: [ TreeZipper new
			focus: trail rightNodes first
			trail: (TreeZipperNode
				path: trail path
				value: trail value
				leftNodes: (trail leftNodes addFirst: focus; yourself)
				rightNodes: trail rightNodes allButFirst) ]
		ifFalse: [ self copy ].
		
	^ {success. zipper.}! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 17:31'!
safeUp
	| success zipper |
	success := trail
		ifNil: [ #upAtRootNode ]
		ifNotNil: [ #success ].
	
	zipper := (success = #success)
		ifTrue: [ TreeZipper new
			focus: (ZTree
				value: trail value
				children: trail leftNodes reverse, focus asOrderedCollection, trail rightNodes)
			trail: trail path ]
		ifFalse: [ self copy ].
		
	^ {success. zipper.}! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 17:34'!
up
	^ self move: #safeUp.! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 17:35'!
upOrElse: aBlock
	^ self move: #safeUp orElse: aBlock.! !


!TreeZipper methodsFor: 'accessing' stamp: 'fbs 12/30/2010 22:06'!
focus
	^ focus.! !

!TreeZipper methodsFor: 'accessing' stamp: 'fbs 2/16/2011 07:45'!
trail
	^ trail.! !


!TreeZipper methodsFor: 'private' stamp: 'fbs 12/31/2010 16:37'!
focus: aTree trail: aTreeZipperNode
	focus := aTree.
	trail := aTreeZipperNode.! !

!TreeZipper methodsFor: 'private' stamp: 'fbs 2/16/2011 17:43'!
move: directionSelector
	"Move in some direction. If we fall off the data structure, raise an exception."
	| move |
	move := self perform: directionSelector.
	move first = #success ifFalse: [ ^ ZipperNavigation signal: move first ].
	
	^ move second.! !

!TreeZipper methodsFor: 'private' stamp: 'fbs 2/16/2011 17:43'!
move: directionSelector orElse: aBlock
	"Move in some direction. If we can't, run aBlock. If aBlock takes parameters, pass in the current focus as an argument."
	| move |
	move := self perform: directionSelector.
	^ move first = #success
		ifTrue: [ move second ]
		ifFalse: [ aBlock cull: self focus ].! !


!TreeZipper methodsFor: 'mutating' stamp: 'fbs 2/9/2011 09:15'!
change: aBlock
	"aBlock is a unary block whose evaluated value we use to replace the current focus."
	^ self changeTo: (aBlock value: focus value).! !

!TreeZipper methodsFor: 'mutating' stamp: 'fbs 12/31/2010 19:32'!
changeTo: newValue
	^ TreeZipper new
		focus: (ZTree
			value: newValue
			children: focus children)
		trail: trail.! !

!TreeZipper methodsFor: 'mutating' stamp: 'fbs 1/1/2011 17:17'!
delete
	trail ifNil: [^ ZipperNavigation signal: 'Delete at top'].
	
	(trail leftNodes isEmpty and: [trail rightNodes isEmpty]) ifTrue:
		[^ TreeZipper new
			focus: (ZTree value: trail value) 
			trail: trail path].
			
	trail leftNodes isEmpty ifTrue:
		[^ TreeZipper new
			focus: trail rightNodes first
			trail: (TreeZipperNode
				path: trail path
				value: trail value
				leftNodes: trail leftNodes
				rightNodes: trail rightNodes allButFirst)].
			
	^ TreeZipper new
		focus: trail leftNodes first
		trail: (TreeZipperNode
			path: trail path
			value: trail value
			leftNodes: trail leftNodes allButFirst
			rightNodes: trail rightNodes).! !

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


!TreeZipper methodsFor: 'copying' stamp: 'fbs 2/16/2011 07:45'!
copy
	^ TreeZipper new
		focus: self focus
		trail: self trail.! !


!TreeZipper methodsFor: 'testing' stamp: 'fbs 2/17/2011 07:43'!
isEmpty
	"We don't have a concept of an empty tree (a tree with no nodes). A tree with a single node is the closest we get. So an empty tree is a tree where we can go neither up nor down."
	| moveDown moveUp |
	moveDown := self safeDown.
	moveDown first = #success ifTrue: [ self safeUp ].
	moveUp := self safeUp.
	moveDown first = #success ifTrue: [ self safeUp ].
	
	^ (moveDown first ~= #success) and: [moveUp first ~= #success]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

TreeZipper class
	instanceVariableNames: ''!

!TreeZipper class methodsFor: 'instance creation' stamp: 'fbs 12/31/2010 16:36'!
on: aTree
	^ self new focus: aTree trail: nil.! !
