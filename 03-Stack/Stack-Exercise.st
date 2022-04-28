!classDefinition: #OOStackTest category: 'Stack-Exercise'!
TestCase subclass: #OOStackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test01StackShouldBeEmptyWhenCreated

	| stack |
	
	stack := OOStack new.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:29:55'!
test02PushAddElementsToTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	
	self deny: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:01'!
test03PopRemovesElementsFromTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:09'!
test04PopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	stack push: pushedObject.
	
	self assert: stack pop = pushedObject! !

!OOStackTest methodsFor: 'test' stamp: 'NR 9/16/2021 17:40:17'!
test05StackBehavesLIFO

	| stack firstPushedObject secondPushedObject |
	
	stack := OOStack new.
	firstPushedObject := 'firstSomething'.
	secondPushedObject := 'secondSomething'.
	
	stack push: firstPushedObject.
	stack push: secondPushedObject.
	
	self assert: stack pop = secondPushedObject.
	self assert: stack pop = firstPushedObject.
	self assert: stack isEmpty 
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:20'!
test06TopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack top = pushedObject.
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:24'!
test07TopDoesNotRemoveObjectFromStack

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack size = 1.
	stack top.
	self assert: stack size = 1.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:26'!
test08CanNotPopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:31'!
test09CanNotPopWhenThereAreNoObjectsInTheStackAndTheStackHadObjects

	| stack  |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:44'!
test10CanNotTopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack top ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !


!classDefinition: #SentenceFinderByPrefixTest category: 'Stack-Exercise'!
TestCase subclass: #SentenceFinderByPrefixTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'FG 4/27/2022 21:01:59'!
test1FindExistingString
	
	|stack finder collection|
	
	stack := OOStack new.
	
	stack push: 'Fabian'.
	stack push: 'Florencia'.
	
	finder := SentenceFinderByPrefix new.
	
	collection := finder findByPrefix: 'Fab' insideStack: stack.
	
	self assert: collection size = 1.
	self assert: collection last = 'Fabian'.

	! !

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'FG 4/27/2022 21:03:26'!
test2FindTwoExistingStrings
	
	|stack finder collection|
	
	stack := OOStack new.
	
	stack push: 'Fabian'.
	stack push: 'Florencia'.
	
	finder := SentenceFinderByPrefix new.
	
	collection := finder findByPrefix: 'F' insideStack: stack.
	
	self assert: collection size = 2.
	self assert: collection first = 'Florencia'.
	self assert: collection last = 'Fabian'.

	! !

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'FG 4/27/2022 21:09:27'!
test3AssertFindStringWithBlankSpacesThrowsError
	
	|stack finder |
	
	stack := OOStack new.
	
	stack push: 'Fabian'.
	stack push: 'Florencia'.
	
	finder := SentenceFinderByPrefix new.
	
	self
		should: [ finder findByPrefix: 'fa b' insideStack: stack ]
		raise: Error 
		withExceptionDo: [ :anError |
			self assert: anError messageText = SentenceFinderByPrefix stringToFindHasSpaces ]

	! !

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'FG 4/27/2022 21:03:17'!
test3NotFoundString
	
	|stack finder collection|
	
	stack := OOStack new.
	
	stack push: 'Fabian'.
	stack push: 'Florencia'.
	
	finder := SentenceFinderByPrefix new.
	
	collection := finder findByPrefix: 'J' insideStack: stack.
	
	self assert: collection size = 0.

	! !

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'FG 4/27/2022 21:08:36'!
test4FindDifferentCollectionsAfterPop
	
	|stack finder collection|
	
	stack := OOStack new.
	
	stack push: 'Fabian'.
	stack push: 'Florencia'.
	
	finder := SentenceFinderByPrefix new.
	
	collection := finder findByPrefix: 'F' insideStack: stack.
	
	self assert: collection size = 2.
	self assert: collection first = 'Florencia'.
	self assert: collection last = 'Fabian'.
	
	stack pop.
	
	collection := finder findByPrefix: 'F' insideStack: stack.
	
	self assert: collection size = 1.
	self assert: collection first = 'Fabian'.
	
	stack pop.
	
	collection := finder findByPrefix: 'F' insideStack: stack.
	self assert: collection size = 0.

	! !

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'FG 4/27/2022 21:09:04'!
testAssert1FindEmptyStringThrowsError
	
	|stack finder |
	
	stack := OOStack new.
	
	stack push: 'Fabian'.
	stack push: 'Florencia'.
	
	finder := SentenceFinderByPrefix new.
	
	self
		should: [ finder findByPrefix: '' insideStack: stack ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = SentenceFinderByPrefix stringToFindEmpty ]

	! !

