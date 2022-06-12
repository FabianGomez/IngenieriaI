!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'priceList book1 clientId'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'test' stamp: 'FF 6/12/2022 11:02:48'!
test01CartIsEmptyWhenCreated

	| cart |

	cart := Cart from: clientId with: priceList .
	
	self assert: cart isEmpty.
	! !

!CartTest methodsFor: 'test' stamp: 'FF 6/12/2022 11:02:48'!
test02EmptyCartAfterAddingABookIsNotEmpty

	|  cart |
	cart := Cart from: clientId with: priceList.
	
	cart add: 1 of: book1 .
	
	self deny: cart isEmpty.! !

!CartTest methodsFor: 'test' stamp: 'FF 6/12/2022 11:02:48'!
test03CannotAddBooksToCartWithNonPositiveQuantity

	| cart |
	cart := Cart from: clientId with: priceList.
	
	self should: [cart add: -1 of: book1.] 
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError | self assert: Cart cannotAddBookWithNonPositiveQuantity equals: anError messageText .
		self assert: cart isEmpty ].! !

!CartTest methodsFor: 'test' stamp: 'FF 6/12/2022 11:02:48'!
test04CannotAddAnUncataloguedBook

	| book cart |	
	book := 'uncatolog book'.
	cart := Cart from: clientId with: priceList .
	
	self should: [cart add: 1 of: book.] 
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError | self assert: Cart cannotAddAnUncataloguedBook equals: anError messageText .
		self assert: cart isEmpty ].! !

!CartTest methodsFor: 'test' stamp: 'FF 6/12/2022 11:02:48'!
test05CartReturnsEmptyBookListWhenCreated

	| cart |
	cart := Cart from: clientId with: priceList .
	
	self assert: cart books isEmpty.! !

!CartTest methodsFor: 'test' stamp: 'FF 6/12/2022 11:02:48'!
test06CartBookListIncludesBookAfterAdding

	| cart  |
	cart := Cart from: clientId with: priceList.
	cart add: 2 of: book1 .
	
	self deny: cart books isEmpty.
	self assert: (cart books includes: book1).! !

!CartTest methodsFor: 'test' stamp: 'FF 6/12/2022 11:02:48'!
test07EmptyCartTotalIsZero

	| cart |
	cart := Cart from: clientId with: priceList .
	
	self assert: 0 equals: cart total.! !

!CartTest methodsFor: 'test' stamp: 'FF 6/12/2022 11:02:48'!
test08CartWithItemsTotalIsTheSumOfItemPrices

	| cart |

	cart := Cart from: clientId with: priceList.
	cart add: 2 of: book1.
	
	self assert: 20 equals: cart total.! !


!CartTest methodsFor: 'setUp' stamp: 'FF 6/12/2022 11:04:00'!
setUp

	book1 := 'libro 1'.
	
	priceList := Dictionary new.
	priceList at: book1 put: 10 .
	clientId := 'clientId'.! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'book1 book2 priceList sales validCreditCard expiredCreditCard today merchantProcessor ownerName clientId'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'test' stamp: 'FF 6/12/2022 11:31:18'!
test01CannotCheckOutEmptyCart

	| cart cashier |
	cart := Cart from: clientId with: priceList .
	cashier := Cashier using: sales debitProcessor: merchantProcessor .
	
	self should: [cashier checkOut: cart payingWith: validCreditCard on: today] 
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError | self assert: Cashier cannotCheckOutAnEmptyCart equals: anError messageText .
			self assert: sales isEmpty.
			self assert: 0 equals: merchantProcessor answeredCalls.
		].! !

!CashierTest methodsFor: 'test' stamp: 'FF 6/12/2022 11:31:31'!
test02CannotCheckOutCartProvidingAnExpiredCreditCard
	| cart cashier |
	
	cart := Cart from: clientId with: priceList .
	cart add: 1 of: book1. 
	cashier := Cashier using: sales debitProcessor: merchantProcessor .
	
	self should: [cashier checkOut: cart payingWith: expiredCreditCard on: today] 
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError |  self assert: Cashier cannotPayWithExpiredCreditCard equals: anError messageText .
			self assert: sales isEmpty .
			self assert: 0 equals: merchantProcessor answeredCalls.
		].! !

!CashierTest methodsFor: 'test' stamp: 'FF 6/12/2022 11:32:05'!
test03CheckOutCartWithItemsAddElementToSalesList
	| cart cashier |
	
	cart := Cart from: clientId with: priceList.
	cart add: 1 of: book1.
	cart add: 2 of: book2.
	cashier := Cashier using: sales debitProcessor: merchantProcessor .
	cashier checkOut: cart payingWith: validCreditCard on: today.
			
	self assert: 1 equals: merchantProcessor answeredCalls.
	self deny: sales isEmpty.! !

