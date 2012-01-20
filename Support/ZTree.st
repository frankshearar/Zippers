Object subclass: #ZTree
	instanceVariableNames: 'children value'
	classVariableNames: 'Empty'
	poolDictionaries: ''
	category: 'Zippers-Support'!
!ZTree commentStamp: 'fbs 12/30/2010 23:32' prior: 0!
I'm a basic implementation of a tree, only present so that my package doesn't need to rely on a separate tree package.!


!ZTree methodsFor: 'accessing' stamp: 'fbs 12/30/2010 23:33'!
children
	^ children! !

!ZTree methodsFor: 'accessing' stamp: 'fbs 12/31/2010 16:54'!
value
	^ value.! !


!ZTree methodsFor: 'initialize-release' stamp: 'fbs 12/30/2010 23:34'!
initialize
	super initialize.
	children := OrderedCollection new.! !


!ZTree methodsFor: 'printing' stamp: 'fbs 4/24/2011 12:33'!
asDotFile
	| join |
	join := [:c | c
			ifEmpty: ['']
			ifNotEmpty: [ c reduce: [:s :e | s, ';', Character cr, e ]]].

	^ 'digraph {', Character cr,
		self printChildRecords, Character cr,
		(join value: (self associations collect: #printString)), Character cr,
		'}'! !

!ZTree methodsFor: 'printing' stamp: 'fbs 4/24/2011 20:56'!
asDotNode
	| labels labelString |
	labels := OrderedCollection new.
	(1 to: self children size do: [:i | labels addLast: '<p', i printString, '>']).
	labelString := labels ifEmpty: ['']
		ifNotEmpty: ['[label = "', (labels reduce: [:acc :each | acc , ' | ']), '"]'].
	^ '"node', self value printString, labelString, ';'! !

!ZTree methodsFor: 'printing' stamp: 'fbs 12/30/2010 23:54'!
printString
	^ '(', self value printString,
		(children
			ifEmpty: ['']
			ifNotEmpty: [' ', (self children reduce: [:a :b | a printString, ', ', b printString])]),
		')'.! !


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


!ZTree methodsFor: 'comparing' stamp: 'fbs 4/27/2011 17:49'!
= anObject
	^ anObject class == self class and:
		[self value = anObject value and:
			[self childrenEqual: anObject children]].! !


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


!ZTree methodsFor: 'converting' stamp: 'fbs 4/28/2011 21:21'!
asMutableTree
	"Return a mutable copy of this tree."
	| mutableCopy |
	self isEmpty ifTrue: [^ZTree empty].

	mutableCopy := MutableZTree new.
	mutableCopy value: self value.
	mutableCopy children addAll: (self children collect: #asMutableTree).
	^ mutableCopy.! !

!ZTree methodsFor: 'converting' stamp: 'fbs 4/30/2011 17:09'!
balance
	"Return a balanced copy of self."
	^ self asOrderedCollection asBalancedBinaryTree.! !

!ZTree methodsFor: 'converting' stamp: 'fbs 4/30/2011 17:09'!
balanceDSW
	"Return a balanced copy of self."
	^ self asMutableTree balance asImmutableTreeOfType: ZBinaryTree.! !

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
!

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