!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'FG 4/27/2022 21:09:19'!
testAssert2FindBlankSpaceStringThrowsError
	
	|stack finder |
	
	stack := OOStack new.
	
	stack push: 'Fabian'.
	stack push: 'Florencia'.
	
	finder := SentenceFinderByPrefix new.
	
	self
		should: [ finder findByPrefix: ' ' insideStack: stack ]
		raise: Error 
		withExceptionDo: [ :anError |
			self assert: anError messageText = SentenceFinderByPrefix stringToFindHasSpaces ]

	! !


!classDefinition: #EstadoStack category: 'Stack-Exercise'!
Object subclass: #EstadoStack
	instanceVariableNames: 'stack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!EstadoStack methodsFor: 'initialization' stamp: 'FG 4/26/2022 20:29:45'!
initializeWith: anOOStackToBeStateOf
	
	stack := anOOStackToBeStateOf .! !


!EstadoStack methodsFor: 'accessing' stamp: 'FG 4/26/2022 20:21:15'!
pop
	self subclassResponsibility.! !

!EstadoStack methodsFor: 'accessing' stamp: 'FG 4/26/2022 20:21:10'!
top
	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EstadoStack class' category: 'Stack-Exercise'!
EstadoStack class
	instanceVariableNames: ''!

!EstadoStack class methodsFor: 'instance creation' stamp: 'FG 4/26/2022 20:28:27'!
canHandle: anOOStackSize

	self subclassResponsibility.! !

!EstadoStack class methodsFor: 'instance creation' stamp: 'FG 4/26/2022 20:09:40'!
for: anOOStackToBeStateOf

	self subclassResponsibility .! !


!classDefinition: #StackNoVacio category: 'Stack-Exercise'!
EstadoStack subclass: #StackNoVacio
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!StackNoVacio methodsFor: 'accessing' stamp: 'FG 4/26/2022 20:16:30'!
pop

	^stack popStackNotEmpty.! !

!StackNoVacio methodsFor: 'accessing' stamp: 'FG 4/26/2022 20:16:37'!
top

	^stack topStackNotEmpty.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'StackNoVacio class' category: 'Stack-Exercise'!
StackNoVacio class
	instanceVariableNames: ''!

!StackNoVacio class methodsFor: 'instance creation' stamp: 'FG 4/26/2022 20:28:33'!
canHandle: anOOStackSize

	^anOOStackSize > 0.! !

!StackNoVacio class methodsFor: 'instance creation' stamp: 'FG 4/26/2022 20:09:19'!
for: anOOStackToBeStateOf

	^self new initializeWith: anOOStackToBeStateOf.! !


!classDefinition: #StackVacio category: 'Stack-Exercise'!
EstadoStack subclass: #StackVacio
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!StackVacio methodsFor: 'accessing' stamp: 'FG 4/26/2022 20:14:18'!
pop

	^stack popStackEmpty.! !

!StackVacio methodsFor: 'accessing' stamp: 'FG 4/26/2022 20:14:28'!
top

	^stack topStackEmpty.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'StackVacio class' category: 'Stack-Exercise'!
StackVacio class
	instanceVariableNames: ''!

!StackVacio class methodsFor: 'instance creation' stamp: 'FG 4/26/2022 20:28:37'!
canHandle: anOOStackSize

	^anOOStackSize = 0.! !

