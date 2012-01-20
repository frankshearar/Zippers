Object subclass: #DepthTraversal
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Support'!
!DepthTraversal commentStamp: 'fbs 2/26/2011 23:06' prior: 0!
My subclasses define various ways of traversing trees and graphs.!


!DepthTraversal methodsFor: 'private' stamp: 'fbs 2/18/2011 07:28'!
depthFirstTraversal: aZipper doing: aBlock
	self subclassResponsibility.! !


!DepthTraversal methodsFor: 'enumerating' stamp: 'fbs 4/24/2011 12:38'!
collect: aBlock using: aZipper
	^ self collectNodes: [:each | aBlock value: each value ] using: aZipper! !

!DepthTraversal methodsFor: 'enumerating' stamp: 'fbs 4/24/2011 12:40'!
traverse: aTree collecting: aBlock
	"Traverse the VALUES in aTree."
	^ self traverseNodes: aTree collecting: [:each | aBlock value: each value].! !

!DepthTraversal methodsFor: 'enumerating' stamp: 'fbs 2/21/2011 07:24'!
traverse: aTree doing: aBlock
	^ self depthFirstTraversal: aTree zipper doing: aBlock.! !

!DepthTraversal methodsFor: 'enumerating' stamp: 'fbs 4/24/2011 12:37'!
traverseNodes: aTree collecting: aBlock
	"Traverse the NODES in aTree, letting you inspect the relationship between any node and its children."
	^ self collectNodes: aBlock using: aTree zipper.! !
