TreeZipperTest subclass: #PluggableZipperTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Tests'!

!PluggableZipperTest methodsFor: 'fixtures' stamp: 'fbs 2/6/2012 19:08'!
makeZipperOn: aTree
	"These are copies of TreeZipper's 'pluggable behaviour' category methods."
	^ PluggableZipper
		on: aTree 
		childrenBlock: [:node | node children]
		branchBlock: [:node | node children notEmpty]
		newNodeBlock: [:anObject :someObjects |
			(anObject isKindOf: ZTree)
				ifTrue: [ZTree value: anObject value children: someObjects]
				ifFalse: [ZTree value: anObject children: someObjects]].! !
