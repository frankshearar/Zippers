TestCase subclass: #ZTreeTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Tests'!

!ZTreeTests methodsFor: 'testing - comparing' stamp: 'fbs 12/31/2010 23:35'!
testEqualsEqualSingleNodesReturnsTrue
	| a b |
	a := ZTree value: 1.
	b := ZTree value: 1.
	self assert: a = b.! !

!ZTreeTests methodsFor: 'testing - comparing' stamp: 'fbs 12/31/2010 23:36'!
testEqualsEqualTreesReturnsTrue
	| a b |
	a := ZTree value: 1 children: {ZTree value: 2}.
	b := ZTree value: 1 children: {ZTree value: 2}.
	self assert: a = b.! !

!ZTreeTests methodsFor: 'testing - comparing' stamp: 'fbs 12/31/2010 23:35'!
testEqualsUnequalSingleNodesReturnsFalse
	| a b |
	a := ZTree value: 1.
	b := ZTree value: 2.
	self deny: a = b.! !

!ZTreeTests methodsFor: 'testing - comparing' stamp: 'fbs 12/31/2010 23:37'!
testEqualsUnequalTreesInChildrenReturnsFalse
	| a b |
	a := ZTree value: 1 children: {ZTree value: 2}.
	b := ZTree value: 1 children: {ZTree value: 1}.
	self deny: a = b.! !

!ZTreeTests methodsFor: 'testing - comparing' stamp: 'fbs 12/31/2010 23:39'!
testEqualsUnequalTreesInValueReturnsFalse
	| a b |
	a := ZTree value: 1 children: {ZTree value: 2}.
	b := ZTree value: 2 children: {ZTree value: 2}.
	self deny: a = b.! !


!ZTreeTests methodsFor: 'testing - printing' stamp: 'fbs 2/25/2011 21:33'!
testPrintEmptyTreeShowsSpecialSymbol
	self assert: '<>' = ZTree empty printString.! !

!ZTreeTests methodsFor: 'testing - printing' stamp: 'fbs 12/31/2010 23:32'!
testPrintSingleNodePrintsNoChildren
	self assert: (ZTree value: 1) printString = '(1)'.! !

!ZTreeTests methodsFor: 'testing - printing' stamp: 'fbs 12/31/2010 23:33'!
testPrintTreeNodePrintsChildren
	| t |
	t := ZTree value: 1 children: {ZTree value: 2. ZTree value: 3}.
	self assert: t printString = '(1 (2), (3))'.! !


!ZTreeTests methodsFor: 'testing - instance creation' stamp: 'fbs 2/25/2011 17:55'!
testValueWithEmptyTreeReturnsEmptyTree
	self assert: ZTree empty == (ZTree value: ZTree empty).! !
g = '(1 (2), (3))'.! !


!ZTreeTests methodsFor: 'testing - converting' stamp: 'fbs 4/28/2011 21:33'!
testAsMutableTreeEmptyTree
	| t |
	t := ZTree empty.
	self assert: t asMutableTree isEmpty.! !

!ZTreeTests methodsFor: 'testing - converting' stamp: 'fbs 4/28/2011 20:59'!
testAsMutableTreeMultipleChildren
	| t |
	t := (ZTree value: 0 children: {ZTree value: 1. ZTree value: 2}) asMutableTree.
	self assert: t notNil.
	self assert: t value = 0.
	self assert: t left notNil.
	self assert: t left value = 1.
	self assert: t left left isEmpty.
	self assert: t left right isEmpty.
	self deny: t right isEmpty.
	self assert: t right value = 2.
	self assert: t right left isEmpty.
	self assert: t right right isEmpty.! !

!ZTreeTests methodsFor: 'testing - converting' stamp: 'fbs 4/28/2011 20:59'!
testAsMutableTreeSingleChildLeft
	| t |
	t := (ZTree value: 0 children: {ZTree value: 1}) asMutableTree.
	self assert: t notNil.
	self assert: t value = 0.
	self deny: t left isEmpty.
	self assert: t left value = 1.
	self assert: t left left isEmpty.
	self assert: t left right isEmpty.
	self assert: t right isEmpty.! !

!ZTreeTests methodsFor: 'testing - converting' stamp: 'fbs 4/28/2011 21:20'!
testAsMutableTreeSingleChildRight
	| t |
	t := (ZTree value: 0 children: {ZTree empty. ZTree value: 1}) asMutableTree.
	self deny: t isEmpty.
	self assert: t value = 0.
	self assert: t left isEmpty.
	self deny: t right isEmpty.
	self assert: t right value = 1.
	self assert: t right left isEmpty.
	self assert: t right right isEmpty.! !

