TestCase subclass: #OrderedCollectionZipperSupportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Tests'!

!OrderedCollectionZipperSupportTest methodsFor: 'testing - converting' stamp: 'fbs 4/28/2011 23:20'!
testEmptyCollectionAsBalancedBinaryTreeIsEmptyTree
	self assert: #() asBalancedBinaryTree == ZTree empty.! !

!OrderedCollectionZipperSupportTest methodsFor: 'testing - converting' stamp: 'fbs 4/30/2011 17:13'!
testEvenCollectionAsBalancedBinaryTreeIsEmptyTree
	| expected |
	expected := ZTree
		value: 2
		children: {ZTree value: 1.
		ZTree value: 3 children: {ZTree empty. ZTree value: 4}}.
	self assert: #(1 2 3 4) asBalancedBinaryTree = expected.! !

!OrderedCollectionZipperSupportTest methodsFor: 'testing - converting' stamp: 'fbs 4/30/2011 17:13'!
testOddCollectionAsBalancedBinaryTreeIsEmptyTree
	| expected |
	expected := ZTree
		value: 2
		children: {ZTree value: 1. ZTree value: 3}.
	self assert: #(1 2 3) asBalancedBinaryTree = expected.! !

!OrderedCollectionZipperSupportTest methodsFor: 'testing - converting' stamp: 'fbs 4/30/2011 17:13'!
testSingleCollectionAsBalancedBinaryTreeIsSingleNode
	self assert: #(0) asBalancedBinaryTree = (ZTree value: 0).! !
edBinaryTree = (ZBinaryTree value: 0).! !
