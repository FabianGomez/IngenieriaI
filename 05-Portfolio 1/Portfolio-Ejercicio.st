!classDefinition: #CannotAddAccountSummary category: 'Portfolio-Ejercicio'!
Error subclass: #CannotAddAccountSummary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!


!classDefinition: #PortfolioTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'assertions' stamp: 'FG 5/22/2022 16:09:55'!
assertPortfolioBalanceEquals: balanceCalculation afterDoing: aClosureOfTransactionsToProcess

	|portfolio|
	
	portfolio := Portfolio new.
	
	aClosureOfTransactionsToProcess value: portfolio.
	
	self assert: portfolio balance = balanceCalculation.! !

!PortfolioTest methodsFor: 'assertions' stamp: 'FG 5/22/2022 16:54:29'!
should: aClosureToFail raiseCannotAddAccountSummaryAfter: aClosureToProcess

	aClosureToProcess value.
	
	self should: aClosureToFail raise: CannotAddAccountSummary.
	
		
	! !


!PortfolioTest methodsFor: 'testing' stamp: 'FG 5/22/2022 16:10:45'!
test01PortfolioHaveZeroAsBalanceWhenCreated

	self assertPortfolioBalanceEquals: 0 afterDoing: [:portfolio | ^self].! !

!PortfolioTest methodsFor: 'testing' stamp: 'FG 5/22/2022 16:49:19'!
test02AccountWithTransactionsIncreasePortfolioBalance

	|account|
	
	account := self createAccountWithDeposit: 100.
	
	self assertPortfolioBalanceEquals: account balance afterDoing: [:portfolio | portfolio addAccountSummary: account.].! !

!PortfolioTest methodsFor: 'testing' stamp: 'FG 5/22/2022 16:28:50'!
test04PortfolioBalanceIsTheSumOfAllItsAccounts

	|account anotherAccount |
	
	account := self createAccountWithDeposit: 100.
	anotherAccount := self createAccountWithDeposit: 100.

	self assertPortfolioBalanceEquals: 100
	afterDoing:  [:portfolio | 
		portfolio addAccountSummary: account.
		Deposit register: 50 on: account.
		
		portfolio addAccountSummary: anotherAccount.
		Withdraw register: 150 on: anotherAccount.
	].! !

