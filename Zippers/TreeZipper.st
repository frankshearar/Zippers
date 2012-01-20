Object subclass: #TreeZipper
	instanceVariableNames: 'focus trail'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!
!TreeZipper commentStamp: 'fbs 12/30/2010 22:08' prior: 0!
I am a zipper for navigating over a variable-arity tree, that is a tree that may have any number of children per node.

That is, I allow one to navigate arbitrarily over a tre structure, and change parts of it, where "change" means "return a structure that shares part of the original structure, but otherwise leaves the host structure unchanged".!


!TreeZipper methodsFor: 'navigating' stamp: 'fbs 12/30/2010 21:56'!
down! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 12/30/2010 21:40'!
left! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 12/30/2010 21:41'!
right! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 12/30/2010 21:40'!
up! !


!TreeZipper methodsFor: 'accessing' stamp: 'fbs 12/30/2010 22:06'!
focus
	^ focus.! !


!TreeZipper methodsFor: 'private' stamp: 'fbs 12/30/2010 22:04'!
focus: aTree trail: anOrderedCollection
	focus := aTree.
	trail := anOrderedCollection.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

TreeZipper class
	instanceVariableNames: ''!

!TreeZipper class methodsFor: 'instance creation' stamp: 'fbs 12/30/2010 22:04'!
on: aTree
	^ self new focus: aTree trail: OrderedCollection new.! !
