Object subclass: #BaseZipper
	instanceVariableNames: 'focus trail'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!
!BaseZipper commentStamp: 'fbs 1/1/2011 18:01' prior: 0!
I am a zipper for navigating over a variable-arity tree, that is a tree that may have any number of children per node.

That is, I allow one to navigate arbitrarily over a tree structure (a ZTree), and change parts of it, where "change" means "return a structure that shares part of the original structure, but otherwise leaves the host structure unchanged".!


!BaseZipper methodsFor: 'mutating' stamp: 'fbs 12/20/2011 21:23'!
change: aBlock
	"aBlock is a unary block whose evaluated value we use to replace the current focus."
	^ self mutate: (aBlock value: focus value) with: #safeChangeTo:.! !

!BaseZipper methodsFor: 'mutating' stamp: 'fbs 12/20/2011 21:23'!
changeTo: newValue
	^ self mutate: newValue with: #safeChangeTo:.! !

!BaseZipper methodsFor: 'mutating' stamp: 'fbs 12/20/2011 21:36'!
delete
	^ self move: #safeDelete.! !

!BaseZipper methodsFor: 'mutating' stamp: 'fbs 12/20/2011 21:15'!
insertDown: anObject
	"Insert anObject as a child node of the current focus. Sometimes you need a 'spacer' in your tree: a binary tree needs one so that the node can have just a right subtree. In that event, we insert a ZTree empty."

	^ self mutate: anObject with: #safeInsertDown:.! !

!BaseZipper methodsFor: 'mutating' stamp: 'fbs 12/20/2011 21:15'!
insertLeft: anObject
	^ self mutate: anObject with: #safeInsertLeft:.! !

!BaseZipper methodsFor: 'mutating' stamp: 'fbs 12/20/2011 21:16'!
insertRight: anObject
	^ self mutate: anObject with: #safeInsertRight:.! !

!BaseZipper methodsFor: 'mutating' stamp: 'fbs 12/20/2011 21:25'!
safeChange: aBlock
	^ self safeChangeTo: (aBlock value: focus value).! !

