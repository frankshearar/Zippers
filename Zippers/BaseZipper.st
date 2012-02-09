Object subclass: #BaseZipper
	instanceVariableNames: 'focus trail'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!
!BaseZipper commentStamp: 'fbs 1/21/2012 09:49' prior: 0!
I am a zipper for navigating over an hierarchical structure.

That is, I allow one to navigate arbitrarily over a tree structure, and change parts of it, where "change" means "return a structure that shares part of the original structure, but otherwise leaves the host structure unchanged".

 My subclasses define the three structure-specific pieces I need, namely,
* can this node have children? (#branch)
* what are this node's children? (#children)
* how can I construct a new node, given a parent and some children nodes? (#newFocusOn:children)!


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

!BaseZipper methodsFor: 'mutating' stamp: 'fbs 2/5/2012 08:28'!
safeChangeTo: newValue
	^ Right value: (self class new
		focus: newValue
		trail: (trail class "This could be a normal context or the root context."
			path: trail path
			leftNodes: trail leftNodes
			rightNodes: trail rightNodes
			parentNodes: trail parentNodes
			changed: true))! !

!BaseZipper methodsFor: 'mutating' stamp: 'fbs 2/5/2012 08:30'!
safeDelete
	trail isRoot ifTrue: [^ Left value: (ZipperError error: #deleteAtRoot location: self)].
	
	(trail leftNodes isEmpty and: [trail rightNodes isEmpty]) ifTrue:
		[^ Right value: (self class new
			focus: (self newFocusOn: trail parentNode)
			trail: trail path)].
			
	trail leftNodes isEmpty ifTrue:
		[^ Right value: (self class new
			focus: trail rightNodes first
			trail: (ZipperContext
				path: trail path
				leftNodes: trail leftNodes
				rightNodes: trail rightNodes allButFirst
				parentNodes: trail parentNodes
				changed: true))].
	
	^ Right value: (self class new
		focus: trail leftNodes last
		trail: (ZipperContext
			path: trail path
			leftNodes: trail leftNodes allButLast
			rightNodes: trail rightNodes
			parentNodes: trail parentNodes
			changed: true)).! !

!BaseZipper methodsFor: 'mutating' stamp: 'fbs 2/5/2012 08:32'!
safeInsertDown: anObject
	"Insert anObject as a child node of the current focus. Sometimes you need a 'spacer' in your tree: a binary tree needs one so that the node can have just a right subtree. In that event, we insert a ZTree empty."

	focus isEmpty ifTrue: [^ self safeChangeTo: anObject].
	
	^ Right value: (self class new
			focus: (anObject = ZTree empty
				ifTrue: [ ZTree empty ]
				ifFalse: [ self newFocusOn: anObject ])
			trail: (ZipperContext
				path: trail
				leftNodes: {}
				rightNodes: focus children
				parentNodes: trail parentNodes, {focus}
				changed: true))! !

!BaseZipper methodsFor: 'mutating' stamp: 'fbs 2/5/2012 08:32'!
safeInsertLeft: anObject
	trail isRoot ifTrue: [^ Left value: (ZipperError error: #insertLeftAtRoot location: self)].

	^ Right value: (self class new
				focus: (self newFocusOn: anObject)
				trail: (ZipperContext
					path: trail path
					leftNodes: trail leftNodes
					rightNodes: ({focus} , trail rightNodes)
					parentNodes: trail parentNodes
					changed: true)).! !

!BaseZipper methodsFor: 'mutating' stamp: 'fbs 2/5/2012 08:33'!
safeInsertRight: anObject
	trail isRoot ifTrue: [^ Left value: (ZipperError error: #insertRightAtRoot location: self)].
		
	^ Right value: (self class new
			focus: (self newFocusOn: anObject)
			trail: (ZipperContext
				path: trail path
				leftNodes: (trail leftNodes , {focus})
				rightNodes: trail rightNodes
				parentNodes: trail parentNodes
				changed: true)).! !


!BaseZipper methodsFor: 'private navigating' stamp: 'fbs 2/4/2012 22:11'!
changedRoot
	"Return the possibly new/mutated tree under navigation"
	^ trail isRoot
		ifTrue: [focus]
		ifFalse: [self changedUp changedRoot].! !

!BaseZipper methodsFor: 'private navigating' stamp: 'fbs 10/19/2011 17:25'!
changedUp
	^ self move: #safeChangedUp.! !

!BaseZipper methodsFor: 'private navigating' stamp: 'fbs 2/5/2012 08:34'!
safeChangedUp
	"When part of the structure has changed, return a pair (successfully moved, zipper on new location)."
	trail isRoot ifTrue: [^ Left value: (ZipperError error: #upAtRootNode location: self)].
	
	^ Right value: (self class new
					focus: (self
						newFocusOn: trail parentNode
						children: trail leftNodes reverse, {focus} , trail rightNodes)
					trail: trail path).! !


!BaseZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 11/12/2011 20:56'!
children
	self subclassResponsibility.! !

!BaseZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 11/12/2011 21:00'!
isBranch
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

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 2/4/2012 22:11'!
root
	"Return the possibly new/mutated tree under navigation"
	^ trail isRoot
		ifTrue: [focus]
		ifFalse: [trail changed
			ifTrue: [self changedUp changedRoot]
			ifFalse: [self up root]]! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 2/7/2012 09:37'!
safeDown
	"Return a pair whose first element tells us whether we successfully went down (represented by the value #success), and a Zipper. If yes, a Zipper focusing on the first child element of this node. If not, a Zipper focused on where we are."
	^ self isBranch
		ifTrue: [Right value: 
			(self class new
			focus: self children first
			trail: (ZipperContext
					path: trail
					leftNodes: {}
					rightNodes: self children allButFirst
					parentNodes: trail parentNodes, {focus}
					changed: false))]
		ifFalse: [Left value: (ZipperError error: #downAtLeafNode location: self)].! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 2/5/2012 08:23'!
safeLeft
	"Return a pair (successfully moved, zipper on new location)."
	trail isRoot ifTrue: [^ Left value: (ZipperError error: #leftAtRootNode location: self)].
	trail leftNodes ifEmpty: [^ Left value: (ZipperError error: #leftAtRootNode location: self)].

	^ Right value: (self class new
			focus: trail leftNodes last
			trail: (ZipperContext
				path: trail path
				leftNodes: (trail leftNodes allButLast)
				rightNodes: ({focus} , trail rightNodes)
				parentNodes: trail parentNodes
				changed: false)).! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 2/5/2012 08:24'!
safeLeftmost
	"Return a pair (successfully moved, zipper on new location)."
	trail isRoot ifTrue: [^ Left value: (ZipperError error: #leftAtRootNode location: self)].
	trail leftNodes ifEmpty: [^ Left value: (ZipperError error: #leftAtLeftmostSibling location: self)].

	^ Right value: (self class new
			focus: trail leftNodes first
			trail: (ZipperContext
				path: trail path
				leftNodes: #()
				rightNodes: (trail leftNodes allButFirst, {focus} , trail rightNodes)
				parentNodes: trail parentNodes
				changed: false)).! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 2/5/2012 08:26'!
safeRight
	"Return a pair (successfully moved, zipper on new location)."
	trail isRoot ifTrue: [^ Left value: (ZipperError error: #rightAtRootNode location: self)].
	trail rightNodes ifEmpty: [^ Left value: (ZipperError error: #rightAtRightmostSibling location: self)].

	^ Right value: (self class new
			focus: trail rightNodes first
			trail: (ZipperContext
				path: trail path
				leftNodes: (trail leftNodes, {focus})
				rightNodes: trail rightNodes allButFirst
				parentNodes: trail parentNodes
				changed: false)).! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 2/5/2012 21:58'!
safeRightmost
	"Return a pair (successfully moved, zipper on new location)."
	trail isRoot ifTrue: [^ Left value: (ZipperError error: #rightAtRootNode location: self)].
	trail rightNodes ifEmpty: [^ Left value: (ZipperError error: #rightAtRightmostSibling location: self)].
	
	^ Right value: (self class new
			focus: trail rightNodes last
			trail: (ZipperContext
				path: trail path
				leftNodes: (trail leftNodes, {focus}, trail rightNodes allButLast)
				rightNodes: #()
				parentNodes: trail parentNodes
				changed: false)).! !

!BaseZipper methodsFor: 'navigating' stamp: 'fbs 2/5/2012 08:27'!
safeUp
	"When no part of (this local part of) the structure has changed, return a pair (successfully moved, zipper on identical location)."
	trail isRoot ifTrue: [ ^ Left value: (ZipperError error: #upAtRootNode location: self)].

	^ Right value: (self class new
		focus: trail parentNodes last
		trail: trail path).! !

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

!BaseZipper methodsFor: 'private' stamp: 'fbs 2/5/2012 08:42'!
move: directionSelector
	"Move in some direction. If we fall off the data structure, raise an exception."
	| move |
	move := self perform: directionSelector.
	^ move
		ifLeft: [ZipperNavigation signal: move value error]
		ifRight: [move value]! !

!BaseZipper methodsFor: 'private' stamp: 'fbs 2/5/2012 08:43'!
move: directionSelector orElse: aBlock
	"Move in some direction. If we can't, run aBlock. If aBlock takes parameters, pass in the current focus as an argument."
	| move |
	move := self perform: directionSelector.
	^ move
		ifRight: [ move value ]
		ifLeft: [ aBlock cull: self focus ].! !

!BaseZipper methodsFor: 'private' stamp: 'fbs 2/5/2012 21:35'!
mutate: anObject with: actionSelector
	| attempt |
	attempt := self perform: actionSelector with: anObject.
	^ attempt
		ifRight: [attempt value]
		ifLeft: [ZipperNavigation signal: attempt value error]! !

!BaseZipper methodsFor: 'private' stamp: 'fbs 1/21/2012 09:49'!
newFocusOn: anObject
	^ self newFocusOn: anObject children: #().! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

BaseZipper class
	instanceVariableNames: ''!

!BaseZipper class methodsFor: 'instance creation' stamp: 'fbs 2/4/2012 22:43'!
on: aTree
	^ self new focus: aTree trail: ZipperContext root.! !
!
s as an argument."
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

!BaseZipper methodsFor: 'private' stamp: 'fbs 1/21/2012 09:49'!
newFocusOn: anObject
	^ self newFocusOn: anObject children: #().! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

BaseZipper class
	instanceVariableNames: ''!

!BaseZipper class methodsFor: 'instance creation' stamp: 'fbs 2/4/2012 22:43'!
on: aTree
	^ self new focus: aTree trail: ZipperContext root.! !
il: TreeZipperNode end.! !
