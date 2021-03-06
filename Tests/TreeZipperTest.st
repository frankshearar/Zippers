TreeTestCases subclass: #TreeZipperTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Tests'!

!TreeZipperTest methodsFor: 'testing - instance creation' stamp: 'fbs 12/30/2010 22:19'!
testOn
	| tree zipper |
	tree := self emptyTree.
	zipper := TreeZipper on: tree.
	
	self assert: zipper focus = tree.! !


!TreeZipperTest methodsFor: 'fixtures' stamp: 'fbs 2/25/2011 17:36'!
emptyTree
	^ ZTree empty.! !

!TreeZipperTest methodsFor: 'fixtures' stamp: 'fbs 12/31/2010 18:21'!
flatTree
	" Best viewed in a monospaced font:
	       1
	   / / | \ \
	  2 3  4 5 6"
	^ ZTree value: 1 children: ((2 to: 6) collect: [ :i | ZTree value: i])! !

!TreeZipperTest methodsFor: 'fixtures' stamp: 'fbs 2/25/2011 08:05'!
makeZipperOn: aTree
	^ TreeZipper on: aTree.! !

!TreeZipperTest methodsFor: 'fixtures' stamp: 'fbs 12/31/2010 17:58'!
nestedTriangleTree
	" Best viewed in a monospaced font:
	    1
	   / \
	  2   3 
	     / \
	    4   5 "
	| b c |
	b := ZTree value: 2.
	c := ZTree value: 3 children: {ZTree value: 4. ZTree value: 5}.
	^ ZTree value: 1 children: {b. c.}! !

!TreeZipperTest methodsFor: 'fixtures' stamp: 'fbs 12/31/2010 16:53'!
triangleTree
	" Best viewed in a monospaced font:
	   1
	  / \
	 2   3 "
	| b c |
	b := ZTree value: 2.
	c := ZTree value: 3.
	^ ZTree value: 1 children: {b. c.}! !


!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 12/30/2010 22:18'!
testDownOnEmptyTreeSignalsException
	| zipper |
	zipper := TreeZipper on: self emptyTree.
	
	self
		should: [zipper down]
		raise: ZipperNavigation.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 12/30/2010 22:59'!
testDownOnLeafNodeSignalsException
	| zipper |
	zipper := TreeZipper on: self triangleTree.
	zipper := zipper down.

	self
		should: [zipper down]
		raise: ZipperNavigation.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 12/30/2010 23:44'!
testDownOnNonEmptyTreeFocusesOnFirstSibling
	| tree zipper |
	tree := self triangleTree.
	zipper := TreeZipper on: tree.
	zipper := zipper down.
	
	self assert: zipper focus = tree children first.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 2/16/2011 17:42'!
testDownOrElseCanUseFocus
	| node tree zipper |
	tree := self emptyTree.
	zipper := tree zipper.
	zipper downOrElse: [:focus | node := focus ].
	
	self assert: node = zipper focus.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 2/16/2011 07:50'!
testDownOrElseOnEmptyTreeRunsBlock
	| ran zipper |
	zipper := self emptyTree zipper.
	ran := false.
	zipper := zipper downOrElse: [ran := true].
	self assert: ran.
	self assert: zipper == ran description: 'Unexpected result'.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 2/13/2011 19:18'!
testDownOrElseOnLeafNodeRunsBlock
	| ran zipper |
	zipper := TreeZipper on: self triangleTree.
	zipper := zipper down.

	ran := false.
	zipper := zipper downOrElse: [ran := true].
	self assert: ran.
	self assert: zipper == ran description: 'Unexpected result'.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 2/13/2011 18:29'!
testDownOrElseOnNonEmptyTreeFocusesOnFirstSibling
	| ran tree zipper |
	tree := self triangleTree.
	zipper := TreeZipper on: tree.
	ran := false.
	zipper := zipper downOrElse: [ran := true].
	
	self assert: zipper focus = tree children first.
	self deny: ran.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 12/31/2010 18:48'!