!PortfolioTest methodsFor: 'testing' stamp: 'FG 5/22/2022 17:19:29'!
test05PortfolioWithPositiveBalanceIncreasePortfolioBalanceAfterBeingAdded

	|account portfolioToAdd|
	
	account := self createAccountWithDeposit: 100.

	portfolioToAdd := self createPortfolioWithAccountSummary: account.
	
	self assertPortfolioBalanceEquals: portfolioToAdd balance
	afterDoing:  [:portfolio | 
		portfolio addAccountSummary: portfolioToAdd .
	].
	
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'FG 5/22/2022 16:43:20'!
test06PortfolioBalanceIsTheSumOfAllItsPortfolios

	|account anotherAccount portfolioToAdd anotherPortfolioToAdd|
	
	account := self createAccountWithDeposit: 100.
	anotherAccount  := self createAccountWithWithdraw: 20.

	portfolioToAdd := self createPortfolioWithAccountSummary: account.
	anotherPortfolioToAdd := self createPortfolioWithAccountSummary: anotherAccount.

	self assertPortfolioBalanceEquals: (portfolioToAdd balance + anotherPortfolioToAdd balance)
	afterDoing:  [:portfolio | 
		portfolio addAccountSummary: portfolioToAdd .
		portfolio addAccountSummary: anotherPortfolioToAdd .
	].
	
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'FG 5/22/2022 16:43:20'!
test07PortfolioBalanceIsTheSumOfAllItsPortfoliosAndAccounts

	|account anotherAccount portfolioAccount portfolioToAdd anotherPortfolioToAdd|
	
	account := self createAccountWithDeposit: 100.
	anotherAccount  := self createAccountWithWithdraw: 20.
	portfolioAccount := self createAccountWithDeposit: 50.
	
	portfolioToAdd := self createPortfolioWithAccountSummary: account.
	anotherPortfolioToAdd := self createPortfolioWithAccountSummary: anotherAccount.

	self assertPortfolioBalanceEquals: (portfolioToAdd balance + anotherPortfolioToAdd balance + portfolioAccount balance)
	afterDoing:  [:portfolio | 
		portfolio addAccountSummary: portfolioToAdd .
		portfolio addAccountSummary: anotherPortfolioToAdd .
		portfolio addAccountSummary: portfolioAccount .
	].
	
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'FG 5/19/2022 20:19:40'!
test08PortfolioHasRegisteredReturnFalseWhenCreated

	|portfolio account transaction|
	
	portfolio := Portfolio new.

	account := ReceptiveAccount new.
	transaction := Deposit register: 56 on: account .
	
	self deny: (portfolio hasRegistered: transaction).
	
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'FG 5/22/2022 17:18:05'!
test09PortfolioHasRegisteredReturnTrueWhenItsAccountIncludesTheTransaction

	|portfolio account transaction|

	account := ReceptiveAccount new.
	transaction := Deposit register: 56 on: account .
	
	portfolio := self createPortfolioWithAccountSummary: account.
	
	self assert: (portfolio hasRegistered: transaction).
	
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'FG 5/22/2022 17:18:19'!
test10PortfolioHasRegisteredReturnTrueWhenItsPortfolioIncludesTheTransaction

	|portfolio anotherPortfolio account transaction|
	
	account := ReceptiveAccount new.
	transaction := Deposit register: 56 on: account .
	
	anotherPortfolio  := self createPortfolioWithAccountSummary: account.
	portfolio  := self createPortfolioWithAccountSummary: anotherPortfolio.

	self assert: (portfolio hasRegistered: transaction).
	
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'FG 5/19/2022 20:35:53'!
test11PortfolioTransactionsDoesNotHaveElementsWhenCreated

	|portfolio account transaction|
	
	portfolio := Portfolio new.

	account := ReceptiveAccount new.
	transaction := Deposit register: 56 on: account .
	
	self deny: (portfolio transactions includes: transaction).
	
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'FG 5/22/2022 17:11:24'!
test12PortfolioTransactionsContainsItsAccountsTransactions

	|portfolio account |
	
	account := self createAccountWithDeposit: 50.
	portfolio := self createPortfolioWithAccountSummary: account.
	
	self assert: ((portfolio transactions) includesAllOf: (account transactions)).
	
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'FG 5/22/2022 17:12:19'!
test13PortfolioTransactionsContainsItsPortfolioTransactions

	|portfolio anotherPortfolio account|
	
	account := self createAccountWithDeposit: 50.
	anotherPortfolio := self createPortfolioWithAccountSummary: account.
	portfolio := self createPortfolioWithAccountSummary: anotherPortfolio.
	
	self assert: ((portfolio transactions) includesAllOf: (anotherPortfolio transactions)).
	
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'FG 5/22/2022 16:56:36'!
test14AddingAnAccountFailsIfTheAccountAlreadyExistsOnThePortfolio

	|portfolio account|

	self should: [portfolio addAccountSummary: account.] 
		raiseCannotAddAccountSummaryAfter: [
			account := self createAccountWithDeposit: 50.
			portfolio := self createPortfolioWithAccountSummary: account.
	]
	
		
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'FG 5/22/2022 17:23:22'!
test15AddingAnAccountFailsIfTheAccountAlreadyExistsOnAChildPortfolio

	|portfolio account childPortfolio|

	self should: [portfolio addAccountSummary: account.] 
		raiseCannotAddAccountSummaryAfter: [
			account := self createAccountWithDeposit: 50.
			childPortfolio := self createPortfolioWithAccountSummary: account.
			portfolio := self createPortfolioWithAccountSummary: childPortfolio.
	]
	
		
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'FG 5/22/2022 17:25:20'!
test16AddingAnAccountFailsIfTheAccountAlreadyExistsOnAnySuccessorPortfolio

	|portfolio account childPortfolio grandChildPortfolio|

	self should: [portfolio addAccountSummary: account.] 
		raiseCannotAddAccountSummaryAfter: [
			account := self createAccountWithDeposit: 50.
			grandChildPortfolio := self createPortfolioWithAccountSummary: account.
			childPortfolio := self createPortfolioWithAccountSummary: grandChildPortfolio.
			portfolio := self createPortfolioWithAccountSummary: childPortfolio.
	]
	
		
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'FG 5/22/2022 17:01:31'!
test17AddingAnAccountFailsIfTheAccountAlreadyExistsOnTheParentPortfolio

	|portfolio account childPortfolio|

	self should: [childPortfolio addAccountSummary: account.] 
		raiseCannotAddAccountSummaryAfter: [
			account := self createAccountWithDeposit: 50.
			childPortfolio := Portfolio new.
			portfolio := self createPortfolioWithAccountSummary: childPortfolio.
			portfolio addAccountSummary: account. 
	]
	
		
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'FG 5/22/2022 17:03:03'!
test18AddingAnAccountFailsIfTheAccountAlreadyExistsOnAnyOfTheParentsPortfolio

	|parentPortfolio account childPortfolio anotherParentPortfolio|

	self should: [childPortfolio addAccountSummary: account.] 
		raiseCannotAddAccountSummaryAfter: [
			account := self createAccountWithDeposit: 50.
			childPortfolio := Portfolio new.
			parentPortfolio := self createPortfolioWithAccountSummary: childPortfolio.
			parentPortfolio addAccountSummary: account. 
			anotherParentPortfolio := self createPortfolioWithAccountSummary: childPortfolio.
	]
	
		
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'FG 5/22/2022 17:05:19'!
test19AddingAnAccountFailsIfTheAccountAlreadyExistsOnTheTree
	
	|parentPortfolio account childPortfolio grandParentPortfolio|

	self should: [childPortfolio addAccountSummary: account.] 
		raiseCannotAddAccountSummaryAfter: [
			account := self createAccountWithDeposit: 50.
			childPortfolio := Portfolio new.
			parentPortfolio := self createPortfolioWithAccountSummary: childPortfolio.
			grandParentPortfolio := self createPortfolioWithAccountSummary: parentPortfolio.
 			grandParentPortfolio addAccountSummary: account. 
	]
	
		
	! !


