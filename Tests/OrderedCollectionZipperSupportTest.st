TestCase subclass: #OrderedCollectionZipperSupportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Tests'!

!OrderedCollectionZipperSupportTest methodsFor: 'testing - converting' stamp: 'fbs 4/28/2011 23:20'!
testEmptyCollectionAsBalancedBinaryTreeIsEmptyTree
	self assert: #() asBalancedBinaryTree == ZTree empty.! !

!OrderedCollectionZipperSupportTest methodsFor: 'testing - converting' stamp: 'fbs 4/29/2011 09:53'!
testEvenCollectionAsBalancedBinaryTreeIsEmptyTree
	| expected |
	expected := ZBinaryTree
		value: 2
		left: (ZBinaryTree value: 1)
		right: (ZBinaryTree value: 3 right: (ZBinaryTree value: 4)).
	self assert: #(1 2 3 4) asBalancedBinaryTree = expected.! !

!OrderedCollectionZipperSupportTest methodsFor: 'testing - converting' stamp: 'fbs 4/28/2011 23:24'!
testOddCollectionAsBalancedBinaryTreeIsEmptyTree
	| expected |
	expected := ZBinaryTree
		value: 2
		left: (ZBinaryTree value: 1)
		right: (ZBinaryTree value: 3).
	self assert: #(1 2 3) asBalancedBinaryTree = expected.! !

!OrderedCollectionZipperSupportTest methodsFor: 'testing - converting' stamp: 'fbs 4/29/2011 09:54'!
testSingleCollectionAsBalancedBinaryTreeIsSingleNode
	self assert: #(0) asBalancedBinaryTree = (ZBinaryTree value: 0).! !
