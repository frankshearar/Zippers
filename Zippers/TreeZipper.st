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

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 2/28/2011 22:45'!
safeDown
	"Return a pair whose first element tells us whether we successfully went down (represented by the value #success), and a Zipper. If yes, a Zipper focusing on the first child element of this node. If not, a Zipper focused on where we are."
	| success zipper |
	success := self focus children isEmpty
		ifTrue: [ #downAtLeafNode ]
		ifFalse: [ #success ].
	
	zipper := (success = #success) ifTrue:
		[self class new
			focus: focus children first
			trail: (TreeZipperNode
					path: trail
					value: focus value
					leftNodes: OrderedCollection new
					rightNodes: focus children allButFirst)
		] ifFalse: [ self ].
	^ {success. zipper.}! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 2/28/2011 22:46'!
safeLeft
	"Return a pair (successfully moved, zipper on new location)."
	| success zipper |
	trail
		ifNil: [ success := #leftAtRootNode ]
		ifNotNil: [trail leftNodes ifEmpty: [ success := #leftAtLeftmostSibling ]].
	success ifNil: [ success := #success ].
	
	zipper := (success = #success) ifTrue:
		[self class new
			focus: trail leftNodes first
			trail: (TreeZipperNode
				path: trail path
				value: trail value
				leftNodes: (trail leftNodes allButFirst)
				rightNodes: (trail rightNodes addFirst: focus; yourself))]
		ifFalse: [ self ].
	^ {success. zipper.}! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 2/28/2011 22:46'!
safeRight
	"Return a pair (successfully moved, zipper on new location)."
	| success zipper |
	trail
		ifNil: [ success := #rightAtRootNode ]
		ifNotNil: [ trail rightNodes ifEmpty: [ success := #rightAtRightmostSibling ]].
	success ifNil: [ success := #success ].
	
	zipper := (success = #success)
		ifTrue: [ self class new
			focus: trail rightNodes first
			trail: (TreeZipperNode
				path: trail path
				value: trail value
				leftNodes: (trail leftNodes addFirst: focus; yourself)
				rightNodes: trail rightNodes allButFirst) ]
		ifFalse: [ self ].
		
	^ {success. zipper.}! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 2/28/2011 22:46'!
safeUp
	"Return a pair (successfully moved, zipper on new location)."
	| success zipper |
	success := trail
		ifNil: [ #upAtRootNode ]
		ifNotNil: [ #success ].
	
	zipper := (success = #success)
		ifTrue: [ self class new
			focus: (ZTree
				value: trail value
				children: trail leftNodes reverse, focus asOrderedCollection, trail rightNodes)
			trail: trail path ]
		ifFalse: [ self ].
		
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

!TreeZipper methodsFor: 'mutating' stamp: 'fbs 4/28/2011 22:28'!
insertDown: anObject
	"Insert anObject as a child node of the current focus. Sometimes you need a 'spacer' in your tree: a binary tree needs one so that the node can have just a right subtree. In that event, we insert a ZTree empty."

	^ focus isEmpty
		ifTrue: [self changeTo: anObject ]
		ifFalse: [ TreeZipper new
			focus: (anObject = ZTree empty
				ifTrue: [ ZTree empty ]
				ifFalse: [ ZTree value: anObject ])
			trail: (TreeZipperNode
				path: trail
				value: focus value
				leftNodes: OrderedCollection new
				rightNodes: focus children) ]! !

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


!TreeZipper methodsFor: 'testing' stamp: 'fbs 2/25/2011 17:35'!
isEmpty
	^ focus isEmpty.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

TreeZipper class
	instanceVariableNames: ''!

!TreeZipper class methodsFor: 'instance creation' stamp: 'fbs 12/31/2010 16:36'!
on: aTree
	^ self new focus: aTree trail: nil.! !
e trail: nil.! !
