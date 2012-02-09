BaseZipper subclass: #PluggableZipper
	instanceVariableNames: 'childrenBlock branchBlock mkFocusBlock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers'!
!PluggableZipper commentStamp: 'fbs 2/9/2012 09:32' prior: 0!
A PluggableZipper is a BaseZipper with which you supply three blocks:

Instance Variables
	branchBlock:		<Block numArgs: 1 <Object> returning: <Boolean>>
	childrenBlock:		<Object numArgs: 1 <Object> returning: <SequenceableCollection of: <Object>>>
	mkFocusBlock:		<Object numArgs: 2 <Object, <Collection of: Object>> returning: <Object>>

branchBlock
	- Takes an object and returns true if that object has children, and false otherwise.

childrenBlock
	- Takes an object and returns a sequenceable collection of its children.

mkFocusBlock
	- takes a parent object and children objects and returns a new node in the structure over which you're zipping.!


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
