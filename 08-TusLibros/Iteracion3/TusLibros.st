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
	instanceVariableNames: 'book1 book2 priceList sales validCreditCard expiredCreditCard today merchantProcessor ownerName'
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


!CashierTest methodsFor: 'setUp' stamp: 'FF 6/11/2022 20:16:55'!
setUp

	today := Date today.
	book1 := 'primer libro'.
	book2 := 'segundo libro'.

	priceList := Dictionary new.
	priceList at: book1 put: 10.
	priceList at: book2 put: 20.
	
	ownerName := 'owner'.

	sales := OrderedCollection new.
	
	validCreditCard := CreditCard number: '4545454545454545' validTo: today month next from: ownerName.
	expiredCreditCard := CreditCard number: '4545454545454545' validTo: today month previous from: ownerName.
	merchantProcessor := MerchantProcessorSimulator new.! !


!classDefinition: #CreditCardTest category: 'TusLibros'!
TestCase subclass: #CreditCardTest
	instanceVariableNames: 'today ownerName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCardTest methodsFor: 'setUp' stamp: 'FF 6/11/2022 20:17:33'!
setUp

	today := Date today.
	ownerName := 'owner'! !


!CreditCardTest methodsFor: 'test' stamp: 'FF 6/11/2022 20:18:14'!
test01CardCannotBeCreatedWithInvalidNumberLenght
	|card|

	self should: [card := CreditCard number: '2323' validTo: today month from: ownerName ]
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError | 
		self assert: CreditCard invalidCreditCardNumber equals: anError messageText .
		self assert: card isNil.
		]! !

!CreditCardTest methodsFor: 'test' stamp: 'FF 6/11/2022 20:18:21'!
test02CardCannotBeCreatedWithInvalidNumberCharacters
	|card|

	self should: [card := CreditCard number: 'aaaaaaaaaaaaaaaa' validTo: today month from: ownerName ]
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError | 
		self assert: CreditCard invalidCreditCardNumber equals: anError messageText .
		self assert: card isNil.
		]! !

!CreditCardTest methodsFor: 'test' stamp: 'FF 6/11/2022 20:18:26'!
test03CardCannotBeCreatedWhenValidToIsNotAMonth
	|card|

	self should: [card := CreditCard number: '4251236587945120' validTo: '' from: ownerName ]
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError | 
		self assert: CreditCard invalidExpirationDate equals: anError messageText .
		self assert: card isNil.
		]! !

!CreditCardTest methodsFor: 'test' stamp: 'FF 6/11/2022 20:18:32'!
test04CreditCardWithExpirationDateBeforeTodayShouldBeExpired

	|card|
	
	card := CreditCard number: '4251236587945120' validTo: today month previous from: ownerName .
	
	self assert: (card isExpiredOn: today).

		! !

!CreditCardTest methodsFor: 'test' stamp: 'FF 6/11/2022 20:18:44'!
test05CreditCardWithExpirationDateAfterTodayShouldNotBeExpired

	|card|
	
	card := CreditCard number: '4251236587945120' validTo: today month next from: ownerName .
	
	self deny: (card isExpiredOn: today).

		! !

!CreditCardTest methodsFor: 'test' stamp: 'FF 6/11/2022 20:17:43'!
test06CreditCardExpirationMonthIsIncludedOnTheExpirationPeriod

	|card|
	
	card := CreditCard number: '4251236587945120' validTo: today month from: ownerName .
	
	self deny: (card isExpiredOn: today).

		! !


!classDefinition: #InterfaceFacadeTest category: 'TusLibros'!
TestCase subclass: #InterfaceFacadeTest
	instanceVariableNames: 'invalidCartId validBookISBN priceList authenticatorServiceSimulatingValidClient authenticatorServiceSimulatingInvalidClient interfaceFacade interfaceFacadeInvalid clientId password creditCardNumber expirationMonth cardOwnerName today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!InterfaceFacadeTest methodsFor: 'setUp' stamp: 'FF 6/11/2022 20:22:22'!
setUp

	today := Date today.
	clientId := 'ClientId'.
	password := 'password'.
	invalidCartId := nil.
	validBookISBN := 'book1'.
	priceList := Dictionary new.
	priceList at: validBookISBN put: 15.
	creditCardNumber := '1234123412341234'.
	expirationMonth := today month next.
	cardOwnerName := 'owner'.
	
	authenticatorServiceSimulatingValidClient := AuthenticatorServiceSimulator simulateClientIsValid: true.
	authenticatorServiceSimulatingInvalidClient := AuthenticatorServiceSimulator simulateClientIsValid: false.

	interfaceFacade := InterfaceFacade priceList: priceList authenticator: authenticatorServiceSimulatingValidClient.
	
	interfaceFacadeInvalid := InterfaceFacade priceList: priceList authenticator: authenticatorServiceSimulatingInvalidClient.! !


