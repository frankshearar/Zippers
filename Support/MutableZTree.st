ZTree subclass: #MutableZTree
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Support'!
!MutableZTree commentStamp: 'fbs 4/28/2011 07:52' prior: 0!
I implement a mutable version of ZTree. My sole reason for being is to provide a boundary within which mutable stuff can happen... like rebalancing a tree using the Day/Stout/Warren algorithm.!


!MutableZTree methodsFor: 'converting' stamp: 'fbs 4/28/2011 12:48'!
asImmutableTree
	^ self asImmutableTreeOfType: ZTree.! !

!MutableZTree methodsFor: 'converting' stamp: 'fbs 4/28/2011 21:26'!
asImmutableTreeOfType: aClass
	"Return an immutable version of self."
	self children isEmpty ifTrue: [^ aClass value: self value].

	^ aClass
		value: self value
		children: (self children
			collect: [:each | each
				ifNil: [ZTree empty]
				ifNotNil: [each asImmutableTreeOfType: aClass]]).! !

!MutableZTree methodsFor: 'converting' stamp: 'fbs 4/28/2011 07:49'!
balance
	"Return myself, only balanced. Use the DSW algorithm."
	| pseudoroot size |
	pseudoroot := MutableZTree new
		right: self;
		yourself.
	size := pseudoroot asVine.
	pseudoroot asTreeOfSize: size.
	^ pseudoroot right.! !


!MutableZTree methodsFor: 'private' stamp: 'fbs 4/28/2011 07:49'!
asTreeOfSize: size
	"Convert my vine-self to a balanced tree."
	| sz leafCount internalNodeExp |
	internalNodeExp := ((size + 1) ln / 2 ln) floor.
	sz := size.
	
	leafCount := size + 1 - (2 raisedTo: internalNodeExp).
	self compressTimes: leafCount.
	sz := sz - leafCount.
	[sz > 1] whileTrue:
		[self compressTimes: sz / 2.
		sz := sz / 2].! !

!MutableZTree methodsFor: 'private' stamp: 'fbs 4/28/2011 21:33'!
asVine
	"The first half of the DSW algorithm. Turn self into a vine, and return the number of nodes in the vine."
	| vineTail remainder tempPtr size |
	vineTail := self.
	remainder := vineTail right.
	size := 0.
	[ remainder isEmpty ] whileFalse:
		[(remainder left isEmpty)
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

!MutableZTree methodsFor: 'private' stamp: 'fbs 4/28/2011 07:47'!
compressTimes: count
	| scanner child |
	scanner := self.
	1 to: count do:
		[:i | child := scanner right.
		scanner right: child right.
		scanner := scanner right.
		child right: scanner left.
		scanner left: child].! !


!MutableZTree methodsFor: 'accessing' stamp: 'fbs 4/27/2011 07:51'!
children
	^ children.! !

!MutableZTree methodsFor: 'accessing' stamp: 'fbs 4/28/2011 20:57'!
left
	^ children at: 1 ifAbsent: [ZTree empty].! !

!MutableZTree methodsFor: 'accessing' stamp: 'fbs 4/27/2011 12:14'!
left: aMutableBinaryNode
	children
		ifEmpty: [children addLast: aMutableBinaryNode]
		ifNotEmpty: [children at: 1 put: aMutableBinaryNode]! !

!MutableZTree methodsFor: 'accessing' stamp: 'fbs 4/28/2011 20:57'!
right
	^ children at: 2 ifAbsent: [ZTree empty].! !

!MutableZTree methodsFor: 'accessing' stamp: 'fbs 4/28/2011 20:57'!
right: aMutableBinaryNode
	"If you set right before left, you need to make sure you set left to nil before continuing."
	[children size < 2] whileTrue: [children addLast: ZTree empty].
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
! !