!PortfolioTest methodsFor: 'accountSummary' stamp: 'FG 5/22/2022 16:19:36'!
createAccountWithDeposit: aValueToDeposit

	|account|
	
	account := ReceptiveAccount  new.
	Deposit register: aValueToDeposit on: account.
	
	^account! !

!PortfolioTest methodsFor: 'accountSummary' stamp: 'FG 5/22/2022 16:39:09'!
createAccountWithWithdraw: aValueToWithdraw

	|account|
	
	account := ReceptiveAccount  new.
	Withdraw register: aValueToWithdraw on: account.
	
	^account! !

!PortfolioTest methodsFor: 'accountSummary' stamp: 'FG 5/22/2022 16:43:28'!
createPortfolioWithAccountSummary: anAccountSummaryToBeAdded

	| portfolio |
	
	portfolio := Portfolio new.
	portfolio addAccountSummary: anAccountSummaryToBeAdded.
	
	^portfolio.
	! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'FG 5/22/2022 16:07:11'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	self assertAReceptiveAccount: [ :account | self assert: 0 equals: account balance.] afterDoing: [ :account | ^self ]
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'FG 5/22/2022 16:07:11'!
test02DepositIncreasesBalanceOnTransactionValue 

	self assertAReceptiveAccount: [ :account | self assert: 100 equals: account balance.] afterDoing: [ :account | Deposit register: 100 on: account. ]
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'FG 5/22/2022 16:07:11'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	self assertAReceptiveAccount: 
		[:account | self assert: 50 equals: account balance.] 
	afterDoing: 
		[:account | Deposit register: 100 on: account.
		Withdraw register: 50 on: account.] 
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'FG 5/22/2022 16:07:11'!
test04WithdrawValueMustBePositive 

	| withdrawValue |
	
	withdrawValue := 50.

	self assertAReceptiveAccount: [:account | self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value] 
	afterDoing: [:account | ^self].
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'FG 5/22/2022 16:07:11'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| deposit withdraw |
	
	self assertAReceptiveAccount: 
		[:account | self assert: (account hasRegistered: deposit).
			self assert: (account hasRegistered: withdraw).] 
	afterDoing: 
		[:account | deposit := Deposit register: 100 on: account.
			withdraw := Withdraw register: 50 on: account.]
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'FG 5/22/2022 16:07:11'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| deposit withdraw |
	
	self assertAReceptiveAccount: 
		[:account | self deny: (account hasRegistered: deposit).
			self deny: (account hasRegistered: withdraw).] 
	afterDoing: 
		[:account |		deposit :=  Deposit for: 200.
			withdraw := Withdraw for: 50.].
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'FG 5/22/2022 16:07:11'!
test07AccountKnowsItsTransactions 

	| deposit |
	
	self assertAReceptiveAccount: 
		[:account | self assert: 1 equals: account transactions size.
			self assert: (account transactions includes: deposit).] 
	afterDoing: 
		[:account |	 deposit := Deposit register: 50 on: account.].! !