!CashierTest methodsFor: 'test' stamp: 'FF 6/12/2022 11:02:48'!
test04CheckOutCartWithItemsReturnsTotal

	| cart cashier ticket |
	
	cart := Cart from: clientId with: priceList.
	cart add: 1 of: book1.
	cart add: 2 of: book2.
	cashier := Cashier using: sales debitProcessor: merchantProcessor .
	
	ticket := cashier checkOut: cart payingWith: validCreditCard on: today.
	
	self assert: cart total equals: ticket total.
	self assert: 1 equals: merchantProcessor answeredCalls.! !

!CashierTest methodsFor: 'test' stamp: 'FF 6/12/2022 11:02:48'!
test05CannotCheckOutCartProvidingStolenCreditCard

	| cart cashier |
	
	cart := Cart from: clientId with: priceList.
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

!CashierTest methodsFor: 'test' stamp: 'FF 6/12/2022 11:02:48'!
test06CannotCheckOutCartProvidingCreditCardWithoutEnoughLimit

	| cart cashier |
	
	cart := Cart from: clientId with: priceList.
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


!CashierTest methodsFor: 'setUp' stamp: 'FF 6/12/2022 11:04:56'!
setUp

	today := Date today.
	book1 := 'primer libro'.
	book2 := 'segundo libro'.
	clientId := 'clientId'.

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
	instanceVariableNames: 'invalidCartId validBookISBN priceList authenticatorServiceSimulatingValidClient authenticatorServiceSimulatingInvalidClient interfaceFacade interfaceFacadeInvalid clientId password creditCardNumber expirationMonth cardOwnerName today timerSimulator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!InterfaceFacadeTest methodsFor: 'setUp' stamp: 'FF 6/12/2022 11:54:36'!
setUp

	timerSimulator := TimerSimulator new.
	today := timerSimulator today.
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

	interfaceFacade := InterfaceFacade priceList: priceList authenticator: authenticatorServiceSimulatingValidClient timer: timerSimulator.
	
	interfaceFacadeInvalid := InterfaceFacade priceList: priceList authenticator: authenticatorServiceSimulatingInvalidClient timer: timerSimulator .! !


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

!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/12/2022 10:27:30'!
test11InvalidClientCannotListAnyPurchases

	| listPurchases |
	
	self should: [ listPurchases := interfaceFacadeInvalid listPurchasesFrom: clientId signInWith: password ] 
	raise:  Error - MessageNotUnderstood 
	withExceptionDo: [ :anError |
		self assert: InterfaceFacade clientIsNotValid equals: anError messageText.
		self assert: listPurchases isNil.
	].

	
	
	! !

!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/12/2022 10:35:17'!
test12CheckOutReturnsUniqueTransactionId

	| firstCartId secondCartId quantity firstTransactionId secondTransactionId |
	quantity := 1.
	firstCartId := interfaceFacade createCartFor: clientId signInWith: password.
	interfaceFacade addToCart: firstCartId book: validBookISBN quantity: quantity.
		
	firstTransactionId := interfaceFacade checkOut: firstCartId withCardNumber: creditCardNumber expirationDate: expirationMonth from: cardOwnerName .
	
	secondCartId := interfaceFacade createCartFor: clientId signInWith: password.
	interfaceFacade addToCart: secondCartId book: validBookISBN quantity: quantity.
		
	secondTransactionId := interfaceFacade checkOut: secondCartId withCardNumber: creditCardNumber expirationDate: expirationMonth from: cardOwnerName .
	

	self deny: (firstTransactionId = secondTransactionId).
	

	
	
	! !

!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/12/2022 10:43:33'!
test13CartIdIsInvalidAfterCheckOut

	|  cartId  quantity |
	quantity := 1.
	cartId := interfaceFacade createCartFor: clientId signInWith: password.
	interfaceFacade addToCart: cartId book: validBookISBN quantity: quantity.
		
	interfaceFacade checkOut: cartId withCardNumber: creditCardNumber expirationDate: expirationMonth from: cardOwnerName .
	
	self should: [ interfaceFacade checkOut: cartId withCardNumber: creditCardNumber expirationDate: expirationMonth from: cardOwnerName ] 
	raise:  Error - MessageNotUnderstood 
	withExceptionDo: [ :anError |
		self assert: InterfaceFacade cartDoesNotExist equals: anError messageText.
	].

	
	
	! !