!ZTreeTests methodsFor: 'testing - converting' stamp: 'fbs 4/28/2011 21:20'!
testAsMutableTreeSingleNode
	| t |
	t := (ZTree value: 0) asMutableTree.
	self deny: t isEmpty.
	self assert: t value = 0.
	self assert: t left isEmpty.
	self assert: t right isEmpty.! !


!ZTreeTests methodsFor: 'testing - testing' stamp: 'fbs 4/30/2011 17:27'!
testDepth
	self assert: ZTree empty depth = 0.
	self assert: (ZTree value: 1) depth = 1.
	self assert: (ZTree value: 1 children: {ZTree empty.}) depth = 1.
	self assert: (ZTree value: 1 children: {ZTree value: 2}) depth = 2.
	self assert: (ZTree value: 1 children: {ZTree value: 2. ZTree value: 2 children: {ZTree value: 3}}) depth = 3.! !

!ZTreeTests methodsFor: 'testing - testing' stamp: 'fbs 4/30/2011 15:31'!
testHasChildren
	self deny: ZTree empty hasChildren.
	self deny: (ZTree value: 0) hasChildren.
	self deny: (ZTree value: 0 children: {ZTree empty}) hasChildren.
	self assert: (ZTree value: 0 children: {ZTree value: 1}) hasChildren.! !

!ZTreeTests methodsFor: 'testing - testing' stamp: 'fbs 4/30/2011 17:21'!
testIsBalanced
	self assert: ZTree empty isBalanced.
	self assert: (ZTree value: 0) isBalanced.
	self assert: (ZTree value: 0 children: {ZTree empty}) isBalanced.
	self assert: (ZTree value: 0 children: {ZTree value: 1}) isBalanced.
	self assert: (ZTree value: 0 children: {ZTree empty. ZTree empty}) isBalanced.
	
	self deny: (ZTree value: 0 children: {ZTree value: 1 children: {ZTree value: 2}}) isBalanced.
	self deny: (ZTree value: 0 children: {ZTree empty. ZTree value: 1 children: {ZTree value: 2}}) isBalanced.! !


!ZTreeTests methodsFor: 'testing - comparing' stamp: 'fbs 12/31/2010 23:35'!
testEqualsEqualSingleNodesReturnsTrue
	| a b |
	a := ZTree value: 1.
	b := ZTree value: 1.
	self assert: a = b.! !

!ZTreeTests methodsFor: 'testing - comparing' stamp: 'fbs 12/31/2010 23:36'!
testEqualsEqualTreesReturnsTrue
	| a b |
	a := ZTree value: 1 children: {ZTree value: 2}.
	b := ZTree value: 1 children: {ZTree value: 2}.
	self assert: a = b.! !

!ZTreeTests methodsFor: 'testing - comparing' stamp: 'fbs 12/31/2010 23:35'!
testEqualsUnequalSingleNodesReturnsFalse
	| a b |
	a := ZTree value: 1.
	b := ZTree value: 2.
	self deny: a = b.! !

!ZTreeTests methodsFor: 'testing - comparing' stamp: 'fbs 12/31/2010 23:37'!
testEqualsUnequalTreesInChildrenReturnsFalse
	| a b |
	a := ZTree value: 1 children: {ZTree value: 2}.
	b := ZTree value: 1 children: {ZTree value: 1}.
	self deny: a = b.! !

!ZTreeTests methodsFor: 'testing - comparing' stamp: 'fbs 12/31/2010 23:39'!
testEqualsUnequalTreesInValueReturnsFalse
	| a b |
	a := ZTree value: 1 children: {ZTree value: 2}.
	b := ZTree value: 2 children: {ZTree value: 2}.
	self deny: a = b.! !

!ZTreeTests methodsFor: 'testing - comparing' stamp: 'fbs 4/27/2011 17:45'!
testEqualsWithEmptyLeftSubtree
	| a b |
	a := ZTree value: 1 children: {ZTree empty. ZTree value: 2}.
	b := ZTree value: 1 children: {ZTree empty. ZTree value: 2}.
	self assert: a = b.! !

!ZTreeTests methodsFor: 'testing - comparing' stamp: 'fbs 4/27/2011 17:46'!
testEqualsWithEmptyRightSubtree
	| a b |
	a := ZTree value: 1 children: {ZTree value: 2. ZTree empty}.
	b := ZTree value: 1 children: {ZTree value: 2}.
	self assert: a = b.! !

!ZTreeTests methodsFor: 'testing - comparing' stamp: 'fbs 4/27/2011 17:44'!
testEqualsWithEmptySubtreeVersusNoChildren
	| a b |
	a := ZTree value: 1.
	b := ZTree value: 1 children: {ZTree empty}.
	self assert: a = b.! !


!ZTreeTests methodsFor: 'testing - instance creation' stamp: 'fbs 2/25/2011 17:55'!
testValueWithEmptyTreeReturnsEmptyTree
	self assert: ZTree empty == (ZTree value: ZTree empty).! !
