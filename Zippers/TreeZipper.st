Object subclass: #TreeZipper
	instanceVariableNames: 'focus trail'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!
!TreeZipper commentStamp: 'fbs 12/30/2010 22:41' prior: 0!
I am a zipper for navigating over a variable-arity tree, that is a tree that may have any number of children per node.

In particular, Smalltalk has a built-in tree structure, that of dependents: any Object may have any number of dependents, who may each in turn have their own dependents. Really, this allows for a directed graph rather than a tree. Further, we treat objects with no dependents as leaf nodes. Every node is its own value.

That is, I allow one to navigate arbitrarily over a tree structure, and change parts of it, where "change" means "return a structure that shares part of the original structure, but otherwise leaves the host structure unchanged".!


!TreeZipper methodsFor: 'navigating' stamp: 'fbs 12/30/2010 22:42'!
down
	(self dependents isEmpty)
		ifTrue: [ ^ ZipperNavigation signal: 'Down at a leaf node' ].! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 12/30/2010 21:40'!
left! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 12/30/2010 21:41'!
right! !

!TreeZipper methodsFor: 'navigating' stamp: 'fbs 12/30/2010 22:21'!
up
	^ ZipperNavigation signal: 'Up at the root node'.! !


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
