
!SequenceableCollection methodsFor: '*Zippers' stamp: 'fbs 4/29/2011 09:52'!
asBalancedBinaryTree
	^ self asBalancedBinaryTreeFrom: 1 to: self size.! !

!SequenceableCollection methodsFor: '*Zippers' stamp: 'fbs 4/29/2011 09:53'!
asBalancedBinaryTreeFrom: startIdx to: endIdx
	| mid |
	(startIdx > endIdx) ifTrue: [ ^ ZTree empty ].
	(startIdx = endIdx) ifTrue: [ ^ ZBinaryTree value: (self at: startIdx) ].
	
	mid := ((startIdx + endIdx) / 2) floor.
	^ ZBinaryTree value: (self at: mid)
		left: (self asBalancedBinaryTreeFrom: startIdx to: mid - 1)
		right: (self asBalancedBinaryTreeFrom: mid + 1 to: endIdx).! !