!StackVacio class methodsFor: 'instance creation' stamp: 'FG 4/26/2022 20:09:23'!
for: anOOStackToBeStateOf

	^self new initializeWith: anOOStackToBeStateOf.! !


!classDefinition: #OOStack category: 'Stack-Exercise'!
Object subclass: #OOStack
	instanceVariableNames: 'collection'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'testing' stamp: 'FG 4/26/2022 19:54:51'!
isEmpty
	
	^collection isEmpty.! !

!OOStack methodsFor: 'testing' stamp: 'FG 4/25/2022 21:28:01'!
size
	
	^collection size.! !


!OOStack methodsFor: 'initialization' stamp: 'FG 4/26/2022 19:54:15'!
initialize

	collection  := OrderedCollection  new.! !


!OOStack methodsFor: 'accessing - private' stamp: 'FG 4/26/2022 20:33:22'!
getStateForStackSize
	^ (EstadoStack allSubclasses detect:[:aClass | aClass canHandle: collection size]) for: self.! !

!OOStack methodsFor: 'accessing - private' stamp: 'FG 4/26/2022 20:25:52'!
popStackEmpty
	
	^ self topStackEmpty . ! !

!OOStack methodsFor: 'accessing - private' stamp: 'FG 4/26/2022 20:17:32'!
popStackNotEmpty
	
	^collection removeLast ! !

!OOStack methodsFor: 'accessing - private' stamp: 'FG 4/26/2022 20:15:13'!
topStackEmpty
	
	^ self error: self class stackEmptyErrorDescription. ! !

!OOStack methodsFor: 'accessing - private' stamp: 'FG 4/26/2022 20:17:51'!
topStackNotEmpty
	
	^collection last. ! !


!OOStack methodsFor: 'accessing' stamp: 'FG 4/26/2022 20:34:18'!
pop
	
	^self getStateForStackSize pop.! !

!OOStack methodsFor: 'accessing' stamp: 'FG 4/26/2022 20:18:52'!
push: anElementToPush

	^collection add: anElementToPush.! !

!OOStack methodsFor: 'accessing' stamp: 'FG 4/26/2022 20:34:04'!
top

	^self getStateForStackSize top.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStack class' category: 'Stack-Exercise'!
OOStack class
	instanceVariableNames: ''!

!OOStack class methodsFor: 'error descriptions' stamp: 'NR 9/16/2021 17:39:43'!
stackEmptyErrorDescription
	
	^ 'stack is empty!!!!!!'! !


!classDefinition: #SentenceFinderByPrefix category: 'Stack-Exercise'!
Object subclass: #SentenceFinderByPrefix
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefix methodsFor: 'as yet unclassified' stamp: 'FG 4/27/2022 21:01:06'!
findByPrefix: aPrefix insideStack: anOOStack

	|auxiliarStack elementsFound|
	
	aPrefix = '' ifTrue: [self error: self class stringToFindEmpty ].
	((aPrefix  findString: ' ') > 0) ifTrue: [self error: self class stringToFindHasSpaces ].

	elementsFound := OrderedCollection new.
	auxiliarStack := OOStack new.
	
	[anOOStack isEmpty ] whileFalse: [
			
			|element| 
			
			element := anOOStack pop.
			
			(element beginsWith: aPrefix) ifTrue: [ elementsFound add: element ].
			
			auxiliarStack push: element.	
		] .
	
	[auxiliarStack isEmpty ] whileFalse: [
			
			anOOStack push: (auxiliarStack pop).
		].
	
	^elementsFound.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SentenceFinderByPrefix class' category: 'Stack-Exercise'!
SentenceFinderByPrefix class
	instanceVariableNames: ''!

!SentenceFinderByPrefix class methodsFor: 'error messages' stamp: 'FG 4/27/2022 20:36:02'!
stringToFindEmpty

	^ 'The string to find cannot be empty'! !

!SentenceFinderByPrefix class methodsFor: 'error messages' stamp: 'FG 4/27/2022 20:38:20'!
stringToFindHasSpaces

	^ 'The string to find cannot have spaces'! !