!ReceptiveAccountTest methodsFor: 'assertions' stamp: 'FG 5/22/2022 16:07:11'!
assertAReceptiveAccount: anAssertClosure afterDoing: aClosureWithTransactionsToProcess

	| account |
	
	account := ReceptiveAccount new.
	
	aClosureWithTransactionsToProcess value: account.

	anAssertClosure value: account.
! !


!classDefinition: #AccountSummary category: 'Portfolio-Ejercicio'!
Object subclass: #AccountSummary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AccountSummary methodsFor: 'balance' stamp: 'FG 5/21/2022 09:19:16'!
balance

	self subclassResponsibility.! !


!AccountSummary methodsFor: 'testing' stamp: 'FG 5/21/2022 09:18:56'!
hasRegistered: aTransaction
	
	self subclassResponsibility.! !

!AccountSummary methodsFor: 'testing' stamp: 'FG 5/21/2022 10:38:35'!
includesAccount: aReceptiveAccount 
	
	self subclassResponsibility.! !


!AccountSummary methodsFor: 'initialization' stamp: 'FG 5/21/2022 09:17:46'!
initialize

	self subclassResponsibility.! !


!AccountSummary methodsFor: 'transactions' stamp: 'FG 5/21/2022 09:19:48'!
transactions

	self subclassResponsibility.! !


!AccountSummary methodsFor: 'adding - private' stamp: 'FG 5/22/2022 11:03:31'!
addParent: aParentPortfolio 
	
	self subclassResponsibility.! !


!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
AccountSummary subclass: #Portfolio
	instanceVariableNames: 'accountSummaries parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'initialization' stamp: 'FG 5/22/2022 10:35:54'!
initialize

	accountSummaries := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'transactions' stamp: 'FG 5/22/2022 11:20:26'!
transactions
	
	^ accountSummaries 
		inject: OrderedCollection new
		into: [ :transactions :anAccountSummary | transactions addAll: anAccountSummary transactions; yourself ].
! !


!Portfolio methodsFor: 'testing' stamp: 'FG 5/22/2022 10:59:09'!
hasRegistered: aTransaction 
	
	 ^ accountSummaries anySatisfy: [:anAccountSummary | anAccountSummary hasRegistered: aTransaction ]! !

!Portfolio methodsFor: 'testing' stamp: 'FG 5/21/2022 10:40:38'!
includesAccount: aReceptiveAccount 
	
	^accountSummaries anySatisfy: [ :anAccountSummary | anAccountSummary includesAccount: aReceptiveAccount].! !

!Portfolio methodsFor: 'testing' stamp: 'FG 5/21/2022 10:54:13'!
includesPortfolio: aPortfolio 
	
	^accountSummaries anySatisfy: [ :anAccountSummary | anAccountSummary includesPortfolio: aPortfolio].! !