!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/11/2022 11:30:04'!
test01ValidClientCanCreateACart

	| cartId listCart |

	cartId := interfaceFacade createCartFor: clientId signInWith: password .
	
	listCart := interfaceFacade listCart: cartId .
	
	self assert: listCart isEmpty.
	! !

!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/11/2022 11:30:42'!
test02InvalidClientCannotCreateACart

	| cartId |
	
	self should: [ cartId := interfaceFacadeInvalid createCartFor: clientId signInWith: password ] 
	raise:  Error - MessageNotUnderstood 
	withExceptionDo: [ :anError |
		self assert: InterfaceFacade clientIsNotValid equals: anError messageText.
		self assert: cartId isNil.
	].

	
	
	! !

!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/11/2022 11:31:34'!
test03CreateCartReturnsUniqueCartId

	| firstCartId secondCartId |
	
	firstCartId := interfaceFacade createCartFor: clientId signInWith: password .
	secondCartId := interfaceFacade createCartFor: clientId signInWith: password .

	self deny: (firstCartId = secondCartId).
	

	
	
	! !

!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/11/2022 11:33:48'!
test04ListCartOfInvalidCartIdThrowsError

	| listCart  |
	
	self should: [ listCart := interfaceFacade listCart: invalidCartId. ]
	raise:  Error - MessageNotUnderstood 
	withExceptionDo: [:anError |
		self assert: InterfaceFacade cartDoesNotExist equals: anError messageText.
		self assert: listCart isNil.
	]
	

	
	
	! !

!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/11/2022 19:13:39'!
test05ListCartIncludesAddedItemsAndItsQuantity

	|  cartId  listCart  quantity|
	
	quantity := 1.
	
	cartId := interfaceFacade createCartFor: clientId signInWith: password.
	
	interfaceFacade addToCart: cartId book: validBookISBN quantity: quantity.
	
	listCart := interfaceFacade listCart: cartId.
	
	self deny: listCart isEmpty.
	self assert: (listCart includes: validBookISBN).
	self assert: quantity equals: (listCart occurrencesOf: validBookISBN).
	

	
	
	! !

!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/11/2022 19:21:28'!
test06AddToCartWithInvalidCartIdThrowsError
	
	self should: [ interfaceFacade addToCart: invalidCartId book: validBookISBN quantity: 2. ]
	raise:  Error - MessageNotUnderstood 
	withExceptionDo: [:anError |
		self assert: InterfaceFacade cartDoesNotExist equals: anError messageText.
		]
	

	
	
	! !

!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/11/2022 19:57:04'!
test07CheckOutCartReturnsTransactionId

	|  cartId  quantity listPurchases transactionId |
	quantity := 1.
	cartId := interfaceFacade createCartFor: clientId signInWith: password.
	interfaceFacade addToCart: cartId book: validBookISBN quantity: quantity.
		
	transactionId := interfaceFacade checkOut: cartId withCardNumber: creditCardNumber expirationDate: expirationMonth from: cardOwnerName .
	listPurchases := interfaceFacade listPurchasesFrom: clientId signInWith: password.
	
	self assert: transactionId notNil.
	self deny: listPurchases isEmpty.


	
	
	! !

!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/11/2022 19:59:35'!
test08CheckOutCartOfInvalidCartIdThrowsError

	| transactionId |
	self should: [ transactionId := interfaceFacade checkOut: invalidCartId withCardNumber: creditCardNumber expirationDate: expirationMonth from: cardOwnerName ] 
	raise:  Error - MessageNotUnderstood 
	withExceptionDo: [ :anError |
		self assert: InterfaceFacade cartDoesNotExist equals: anError messageText.
		self assert: transactionId isNil.
	].

	
	
	! !

!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/11/2022 20:06:28'!
test09CheckOutCartWithInvalidCreditCardThrowsError

	| transactionId cartId |
	cartId := interfaceFacade createCartFor: clientId signInWith: password .
	self should: [ transactionId := interfaceFacade checkOut: cartId withCardNumber: '123' expirationDate: expirationMonth from: cardOwnerName ] 
	raise:  Error - MessageNotUnderstood 
	withExceptionDo: [ :anError |
		self assert: CreditCard invalidCreditCardNumber equals: anError messageText.
		self assert: transactionId isNil.
	].

	
	
	! !

