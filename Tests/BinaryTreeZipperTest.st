TreeTestCases subclass: #BinaryTreeZipperTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Tests'!

!BinaryTreeZipperTest methodsFor: 'fixtures' stamp: 'fbs 4/30/2011 09:40'!
makeZipperOn: aTree
	^ BinaryTreeZipper on: aTree.! !


!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 16:10'!
testCopy
	| copy expected received zipper |
	zipper := BinaryTreeZipper on: self triangleTree.
	copy := zipper copy.
	expected := PreOrderTraversal new collect: #yourself using: zipper.
	received := PreOrderTraversal new collect: #yourself using: copy.
	self assert: expected = received.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 15:55'!
testLeftMovesToLeftChild
	| tree zipper |
	tree := self triangleTree.
	zipper := BinaryTreeZipper on: tree.
	zipper := zipper left.
	
	self assert: zipper focus value = 2 description: 'We followed the wrong path'.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 14:15'!
testLeftOnEmptyTreeFails
	| z |
	z := self makeZipperOn: self emptyTree.
	self should: [ z left ] raise: ZipperNavigation.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 15:27'!
testLeftOnNoLeftSubtreeFails
	| z |
	z := self makeZipperOn: (ZTree value: 0).
	self should: [ z left ] raise: ZipperNavigation.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 14:32'!
testRightMovesToRightSibling
	| tree zipper |
	tree := self triangleTree.
	zipper := BinaryTreeZipper on: tree.
	zipper := zipper right.
	
	self assert: zipper focus value = 3 description: 'We followed the wrong path'.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 14:29'!
testRightOnEmptyTreeFails
	| z |
	z := self makeZipperOn: self emptyTree.
	self should: [ z right ] raise: ZipperNavigation.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 17:12'!
testRightOnNoRightSubtreeFails
	| z |
	z := self makeZipperOn: (ZTree value: 0).
	self should: [ z right ] raise: ZipperNavigation.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 15:26'!
testRightWithNoLeftSubtreeMovesToRightSubtree
	| tree zipper |
	tree := ZTree value: 0 children: {ZTree empty. ZTree value: 1}.
	zipper := BinaryTreeZipper on: tree.
	zipper := zipper right.
	
	self assert: zipper focus value = 1 description: 'We followed the wrong path'.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 15:56'!
testSafeLeftWithEmptyLeftSubtreeFails
	| move tree zipper |
	tree := ZTree value: 0 children: {ZTree empty}.
	zipper := BinaryTreeZipper on: tree.
	move := zipper safeLeft.
	self assert: move first == #noLeftSubtree.
	self assert: move second focus value = 0 description: 'Focus moved'.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 15:56'!
testSafeLeftWithNoLeftSubtreeFails
	| move tree zipper |
	tree := ZTree value: 0.
	zipper := BinaryTreeZipper on: tree.
	move := zipper safeLeft.
	self assert: move first == #noLeftSubtree.
	self assert: move second focus value = 0 description: 'Focus moved'.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 15:50'!
testSafeRightWithEmptyRightSubtreeFails
	| move tree zipper |
	tree := ZTree value: 0 children: {ZTree value: 1. ZTree empty}.
	zipper := BinaryTreeZipper on: tree.
	move := zipper safeRight.
	self assert: move first == #noRightSubtree.
	self assert: move second focus value = 0 description: 'Focus moved'.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 15:38'!
testSafeRightWithNoLeftSubtreeMovesToRightSubtree
	| move tree zipper |
	tree := ZTree value: 0 children: {ZTree empty. ZTree value: 1}.
	zipper := BinaryTreeZipper on: tree.
	move := zipper safeRight.
	self assert: move first == #success.
	self assert: move second focus value = 1 description: 'We followed the wrong path'.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 15:49'!
testSafeRightWithNoRightSubtreeFails
	| move tree zipper |
	tree := ZTree value: 0 children: {ZTree value: 1}.
	zipper := BinaryTreeZipper on: tree.
	move := zipper safeRight.
	self assert: move first == #noRightSubtree.
	self assert: move second focus value = 0 description: 'Focus moved'.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 15:50'!
testSafeRightWithNoSubtreesFails
	| move tree zipper |
	tree := ZTree value: 0.
	zipper := BinaryTreeZipper on: tree.
	move := zipper safeRight.
	self assert: move first == #rightAtLeafNode.
	self assert: move second focus value = 0 description: 'Focus moved'.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 16:04'!
testSafeUpOnLeftSubtreeMovesToParent
	| move zipper |
	zipper := BinaryTreeZipper on: self triangleTree.
	move := zipper left safeUp.
	
	self assert: move first == #success.
	self assert: move second focus value = 1.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 16:04'!
