!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'test' stamp: 'FF 6/7/2022 18:39:35'!
test01CartIsEmptyWhenCreated

	| cart |

	cart := Cart with: Dictionary new.
	
	self assert: cart isEmpty.
	! !

!CartTest methodsFor: 'test' stamp: 'FF 6/7/2022 18:37:46'!
test02EmptyCartAfterAddingABookIsNotEmpty

	| book cart pricesList |
	pricesList := Dictionary new.
	pricesList at: book put: 10 .
	cart := Cart with: pricesList.
	
	cart add: 1 of: book.
	
	self deny: cart isEmpty.! !

!CartTest methodsFor: 'test' stamp: 'FF 6/7/2022 18:39:54'!
test03CannotAddBooksToCartWithNonPositiveQuantity

	| book cart pricesList |
	pricesList := Dictionary new.
	pricesList at: book put: 10 .
	cart := Cart with: pricesList.
	
	self should: [cart add: -1 of: book.] 
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError | self assert: Cart cannotAddBookWithNonPositiveQuantity equals: anError messageText .
		self assert: cart isEmpty ].! !

!CartTest methodsFor: 'test' stamp: 'FF 6/7/2022 18:38:28'!
test04CannotAddAnUncataloguedBook

	| book cart |
	cart := Cart with: Dictionary new.
	
	self should: [cart add: 1 of: book.] 
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError | self assert: Cart cannotAddAnUncataloguedBook equals: anError messageText .
		self assert: cart isEmpty ].! !

!CartTest methodsFor: 'test' stamp: 'FF 6/7/2022 18:40:13'!
test05CartReturnsEmptyBookListWhenCreated

	| cart |
	cart := Cart with: Dictionary new.
	
	self assert: cart books isEmpty.! !

!CartTest methodsFor: 'test' stamp: 'FF 6/7/2022 18:39:07'!
test06CartBookListIncludesBookAfterAdding

	| cart book pricesList |
	pricesList := Dictionary new.
	pricesList at: book put: 10 .
	cart := Cart with: pricesList.
	cart add: 2 of: book.
	
	self deny: cart books isEmpty.
	self assert: (cart books includes: book).! !

!CartTest methodsFor: 'test' stamp: 'FF 6/7/2022 18:40:41'!
test07EmptyCartTotalIsZero

	| cart |
	cart := Cart with: (Dictionary new).
	
	self assert: 0 equals: cart total.! !

!CartTest methodsFor: 'test' stamp: 'FF 6/7/2022 18:42:47'!
test08CartWithItemsTotalIsTheSumOfItemPrices

	| cart book pricesList |
	pricesList := Dictionary new.
	pricesList at: book put: 10 .
	cart := Cart with: pricesList.
	cart add: 2 of: book.
	
	self assert: 20 equals: cart total.! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'libro1 libro2 priceList sales validCreditCard expiredCreditCard today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'test' stamp: 'FF 6/7/2022 18:52:26'!
setUp

	today := Date today.
	libro1 := 'primer libro'.
	libro2 := 'segundo libro'.

	priceList := Dictionary new.
	priceList at: libro1 put: 10.
	priceList at: libro2 put: 20.

	sales := OrderedCollection new.
	
	validCreditCard := CreditCard number: '4545454545454545' validTo: today month next.
	expiredCreditCard := CreditCard number: '4545454545454545' validTo: today month previous.
	! !

!CashierTest methodsFor: 'test' stamp: 'FF 6/7/2022 18:10:30'!
test01CannotCheckOutEmptyCart

	| cart cashier |
	cart := Cart with: OrderedCollection new.
	cashier := Cashier using: sales.
	
	self should: [cashier checkOut: cart payingWith: validCreditCard on: today] 
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError | self assert: Cashier cannotCheckOutAnEmptyCart equals: anError messageText .
			self assert: sales isEmpty.
		].! !

!CashierTest methodsFor: 'test' stamp: 'FF 6/7/2022 18:51:41'!
test02CannotCheckOutCartProvidingAnExpiredCreditCard

	| cart cashier |
	cart := Cart with: priceList .
	cart add: 1 of: libro1. 
	cashier := Cashier using: sales.
	
	self should: [cashier checkOut: cart payingWith: expiredCreditCard on: today] 
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError |  self assert: Cashier cannotPayWithExpiredCreditCard equals: anError messageText .
			self assert: sales isEmpty .
		].! !

!CashierTest methodsFor: 'test' stamp: 'FF 6/7/2022 18:51:41'!
test03CheckOutCartWithItemsAddElementToSalesList

	| cart cashier |
	
	cart := Cart with: priceList.
	cart add: 1 of: libro1.
	cart add: 2 of: libro2.
	cashier := Cashier using: sales.
	 	
	cashier checkOut: cart payingWith: validCreditCard on: today.
	
	self deny: sales isEmpty.! !