!Portfolio methodsFor: 'adding' stamp: 'FG 5/22/2022 11:03:31'!
addAccountSummary: anAccountSummaryToAdd
		
	anAccountSummaryToAdd assertCanBeAddedTo: self.
	
	anAccountSummaryToAdd addParent: self.
	
	accountSummaries add: anAccountSummaryToAdd.! !


!Portfolio methodsFor: 'balance' stamp: 'FG 5/21/2022 09:44:55'!
balance
	
	^accountSummaries sum: [:anAccountSummary | anAccountSummary balance] ifEmpty: [0].! !


!Portfolio methodsFor: 'add asserting - private' stamp: 'FG 5/22/2022 15:37:08'!
assertAccountSummariesSatisfy: aClosureToBeSatified onRecursionDo: aRecursionStep

	parents isEmpty ifTrue: [
		(accountSummaries anySatisfy: aClosureToBeSatified) ifTrue: [^CannotAddAccountSummary signal].
	] ifFalse: [
		parents do: aRecursionStep.
	]! !

!Portfolio methodsFor: 'add asserting - private' stamp: 'FG 5/22/2022 15:38:02'!
assertCanAddPortfolio: aPortfolioToBeAddedTo

	self assertAccountSummariesSatisfy:  [ :anAccountSummary |				anAccountSummary includesPortfolio: aPortfolioToBeAddedTo] 
		onRecursionDo: [:aParent | aParent assertCanAddPortfolio: aPortfolioToBeAddedTo. ].
! !

!Portfolio methodsFor: 'add asserting - private' stamp: 'FG 5/22/2022 15:38:45'!
assertCanAddReceptiveAccount: aReceptiveAccountToBeAddedTo

	self assertAccountSummariesSatisfy:  [ :anAccountSummary |				anAccountSummary includesAccount: aReceptiveAccountToBeAddedTo] 
		onRecursionDo: [:aParent | aParent assertCanAddReceptiveAccount: aReceptiveAccountToBeAddedTo. ].! !

!Portfolio methodsFor: 'add asserting - private' stamp: 'FG 5/21/2022 11:01:28'!
assertCanBeAddedTo: aPortfolioToBeAddedTo
	
	^aPortfolioToBeAddedTo assertCanAddPortfolio: self.! !


!Portfolio methodsFor: 'adding - private' stamp: 'FG 5/22/2022 11:03:31'!
addParent: aParentPortfolio 
	
	parents add: aParentPortfolio.! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Ejercicio'!
AccountSummary subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NR 10/17/2019 15:06:56'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'FG 5/22/2022 11:40:33'!
balance

	|acc|
	acc := 0.
	transactions do: [:aTransaction | acc := aTransaction addToBalance: acc. ].
	^acc.! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'FG 5/21/2022 10:38:20'!
includesAccount: aReceptiveAccount 
	
	^self = aReceptiveAccount.
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'FG 5/21/2022 10:54:56'!
includesPortfolio: aPortfolio
	
	^aPortfolio includesAccount: self.
! !


!ReceptiveAccount methodsFor: 'add asserting - private' stamp: 'FG 5/21/2022 11:03:16'!
assertCanBeAddedTo: aPortfolioToBeAddedTo
	
	^aPortfolioToBeAddedTo assertCanAddReceptiveAccount: self.! !


!ReceptiveAccount methodsFor: 'adding - private' stamp: 'FG 5/22/2022 11:03:31'!
addParent: aParentPortfolio 
	
	^self.! !


!classDefinition: #AccountTransaction category: 'Portfolio-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'balance' stamp: 'FG 5/16/2022 20:21:47'!
addToBalance: aBalanceToBeAddedTo

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/17/2019 03:22:00'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'balance' stamp: 'FG 5/22/2022 11:37:17'!
addToBalance: aBalanceToBeAddedTo

	^aBalanceToBeAddedTo + value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Withdraw category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'balance' stamp: 'FG 5/16/2022 20:21:57'!
addToBalance: aBalanceToBeAddedTo

	^aBalanceToBeAddedTo - value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !
