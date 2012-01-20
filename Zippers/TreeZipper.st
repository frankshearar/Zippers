BaseZipper subclass: #TreeZipper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!
!TreeZipper commentStamp: 'fbs 1/1/2011 18:01' prior: 0!
I am a zipper for navigating over a variable-arity tree, that is a tree that may have any number of children per node.

That is, I allow one to navigate arbitrarily over a tree structure (a ZTree), and change parts of it, where "change" means "return a structure that shares part of the original structure, but otherwise leaves the host structure unchanged".!









!TreeZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 10/17/2011 08:20'!
children
	^ self focus children! !

!TreeZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 10/15/2011 23:11'!
isBranch
	^ self focus children notEmpty! !

!TreeZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 11/12/2011 20:56'!
isEmpty
	^ focus isEmpty.! !

!TreeZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 10/15/2011 22:43'!
newFocusOn: anObject
	^ ZTree value: anObject children: #().! !

!TreeZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 10/15/2011 22:44'!
newFocusOn: anObject children: aCollection
	^ ZTree value: anObject children: aCollection.! !
avigating' stamp: 'fbs 2/16/2011 17:36'!
rightOrElse: aBlock
	^ self move: #safeRight orElse: aBlock.! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 10/23/2011 11:23'!
root
	"Return the possibly new/mutated tree under navigation"
	^ trail isEnd
		ifTrue: [focus]
		ifFalse: [trail changed
			ifTrue: [self changedUp changedRoot]
			ifFalse: [self up root]]! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 10/31/2011 21:52'!
