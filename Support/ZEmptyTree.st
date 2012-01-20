ZTree subclass: #ZEmptyTree
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Support'!
!ZEmptyTree commentStamp: 'fbs 2/22/2011 21:41' prior: 0!
I represent an empty tree.!


!ZEmptyTree methodsFor: 'converting' stamp: 'fbs 5/1/2011 10:17'!
asImmutableTree
	^ self. ! !

!ZEmptyTree methodsFor: 'converting' stamp: 'fbs 5/1/2011 10:17'!
asImmutableTree2
	^ self. ! !


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
