Object subclass: #ListZipper
	instanceVariableNames: 'focus trail'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!
!ListZipper commentStamp: 'fbs 12/28/2010 16:27' prior: 0!
A zipper is a structure that allows one, in a purely functional manner, to navigate a structure. It works by remembering the steps taken to focus on any particular part of a structure.

A ListZipper is a zipper for any sequenceable collection. It has two instance variables, namely

focus - the (sub)list on which we are currently focussed.
trail - the steps taken to focus on the focus instance variable.!


!ListZipper methodsFor: 'mutating' stamp: 'fbs 12/30/2010 20:50'!
change: aBlock
	"Given an arity 1 block, replace the current value in the list with that of evaluating aBlock on that value."
	
	^ ListZipper new
		focus: (aBlock value: focus first) asOrderedCollection, focus allButFirst
		trail: trail.! !


!ListZipper methodsFor: 'accessing' stamp: 'fbs 12/28/2010 16:27'!
focus
	^ focus.! !


!ListZipper methodsFor: 'private' stamp: 'fbs 12/28/2010 16:36'!
focus: aSeqColl trail: anotherSeqColl
	focus := aSeqColl.
	trail := anotherSeqColl.! !


!ListZipper methodsFor: 'navigating' stamp: 'fbs 12/30/2010 23:22'!
left
	trail isEmpty ifTrue: [^ ZipperNavigation new signal: 'Left at the first element'].
	
	^ ListZipper new
		focus: (focus copy addFirst: trail first; yourself)
		trail: trail allButFirst.! !

!ListZipper methodsFor: 'navigating' stamp: 'fbs 12/30/2010 23:22'!
right
	focus isEmpty ifTrue: [^ ZipperNavigation new signal: 'Right at the last element'].
	
	^ ListZipper new
		focus: focus allButFirst
		trail: (trail copy addFirst: focus first; yourself)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ListZipper class
	instanceVariableNames: ''!

!ListZipper class methodsFor: 'instance creation' stamp: 'fbs 12/28/2010 16:48'!
on: aSequenceableCollection
	^ self new focus: aSequenceableCollection asOrderedCollection trail: OrderedCollection new.! !