testLeftAtLeftmostNodeSignalsException
	| zipper |
	zipper := (TreeZipper on: self triangleTree) down.
	
	self
		should: [zipper left]
		raise: ZipperNavigation.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 12/31/2010 17:29'!
testLeftAtRootNodeSignalsException
	| zipper |
	zipper := TreeZipper on: self triangleTree.
	
	self
		should: [zipper left]
		raise: ZipperNavigation.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 12/31/2010 18:22'!
testLeftMovesToLeftSibling
	| tree zipper |
	tree := self nestedTriangleTree.
	zipper := TreeZipper on: tree.
	zipper := zipper down right down up.
	
	self assert: zipper focus value = 3 description: 'We followed the wrong path'.

	zipper := zipper left.
	self assert: zipper focus value = 2 description: 'Left didn''t go left'.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 2/13/2011 19:17'!
testLeftOrElseAtLeftmostNodeRunsBlock
	| ran zipper |
	zipper := (TreeZipper on: self triangleTree) down.
	
	zipper := zipper leftOrElse: [ran := true].
	
	self assert: ran.
	self assert: zipper == ran description: 'Unexpected result'.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 2/13/2011 19:17'!
testLeftOrElseAtRootNodeRunsBlock
	| ran zipper |
	zipper := TreeZipper on: self triangleTree.
	
	zipper := zipper leftOrElse: [ran := true].
	
	self assert: ran.
	self assert: zipper == ran description: 'Unexpected result'.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 2/16/2011 17:41'!
testLeftOrElseCanUseFocus
	| node tree zipper |
	tree := self emptyTree.
	zipper := tree zipper.
	zipper leftOrElse: [:focus | node := focus ].
	
	self assert: node = zipper focus.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 2/13/2011 18:34'!
testLeftOrElseMovesToLeftSibling
	| ran tree zipper |
	tree := self nestedTriangleTree.
	zipper := TreeZipper on: tree.
	zipper := zipper down right down up.
	
	self assert: zipper focus value = 3 description: 'We followed the wrong path'.

	ran := false.
	zipper := zipper leftOrElse: [ran := true].
	self assert: zipper focus value = 2 description: 'Left didn''t go left'.
	self deny: ran.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 1/1/2011 15:34'!
testLeftRightIdempotent
	| tree zipper |
	tree := self flatTree.
	zipper := tree zipper down.
	4 timesRepeat: [zipper := zipper right].
	self assert: zipper focus value = 6.
	
	"Node 2 has 4 younger siblings, so 4 is as far as we can navigate with #right.."
	1 to: 4 do:
		[ :i |
			| original navigated |
			original := navigated :=zipper.
			i timesRepeat: [ navigated := navigated left ].
			i timesRepeat: [ navigated := navigated right ].
			self assert: original focus = navigated focus ]! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 12/22/2011 13:59'!
testLeftmostMovesToLeftmostSibling
	| tree zipper |
	tree := ZTree value: 0 children: {ZTree value: 1. ZTree value: 2. ZTree value: 3.}.
	zipper := TreeZipper on: tree.
	zipper := zipper down right right leftmost.
	
	self assert: zipper focus value = 1 description: 'We followed the wrong path'.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 10/17/2011 17:51'!
testNonMutatingNavigationReturnsIdenticalStructure
	| data |
	data := ZTree value: 1 children: {ZTree value: 2 children: {ZTree value: 3. ZTree value: 4}. ZTree value: 5}.
	self assert: data == data zipper down right root.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 12/31/2010 18:49'!
testRightAtRightmostNodeSignalsException
	| zipper |
	zipper := (TreeZipper on: self triangleTree) down right.
	
	self
		should: [zipper right]
		raise: ZipperNavigation.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 2/13/2011 18:42'!
testRightAtRootNodeSignalsException
	| zipper |
	zipper := TreeZipper on: self triangleTree.
	
	self
		should: [zipper right]
		raise: ZipperNavigation.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 1/1/2011 15:35'!
