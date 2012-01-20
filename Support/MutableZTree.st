Object subclass: #MutableZTree
	instanceVariableNames: 'children value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Support'!
!MutableZTree commentStamp: 'fbs 4/27/2011 22:21' prior: 0!
I implement a mutable version of ZTree. My sole reason for being is to provide a boundary within which mutable stuff can happen... like rebalancing a tree using the DSW algorithm.!


!MutableZTree methodsFor: 'converting' stamp: 'fbs 4/27/2011 17:30'!
asImmutableTree
	"Return an immutable version of self."
	self children isEmpty ifTrue: [^ ZTree value: self value].

	^ ZTree
		value: self value
		children: (self children
			collect: [:each | each
				ifNil: [ZTree empty]
				ifNotNil: [each asImmutableTree]]).! !

!MutableZTree methodsFor: 'converting' stamp: 'fbs 4/27/2011 17:31'!
balance
	"Return myself, only balanced. Use the DSW algorithm."
	| pseudoroot size |
	pseudoroot := MutableZTree new
		right: self;
		yourself.
	size := self asVine: pseudoroot.
	pseudoroot := self asTree: pseudoroot ofSize: size.
	^ pseudoroot right.! !


!MutableZTree methodsFor: 'private' stamp: 'fbs 4/27/2011 14:48'!
asTree: root ofSize: size
	"Convert my vine-self to a balanced tree."
	| sz leafCount internalNodeExp |
	internalNodeExp := ((size + 1) ln / 2 ln) floor.
	sz := size.
	
	leafCount := size + 1 - (2 raisedTo: internalNodeExp).
	self compress: root numbering: leafCount.
	sz := sz - leafCount.
	[sz > 1] whileTrue:
		[self compress: root numbering: sz / 2.
		sz := sz / 2].
	^ root.! !

!MutableZTree methodsFor: 'private' stamp: 'fbs 4/26/2011 22:22'!
asVine: root
	"The first half of the DSW algorithm. Turn self into a vine, and return the number of nodes in the vine."
	| vineTail remainder tempPtr size |
	vineTail := root.
	remainder := vineTail right.
	size := 0.
	[ remainder notNil ] whileTrue:
		[remainder left isNil
			ifTrue: "move vineTail down one"
				[vineTail := remainder.
				remainder := remainder right.
				size := size + 1.]
			ifFalse: "rotate"
				[tempPtr := remainder left.
				remainder left: tempPtr right.
				tempPtr right: remainder.
				remainder := tempPtr.
				vineTail right: tempPtr]].
	
	^ size.! !

!MutableZTree methodsFor: 'private' stamp: 'fbs 4/27/2011 15:18'!
compress: root numbering: count
	| scanner child |
	scanner := root.
	1 to: count do:
		[:i | child := scanner right.
		scanner right: child right.
		scanner := scanner right.
		child right: scanner left.
		scanner left: child].! !


!MutableZTree methodsFor: 'accessing' stamp: 'fbs 4/27/2011 07:51'!
children
	^ children.! !

!MutableZTree methodsFor: 'accessing' stamp: 'fbs 4/27/2011 07:37'!
left
	^ children at: 1 ifAbsent: [nil].! !

!MutableZTree methodsFor: 'accessing' stamp: 'fbs 4/27/2011 12:14'!
left: aMutableBinaryNode
	children
		ifEmpty: [children addLast: aMutableBinaryNode]
		ifNotEmpty: [children at: 1 put: aMutableBinaryNode]! !

!MutableZTree methodsFor: 'accessing' stamp: 'fbs 4/27/2011 07:37'!
right
	^ children at: 2 ifAbsent: [nil].! !

!MutableZTree methodsFor: 'accessing' stamp: 'fbs 4/27/2011 12:16'!
right: aMutableBinaryNode
	"If you set right before left, you need to make sure you set left to nil before continuing."
	[children size < 2] whileTrue: [children addLast: nil].
	children at: 2 put: aMutableBinaryNode.! !

!MutableZTree methodsFor: 'accessing' stamp: 'fbs 4/26/2011 21:43'!
value
	^ value.! !

!MutableZTree methodsFor: 'accessing' stamp: 'fbs 4/26/2011 21:43'!
value: anObject
	value := anObject.! !


!MutableZTree methodsFor: 'initialize-release' stamp: 'fbs 4/27/2011 12:11'!
initialize
	super initialize.
	"We have 'children' rather than 'left' and 'right' so that we have the same shape as ZTree."
	children := OrderedCollection new.! !


!MutableZTree methodsFor: 'printing' stamp: 'fbs 4/27/2011 07:41'!
printString
	^ '(', self value, ' ', (self left printString), ' ', (self right printString), ')'! !
7:41'!
printString
	^ '(', self value, ' ', (self left printString), ' ', (self right printString), ')'! !
