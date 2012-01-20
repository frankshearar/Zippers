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


!ZTreeTests methodsFor: 'testing - printing' stamp: 'fbs 4/23/2011 22:41'!
testAsDotFileOfDoubleNodeTreeShowsGraph
	self assert: ((ZTree value: 0 children: {ZTree value: 1}) asDotFile) = ('digraph {', (Character cr), '0->1', (Character cr), '}').! !

!ZTreeTests methodsFor: 'testing - printing' stamp: 'fbs 4/23/2011 22:39'!
testAsDotFileOfEmptyTreeShowsEmptyGraph
	self assert: (ZTree empty asDotFile) = ('digraph {', Character cr, '}').! !

!ZTreeTests methodsFor: 'testing - printing' stamp: 'fbs 4/23/2011 22:55'!
testAsDotFileOfGrandchildTreeShowsGraph
	| lines |
	lines := OrderedCollection with: 'digraph {'.
	lines add: '2->3'.
	lines add: '0->1'.
	lines add: '0->2'.
	lines add: '}'.
	
	self assert: ((ZTree value: 0 children: {ZTree value: 1. ZTree value: 2 children: {ZTree value: 3}}) asDotFile) = (lines reduce: [:acc :each | acc , Character cr, each]).! !

!ZTreeTests methodsFor: 'testing - printing' stamp: 'fbs 4/23/2011 22:39'!
testAsDotFileOfSingleNodeTreeShowsEmptyGraph
	self assert: ((ZTree value: 0) asDotFile) = ('digraph {', Character cr, '}').! !

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


!ZTreeTests methodsFor: 'testing' stamp: 'fbs 4/24/2011 21:47'!
expectedFailures
	^ #(testAsDotFileOfDoubleNodeTreeShowsGraph.
	testAsDotFileOfEmptyTreeShowsEmptyGraph.
	testAsDotFileOfGrandchildTreeShowsGraph.
	testAsDotFileOfSingleNodeTreeShowsEmptyGraph)! !


!ZTreeTests methodsFor: 'testing - converting' stamp: 'fbs 4/27/2011 07:45'!
testAsMutableTreeEmptyTree
	| t |
	t := ZTree empty.
	self assert: t asMutableTree isNil.! !

!ZTreeTests methodsFor: 'testing - converting' stamp: 'fbs 4/27/2011 07:55'!
testAsMutableTreeMultipleChildren
	| t |
	t := (ZTree value: 0 children: {ZTree value: 1. ZTree value: 2}) asMutableTree.
	self assert: t notNil.
	self assert: t value = 0.
	self assert: t left notNil.
	self assert: t left value = 1.
	self assert: t left left isNil.
	self assert: t left right isNil.
	self assert: t right notNil.
	self assert: t right value = 2.
	self assert: t right left isNil.
	self assert: t right right isNil.! !

!ZTreeTests methodsFor: 'testing - converting' stamp: 'fbs 4/27/2011 07:53'!
testAsMutableTreeSingleChildLeft
	| t |
	t := (ZTree value: 0 children: {ZTree value: 1}) asMutableTree.
	self assert: t notNil.
	self assert: t value = 0.
	self assert: t left notNil.
	self assert: t left value = 1.
	self assert: t left left isNil.
	self assert: t left right isNil.
	self assert: t right isNil.! !

!ZTreeTests methodsFor: 'testing - converting' stamp: 'fbs 4/27/2011 17:47'!
testAsMutableTreeSingleChildRight
	| t |
	t := (ZTree value: 0 children: {ZTree empty. ZTree value: 1}) asMutableTree.
	self assert: t notNil.
	self assert: t value = 0.
	self assert: t left isNil.
	self assert: t right notNil.
	self assert: t right value = 1.
	self assert: t right left isNil.
	self assert: t right right isNil.! !

!ZTreeTests methodsFor: 'testing - converting' stamp: 'fbs 4/27/2011 07:47'!
testAsMutableTreeSingleNode
	| t |
	t := (ZTree value: 0) asMutableTree.
	self assert: t notNil.
	self assert: t value = 0.
	self assert: t left isNil.
	self assert: t right isNil.! !
EqualsUnequalTreesInChildrenReturnsFalse
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
