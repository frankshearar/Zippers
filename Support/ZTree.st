Object subclass: #ZTree
	instanceVariableNames: 'children value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Support'!
!ZTree commentStamp: 'fbs 12/30/2010 23:32' prior: 0!
I'm a basic implementation of a tree, only present so that my package doesn't need to rely on a separate tree package.!


!ZTree methodsFor: 'accessing' stamp: 'fbs 12/30/2010 23:33'!
children
	^ children! !

!ZTree methodsFor: 'accessing' stamp: 'fbs 12/30/2010 23:40'!
value
	^ value.! !


!ZTree methodsFor: 'initialize-release' stamp: 'fbs 12/30/2010 23:34'!
initialize
	super initialize.
	children := OrderedCollection new.! !


!ZTree methodsFor: 'printing' stamp: 'fbs 12/30/2010 23:54'!
printString
	^ '(', self value printString,
		(children
			ifEmpty: ['']
			ifNotEmpty: [' ', (self children reduce: [:a :b | a printString, ', ', b printString])]),
		')'.! !


!ZTree methodsFor: 'private' stamp: 'fbs 12/30/2010 23:41'!
value: anObject children: aCollection
	value := anObject.
	children := aCollection asOrderedCollection.! !


!ZTree methodsFor: 'comparing' stamp: 'fbs 12/31/2010 00:08'!
= anObject
	^ anObject class == self class and:
		[self value = anObject value and:
			[self children = anObject children]].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ZTree class
	instanceVariableNames: ''!

!ZTree class methodsFor: 'instance creation' stamp: 'fbs 12/30/2010 23:40'!
value: anObject
	^ self new value: anObject children: OrderedCollection new.! !

!ZTree class methodsFor: 'instance creation' stamp: 'fbs 12/30/2010 23:41'!
value: anObject children: aCollection
	^ self new value: anObject children: aCollection.! !
ction.! !
ableZTree new.
	mutableCopy value: self value.
	mutableCopy children addAll: (self children collect: #asMutableTree).
	^ mutableCopy.! !

!ZTree methodsFor: 'converting' stamp: 'fbs 4/30/2011 22:30'!
asOrderedCollection
	^ self collect: #yourself! !

!ZTree methodsFor: 'converting' stamp: 'fbs 4/30/2011 17:09'!
balance
	"Return a balanced copy of self."
	^ self asOrderedCollection asBalancedBinaryTree.! !

!ZTree methodsFor: 'converting' stamp: 'fbs 4/30/2011 21:18'!
balanceDSW
	"Return a balanced copy of self."
	^ self asMutableTree balance asImmutableTree.! !

!ZTree methodsFor: 'converting' stamp: 'fbs 5/1/2011 10:16'!
balanceDSW2
	"Return a balanced copy of self."
	^ self asMutableTree balance asImmutableTree2.! !


!ZTree methodsFor: 'private' stamp: 'fbs 4/24/2011 10:35'!
associations
	^ self associationsWithLabels: [:node | node value].! !

!ZTree methodsFor: 'private' stamp: 'fbs 4/23/2011 22:00'!
associationsWithLabels: aBlock
	^ (self children
		inject: OrderedCollection new
		into: [:acc :each | acc addAll: each associations; yourself]) ,
	(self children collect: [:child | (aBlock value: self) -> (aBlock value: child)]).! !

!ZTree methodsFor: 'private' stamp: 'fbs 4/27/2011 17:54'!
childrenEqual: aCollection
	"Compare this node's children against another collection of children. Note that a missing child is semantically identical to that child being the empty (sub)tree."
	1 to: (children size max: aCollection size) do:
		[:i | | left right |
		left := children at: i ifAbsent: [ZTree empty].
		right := aCollection at: i ifAbsent: [ZTree empty].
		(left = right) ifFalse: [^false]].
	^ true.! !

!ZTree methodsFor: 'private' stamp: 'fbs 4/24/2011 12:48'!
printChildRecords
	^ (PreOrderTraversal new
		traverseNodes: self
		collecting: #asDotNode)
		reduce: [:acc :e | acc , Character cr, e].! !

!ZTree methodsFor: 'private' stamp: 'fbs 12/31/2010 16:54'!
value: anObject children: aCollection
	value := anObject.
	children := aCollection asOrderedCollection.! !


!ZTree methodsFor: 'accessing' stamp: 'fbs 12/30/2010 23:33'!
children
	^ children! !

!ZTree methodsFor: 'accessing' stamp: 'fbs 12/31/2010 16:54'!
value
	^ value.! !


!ZTree methodsFor: 'enumerating' stamp: 'fbs 4/30/2011 22:29'!
collect: aBlock
	^ InOrderTraversal new traverse: self collecting: aBlock.! !

!ZTree methodsFor: 'enumerating' stamp: 'fbs 12/31/2010 19:21'!
zipper
	^ TreeZipper on: self.! !


!ZTree methodsFor: 'testing' stamp: 'fbs 4/30/2011 17:28'!
depth
	self hasChildren ifFalse: [ ^ 1 ].
	
	^ 1 + (children collect: #depth) max.! !

!ZTree methodsFor: 'testing' stamp: 'fbs 4/30/2011 15:32'!
hasChildren
	^ (children reject: #isEmpty) isEmpty not.! !

!ZTree methodsFor: 'testing' stamp: 'fbs 4/30/2011 17:31'!
isBalanced
	| depths |
	self hasChildren ifFalse: [ ^ true ].

	depths := (self children collect: #depth) asSortedCollection.
	"A tree with one subtree of depth 1is balanced."
	(depths size = 1) ifTrue: [ ^ depths first = 1 ].
	"A tree with many subtrees is balanced if there is at most a difference of 1 between the depths of its subtrees."
	^ (depths last - depths first) <= 1.! !

!ZTree methodsFor: 'testing' stamp: 'fbs 2/24/2011 17:26'!
isEmpty
	^ false.! !


!ZTree methodsFor: 'initialize-release' stamp: 'fbs 12/30/2010 23:34'!
initialize
	super initialize.
	children := OrderedCollection new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ZTree class
	instanceVariableNames: ''!

!ZTree class methodsFor: 'instance creation' stamp: 'fbs 2/22/2011 21:41'!
empty
	^ Empty ifNil: [Empty := ZEmptyTree new].! !

!ZTree class methodsFor: 'instance creation' stamp: 'fbs 2/25/2011 17:53'!
value: anObject
	^ anObject = ZTree empty
		ifTrue: [ ZTree empty ]
		ifFalse: [ self new
			value: anObject
			children: OrderedCollection new ]! !

!ZTree class methodsFor: 'instance creation' stamp: 'fbs 12/30/2010 23:41'!
value: anObject children: aCollection
	^ self new value: anObject children: aCollection.! !