!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/12/2022 10:50:59'!
test14ListPurchasesAreDifferentBetweenTwoDifferentClients

	|  cartId  quantity listPurchases listPurchasesFromAnotherClient |
	quantity := 1.
	cartId := interfaceFacade createCartFor: clientId signInWith: password.
	interfaceFacade addToCart: cartId book: validBookISBN quantity: quantity.
		
	interfaceFacade checkOut: cartId withCardNumber: creditCardNumber expirationDate: expirationMonth from: cardOwnerName .
	listPurchases := interfaceFacade listPurchasesFrom: clientId signInWith: password.
	listPurchasesFromAnotherClient := interfaceFacade listPurchasesFrom: 'anotherClientId' signInWith: password.
	
	self deny: (listPurchases = listPurchasesFromAnotherClient).

	
	
	! !

!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/12/2022 11:52:37'!
test15CannotCheckOutACartAfterTimeExceeded

	|  cartId  quantity |
	quantity := 1.
	cartId := interfaceFacade createCartFor: clientId signInWith: password.
	interfaceFacade addToCart: cartId book: validBookISBN quantity: quantity.
	
	timerSimulator simulateHalfHourHasPassed.
		 .
	self should: [ interfaceFacade checkOut: cartId withCardNumber: creditCardNumber expirationDate: expirationMonth from: cardOwnerName ] 
	raise:  Error - MessageNotUnderstood 
	withExceptionDo: [ :anError |
		self assert: InterfaceFacade cartIsExpired equals: anError messageText.
	].

	
	
	! !

!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/12/2022 12:31:37'!
test16CannotAddToCartAfterTimeExceeded

	|  cartId  quantity |
	quantity := 1.
	cartId := interfaceFacade createCartFor: clientId signInWith: password.
	
	timerSimulator simulateHalfHourHasPassed.
		 .
	self should: [ interfaceFacade addToCart: cartId book: validBookISBN quantity: quantity. ] 
	raise:  Error - MessageNotUnderstood 
	withExceptionDo: [ :anError |
		self assert: InterfaceFacade cartIsExpired equals: anError messageText.
	].

	
	
	! !

!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/12/2022 12:39:55'!
test17CannotListACartAfterTimeExceeded

	|  cartId  |
	cartId := interfaceFacade createCartFor: clientId signInWith: password.
	
	timerSimulator simulateHalfHourHasPassed.

	self should: [ interfaceFacade listCart: cartId] 
	raise:  Error - MessageNotUnderstood 
	withExceptionDo: [ :anError |
		self assert: InterfaceFacade cartIsExpired equals: anError messageText.
	].

	
	
	! !

!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/12/2022 12:44:14'!
test18AddToCartRestartLastTimeUsed

	|  cartId  quantity listCart |
	quantity := 1.
	cartId := interfaceFacade createCartFor: clientId signInWith: password.
	
	timerSimulator simulateQuarterHourHasPassed.
	interfaceFacade addToCart: cartId book: validBookISBN quantity: quantity.
	timerSimulator simulateQuarterHourHasPassed.
	listCart := interfaceFacade listCart: cartId.
	
	self deny: listCart isEmpty.! !

!InterfaceFacadeTest methodsFor: 'test' stamp: 'FF 6/12/2022 12:48:08'!
test19ListCartRestartLastTimeUsed

	|  cartId  quantity listCart |
	quantity := 1.
	cartId := interfaceFacade createCartFor: clientId signInWith: password.
	
	timerSimulator simulateQuarterHourHasPassed.
	interfaceFacade listCart: cartId.
	timerSimulator simulateQuarterHourHasPassed.
	interfaceFacade addToCart: cartId book: validBookISBN quantity: quantity.
	listCart := interfaceFacade listCart: cartId.
	
	self deny: listCart isEmpty.! !


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
	instanceVariableNames: 'books priceList clientId'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'initialization' stamp: 'FF 6/12/2022 10:57:27'!
from: aClientId with: aPriceList
	priceList := aPriceList .
	clientId := aClientId.
	books := Bag new.
	! !


!Cart methodsFor: 'testing' stamp: 'FF 6/12/2022 09:40:32'!
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


!Cart methodsFor: 'total' stamp: 'FF 6/12/2022 11:29:37'!
generateTicket
	^Ticket from: clientId of: self books total: self total .

	! !

!Cart methodsFor: 'total' stamp: 'FF 6/12/2022 09:04:36'!
total
	^ books sum: [:aBook | priceList at: aBook] ifEmpty: [^0].
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'error messages' stamp: 'FF 6/12/2022 09:10:56'!
cannotAddAnUncataloguedBook
	^'The book is not in the catalog'.! !