!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/11/2022 20:33:45'!
test10ListPurchasesReturnsClientTransactions

	|  cartId  quantity listPurchases transactionId |
	quantity := 1.
	cartId := interfaceFacade createCartFor: clientId signInWith: password.
	interfaceFacade addToCart: cartId book: validBookISBN quantity: quantity.
		
	transactionId := interfaceFacade checkOut: cartId withCardNumber: creditCardNumber expirationDate: expirationMonth from: cardOwnerName .
	listPurchases := interfaceFacade listPurchasesFrom: clientId signInWith: password.
	
	self assert: transactionId notNil.
	self deny: listPurchases isEmpty.
	self assert: (listPurchases at: 1) books includes: validBookISBN .
	self assert: quantity equals: ((listPurchases at: 1) books occurrencesOf: validBookISBN).
	self assert: 15 equals: ((listPurchases at: 1) total).

	
	
	! !


!classDefinition: #AuthenticatorServiceSimulator category: 'TusLibros'!
Object subclass: #AuthenticatorServiceSimulator
	instanceVariableNames: 'isValidClient'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!AuthenticatorServiceSimulator methodsFor: 'initialization' stamp: 'FF 6/11/2022 10:51:36'!
initializeIsValid: isAValidClient 
	isValidClient :=isAValidClient.! !


!AuthenticatorServiceSimulator methodsFor: 'testing' stamp: 'FF 6/11/2022 10:57:34'!
canAuthenticate: aClientId with: aPassword 
	^isValidClient. ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AuthenticatorServiceSimulator class' category: 'TusLibros'!
AuthenticatorServiceSimulator class
	instanceVariableNames: ''!

!AuthenticatorServiceSimulator class methodsFor: 'instance creation' stamp: 'FF 6/11/2022 10:48:32'!
simulateClientIsValid: isAValidClient
	
	^self new initializeIsValid: isAValidClient ! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'books priceList'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'initialization' stamp: 'FF 6/11/2022 11:56:42'!
initializeWith: aPriceList
	priceList := aPriceList.
	books := Bag new.! !


!Cart methodsFor: 'testing' stamp: 'FF 6/3/2022 23:26:15'!
isEmpty
	^books isEmpty.! !


!Cart methodsFor: 'adding' stamp: 'FF 6/11/2022 12:08:02'!
add: aQuantity of: aBook 
	self assertQuantityIsPositive: aQuantity .
	self assertProductExistOnPriceList: aBook.
	books add: aBook withOccurrences: aQuantity .! !

!Cart methodsFor: 'adding' stamp: 'FF 6/11/2022 12:08:09'!
assertProductExistOnPriceList: aProductToBeAdded 
	(priceList includesKey: aProductToBeAdded) ifFalse: [^ self error: self class cannotAddAnUncataloguedBook].! !

!Cart methodsFor: 'adding' stamp: 'FF 6/11/2022 12:08:16'!
assertQuantityIsPositive: quantityOfBookToBeAdded 
	(quantityOfBookToBeAdded <=0) ifTrue: [^self error: self class cannotAddBookWithNonPositiveQuantity ].! !


!Cart methodsFor: 'accessing' stamp: 'FF 6/11/2022 11:56:28'!
books

	^books copy.! !


!Cart methodsFor: 'total' stamp: 'FF 6/11/2022 12:07:47'!
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

!Cashier methodsFor: 'checking out' stamp: 'FF 6/11/2022 20:45:14'!
checkOut: aCart payingWith: aCreditCard on: aDateOfSale

	| totalToDebit ticket |
	self assertCartIsNotEmpty: aCart.
	self assertCreditCardIsNotExpired: aCreditCard on: aDateOfSale .
	
	totalToDebit := aCart total.
	merchantProcessor debit: totalToDebit from: aCreditCard .
	ticket := Ticket of: aCart books total: totalToDebit .
	salesList add: ticket.
	
	^ticket.! !


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
	instanceVariableNames: 'number expirationMonth owner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'initialization' stamp: 'FF 6/11/2022 20:14:08'!
number: aCreditCardNumber validTo: anExpirationMonthOfYear from: aCardOwnerName 
	number := aCreditCardNumber.
	expirationMonth := anExpirationMonthOfYear.	
	owner := aCardOwnerName .! !


!CreditCard methodsFor: 'testing' stamp: 'FF 6/7/2022 17:58:31'!
isExpiredOn: aDate 
	| expirationDate |
	expirationDate := Date year: expirationMonth yearNumber month: expirationMonth monthName day: expirationMonth daysInMonth.
	^aDate > expirationDate.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'FF 6/11/2022 20:14:34'!