testSafeUpOnRightSubtreeMovesToParent
	| move zipper |
	zipper := BinaryTreeZipper on: self triangleTree.
	move := zipper right safeUp.
	
	self assert: move first == #success.
	self assert: move second focus value = 1.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 16:05'!
testSafeUpOnRootNodeFails
	| move zipper |
	zipper := BinaryTreeZipper on: (ZTree value: 0).
	move := zipper safeUp.
	self assert: move first == #upAtRootNode.
	self assert: move second focus value = 0.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 16:01'!
testUpOnEmptyTreeFails
	| zipper |
	zipper := BinaryTreeZipper on: ZTree empty.
	self should: [zipper up] raise: ZipperNavigation.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 16:03'!
testUpOnLeftSubtreeMovesToParent
	| zipper |
	zipper := BinaryTreeZipper on: self triangleTree.
	zipper := zipper left up.
	
	self assert: zipper focus value = 1.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 16:03'!
testUpOnRightSubtreeMovesToParent
	| zipper |
	zipper := BinaryTreeZipper on: self triangleTree.
	zipper := zipper right up.
	
	self assert: zipper focus value = 1.! !

!BinaryTreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 4/30/2011 16:04'!
testUpOnRootNodeFails
	| zipper |
	zipper := BinaryTreeZipper on: (ZTree value: 0).
	self should: [zipper up] raise: ZipperNavigation.! !


!BinaryTreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 4/30/2011 16:15'!
testInsertDownInsertsLeftSubtree
	| tree zipper |
	tree := ZTree value: 0.
	zipper := BinaryTreeZipper on: tree.
	
	zipper := zipper insertDown: 1.
	self assert: zipper focus value = 1 description: 'Zipper not focused on new node'.
	self shouldnt: [zipper up] raise: ZipperNavigation.
	
	self assert: zipper root = (ZTree value: 0 children: {ZTree value: 1}).! !

!BinaryTreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 11/1/2011 08:00'!
testInsertDownOnEmptyTreeIsATreeWithOneNode
	| tree zipper |
	tree := ZTree empty.
	zipper := BinaryTreeZipper on: tree.
	
	zipper := zipper insertDown: 0.
	self assert: zipper focus value = 0 description: 'Zipper not focused on new node'.
	
	self assert: zipper root = (ZTree value: 0).! !

!BinaryTreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 4/30/2011 16:35'!
testInsertLeftInsertsLeftSubtree
	| tree zipper |
	tree := ZTree value: 0.
	zipper := BinaryTreeZipper on: tree.
	
	zipper := zipper insertLeft: 1.
	self assert: zipper focus value = 1 description: 'Zipper not focused on new node'.
	self shouldnt: [zipper up] raise: ZipperNavigation.
	
	self assert: zipper root = (ZTree value: 0 children: {ZTree value: 1}).! !

!BinaryTreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 11/1/2011 07:49'!
testInsertLeftOnEmptyTreeIsATreeWithOneNode
	| tree zipper |
	tree := ZTree empty.
	zipper := BinaryTreeZipper on: tree.
	
	zipper := zipper insertDown: 0.
	self assert: zipper focus value = 0 description: 'Zipper not focused on new node'.
	
	self assert: zipper root = (ZTree value: 0).! !

!BinaryTreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 4/30/2011 17:07'!
testInsertRightInsertsRightSubtree
	| tree zipper |
	tree := ZTree value: 0.
	zipper := BinaryTreeZipper on: tree.
	
	zipper := zipper insertRight: 1.
	self assert: zipper focus value = 1 description: 'Zipper not focused on new node'.
	self shouldnt: [zipper up] raise: ZipperNavigation.
	self assert: zipper root = (ZTree value: 0 children: {ZTree empty. ZTree value: 1}).! !

!BinaryTreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 11/1/2011 07:50'!
testInsertRightOnEmptyTreeIsATreeWithOneNode
	| tree zipper |
	tree := ZTree empty.
	zipper := BinaryTreeZipper on: tree.
	
	zipper := zipper insertRight: 0.
	self assert: zipper focus value = 0 description: 'Zipper not focused on new node'.
	
	self assert: zipper root = (ZTree value: 0).! !


!BinaryTreeZipperTest methodsFor: 'testing - instance creation' stamp: 'fbs 4/30/2011 14:13'!
testOn
	| tree zipper |
	tree := self emptyTree.
	zipper := BinaryTreeZipper on: tree.
	
	self assert: zipper focus = tree.! !
p: 'fbs 4/30/2011 14:13'!
testOn
	| tree zipper |
	tree := self emptyTree.
	zipper := BinaryTreeZipper on: tree.
	
	self assert: zipper focus = tree.! !