!CashierTest methodsFor: 'test' stamp: 'FF 6/7/2022 18:54:51'!
test04CheckOutCartWithItemsReturnsATicketWithTotal

	| cart cashier total |
	
	cart := Cart with: priceList.
	cart add: 1 of: libro1.
	cart add: 2 of: libro2.
	cashier := Cashier using: sales.
	 	
	total := cashier checkOut: cart payingWith: validCreditCard on: today.
	
	self assert: cart total equals: total.! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'books priceList'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'initialization' stamp: 'FF 6/7/2022 18:36:03'!
initializeWith: aPriceList 
	priceList := aPriceList.
	books := Bag new.! !


!Cart methodsFor: 'testing' stamp: 'FF 6/3/2022 23:26:15'!
isEmpty
	^books isEmpty.! !


!Cart methodsFor: 'adding' stamp: 'FF 6/7/2022 18:37:01'!
add: aQuantity of: aBook 
	(aQuantity <=0) ifTrue: [^self error: self class cannotAddBookWithNonPositiveQuantity ].
	(priceList includesKey: aBook) ifFalse: [^ self error: self class cannotAddAnUncataloguedBook].
	books add: aBook withOccurrences: aQuantity .! !


!Cart methodsFor: 'accessing' stamp: 'FF 6/4/2022 10:27:03'!
books
	^books! !


!Cart methodsFor: 'total' stamp: 'FF 6/7/2022 18:50:11'!
total
	^ books sum: [:aBook | priceList at: aBook] ifEmpty: [^0].
	! !

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


!Cart class methodsFor: 'instance creation' stamp: 'FF 6/7/2022 18:35:32'!
with: aPriceList 
	
	^self new initializeWith: aPriceList.! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'salesList'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'assertions' stamp: 'FF 6/7/2022 18:15:25'!
assertCartIsNotEmpty: aCart
	aCart isEmpty ifTrue:[^self error: self class cannotCheckOutAnEmptyCart ].
	! !

!Cashier methodsFor: 'assertions' stamp: 'FF 6/7/2022 18:17:22'!
assertCreditCardIsNotExpired: aCreditCard on: anExpirationDate
	
	(aCreditCard isExpiredOn: anExpirationDate) ifTrue:[^self error: self class cannotPayWithExpiredCreditCard].
! !


!Cashier methodsFor: 'checking out' stamp: 'FF 6/7/2022 18:54:19'!
checkOut: aCart payingWith: aCreditCard on: aDateOfSale
	self assertCartIsNotEmpty: aCart.
	self assertCreditCardIsNotExpired: aCreditCard on: aDateOfSale .
	salesList add: aCart.
	^aCart total.! !


!Cashier methodsFor: 'initialization' stamp: 'FF 6/7/2022 17:11:13'!
initializeUsing: aSalesList 
	salesList := aSalesList.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'error messages' stamp: 'FF 6/6/2022 22:53:52'!
cannotCheckOutAnEmptyCart
	^'An empty cart can not be checked out'	! !

!Cashier class methodsFor: 'error messages' stamp: 'FF 6/6/2022 22:58:17'!
cannotPayWithExpiredCreditCard
	^'The credit card is expired'! !


!Cashier class methodsFor: 'instance creation' stamp: 'FF 6/7/2022 17:10:54'!
using: aSalesList
	^self new initializeUsing: aSalesList. ! !

!Cashier class methodsFor: 'instance creation' stamp: 'FF 6/7/2022 17:21:05'!
with: anOrderedCollection 
	"DO NOT FORGET TO RENAME COLLABORATORS AND REMOVE THIS COMMENT!!!!"
	self shouldBeImplemented.
	^self new initializeWith: anOrderedCollection ! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'number expirationMonth'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'initialization' stamp: 'FF 6/7/2022 17:25:22'!
number: aCreditCardNumber validTo: anExpirationMonthOfYear
	number := aCreditCardNumber.
	expirationMonth := anExpirationMonthOfYear.
	! !


!CreditCard methodsFor: 'testing' stamp: 'FF 6/7/2022 17:58:31'!
isExpiredOn: aDate 
	| expirationDate |
	expirationDate := Date year: expirationMonth yearNumber month: expirationMonth monthName day: expirationMonth daysInMonth.
	^aDate > expirationDate.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'FF 6/7/2022 17:23:16'!
number: aCreditCardNumber validTo: anExpirationMonthOfYear 
	^self new number: aCreditCardNumber validTo: anExpirationMonthOfYear ! !