testRightLeftIdempotent
	| tree zipper |
	tree := self flatTree.
	zipper := tree zipper down.
	
	"Node 2 has 4 younger siblings, so 4 is as far as we can navigate with #right.."
	1 to: 4 do:
		[ :i |
			| original navigated |
			original := navigated :=zipper.
			i timesRepeat: [ navigated := navigated right ].
			i timesRepeat: [ navigated := navigated left ].
			self assert: original focus = navigated focus ]! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 1/1/2011 15:27'!
testRightMovesToRightSibling
	| tree zipper |
	tree := self triangleTree.
	zipper := tree zipper.
	zipper := zipper down right.
	
	self assert: zipper focus = (tree children at: 2).! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 2/13/2011 19:15'!
testRightOrElseAtRightmostNodeRunsBlock
	| ran zipper |
	zipper := (TreeZipper on: self triangleTree) down right.
	
	ran := false.
	zipper := zipper rightOrElse: [ran := true].
	
	self assert: ran.
	self assert: zipper == ran description: 'Unexpected result'.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 2/13/2011 19:15'!
testRightOrElseAtRootNodeRunsBlock
	| ran zipper |
	zipper := TreeZipper on: self triangleTree.
	
	zipper := zipper rightOrElse: [ran := true].
	
	self assert: ran.
	self assert: zipper == ran description: 'Unexpected result'.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 2/16/2011 17:41'!
testRightOrElseCanUseFocus
	| node tree zipper |
	tree := self emptyTree.
	zipper := tree zipper.
	zipper rightOrElse: [:focus | node := focus ].
	
	self assert: node = zipper focus.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 2/13/2011 18:41'!
testRightOrElseMovesToRightSibling
	| ran tree zipper |
	tree := self triangleTree.
	zipper := tree zipper.
	zipper := zipper down.
	
	ran := false.
	zipper := zipper rightOrElse: [ran := true].
	
	self assert: zipper focus = (tree children at: 2).
	self deny: ran.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 1/1/2011 15:48'!
testRightStoresValueCorrectly
	"#right didn't store the value correctly, and would cause the right-most node
	value to be written to all the subsequently-visited nodes."
	| tree zipper |
	tree := self nestedTriangleTree.
	zipper := tree zipper.
	"Down, any (valid) combination of right/left, then up: no-op."
	self assert: zipper focus value = zipper down right up focus value.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 12/22/2011 14:03'!
testRightmostMovesToRightmostSibling
	| tree zipper |
	tree := ZTree value: 0 children: {ZTree value: 1. ZTree value: 2. ZTree value: 3.}.
	zipper := TreeZipper on: tree.
	zipper := zipper down rightmost.
	
	self assert: zipper focus value = 3 description: 'We followed the wrong path'.
	self assert: tree printString equals: zipper root printString! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 12/31/2010 23:31'!
testRootAtChildNodeReturnsRoot
	| tree zipper |
	tree := self triangleTree.
	zipper := tree zipper down.
	
	self assert: zipper root = tree.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 12/31/2010 23:29'!
testRootAtRootReturnsRoot
	| tree zipper |
	tree := self emptyTree.
	zipper := tree zipper.
	
	self assert: zipper root == tree.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 1/1/2011 15:26'!
testUpAtRootNodeSignalsException
	| zipper |
	zipper := self triangleTree zipper.
	
	self
		should: [zipper up]
		raise: ZipperNavigation.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 2/13/2011 19:14'!
testUpOrElseAtRootNodeRunsBlock
	| ran zipper |
	zipper := self triangleTree zipper.
	
	ran := false.
	zipper := zipper upOrElse: [ran := true.].
	
	self assert: ran.
	self assert: zipper == ran description: 'Unexpected result'.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 2/16/2011 17:41'!
testUpOrElseCanUseFocus
	| node tree zipper |
	tree := self emptyTree.
	zipper := tree zipper.
	zipper rightOrElse: [:focus | node := focus ].
	
	self assert: node = zipper focus.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 2/13/2011 19:20'!
testUpOrElseReturnsToParentNode
	| ran tree zipper |
	tree := self triangleTree.
	zipper := tree zipper.
	ran := false.
	zipper := zipper down upOrElse: [ran := true].
	
	self assert: zipper focus = tree.
	self deny: ran.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 2/13/2011 19:21'!