safeDown
	"Return a pair whose first element tells us whether we successfully went down (represented by the value #success), and a Zipper. If yes, a Zipper focusing on the first child element of this node. If not, a Zipper focused on where we are."
	| success zipper |
	success := self isBranch
		ifTrue: [ #success ]
		ifFalse: [ #downAtLeafNode ].
	
	zipper := (success = #success) ifTrue:
		[self class new
			focus: focus children first
			trail: (TreeZipperNode
					path: trail
					value: focus value
					leftNodes: {}
					rightNodes: focus children allButFirst
					visitedNodes: trail visitedNodes , {focus}
					changed: false)
		] ifFalse: [ self ].
	^ {success. zipper.}! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 10/31/2011 21:53'!
safeLeft
	"Return a pair (successfully moved, zipper on new location)."
	| success zipper |
	trail isEnd
		ifTrue: [ success := #leftAtRootNode ]
		ifFalse: [trail leftNodes ifEmpty: [ success := #leftAtLeftmostSibling ]].
	success ifNil: [ success := #success ].
	
	zipper := (success = #success) ifTrue:
		[self class new
			focus: trail leftNodes first
			trail: (TreeZipperNode
				path: trail path
				value: trail value
				leftNodes: (trail leftNodes allButFirst)
				rightNodes: ({focus} , trail rightNodes)
				visitedNodes: trail visitedNodes
				changed: false)]
		ifFalse: [ self ].
	^ {success. zipper.}! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 10/31/2011 21:53'!
safeRight
	"Return a pair (successfully moved, zipper on new location)."
	| success zipper |
	trail isEnd
		ifTrue: [ success := #rightAtRootNode ]
		ifFalse: [ trail rightNodes ifEmpty: [ success := #rightAtRightmostSibling ]].
	success ifNil: [ success := #success ].
	
	zipper := (success = #success)
		ifTrue: [ self class new
			focus: trail rightNodes first
			trail: (TreeZipperNode
				path: trail path
				value: trail value
				leftNodes: ({focus} , trail leftNodes)
				rightNodes: trail rightNodes allButFirst
				visitedNodes: trail visitedNodes
				changed: false) ]
		ifFalse: [ self ].
		
	^ {success. zipper.}! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 10/19/2011 17:27'!
safeUp
	"When no part of (this local part of) the structure has changed, return a pair (successfully moved, zipper on identical location)."
	| success zipper |
	success := trail isEnd
		ifTrue: [ #upAtRootNode ]
		ifFalse: [ #success ].
	
	zipper := (success = #success)
		ifTrue: [ self class new
					focus: trail visitedNodes last
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

!TreeZipper methodsFor: 'mutating' stamp: 'fbs 11/1/2011 08:22'!
changeTo: newValue
	^ self class new
		focus: (self newFocusOn: newValue children: focus children)
		trail: (trail class "This could be a normal context or the end context."
			path: trail path
			value: trail value
			leftNodes: trail leftNodes
			rightNodes: trail rightNodes
			visitedNodes: trail visitedNodes , {focus}
			changed: true).! !

!TreeZipper methodsFor: 'mutating' stamp: 'fbs 10/18/2011 16:28'!
delete
	trail isEnd ifTrue: [^ ZipperNavigation signal: 'Delete at top'].
	
	(trail leftNodes isEmpty and: [trail rightNodes isEmpty]) ifTrue:
		[^ self class new
			focus: (self newFocusOn: trail value) 
			trail: trail path].
			
	trail leftNodes isEmpty ifTrue:
		[^ self class new
			focus: trail rightNodes first
			trail: (TreeZipperNode
				path: trail path
				value: trail value
				leftNodes: trail leftNodes
				rightNodes: trail rightNodes allButFirst
				visitedNodes: trail visitedNodes
				changed: true)].
			
	^ self class new
		focus: trail leftNodes first
		trail: (TreeZipperNode
			path: trail path
			value: trail value
			leftNodes: trail leftNodes allButFirst
			rightNodes: trail rightNodes
			visitedNodes: trail visitedNodes
			changed: true).! !

!TreeZipper methodsFor: 'mutating' stamp: 'fbs 10/31/2011 21:51'!
insertDown: anObject
	"Insert anObject as a child node of the current focus. Sometimes you need a 'spacer' in your tree: a binary tree needs one so that the node can have just a right subtree. In that event, we insert a ZTree empty."

	^ focus isEmpty
		ifTrue: [self changeTo: anObject ]
		ifFalse: [ self class new
			focus: (anObject = ZTree empty
				ifTrue: [ ZTree empty ]
				ifFalse: [ self newFocusOn: anObject ])
			trail: (TreeZipperNode
				path: trail
				value: focus value
				leftNodes: {}
				rightNodes: focus children
				visitedNodes: trail visitedNodes , {focus}
				changed: true) ]! !

!TreeZipper methodsFor: 'mutating' stamp: 'fbs 10/31/2011 21:51'!
insertLeft: anObject
	trail ifNil: [^ ZipperNavigation signal: 'Insert at top'].
	^ self class new
		focus: (self newFocusOn: anObject)
		trail: (TreeZipperNode
			path: trail path
			value: trail value
			leftNodes: trail leftNodes
			rightNodes: ({focus} , trail rightNodes)
			visitedNodes: trail visitedNodes
			changed: true)! !

!TreeZipper methodsFor: 'mutating' stamp: 'fbs 10/31/2011 21:51'!
insertRight: anObject
	trail ifNil: [^ ZipperNavigation signal: 'Insert at top'].
	^ self class new
		focus: (self newFocusOn: anObject)
		trail: (TreeZipperNode
			path: trail path
			value: trail value
			leftNodes: (trail leftNodes , {focus})
			rightNodes: trail rightNodes
			visitedNodes: trail visitedNodes
			changed: true)! !


!TreeZipper methodsFor: 'copying' stamp: 'fbs 6/6/2011 10:28'!
copy
	^ self class new
		focus: self focus
		trail: self trail.! !



!TreeZipper methodsFor: 'private navigating' stamp: 'fbs 10/23/2011 11:23'!
changedRoot
	"Return the possibly new/mutated tree under navigation"
	^ trail isEnd
		ifTrue: [focus]
		ifFalse: [self changedUp changedRoot].! !

!TreeZipper methodsFor: 'private navigating' stamp: 'fbs 10/19/2011 17:25'!
changedUp
	^ self move: #safeChangedUp.! !

!TreeZipper methodsFor: 'private navigating' stamp: 'fbs 10/19/2011 17:26'!
safeChangedUp
	"When part of the structure has changed, return a pair (successfully moved, zipper on new location)."
	| success zipper |
	success := trail isEnd
		ifTrue: [ #upAtRootNode ]
		ifFalse: [ #success ].
	
	zipper := (success = #success)
		ifTrue: [ self class new
					focus: (self
						newFocusOn: trail value
						children: trail leftNodes reverse, {focus} , trail rightNodes)
					trail: trail path ]
		ifFalse: [ self ].
		
	^ {success. zipper.}! !


!TreeZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 10/17/2011 08:18'!
children
	^ self focus children.
	"self subclassResponsibility."! !

!TreeZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 10/15/2011 23:16'!
isBranch
	^ self focus children notEmpty.
	"self subclassResponsibility."! !

!TreeZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 2/25/2011 17:35'!
isEmpty
	^ focus isEmpty.! !

!TreeZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 6/6/2011 12:08'!
newFocusOn: anObject
	^ ZTree value: anObject children: #().! !

!TreeZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 6/6/2011 12:06'!
newFocusOn: anObject children: aCollection
	^ ZTree value: anObject children: aCollection.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

TreeZipper class
	instanceVariableNames: ''!

!TreeZipper class methodsFor: 'instance creation' stamp: 'fbs 10/18/2011 16:22'!
on: aTree
	^ self new focus: aTree trail: TreeZipperNode end.! !
