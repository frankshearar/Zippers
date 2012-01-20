ZTree subclass: #ZEmptyTree
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Support'!
!ZEmptyTree commentStamp: 'fbs 2/22/2011 21:41' prior: 0!
I represent an empty tree.!


!ZEmptyTree methodsFor: 'accessing' stamp: 'fbs 2/22/2011 21:40'!
children
	^ #()! !

!ZEmptyTree methodsFor: 'accessing' stamp: 'fbs 2/22/2011 21:40'!
value
	^ nil.! !


!ZEmptyTree methodsFor: 'testing' stamp: 'fbs 4/30/2011 17:27'!
depth
	^ 0.! !

!ZEmptyTree methodsFor: 'testing' stamp: 'fbs 4/30/2011 17:21'!
isBalanced
	^ true! !

!ZEmptyTree methodsFor: 'testing' stamp: 'fbs 2/24/2011 17:26'!
isEmpty
	^ true.! !


!ZEmptyTree methodsFor: 'printing' stamp: 'fbs 2/25/2011 17:58'!
printString
	^ '<>'.! !


!ZEmptyTree methodsFor: 'as yet unclassified' stamp: 'fbs 4/28/2011 21:26'!
asImmutableTreeOfType: aClass
	^ self.! !
hodsFor: 'printing' stamp: 'fbs 2/25/2011 17:58'!
printString
	^ '<>'.! !