number: aCreditCardNumber validTo: anExpirationMonthOfYear from: aCardOwnerName  	

	(aCreditCardNumber size < 16) ifTrue: [^self error: self invalidCreditCardNumber].
	(aCreditCardNumber noneSatisfy: [:aCharacter | aCharacter isDigit ]) ifTrue: [^self error: self invalidCreditCardNumber].
	(anExpirationMonthOfYear isKindOf: Month) ifFalse: [^self error: self invalidExpirationDate].
	^self new number: aCreditCardNumber validTo: anExpirationMonthOfYear from: aCardOwnerName ! !


!CreditCard class methodsFor: 'error messages' stamp: 'FG 6/7/2022 20:42:41'!
invalidCreditCardNumber
	
	^'The credit card number is invalid. The number should be 16 digits'! !

!CreditCard class methodsFor: 'error messages' stamp: 'FG 6/7/2022 21:00:20'!
invalidExpirationDate
	
	^'The credit card expiration date is invalid. You have to provide a Month of the Year'! !


!classDefinition: #InterfaceFacade category: 'TusLibros'!
Object subclass: #InterfaceFacade
	instanceVariableNames: 'authenticatorService lastCartId carts priceList merchantProcessor today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!InterfaceFacade methodsFor: 'cart' stamp: 'FF 6/11/2022 19:24:18'!
addToCart: aCartId book: aBookISBN quantity: aQuantityToAdd

	| cartFound |
	cartFound := self findCart: aCartId.
	cartFound add: aQuantityToAdd of: aBookISBN.
	! !

!InterfaceFacade methodsFor: 'cart' stamp: 'FF 6/11/2022 20:41:39'!
checkOut: aCartId withCardNumber: aCreditCardNumber expirationDate: anExpirationDate from: aCardOwnerName 
	| creditCard cart cashier |
	cart := self findCart: aCartId.
	cashier := Cashier using: priceList debitProcessor: merchantProcessor.
	creditCard := CreditCard number: aCreditCardNumber validTo: anExpirationDate from: aCardOwnerName .
	cashier checkOut: cart payingWith: creditCard on: today.! !

!InterfaceFacade methodsFor: 'cart' stamp: 'FF 6/11/2022 11:47:48'!
createCartFor: aClientId signInWith: aPassword 
	| newCart |
	
	(authenticatorService canAuthenticate: aClientId with: aPassword) ifFalse: [^self error: self class clientIsNotValid].
	
	newCart := Cart with: priceList.
	lastCartId := lastCartId + 1.
	carts at: lastCartId put: newCart. 
	^lastCartId.! !

!InterfaceFacade methodsFor: 'cart' stamp: 'FF 6/11/2022 19:25:31'!
listCart: aCartId 
	| cartFound |
	cartFound := self findCart: aCartId.
	^cartFound books.! !


!InterfaceFacade methodsFor: 'cart - private' stamp: 'FF 6/11/2022 19:24:18'!
findCart: aCartId

	^ carts at: aCartId ifAbsent:[self error: self class cartDoesNotExist]! !


!InterfaceFacade methodsFor: 'initialization' stamp: 'FF 6/11/2022 11:53:11'!
priceList: aPriceList authenticator: anAuthenticatorService
	authenticatorService := anAuthenticatorService.
	carts := Dictionary new.
	lastCartId := 0.
	priceList := aPriceList .! !


!InterfaceFacade methodsFor: 'client' stamp: 'FF 6/11/2022 20:37:07'!
listPurchasesFrom: aClientId signInWith: aPassword 
	^OrderedCollection with: ''.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InterfaceFacade class' category: 'TusLibros'!
InterfaceFacade class
	instanceVariableNames: ''!

!InterfaceFacade class methodsFor: 'instance creation' stamp: 'FF 6/11/2022 11:52:17'!
priceList: aPriceList authenticator: anAuthenticatorService
	
	^self new priceList: aPriceList authenticator: anAuthenticatorService! !


!InterfaceFacade class methodsFor: 'error messages' stamp: 'FF 6/11/2022 11:38:27'!
cartDoesNotExist
	^'The cartId provided is not valid'! !

!InterfaceFacade class methodsFor: 'error messages' stamp: 'FF 6/11/2022 10:58:39'!
clientIsNotValid
	^'The client is not valid, check the provided password and clientId'! !


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


!classDefinition: #Ticket category: 'TusLibros'!
Object subclass: #Ticket
	instanceVariableNames: 'books total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Ticket methodsFor: 'initialization' stamp: 'FF 6/11/2022 20:47:37'!
of: aBookBag total: anAmount 
	books := aBookBag .
	total := anAmount .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Ticket class' category: 'TusLibros'!
Ticket class
	instanceVariableNames: ''!

!Ticket class methodsFor: 'instance creation' stamp: 'FF 6/11/2022 20:46:42'!
of: aBookBag total: anAmount 
	
	^self new of: aBookBag total: anAmount ! !
