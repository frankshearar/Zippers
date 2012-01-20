DepthTraversal subclass: #PreOrderTraversal
	instanceVariableNames: 'root'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Support'!
!PreOrderTraversal commentStamp: 'fbs 2/13/2011 17:04' prior: 0!
I provide a pre-order traversal of an n-tree: I visit the value of a node and then its subchildren.!


!PreOrderTraversal methodsFor: 'private' stamp: 'fbs 2/25/2011 17:37'!
depthFirstTraversal: aZipper doing: aBlock
	"A naive depth-first traversal. It fails in the presence of cycles."
	^ self collect: aBlock using: aZipper.
	
	"We're backtracking."
	"
	aZipper ifNil: [^ nil ].
	
	aBlock value: aZipper focus value.
	
	aZipper isEmpty
		ifTrue: [ ^ nil ].

	^ self depthFirstTraversal:
			(aZipper downOrElse:
				[self depthFirstTraversal:
					(aZipper rightOrElse: [
						self depthFirstTraversal:
							(aZipper up rightOrElse: [ nil ])
							doing: aBlock ])
					doing: aBlock ])
			doing: aBlock."! !


!PreOrderTraversal methodsFor: 'enumerating' stamp: 'fbs 4/24/2011 21:56'!
collectNodes: aBlock using: aZipper
	"A naive depth-first traversal. It fails in the presence of cycles."
	| collected move value |
	aZipper focus isEmpty
		ifTrue: [ collected := OrderedCollection new ]
		ifFalse:
			[value := aBlock value: aZipper focus.
			move := aZipper safeDown.
	
			collected := (move first = #success)
				ifTrue: [ (self collectNodes: aBlock using: move second) copy addFirst: value; yourself ]
				ifFalse: [ { value } asOrderedCollection ]].
	
	move := aZipper safeRight.
	move first = #success ifTrue: [collected addAll: (self collectNodes: aBlock using: move second)].

	^ collected.! !