testUpOrElseReturnsToParentNode2
	| ran tree zipper |
	tree := ZTree value: 0 children: {ZTree value: 1 children: {ZTree value: 2}}.
	zipper := tree zipper.
	ran := false.
	zipper := zipper down down up upOrElse: [ran := true].
	
	self assert: zipper focus = tree.
	self deny: ran.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 1/1/2011 15:26'!
testUpReturnsToParentNode
	| tree zipper |
	tree := self triangleTree.
	zipper := tree zipper.
	zipper := zipper down up.
	
	self assert: zipper focus = tree.! !

!TreeZipperTest methodsFor: 'testing - navigating' stamp: 'fbs 1/1/2011 14:46'!
testUpReturnsToParentNode2
	| tree zipper |
	tree := ZTree value: 0 children: {ZTree value: 1 children: {ZTree value: 2}}.
	zipper := tree zipper.
	zipper := zipper down down up up.
	
	self assert: zipper focus = tree.! !


!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 12/20/2011 20:30'!
testChangeReplacesValue
	| tree zipper |
	tree := self triangleTree.
	zipper := (TreeZipper on: tree) down.
	
	zipper := zipper change: [ :z | ZTree value: (z value + 1)].
	self assert: zipper focus value = 3 description: 'No change made'.
	self assert: zipper right focus value = 3 description: 'Position changed'.

	self
		assert: (ZTree value: 1 children: {ZTree value: 3. ZTree value: 3.}) printString
		equals: zipper root printString.! !

!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 2/5/2012 21:36'!
testChangeToAtTopReplacesValue
	| tree zipper |
	tree := self triangleTree.
	zipper := TreeZipper on: tree.
	
	zipper := zipper changeTo: (ZTree value: 5 children: zipper focus children).
	self assert: zipper focus value = 5 description: 'No change made'.
	self assert: zipper safeRight value error = #rightAtRootNode.

	self
		assert: (ZTree value: 5 children: {ZTree value: 2. ZTree value: 3}) printString
		equals: zipper root printString.
! !

!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 12/20/2011 16:14'!
testChangeToReplacesValue
	| tree zipper |
	tree := self triangleTree.
	zipper := (TreeZipper on: tree) down.
	
	zipper := zipper changeTo: (ZTree value: 5).
	self assert: zipper focus value = 5 description: 'No change made'.
	self assert: zipper right focus value = 3 description: 'Position changed'.

	self
		assert: (ZTree value: 1 children: {ZTree value: 5. ZTree value: 3}) printString
		equals: zipper root printString.! !

!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 1/1/2011 15:55'!
testDeleteAtTopFails
	self should: [self emptyTree zipper delete] raise: ZipperNavigation.! !

!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 1/1/2011 16:07'!
testDeleteLeafNodeDeletesNode
	| tree zipper |
	tree := ZTree value: 1 children: {ZTree value: 2. ZTree value: 3}.
	zipper := tree zipper down delete.
	
	self assert: zipper root = (ZTree value: 1 children: {ZTree value: 3}).! !

!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 1/1/2011 16:15'!
testDeleteLeafNodeFocusesOnParent
	| tree zipper |
	tree := ZTree value: 1 children: {ZTree value: 2}.
	zipper := tree zipper down.
	zipper := zipper delete.
	
	self assert: zipper root = (ZTree value: 1).
	self assert: zipper focus value = 1.! !

!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 1/1/2011 16:06'!
testDeleteNodeFocusesOnYoungerSibling
	| tree zipper |
	tree := ZTree value: 1 children: {ZTree value: 2. ZTree value: 3}.
	zipper := tree zipper down delete.
	
	self assert: zipper root = (ZTree value: 1 children: {ZTree value: 3}).! !

!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 1/1/2011 17:15'!
testDeleteOldestSiblingFocusesOnYoungerSibling
	| tree zipper |
	tree := ZTree value: 1 children: {ZTree value: 2. ZTree value: 3. ZTree value: 4}.
	zipper := tree zipper down.
	self assert: zipper focus value = 2.
	zipper := zipper delete.
	
	self assert: zipper focus value = 3 description: 'Zipper focused on wrong sibling'.
	self assert: zipper root = (ZTree value: 1 children: {ZTree value: 3. ZTree value: 4}) description: 'Wrong thing deleted'.! !

