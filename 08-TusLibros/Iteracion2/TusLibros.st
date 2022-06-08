!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'priceList book1'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'test' stamp: 'FG 6/7/2022 20:29:38'!
test01CartIsEmptyWhenCreated

	| cart |

	cart := Cart with: priceList .
	
	self assert: cart isEmpty.
	! !

!CartTest methodsFor: 'test' stamp: 'FG 6/7/2022 20:30:25'!
test02EmptyCartAfterAddingABookIsNotEmpty

	|  cart |
	cart := Cart with: priceList.
	
	cart add: 1 of: book1 .
	
	self deny: cart isEmpty.! !

!CartTest methodsFor: 'test' stamp: 'FG 6/7/2022 20:30:48'!
test03CannotAddBooksToCartWithNonPositiveQuantity

	| cart |
	cart := Cart with: priceList.
	
	self should: [cart add: -1 of: book1.] 
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError | self assert: Cart cannotAddBookWithNonPositiveQuantity equals: anError messageText .
		self assert: cart isEmpty ].! !

!CartTest methodsFor: 'test' stamp: 'FG 6/7/2022 20:31:22'!
test04CannotAddAnUncataloguedBook

	| book cart |	
	book := 'uncatolog book'.
	cart := Cart with: priceList .
	
	self should: [cart add: 1 of: book.] 
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError | self assert: Cart cannotAddAnUncataloguedBook equals: anError messageText .
		self assert: cart isEmpty ].! !

!CartTest methodsFor: 'test' stamp: 'FG 6/7/2022 20:31:33'!
test05CartReturnsEmptyBookListWhenCreated

	| cart |
	cart := Cart with: priceList .
	
	self assert: cart books isEmpty.! !

!CartTest methodsFor: 'test' stamp: 'FG 6/7/2022 20:31:54'!
test06CartBookListIncludesBookAfterAdding

	| cart  |
	cart := Cart with: priceList.
	cart add: 2 of: book1 .
	
	self deny: cart books isEmpty.
	self assert: (cart books includes: book1).! !

!CartTest methodsFor: 'test' stamp: 'FG 6/7/2022 20:32:09'!
test07EmptyCartTotalIsZero

	| cart |
	cart := Cart with: priceList .
	
	self assert: 0 equals: cart total.! !

!CartTest methodsFor: 'test' stamp: 'FG 6/7/2022 20:32:26'!
test08CartWithItemsTotalIsTheSumOfItemPrices

	| cart |

	cart := Cart with: priceList.
	cart add: 2 of: book1.
	
	self assert: 20 equals: cart total.! !


!CartTest methodsFor: 'setUp' stamp: 'FG 6/7/2022 20:29:14'!
setUp

	book1 := 'libro 1'.
	
	priceList := Dictionary new.
	priceList at: book1 put: 10 .! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'book1 book2 priceList sales validCreditCard expiredCreditCard today merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'test' stamp: 'FF 6/8/2022 18:45:52'!
test01CannotCheckOutEmptyCart

	| cart cashier |
	cart := Cart with: priceList .
	cashier := Cashier using: sales debitProcessor: merchantProcessor .
	
	self should: [cashier checkOut: cart payingWith: validCreditCard on: today] 
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError | self assert: Cashier cannotCheckOutAnEmptyCart equals: anError messageText .
			self assert: sales isEmpty.
			self assert: 0 equals: merchantProcessor answeredCalls.
		].! !

!CashierTest methodsFor: 'test' stamp: 'FF 6/8/2022 18:42:17'!
test02CannotCheckOutCartProvidingAnExpiredCreditCard
	| cart cashier |
	
	cart := Cart with: priceList .
	cart add: 1 of: book1. 
	cashier := Cashier using: sales debitProcessor: merchantProcessor .
	
	self should: [cashier checkOut: cart payingWith: expiredCreditCard on: today] 
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError |  self assert: Cashier cannotPayWithExpiredCreditCard equals: anError messageText .
			self assert: sales isEmpty .
			self assert: 0 equals: merchantProcessor answeredCalls.
		].! !

!CashierTest methodsFor: 'test' stamp: 'FF 6/8/2022 18:47:13'!
test03CheckOutCartWithItemsAddElementToSalesList

	| cart cashier |
	
	cart := Cart with: priceList.
	cart add: 1 of: book1.
	cart add: 2 of: book2.
	cashier := Cashier using: sales debitProcessor: merchantProcessor .
	 	
	cashier checkOut: cart payingWith: validCreditCard on: today.
		self assert: 1 equals: merchantProcessor answeredCalls.
	self deny: sales isEmpty.! !

!CashierTest methodsFor: 'test' stamp: 'FF 6/8/2022 18:43:38'!
test04CheckOutCartWithItemsReturnsTotal

	| cart cashier total |
	
	cart := Cart with: priceList.
	cart add: 1 of: book1.
	cart add: 2 of: book2.
	cashier := Cashier using: sales debitProcessor: merchantProcessor .
	
	total := cashier checkOut: cart payingWith: validCreditCard on: today.
	
	self assert: cart total equals: total.
	self assert: 1 equals: merchantProcessor answeredCalls.! !

