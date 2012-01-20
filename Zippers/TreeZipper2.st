TreeZipper subclass: #TreeZipper2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!

!TreeZipper2 methodsFor: 'as yet unclassified' stamp: 'fbs 10/17/2011 08:20'!
children
	^ self focus children! !

!TreeZipper2 methodsFor: 'as yet unclassified' stamp: 'fbs 10/15/2011 23:11'!
isBranch
	^ self focus children notEmpty! !


!TreeZipper2 methodsFor: 'private' stamp: 'fbs 10/15/2011 22:43'!
newFocusOn: anObject
	^ ZTree value: anObject children: #().! !

!TreeZipper2 methodsFor: 'private' stamp: 'fbs 10/15/2011 22:44'!
newFocusOn: anObject children: aCollection
	^ ZTree value: anObject children: aCollection.! !
