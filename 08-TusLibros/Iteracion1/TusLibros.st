!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'test' stamp: 'FF 6/4/2022 10:18:06'!
test01CartIsEmptyWhenCreated

	| cart |

	cart := Cart with: OrderedCollection new.
	
	self assert: cart isEmpty.
	! !

!CartTest methodsFor: 'test' stamp: 'FF 6/4/2022 10:19:01'!
test02EmptyCartAfterAddingABookIsNotEmpty

	| book cart catalog |
	catalog := OrderedCollection with: book. 
	cart := Cart with: catalog.
	
	cart add: 1 of: book.
	
	self deny: cart isEmpty.! !

!CartTest methodsFor: 'test' stamp: 'FF 6/4/2022 10:20:11'!
test03CannotAddBooksToCartWithNonPositiveQuantity

	| book cart |
	cart := Cart with: (OrderedCollection with: book).
	
	self should: [cart add: -1 of: book.] 
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError | self assert: Cart cannotAddBookWithNonPositiveQuantity equals: anError messageText .
		self assert: cart isEmpty ].! !

!CartTest methodsFor: 'test' stamp: 'FF 6/4/2022 10:21:02'!
test04CannotAddAnUncataloguedBook

	| book cart |
	cart := Cart with: OrderedCollection new.
	
	self should: [cart add: 1 of: book.] 
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError | self assert: Cart cannotAddAnUncataloguedBook equals: anError messageText .
		self assert: cart isEmpty ].! !

!CartTest methodsFor: 'test' stamp: 'FF 6/4/2022 10:26:47'!
test05CartReturnsEmptyBookListWhenCreated

	| cart |
	cart := Cart with: OrderedCollection new.
	
	self assert: cart books isEmpty.! !

!CartTest methodsFor: 'test' stamp: 'FF 6/4/2022 10:29:53'!
test06CartBookListIncludesBookAfterAdding

	| cart book|
	cart := Cart with: (OrderedCollection with: book).
	cart add: 2 of: book.
	
	self deny: cart books isEmpty.
	self assert: (cart books includes: book).! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'books catalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'initialization' stamp: 'FF 6/4/2022 10:17:06'!
initializeWith: aCatalog 
	catalog := aCatalog.
	books := Bag new.! !


!Cart methodsFor: 'testing' stamp: 'FF 6/3/2022 23:26:15'!
isEmpty
	^books isEmpty.! !


!Cart methodsFor: 'adding' stamp: 'FF 6/4/2022 10:39:15'!
add: aQuantity of: aBook 
	(aQuantity <=0) ifTrue: [^self error: self class cannotAddBookWithNonPositiveQuantity ].
	(catalog includes: aBook) ifFalse: [^ self error: self class cannotAddAnUncataloguedBook].
	books add: aBook withOccurrences: aQuantity .! !


!Cart methodsFor: 'accessing' stamp: 'FF 6/4/2022 10:27:03'!
books
	^books! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'error messages' stamp: 'FF 6/3/2022 23:36:07'!
cannotAddAnUncataloguedBook
	^'The book is not in the catalog'.! !

!Cart class methodsFor: 'error messages' stamp: 'FF 6/3/2022 23:29:58'!
cannotAddBookWithNonPositiveQuantity

	^'Can not add books with zero or negative quantity'! !


!Cart class methodsFor: 'instance creation' stamp: 'FF 6/4/2022 10:16:23'!
with: aCatalog 
	
	^self new initializeWith: aCatalog.! !
