TestCase subclass: #TreeTestCases
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Zippers-Tests'!

!TreeTestCases methodsFor: 'fixtures' stamp: 'fbs 2/25/2011 17:35'!
emptyTree
	^ ZTree empty.! !

!TreeTestCases methodsFor: 'fixtures' stamp: 'fbs 2/25/2011 08:00'!
flatTree
	" Best viewed in a monospaced font:
	       1
	   / / | \ \
	  2 3  4 5 6"
	^ ZTree value: 1 children: ((2 to: 6) collect: [ :i | ZTree value: i])! !

!TreeTestCases methodsFor: 'fixtures' stamp: 'fbs 2/25/2011 08:00'!
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

!TreeTestCases methodsFor: 'fixtures' stamp: 'fbs 2/25/2011 07:59'!
triangleTree
	" Best viewed in a monospaced font:
	   1
	  / \
	 2   3 "
	| b c |
	b := ZTree value: 2.
	c := ZTree value: 3.
	^ ZTree value: 1 children: {b. c.}! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

TreeTestCases class
	instanceVariableNames: ''!

!TreeTestCases class methodsFor: 'testing' stamp: 'fbs 2/25/2011 08:07'!
isAbstract
	^ self name = #TreeTestCases.! !