!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 12/20/2011 20:32'!
testDeleteOnlyLeafNode
	| tree zipper |
	tree := ZTree value: 1 children: {ZTree value: 2}.
	zipper := tree zipper down delete.
	
	self assert: zipper root = (ZTree value: 1).! !

!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 1/1/2011 17:15'!
testDeleteYoungerSiblingFocusesOnOlderSibling
	| tree zipper |
	tree := ZTree value: 1 children: {ZTree value: 2. ZTree value: 3. ZTree value: 4}.
	zipper := tree zipper down right.
	self assert: zipper focus value = 3.
	zipper := zipper delete.
	
	self assert: zipper focus value = 2 description: 'Zipper focused on wrong sibling'.
	self assert: zipper root = (ZTree value: 1 children: {ZTree value: 2. ZTree value: 4}) description: 'Wrong thing deleted'.! !

!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 1/1/2011 17:16'!
testDeleteYoungestSiblingFocusesOnOlderSibling
	| tree zipper |
	tree := ZTree value: 1 children: {ZTree value: 2. ZTree value: 3. ZTree value: 4}.
	zipper := tree zipper down right right.
	self assert: zipper focus value = 4.
	zipper := zipper delete.
	
	self assert: zipper focus value = 3 description: 'Zipper focused on wrong sibling'.
	self assert: zipper root = (ZTree value: 1 children: {ZTree value: 2. ZTree value: 3}) description: 'Wrong thing deleted'.! !

!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 12/20/2011 20:31'!
testInsertDownInsertsChild
	| tree zipper |
	tree := ZTree value: 0.
	zipper := tree zipper.
	
	zipper := zipper insertDown: (ZTree value: 1).
	"self should: [zipper up] raise: ZipperNavigation."
	self assert: zipper focus value = 1 description: 'Zipper not focused on new node'.
	self shouldnt: [zipper up] raise: ZipperNavigation.
	
	self assert: zipper root = (ZTree value: 0 children: {ZTree value: 1}).! !

!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 12/20/2011 16:17'!
testInsertDownOnEmptyTreeIsATreeWithOneNode
	| tree zipper |
	tree := ZTree empty.
	zipper := tree zipper.
	
	zipper := zipper insertDown: (ZTree value: 0).
	self assert: zipper focus value = 0 description: 'Zipper not focused on new node'.
	
	self assert: zipper root = (ZTree value: 0).! !

!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 12/20/2011 20:31'!
testInsertLeftInsertsImmediatelyOlderSibling
	| tree zipper |
	tree := ZTree value: 0 children: {ZTree value: 1. ZTree value: 2}.
	zipper := tree zipper.
	zipper := zipper down right insertLeft: (ZTree value: 3).
	self assert: zipper focus value = 3 description: 'Zipper not focused on new node'.
	self assert: zipper root = (ZTree value: 0 children: {ZTree value: 1. ZTree value: 3. ZTree value: 2}).! !

!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 12/20/2011 12:43'!
testInsertLeftInsertsOlderSibling
	| tree zipper |
	tree := ZTree value: 0 children: {ZTree value: 1}.
	zipper := tree zipper.
	zipper := zipper down insertLeft: (ZTree value: 2).
	self assert: zipper root = (ZTree value: 0 children: {ZTree value: 2. ZTree value: 1}).! !

!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 12/20/2011 20:54'!
testInsertLeftOnRootIndicatesFailure
	| tree zipper |
	tree := ZTree value: 0.
	zipper := tree zipper.
	self should: [zipper insertLeft: (ZTree value: 1)] raise: ZipperNavigation! !

!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 12/20/2011 20:31'!
testInsertRightInsertsYoungerSibling
	| tree zipper |
	tree := ZTree value: 0 children: {ZTree value: 1}.
	zipper := tree zipper.
	zipper := zipper down insertRight: (ZTree value: 2).
	self assert: zipper focus value = 2 description: 'Zipper not focused on new node'.
	self assert: zipper root = (ZTree value: 0 children: {ZTree value: 1. ZTree value: 2}).! !