!Cart class methodsFor: 'error messages' stamp: 'FF 6/12/2022 09:11:05'!
cannotAddBookWithNonPositiveQuantity
	^'Can not add books with zero or negative quantity'! !


!Cart class methodsFor: 'instance creation' stamp: 'FF 6/12/2022 11:03:08'!
from: aClientId with: aPriceList 
	^self new from: aClientId with: aPriceList.! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'salesList merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'checking out' stamp: 'FF 6/12/2022 09:02:19'!
assertCartIsNotEmpty: aCart
	aCart isEmpty ifTrue:[^self error: self class cannotCheckOutAnEmptyCart ].
	! !

!Cashier methodsFor: 'checking out' stamp: 'FF 6/12/2022 09:02:04'!
assertCreditCardIsNotExpired: aCreditCard on: anExpirationDate
	
	(aCreditCard isExpiredOn: anExpirationDate) ifTrue:[^self error: self class cannotPayWithExpiredCreditCard].
! !

!Cashier methodsFor: 'checking out' stamp: 'FF 6/12/2022 11:27:08'!
checkOut: aCart payingWith: aCreditCard on: aDateOfSale

	| totalToDebit ticket |
	self assertCartIsNotEmpty: aCart.
	self assertCreditCardIsNotExpired: aCreditCard on: aDateOfSale .
	
	totalToDebit := aCart total.
	merchantProcessor debit: totalToDebit from: aCreditCard .
	ticket := aCart generateTicket.
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


!Cashier class methodsFor: 'instance creation' stamp: 'FF 6/8/2022 18:01:18'!
using: aSalesList debitProcessor: aMerchantProcessor
	^self new using: aSalesList debitProcessor: aMerchantProcessor ! !


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


!CreditCard methodsFor: 'testing' stamp: 'FF 6/12/2022 09:08:39'!
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
	instanceVariableNames: 'authenticatorService lastCartId carts priceList merchantProcessor today salesList lastTransactionId timer cartsLastTimeUsed'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!InterfaceFacade methodsFor: 'cart' stamp: 'FF 6/12/2022 12:48:55'!
addToCart: aCartId book: aBookISBN quantity: aQuantityToAdd

	| cartFound |
	cartFound := self findCart: aCartId.
	
	self assertCartIsNotExpired: aCartId.
	
	self updateLastTimeUsed: aCartId.
	
	cartFound add: aQuantityToAdd of: aBookISBN.
	! !

!InterfaceFacade methodsFor: 'cart' stamp: 'FF 6/12/2022 12:36:38'!
assertCartIsNotExpired: aCartId
	|  lastTimeUsed now |
	now := timer now.
	lastTimeUsed := (cartsLastTimeUsed at: aCartId).
	((now - lastTimeUsed) >= (Duration minutes: 30) ) 
	ifTrue: [
		self deleteCart: aCartId .
		self error: self class cartIsExpired.
	 ].
	! !

!InterfaceFacade methodsFor: 'cart' stamp: 'FF 6/12/2022 12:37:17'!
checkOut: aCartId withCardNumber: aCreditCardNumber expirationDate: anExpirationDate from: aCardOwnerName 
	| creditCard cart cashier |
	cart := self findCart: aCartId.
	
	self assertCartIsNotExpired: aCartId.
	
	cashier := Cashier using: salesList debitProcessor: merchantProcessor.
	creditCard := CreditCard number: aCreditCardNumber validTo: anExpirationDate from: aCardOwnerName .
	cashier checkOut: cart payingWith: creditCard on: today.
	self deleteCart: aCartId .
	lastTransactionId := lastTransactionId + 1.
	^lastTransactionId.! !

!InterfaceFacade methodsFor: 'cart' stamp: 'FF 6/12/2022 12:14:58'!
createCartFor: aClientId signInWith: aPassword 
	| newCart |
	
	self assertClient: aClientId canAuthenticateUsing: aPassword.
	
	newCart := Cart from: aClientId with: priceList.
	lastCartId := lastCartId + 1.
	cartsLastTimeUsed at: lastCartId put: timer now.
	carts at: lastCartId put: newCart. 
	^lastCartId.! !

!InterfaceFacade methodsFor: 'cart' stamp: 'FF 6/12/2022 12:36:48'!
deleteCart: aCartId

	carts removeKey: aCartId.
	cartsLastTimeUsed removeKey: aCartId! !