!CashierTest methodsFor: 'test' stamp: 'FF 6/8/2022 18:47:24'!
test05CannotCheckOutCartProvidingStolenCreditCard

	| cart cashier |
	
	cart := Cart with: priceList.
	cart add: 1 of: book1.
	cart add: 2 of: book2.
	merchantProcessor simulateStolenCreditCard.
	cashier := Cashier using: sales debitProcessor: merchantProcessor.
	
	self should: [cashier checkOut: cart payingWith: validCreditCard on: today] 
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError |  self assert: MerchantProcessorSimulator cannotPayWithStolenCreditCard equals: anError messageText .
			self assert: sales isEmpty .
			self assert: 1 equals: merchantProcessor answeredCalls.
		].! !

!CashierTest methodsFor: 'test' stamp: 'FF 6/8/2022 18:47:34'!
test06CannotCheckOutCartProvidingCreditCardWithoutEnoughLimit

	| cart cashier |
	
	cart := Cart with: priceList.
	cart add: 1 of: book1.
	cart add: 2 of: book2.
	merchantProcessor simulateCreditCardWithoutEnoughLimit.
	cashier := Cashier using: sales debitProcessor: merchantProcessor.
	
	self should: [cashier checkOut: cart payingWith: validCreditCard on: today] 
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError |  self assert: MerchantProcessorSimulator cannotPayWithCreditCardWithoutEnoughLimit equals: anError messageText .
			self assert: sales isEmpty .
			self assert: 1 equals: merchantProcessor answeredCalls.
		].! !


!CashierTest methodsFor: 'setUp' stamp: 'FF 6/8/2022 18:05:38'!
setUp

	today := Date today.
	book1 := 'primer libro'.
	book2 := 'segundo libro'.

	priceList := Dictionary new.
	priceList at: book1 put: 10.
	priceList at: book2 put: 20.

	sales := OrderedCollection new.
	
	validCreditCard := CreditCard number: '4545454545454545' validTo: today month next.
	expiredCreditCard := CreditCard number: '4545454545454545' validTo: today month previous.
	merchantProcessor := MerchantProcessorSimulator new.! !


!classDefinition: #CreditCardTest category: 'TusLibros'!
TestCase subclass: #CreditCardTest
	instanceVariableNames: 'today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCardTest methodsFor: 'setUp' stamp: 'FG 6/7/2022 20:40:01'!
setUp

	today := Date today.! !


!CreditCardTest methodsFor: 'test' stamp: 'FG 6/7/2022 20:43:22'!
test01CardCannotBeCreatedWithInvalidNumberLenght
	|card|

	self should: [card := CreditCard number: '2323' validTo: today month]
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError | 
		self assert: CreditCard invalidCreditCardNumber equals: anError messageText .
		self assert: card isNil.
		]! !

!CreditCardTest methodsFor: 'test' stamp: 'FG 6/7/2022 20:53:00'!
test02CardCannotBeCreatedWithInvalidNumberCharacters
	|card|

	self should: [card := CreditCard number: 'aaaaaaaaaaaaaaaa' validTo: today month]
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError | 
		self assert: CreditCard invalidCreditCardNumber equals: anError messageText .
		self assert: card isNil.
		]! !

!CreditCardTest methodsFor: 'test' stamp: 'FF 6/8/2022 17:40:16'!
test03CardCannotBeCreatedWhenValidToIsNotAMonth
	|card|

	self should: [card := CreditCard number: '4251236587945120' validTo: '']
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError | 
		self assert: CreditCard invalidExpirationDate equals: anError messageText .
		self assert: card isNil.
		]! !

!CreditCardTest methodsFor: 'test' stamp: 'FG 6/7/2022 21:04:33'!
test04CreditCardWithExpirationDateBeforeTodayShouldBeExpired

	|card|
	
	card := CreditCard number: '4251236587945120' validTo: today month previous .
	
	self assert: (card isExpiredOn: today).

		! !

!CreditCardTest methodsFor: 'test' stamp: 'FG 6/7/2022 21:04:40'!
test05CreditCardWithExpirationDateAfterTodayShouldNotBeExpired

	|card|
	
	card := CreditCard number: '4251236587945120' validTo: today month next .
	
	self deny: (card isExpiredOn: today).

		! !

!CreditCardTest methodsFor: 'test' stamp: 'FG 6/7/2022 21:06:10'!
test06CreditCardExpirationMonthIsIncludedOnTheExpirationPeriod

	|card|
	
	card := CreditCard number: '4251236587945120' validTo: today month.
	
	self deny: (card isExpiredOn: today).

		! !


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


!Cart methodsFor: 'adding' stamp: 'FG 6/7/2022 20:26:05'!
add: aQuantity of: aBook 
	self assertQuantityIsPositive: aQuantity .
	self assertProductExistOnPriceList: aBook.
	books add: aBook withOccurrences: aQuantity .! !

!Cart methodsFor: 'adding' stamp: 'FG 6/7/2022 20:25:52'!
assertProductExistOnPriceList: aProductToBeAdded 
	(priceList includesKey: aProductToBeAdded) ifFalse: [^ self error: self class cannotAddAnUncataloguedBook].! !