!BaseZipper methodsFor: 'mutating' stamp: 'fbs 12/20/2011 21:18'!
safeChangeTo: newValue
	| zipper |
	zipper := self class new
		focus: newValue
		trail: (trail class "This could be a normal context or the end context."
			path: trail path
			leftNodes: trail leftNodes
			rightNodes: trail rightNodes
			parentNodes: trail parentNodes
			changed: true).
	^ {#success. zipper.}! !

!BaseZipper methodsFor: 'mutating' stamp: 'fbs 12/22/2011 14:12'!
safeDelete
	| success |
	success := trail isEnd
		ifTrue: [#deleteAtRoot]
		ifFalse: [#success].

	(success = #success)
		ifFalse: [^ {success. self.}].
	
	(trail leftNodes isEmpty and: [trail rightNodes isEmpty]) ifTrue:
		[^ {success. self class new
			focus: (self newFocusOn: trail parentNode)
			trail: trail path}].
			
	trail leftNodes isEmpty ifTrue:
		[^ {success. self class new
			focus: trail rightNodes first
			trail: (TreeZipperNode
				path: trail path
				leftNodes: trail leftNodes
				rightNodes: trail rightNodes allButFirst
				parentNodes: trail parentNodes
				changed: true)}].
	
	^ {success. self class new
		focus: trail leftNodes last
		trail: (TreeZipperNode
			path: trail path
			leftNodes: trail leftNodes allButLast
			rightNodes: trail rightNodes
			parentNodes: trail parentNodes
			changed: true).}! !

!BaseZipper methodsFor: 'mutating' stamp: 'fbs 12/20/2011 21:09'!
safeInsertDown: anObject
	"Insert anObject as a child node of the current focus. Sometimes you need a 'spacer' in your tree: a binary tree needs one so that the node can have just a right subtree. In that event, we insert a ZTree empty."

	| zipper |
	zipper := focus isEmpty
		ifTrue: [self changeTo: anObject ]
		ifFalse: [ self class new
			focus: (anObject = ZTree empty
				ifTrue: [ ZTree empty ]
				ifFalse: [ self newFocusOn: anObject ])
			trail: (TreeZipperNode
				path: trail
				leftNodes: {}
				rightNodes: focus children
				parentNodes: trail parentNodes, {focus}
				changed: true) ].
	^ {#success. zipper.}.! !

!BaseZipper methodsFor: 'mutating' stamp: 'fbs 12/20/2011 20:57'!
safeInsertLeft: anObject
	| success zipper |
	success := trail isEnd
		ifTrue: [#insertLeftAtRoot]
		ifFalse: [#success].
		
	zipper := (success = #success)
		ifTrue: [
			self class new
				focus: (self newFocusOn: anObject)
				trail: (TreeZipperNode
					path: trail path
					leftNodes: trail leftNodes
					rightNodes: ({focus} , trail rightNodes)
					parentNodes: trail parentNodes
					changed: true)]
		ifFalse: [self].
	^ {success. zipper.}! !

!BaseZipper methodsFor: 'mutating' stamp: 'fbs 12/20/2011 20:50'!
safeInsertRight: anObject
	| success zipper |
	success := trail isEnd
		ifTrue: [#insertRightAtRoot]
		ifFalse: [#success].
		
	zipper := (success = #success)
		ifTrue: [
			self class new
			focus: (self newFocusOn: anObject)
			trail: (TreeZipperNode
				path: trail path
				leftNodes: (trail leftNodes , {focus})
				rightNodes: trail rightNodes
				parentNodes: trail parentNodes
				changed: true)]
		ifFalse: [self].
	^ {success. zipper.}! !


!BaseZipper methodsFor: 'private navigating' stamp: 'fbs 10/23/2011 11:23'!
changedRoot
	"Return the possibly new/mutated tree under navigation"
	^ trail isEnd
		ifTrue: [focus]
		ifFalse: [self changedUp changedRoot].! !

!BaseZipper methodsFor: 'private navigating' stamp: 'fbs 10/19/2011 17:25'!
changedUp
	^ self move: #safeChangedUp.! !

!BaseZipper methodsFor: 'private navigating' stamp: 'fbs 12/20/2011 12:22'!
safeChangedUp
	"When part of the structure has changed, return a pair (successfully moved, zipper on new location)."
	| success zipper |
	success := trail isEnd
		ifTrue: [ #upAtRootNode ]
		ifFalse: [ #success ].
	
	zipper := (success = #success)
		ifTrue: [ self class new
					focus: (self
						newFocusOn: trail parentNode
						children: trail leftNodes reverse, {focus} , trail rightNodes)
					trail: trail path ]
		ifFalse: [ self ].
		
	^ {success. zipper.}! !


!BaseZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 11/12/2011 20:56'!
children
	self subclassResponsibility.! !

!BaseZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 11/12/2011 21:00'!
isBranch
	self subclassResponsibility.! !

!BaseZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 11/12/2011 20:56'!
isEmpty
	self subclassResponsibility.! !

!BaseZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 11/12/2011 20:57'!
newFocusOn: anObject
	self subclassResponsibility.! !

!BaseZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 11/12/2011 20:57'!
newFocusOn: anObject children: aCollection
	self subclassResponsibility.! !


!BaseZipper methodsFor: 'copying' stamp: 'fbs 6/6/2011 10:28'!
copy
	^ self class new
		focus: self focus
		trail: self trail.! !


!BaseZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 17:33'!
down
	"Return a Zipper focusing on the first child element of this node."
	^ self move: #safeDown.! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 17:37'!
downOrElse: aBlock
	^ self move: #safeDown orElse: aBlock.! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 17:34'!
left
	^ self move: #safeLeft.! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 17:36'!
leftOrElse: aBlock
	^ self move: #safeLeft orElse: aBlock.! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 12/22/2011 14:00'!
leftmost
	^ self move: #safeLeftmost.! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 17:34'!
right
	^ self move: #safeRight.! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 17:36'!
rightOrElse: aBlock
	^ self move: #safeRight orElse: aBlock.! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 12/22/2011 14:02'!
rightmost
	^ self move: #safeRightmost! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 10/23/2011 11:23'!
root
	"Return the possibly new/mutated tree under navigation"
	^ trail isEnd
		ifTrue: [focus]
		ifFalse: [trail changed
			ifTrue: [self changedUp changedRoot]
			ifFalse: [self up root]]! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 12/20/2011 20:39'!
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
					leftNodes: {}
					rightNodes: focus children allButFirst
					parentNodes: trail parentNodes, {focus}
					changed: false)
		] ifFalse: [ self ].
	^ {success. zipper.}! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 12/22/2011 14:11'!
safeLeft
	"Return a pair (successfully moved, zipper on new location)."
	| success zipper |
	trail isEnd
		ifTrue: [ success := #leftAtRootNode ]
		ifFalse: [trail leftNodes ifEmpty: [ success := #leftAtLeftmostSibling ]].
	success ifNil: [ success := #success ].
	
	zipper := (success = #success) ifTrue:
		[self class new
			focus: trail leftNodes last
			trail: (TreeZipperNode
				path: trail path
				leftNodes: (trail leftNodes allButLast)
				rightNodes: ({focus} , trail rightNodes)
				parentNodes: trail parentNodes
				changed: false)]
		ifFalse: [ self ].
	^ {success. zipper.}! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 12/22/2011 14:11'!
safeLeftmost
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
				leftNodes: #()
				rightNodes: (trail leftNodes allButFirst, {focus} , trail rightNodes)
				parentNodes: trail parentNodes
				changed: false)]
		ifFalse: [ self ].
	^ {success. zipper.}! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 12/22/2011 14:12'!
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
				leftNodes: (trail leftNodes, {focus})
				rightNodes: trail rightNodes allButFirst
				parentNodes: trail parentNodes
				changed: false) ]
		ifFalse: [ self ].
		
	^ {success. zipper.}! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 12/22/2011 14:01'!
safeRightmost
	"Return a pair (successfully moved, zipper on new location)."
	| success zipper |
	trail isEnd
		ifTrue: [ success := #rightAtRootNode ]
		ifFalse: [ trail rightNodes ifEmpty: [ success := #rightAtRightmostSibling ]].
	success ifNil: [ success := #success ].
	
	zipper := (success = #success)
		ifTrue: [ self class new
			focus: trail rightNodes last
			trail: (TreeZipperNode
				path: trail path
				leftNodes: (trail leftNodes, {focus}, trail rightNodes allButLast)
				rightNodes: #()
				parentNodes: trail parentNodes
				changed: false) ]
		ifFalse: [ self ].
		
	^ {success. zipper.}! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 12/20/2011 20:39'!
safeUp
	"When no part of (this local part of) the structure has changed, return a pair (successfully moved, zipper on identical location)."
	| success zipper |
	success := trail isEnd
		ifTrue: [ #upAtRootNode ]
		ifFalse: [ #success ].
	
	zipper := (success = #success)
		ifTrue: [ self class new
					focus: trail parentNodes last
					trail: trail path ]
		ifFalse: [ self ].
		
	^ {success. zipper.}! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 17:34'!
up
	^ self move: #safeUp.! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 2/16/2011 17:35'!
upOrElse: aBlock
	^ self move: #safeUp orElse: aBlock.! !


!BaseZipper methodsFor: 'accessing' stamp: 'fbs 12/30/2010 22:06'!
focus
	^ focus.! !

!BaseZipper methodsFor: 'accessing' stamp: 'fbs 2/16/2011 07:45'!
trail
	^ trail.! !


!BaseZipper methodsFor: 'private' stamp: 'fbs 12/31/2010 16:37'!
focus: aTree trail: aTreeZipperNode
	focus := aTree.
	trail := aTreeZipperNode.! !

!BaseZipper methodsFor: 'private' stamp: 'fbs 2/16/2011 17:43'!
move: directionSelector
	"Move in some direction. If we fall off the data structure, raise an exception."
	| move |
	move := self perform: directionSelector.
	move first = #success ifFalse: [ ^ ZipperNavigation signal: move first ].
	
	^ move second.! !

!BaseZipper methodsFor: 'private' stamp: 'fbs 2/16/2011 17:43'!
move: directionSelector orElse: aBlock
	"Move in some direction. If we can't, run aBlock. If aBlock takes parameters, pass in the current focus as an argument."
	| move |
	move := self perform: directionSelector.
	^ move first = #success
		ifTrue: [ move second ]
		ifFalse: [ aBlock cull: self focus ].! !

!BaseZipper methodsFor: 'private' stamp: 'fbs 12/20/2011 21:14'!
mutate: anObject with: actionSelector
	| attempt |
	attempt := self perform: actionSelector with: anObject.
	(attempt first = #success)
		ifTrue: [ ^ attempt second].
		
	ZipperNavigation signal: attempt first.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

BaseZipper class
	instanceVariableNames: ''!

!BaseZipper class methodsFor: 'instance creation' stamp: 'fbs 10/18/2011 16:22'!
on: aTree
	^ self new focus: aTree trail: TreeZipperNode end.! !