!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 12/20/2011 12:44'!
testInsertRightOnEmptyTreeInsertsYoungerSibling
	| tree zipper |
	tree := ZTree value: 0 children: {ZTree empty}.
	zipper := tree zipper.
	zipper := zipper down insertRight: (ZTree value: 2).
	self assert: zipper root = (ZTree value: 0 children: {ZTree empty. ZTree value: 2}).! !

!TreeZipperTest methodsFor: 'testing - mutating' stamp: 'fbs 12/20/2011 20:50'!
testInsertRightOnRootIndicatesFailure
	| tree zipper |
	tree := ZTree value: 0.
	zipper := tree zipper.
	self should: [zipper insertRight: (ZTree value: 1)] raise: ZipperNavigation! !


!TreeZipperTest methodsFor: 'testing - copying' stamp: 'fbs 2/25/2011 08:06'!
testCopyReturnsExactCopy
	| copy zipper |
	zipper := (self makeZipperOn: self triangleTree) down.
	copy := zipper copy.
	
	self deny: copy == zipper.
	self assert: copy focus = zipper focus.
	self assert: copy up focus = zipper up focus.! !


!TreeZipperTest methodsFor: 'testing - testing' stamp: 'fbs 2/17/2011 07:38'!
testIsEmptyOnEmptyTreeReturnsTrue
	self assert: self emptyTree zipper isEmpty.! !

!TreeZipperTest methodsFor: 'testing - testing' stamp: 'fbs 2/17/2011 07:42'!
testIsEmptyOnNonEmptyTreeAlwaysReturnsFalse
	| zipper |
	zipper := self triangleTree zipper.
	self deny: zipper isEmpty.
	
	self deny: zipper down isEmpty.! !


!TreeZipperTest methodsFor: 'testing - sharing' stamp: 'fbs 11/1/2011 17:24'!
testZipperShouldShareSubstructures
	| t newTree |
	t := self nestedTriangleTree.
	newTree := (t zipper down changeTo: 5) root.
	self assert: newTree children second == t children second.! !


!TreeZipperTest methodsFor: 'testing - safe mutating' stamp: 'fbs 2/5/2012 21:55'!
testSafeChangeReplacesValue
	| attempt tree zipper |
	tree := self triangleTree.
	zipper := (TreeZipper on: tree) down.
	
	attempt := zipper safeChange: [ :z | ZTree value: (z value + 1)].
	self assert: attempt isRight.
	self assert: attempt value focus value = 3 description: 'No change made'.
	self assert: attempt value right focus value = 3 description: 'Position changed'.

	self
		assert: (ZTree value: 1 children: {ZTree value: 3. ZTree value: 3.}) printString
		equals: attempt value root printString.! !

!TreeZipperTest methodsFor: 'testing - safe mutating' stamp: 'fbs 2/5/2012 21:54'!
testSafeChangeToAtTopReplacesValue
	| attempt tree zipper |
	tree := self triangleTree.
	zipper := TreeZipper on: tree.
	
	attempt := zipper safeChangeTo: (ZTree value: 5 children: zipper focus children).
	self assert: attempt isRight.
	self assert: attempt value focus value = 5 description: 'No change made'.
	self deny: attempt value safeRight isRight.
	self assert: #rightAtRootNode equals: attempt value safeRight value error.

	self
		assert: (ZTree value: 5 children: {ZTree value: 2. ZTree value: 3}) printString
		equals: attempt value root printString.
! !

!TreeZipperTest methodsFor: 'testing - safe mutating' stamp: 'fbs 2/5/2012 21:52'!
testSafeChangeToReplacesValue
	| attempt tree zipper |
	tree := self triangleTree.
	zipper := (TreeZipper on: tree) down.
	
	attempt := zipper safeChangeTo: (ZTree value: 5).
	self assert: attempt isRight.
	self assert: attempt value focus value = 5 description: 'No change made'.
	self assert: attempt value right focus value = 3 description: 'Position changed'.

	self
		assert: (ZTree value: 1 children: {ZTree value: 5. ZTree value: 3}) printString
		equals: attempt value root printString.! !

