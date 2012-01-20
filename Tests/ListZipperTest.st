TestCase subclass: #ListZipperTest
	instanceVariableNames: 'prefix suffix'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Tests'!

!ListZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 12/30/2010 21:13'!
testChangeChangesValue
	| list zipper |
	list := #(1 2 3) asOrderedCollection.
	zipper := ListZipper on: list.
	zipper := zipper right right.
	zipper := zipper change: [:x | x + 1].
	
	zipper := zipper left left.
	
	self assert: zipper focus = #(1 2 4) asOrderedCollection.! !

!ListZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 12/30/2010 21:13'!
testChangePreservesOriginal
	| original list zipper |
	original := list := #(1 (2 3) 4) asOrderedCollection.
	zipper := ListZipper on: list.
	zipper := zipper right.
	zipper := zipper change: [:x | x size].
	zipper := zipper left.
	
	self assert: zipper focus = #(1 2 4) asOrderedCollection.
	self assert: list = original description: 'Zipper not functional'.! !

!ListZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 12/30/2010 21:15'!
testChangeSharesStructure
	| original list zipper |
	original := list := #(1 (2 3) 4) asOrderedCollection.
	zipper := ListZipper on: list.
	zipper := zipper right right.
	zipper := zipper change: [:x | x + 1].
	zipper := zipper left left.
	
	self assert: zipper focus = #(1 (2 3) 5) asOrderedCollection.
	self assert: zipper focus second == original second description: 'Zipper not sharing original structure'.! !


!ListZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 12/28/2010 16:50'!
testLeft
	| left list zipper right |
	list := #(1 2 3) asOrderedCollection.
	zipper := ListZipper on: list.
	right := zipper right right.
	
	left := right left.
	self assert: left focus = list allButFirst.
	
	left := left left.
	self assert: left focus = list.! !

!ListZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 12/28/2010 19:11'!
testLeftPastBeginningOfCollectionReturnsEmptyZipper
	| zipper |
	zipper := ListZipper on: #(1 2).
	self
		should: [ zipper right left left ]
		raise: ZipperNavigation.! !

!ListZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 12/28/2010 16:49'!
testOn
	| list zipper |
	list := #(1 2 3 4 5).
	zipper := ListZipper on: list.
	self assert: zipper focus = list asOrderedCollection.! !

!ListZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 12/28/2010 16:50'!
testRight
	| list zipper right |
	list := #(1 2 3) asOrderedCollection.
	zipper := ListZipper on: list.
	right := zipper right.
	self assert: right focus = list allButFirst.
	
	right := right right.
	self assert: right focus = list allButFirst allButFirst.! !

!ListZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 12/28/2010 17:37'!
testRightPastEndOfCollectionReturnsEmptyZipper
	| zipper |
	zipper := ListZipper on: #(1 2).
	self
		should: [ zipper right right right ]
		raise: ZipperNavigation.! !
!
