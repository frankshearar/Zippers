Object subclass: #PreOrderTraversal
	instanceVariableNames: 'root'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Support'!
!PreOrderTraversal commentStamp: 'fbs 2/13/2011 17:04' prior: 0!
I provide a pre-order traversal of an n-tree: I visit the value of a node and then its subchildren.!


!PreOrderTraversal methodsFor: 'private' stamp: 'fbs 2/17/2011 07:57'!
depthFirstTraversal: aZipper doing: aBlock
	"A naive depth-first traversal. It fails in the presence of cycles."
	| value |
	"aZipper isNil if we're backtracking."
	aZipper ifNil: [^ nil].
	
	value := aBlock value: aZipper focus value.
	
	^ aZipper isEmpty
		ifTrue: [ value ]
		ifFalse: [ self depthFirstTraversal:
			(aZipper downOrElse:
				[self depthFirstTraversal:
					(aZipper rightOrElse: [
						self depthFirstTraversal:
							(aZipper up rightOrElse: [nil "All nodes processed; up again!!"])
							doing: aBlock])
					doing: aBlock])
			doing: aBlock ]! !


!PreOrderTraversal methodsFor: 'enumerating' stamp: 'fbs 2/14/2011 08:30'!
traverse: aTree doing: aBlock
	self depthFirstTraversal: aTree zipper doing: aBlock.! !
g: aBlock
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