!TreeZipperTest methodsFor: 'testing - safe mutating' stamp: 'fbs 2/5/2012 21:51'!
testSafeDeleteAtTopFails
	| attempt zipper |
	zipper := self emptyTree zipper.
	attempt := zipper safeDelete.
	self deny: attempt isRight.
	self assert: #deleteAtRoot equals: attempt value error.
	self assert: zipper equals: attempt value location.! !

!TreeZipperTest methodsFor: 'testing - safe mutating' stamp: 'fbs 2/5/2012 21:50'!
testSafeDeleteLeafNodeDeletesNode
	| attempt tree |
	tree := ZTree value: 1 children: {ZTree value: 2. ZTree value: 3}.
	attempt := tree zipper down safeDelete.
	
	self assert: attempt isRight.
	self assert: attempt value root = (ZTree value: 1 children: {ZTree value: 3}).! !

!TreeZipperTest methodsFor: 'testing - safe mutating' stamp: 'fbs 2/5/2012 21:50'!
testSafeDeleteLeafNodeFocusesOnParent
	| attempt tree zipper |
	tree := ZTree value: 1 children: {ZTree value: 2}.
	zipper := tree zipper down.
	attempt := zipper safeDelete.
	
	self assert: attempt isRight.
	self assert: attempt value root = (ZTree value: 1).
	self assert: attempt value focus value = 1.! !

!TreeZipperTest methodsFor: 'testing - safe mutating' stamp: 'fbs 2/5/2012 21:50'!
testSafeDeleteOldestSiblingFocusesOnYoungerSibling
	| attempt tree zipper |
	tree := ZTree value: 1 children: {ZTree value: 2. ZTree value: 3. ZTree value: 4}.
	zipper := tree zipper down.
	self assert: zipper focus value = 2.
	attempt := zipper safeDelete.
	
	self assert: attempt isRight.
	self assert: attempt value focus value = 3 description: 'Zipper focused on wrong sibling'.
	self assert: attempt value root = (ZTree value: 1 children: {ZTree value: 3. ZTree value: 4}) description: 'Wrong thing deleted'.! !

!TreeZipperTest methodsFor: 'testing - safe mutating' stamp: 'fbs 2/5/2012 21:50'!
testSafeDeleteOnlyLeafNode
	| attempt tree |
	tree := ZTree value: 1 children: {ZTree value: 2}.
	attempt := tree zipper down safeDelete.
	
	self assert: attempt isRight.
	self assert: attempt value root = (ZTree value: 1).! !

!TreeZipperTest methodsFor: 'testing - safe mutating' stamp: 'fbs 2/5/2012 21:49'!
testSafeDeleteYoungerSiblingFocusesOnOlderSibling
	| attempt tree zipper |
	tree := ZTree value: 1 children: {ZTree value: 2. ZTree value: 3. ZTree value: 4}.
	zipper := tree zipper down right.
	self assert: zipper focus value = 3.
	attempt := zipper safeDelete.
	
	self assert: attempt isRight.
	self assert: attempt value focus value = 2 description: 'Zipper focused on wrong sibling'.
	self assert: attempt value root = (ZTree value: 1 children: {ZTree value: 2. ZTree value: 4}) description: 'Wrong thing deleted'.! !

!TreeZipperTest methodsFor: 'testing - safe mutating' stamp: 'fbs 2/5/2012 21:49'!
testSafeDeleteYoungestSiblingFocusesOnOlderSibling
	| attempt tree zipper |
	tree := ZTree value: 1 children: {ZTree value: 2. ZTree value: 3. ZTree value: 4}.
	zipper := tree zipper down right right.
	self assert: zipper focus value = 4.
	attempt := zipper safeDelete.
	
	self assert: attempt isRight.
	self assert: attempt value focus value = 3 description: 'Zipper focused on wrong sibling'.
	self assert: attempt value root = (ZTree value: 1 children: {ZTree value: 2. ZTree value: 3}) description: 'Wrong thing deleted'.! !

