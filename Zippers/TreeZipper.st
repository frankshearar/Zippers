BaseZipper subclass: #TreeZipper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!

!TreeZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 10/17/2011 08:20'!
children
	^ self focus children! !

!TreeZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 10/15/2011 23:11'!
isBranch
	^ self focus children notEmpty! !

!TreeZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 11/12/2011 20:56'!
isEmpty
	^ focus isEmpty.! !

!TreeZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 12/20/2011 16:13'!
newFocusOn: anObject
	^ self newFocusOn: anObject children: #().! !

!TreeZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 12/20/2011 16:13'!
newFocusOn: anObject children: aCollection
	^ (anObject isKindOf: ZTree)
		ifTrue: [ZTree value: anObject value children: aCollection]
		ifFalse: [ZTree value: anObject children: aCollection].! !
