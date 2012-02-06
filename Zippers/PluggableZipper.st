BaseZipper subclass: #PluggableZipper
	instanceVariableNames: 'childrenBlock branchBlock mkFocusBlock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!

!PluggableZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 2/6/2012 19:00'!
children
	^ childrenBlock value: self focus.! !

!PluggableZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 2/6/2012 19:00'!
isBranch
	^ branchBlock value: self focus! !

!PluggableZipper methodsFor: 'pluggable behaviours' stamp: 'fbs 2/6/2012 19:00'!
newFocusOn: anObject children: someObjects
	^ mkFocusBlock value: anObject value: someObjects.! !


!PluggableZipper methodsFor: 'private' stamp: 'fbs 2/6/2012 19:04'!
focus: aTree trail: aZipperContext childrenBlock: unaryBlock1 branchBlock: unaryBlock2 newNodeBlock: binaryBlock.
	self focus: aTree trail: aZipperContext.
	childrenBlock := unaryBlock1.
	branchBlock := unaryBlock2.
	mkFocusBlock := binaryBlock.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

PluggableZipper class
	instanceVariableNames: ''!

!PluggableZipper class methodsFor: 'instance creation' stamp: 'fbs 2/6/2012 19:02'!
on: aTree childrenBlock: childrenBlock branchBlock: branchBlock newNodeBlock: newNodeBlock
	^ self new
		focus: aTree
		trail: ZipperContext root
		childrenBlock: childrenBlock
		branchBlock: branchBlock
		newNodeBlock: newNodeBlock.! !