!TreeZipperTest methodsFor: 'testing - safe mutating' stamp: 'fbs 2/5/2012 21:39'!
testSafeInsertDownInsertsChild
	| attempt tree zipper |
	tree := ZTree value: 0.
	zipper := tree zipper.
	
	attempt := zipper safeInsertDown: (ZTree value: 1).
	self assert: attempt isRight.
	self assert: attempt value focus value = 1 description: 'Zipper not focused on new node'.
	self shouldnt: [attempt value up] raise: ZipperNavigation.
	
	self assert: attempt value root = (ZTree value: 0 children: {ZTree value: 1}).! !

!TreeZipperTest methodsFor: 'testing - safe mutating' stamp: 'fbs 2/5/2012 21:39'!
testSafeInsertDownOnEmptyTreeIsATreeWithOneNode
	| attempt tree zipper |
	tree := ZTree empty.
	zipper := tree zipper.
	
	attempt := zipper safeInsertDown: (ZTree value: 0).
	self assert: attempt isRight.
	self assert: attempt value focus value = 0 description: 'Zipper not focused on new node'.
	
	self assert: attempt value root = (ZTree value: 0).! !

!TreeZipperTest methodsFor: 'testing - safe mutating' stamp: 'fbs 2/5/2012 21:38'!
testSafeInsertLeftInsertsImmediatelyOlderSibling
	| attempt tree zipper |
	tree := ZTree value: 0 children: {ZTree value: 1. ZTree value: 2}.
	zipper := tree zipper.
	attempt := zipper down right safeInsertLeft: (ZTree value: 3).
	self assert: attempt isRight.
	self assert: attempt value focus value = 3 description: 'Zipper not focused on new node'.
	self assert: attempt value root = (ZTree value: 0 children: {ZTree value: 1. ZTree value: 3. ZTree value: 2}).! !

!TreeZipperTest methodsFor: 'testing - safe mutating' stamp: 'fbs 2/5/2012 21:38'!
testSafeInsertLeftInsertsOlderSibling
	| attempt tree zipper |
	tree := ZTree value: 0 children: {ZTree value: 1}.
	zipper := tree zipper.
	attempt := zipper down safeInsertLeft: (ZTree value: 2).
	self assert: attempt isRight.
	self assert: attempt value root = (ZTree value: 0 children: {ZTree value: 2. ZTree value: 1}).! !

!TreeZipperTest methodsFor: 'testing - safe mutating' stamp: 'fbs 2/5/2012 21:38'!
testSafeInsertLeftOnRootIndicatesFailure
	| attempt tree zipper |
	tree := ZTree value: 0.
	zipper := tree zipper.
	attempt := zipper safeInsertLeft: (ZTree value: 1).
	self deny: attempt isRight.
	self assert: #insertLeftAtRoot equals: attempt value error.
	self assert: zipper = attempt value location.! !

!TreeZipperTest methodsFor: 'testing - safe mutating' stamp: 'fbs 2/5/2012 21:37'!
testSafeInsertRightInsertsYoungerSibling
	| attempt tree zipper |
	tree := ZTree value: 0 children: {ZTree value: 1}.
	zipper := tree zipper.
	attempt := zipper down safeInsertRight: (ZTree value: 2).
	self assert: attempt isRight.
	self assert: attempt value focus value = 2 description: 'Zipper not focused on new node'.
	self assert: attempt value root = (ZTree value: 0 children: {ZTree value: 1. ZTree value: 2}).! !

!TreeZipperTest methodsFor: 'testing - safe mutating' stamp: 'fbs 2/5/2012 21:36'!
testSafeInsertRightOnRootIndicatesFailure
	| attempt tree zipper |
	tree := ZTree value: 0.
	zipper := tree zipper.
	attempt := zipper safeInsertRight: (ZTree value: 2).
	self assert: attempt isLeft.
	self assert: #insertRightAtRoot equals: attempt value error.
	self assert: attempt value location = zipper.! !
