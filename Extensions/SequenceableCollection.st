
!SequenceableCollection methodsFor: '*Zippers' stamp: 'fbs 4/29/2011 09:52'!
asBalancedBinaryTree
	^ self asBalancedBinaryTreeFrom: 1 to: self size.! !

!SequenceableCollection methodsFor: '*Zippers' stamp: 'fbs 4/30/2011 17:11'!
asBalancedBinaryTreeFrom: startIdx to: endIdx
	| mid |
	(startIdx > endIdx) ifTrue: [ ^ ZTree empty ].
	(startIdx = endIdx) ifTrue: [ ^ ZTree value: (self at: startIdx) ].
	
	mid := ((startIdx + endIdx) / 2) floor.
	^ ZTree value: (self at: mid)
		children:
			{self asBalancedBinaryTreeFrom: startIdx to: mid - 1.
			self asBalancedBinaryTreeFrom: mid + 1 to: endIdx.}.! !
ndIdx).! !