!InterfaceFacade methodsFor: 'cart' stamp: 'FF 6/12/2022 12:49:03'!
listCart: aCartId 
	| cartFound |
	cartFound := self findCart: aCartId.
	self assertCartIsNotExpired: aCartId.
	self updateLastTimeUsed: aCartId.
	^cartFound books.! !

!InterfaceFacade methodsFor: 'cart' stamp: 'FF 6/12/2022 12:48:54'!
updateLastTimeUsed: aCartId

	^ cartsLastTimeUsed at: aCartId put: timer now! !


!InterfaceFacade methodsFor: 'cart - private' stamp: 'FF 6/11/2022 19:24:18'!
findCart: aCartId

	^ carts at: aCartId ifAbsent:[self error: self class cartDoesNotExist]! !


!InterfaceFacade methodsFor: 'initialization' stamp: 'FF 6/12/2022 12:14:58'!
priceList: aPriceList authenticator: anAuthenticatorService timer: aTimer 
	priceList := aPriceList .
	authenticatorService := anAuthenticatorService .
	timer := aTimer .
	carts := Dictionary new.
	lastCartId := 0.
	lastTransactionId := 0.
	salesList := OrderedCollection new.
	merchantProcessor := MerchantProcessorSimulator new.
	cartsLastTimeUsed := Dictionary new.
	today := timer today.! !


!InterfaceFacade methodsFor: 'client' stamp: 'FF 6/12/2022 10:29:49'!
assertClient: aClientId canAuthenticateUsing: aPassword

	^ (authenticatorService canAuthenticate: aClientId with: aPassword) ifFalse: [self error: self class clientIsNotValid]! !

!InterfaceFacade methodsFor: 'client' stamp: 'FF 6/12/2022 10:53:09'!
listPurchasesFrom: aClientId signInWith: aPassword 
	self assertClient: aClientId canAuthenticateUsing: aPassword.
	^salesList select:[:ticket | ticket clientId = aClientId ].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InterfaceFacade class' category: 'TusLibros'!
InterfaceFacade class
	instanceVariableNames: ''!

!InterfaceFacade class methodsFor: 'instance creation' stamp: 'FF 6/12/2022 11:59:45'!
priceList: aPriceList authenticator: anAuthenticatorService timer: aTimer 
	^self new priceList: aPriceList authenticator: anAuthenticatorService timer: aTimer ! !


!InterfaceFacade class methodsFor: 'error messages' stamp: 'FF 6/11/2022 11:38:27'!
cartDoesNotExist
	^'The cartId provided is not valid'! !

!InterfaceFacade class methodsFor: 'error messages' stamp: 'FF 6/12/2022 12:26:45'!
cartIsExpired
	^'The cart has expired'! !

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
	instanceVariableNames: 'books total clientId'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Ticket methodsFor: 'initialization' stamp: 'FF 6/12/2022 11:14:14'!
from: aClientId of: aBooksCollection total: anAmount 
	clientId := aClientId .
	books := aBooksCollection .
	total := anAmount .! !


!Ticket methodsFor: 'accessing' stamp: 'FF 6/12/2022 10:20:12'!
books
	^books copy.! !

!Ticket methodsFor: 'accessing' stamp: 'FF 6/12/2022 10:53:41'!
clientId
	^clientId.! !

!Ticket methodsFor: 'accessing' stamp: 'FF 6/12/2022 10:19:59'!
total
	^total.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Ticket class' category: 'TusLibros'!
Ticket class
	instanceVariableNames: ''!

!Ticket class methodsFor: 'instance creation' stamp: 'FF 6/12/2022 11:13:23'!
from: aClientId of: aBooksCollection total: anAmount 
	^self new from: aClientId of: aBooksCollection total: anAmount ! !


!classDefinition: #TimerSimulator category: 'TusLibros'!
Object subclass: #TimerSimulator
	instanceVariableNames: 'now'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TimerSimulator methodsFor: 'date' stamp: 'FF 6/12/2022 12:19:27'!
now
	^now! !

!TimerSimulator methodsFor: 'date' stamp: 'FF 6/12/2022 12:02:37'!
today
	^now date.! !


!TimerSimulator methodsFor: 'initialization' stamp: 'FF 6/12/2022 12:02:16'!
initialize
	now := DateAndTime now.! !


!TimerSimulator methodsFor: 'simulation' stamp: 'FF 6/12/2022 12:20:55'!
simulateHalfHourHasPassed
	now := now + (Duration minutes: 30).! !

!TimerSimulator methodsFor: 'simulation' stamp: 'FF 6/12/2022 12:45:20'!
simulateQuarterHourHasPassed
	now := now + (Duration minutes: 15).! !