!Cart methodsFor: 'adding' stamp: 'FG 6/7/2022 20:24:42'!
assertQuantityIsPositive: quantityOfBookToBeAdded 
	(quantityOfBookToBeAdded <=0) ifTrue: [^self error: self class cannotAddBookWithNonPositiveQuantity ].! !


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
	instanceVariableNames: 'salesList merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'checking out' stamp: 'FF 6/7/2022 18:15:25'!
assertCartIsNotEmpty: aCart
	aCart isEmpty ifTrue:[^self error: self class cannotCheckOutAnEmptyCart ].
	! !

!Cashier methodsFor: 'checking out' stamp: 'FF 6/7/2022 18:17:22'!
assertCreditCardIsNotExpired: aCreditCard on: anExpirationDate
	
	(aCreditCard isExpiredOn: anExpirationDate) ifTrue:[^self error: self class cannotPayWithExpiredCreditCard].
! !

!Cashier methodsFor: 'checking out' stamp: 'FF 6/8/2022 18:20:54'!
checkOut: aCart payingWith: aCreditCard on: aDateOfSale

	| totalToDebit |
	self assertCartIsNotEmpty: aCart.
	self assertCreditCardIsNotExpired: aCreditCard on: aDateOfSale .
	
	totalToDebit := aCart total.
	merchantProcessor debit: totalToDebit from: aCreditCard .
	
	salesList add: aCart.
	
	^totalToDebit.! !


!Cashier methodsFor: 'initialization' stamp: 'FF 6/8/2022 18:02:09'!
using: aSalesList debitProcessor: aMerchantProcessor
	salesList := aSalesList .
	merchantProcessor := aMerchantProcessor.! !

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

!Cashier class methodsFor: 'instance creation' stamp: 'FF 6/8/2022 18:01:18'!
using: aSalesList debitProcessor: aMerchantProcessor
	^self new using: aSalesList debitProcessor: aMerchantProcessor ! !

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

!CreditCard methodsFor: 'initialization' stamp: 'FG 6/7/2022 20:50:52'!
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

!CreditCard class methodsFor: 'instance creation' stamp: 'FG 6/7/2022 20:59:43'!
number: aCreditCardNumber validTo: anExpirationMonthOfYear 	
	(aCreditCardNumber size < 16) ifTrue: [^self error: self invalidCreditCardNumber].
	(aCreditCardNumber noneSatisfy: [:aCharacter | aCharacter isDigit ]) ifTrue: [^self error: self invalidCreditCardNumber].
	(anExpirationMonthOfYear isKindOf: Month) ifFalse: [^self error: self invalidExpirationDate].
	^self new number: aCreditCardNumber validTo: anExpirationMonthOfYear ! !


!CreditCard class methodsFor: 'error messages' stamp: 'FG 6/7/2022 20:42:41'!
invalidCreditCardNumber
	
	^'The credit card number is invalid. The number should be 16 digits'! !

!CreditCard class methodsFor: 'error messages' stamp: 'FG 6/7/2022 21:00:20'!
invalidExpirationDate
	
	^'The credit card expiration date is invalid. You have to provide a Month of the Year'! !


!classDefinition: #MerchantProcessorSimulator category: 'TusLibros'!
Object subclass: #MerchantProcessorSimulator
	instanceVariableNames: 'actionToSimulate answeredCalls'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessorSimulator methodsFor: 'simulation' stamp: 'FF 6/8/2022 18:35:08'!
simulateCreditCardWithoutEnoughLimit
	actionToSimulate := [self error: self class cannotPayWithCreditCardWithoutEnoughLimit].! !

!MerchantProcessorSimulator methodsFor: 'simulation' stamp: 'FF 6/8/2022 18:17:25'!
simulateStolenCreditCard
	actionToSimulate := [self error: self class cannotPayWithStolenCreditCard].! !


!MerchantProcessorSimulator methodsFor: 'action' stamp: 'FF 6/8/2022 18:45:00'!
debit: anAmount from: aCreditCard 
	answeredCalls := answeredCalls + 1.
	actionToSimulate value.! !


!MerchantProcessorSimulator methodsFor: 'testing' stamp: 'FF 6/8/2022 18:44:17'!
answeredCalls
	^answeredCalls.! !


!MerchantProcessorSimulator methodsFor: 'initialization' stamp: 'FF 6/8/2022 18:46:35'!
initialize
	answeredCalls := 0.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MerchantProcessorSimulator class' category: 'TusLibros'!
MerchantProcessorSimulator class
	instanceVariableNames: ''!

!MerchantProcessorSimulator class methodsFor: 'error messages' stamp: 'FF 6/8/2022 18:36:48'!
cannotPayWithCreditCardWithoutEnoughLimit
	^'The credit card limit is not enough'.! !

!MerchantProcessorSimulator class methodsFor: 'error messages' stamp: 'FF 6/8/2022 18:24:07'!
cannotPayWithStolenCreditCard
	^'The credit card has been notified as stolen'.! !
