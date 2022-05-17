!classDefinition: #PortfolioTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FG 5/16/2022 20:43:20'!
test01PortfolioHaveZeroAsBalanceWhenCreated

	|portfolio|
	
	portfolio := Portfolio new.
	
	self assert: portfolio balance = 0.! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FG 5/16/2022 21:51:12'!
test02AccountWithTransaccionsIncreasePortfolioBalance

	|portfolio account|
	
	account := ReceptiveAccount  new.
	portfolio := Portfolio new.
	
	Deposit register: 100 on: account.
	portfolio addAccount: account.

	self assert: portfolio balance equals: account balance.! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FG 5/16/2022 20:58:05'!
test03AccountIncreasePortfolioBalanceAfterAdding

	|portfolio account|
	
	account := ReceptiveAccount  new.
	portfolio := Portfolio new.
	
	Deposit register: 100 on: account.
	portfolio addAccount: account.
	Deposit register: 50 on: account.

	self assert: portfolio balance = 150.! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FG 5/16/2022 21:00:39'!
test04PortfolioBalanceIsTheSumOfAllItsAccounts

	|portfolio account|
	
	account := ReceptiveAccount  new.
	portfolio := Portfolio new.
	
	Deposit register: 100 on: account.
	portfolio addAccount: account.
	Deposit register: 50 on: account.

	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
	portfolio addAccount: account.
	Withdraw register: 150 on: account.
	
	self assert: portfolio balance = 100.! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FG 5/16/2022 21:25:48'!
test05PortfolioWithPositiveBalanceIncreasePortfolioBalanceAfterAdding

	|account portfolio portfolioToAdd|
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account .
	
	portfolioToAdd := Portfolio new.
	portfolioToAdd addAccount: account.
	
	portfolio := Portfolio new.
	portfolio addPortfolio: portfolioToAdd .
	
	self assert: portfolio balance = 100.
	
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FG 5/16/2022 21:34:04'!
test06PortfolioBalanceIsTheSumOfAllItsPortfolios

	|account anotherAccount portfolio portfolioToAdd anotherPortfolioToAdd|
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account .
	
	anotherAccount := ReceptiveAccount new.
	Withdraw register: 20 on: anotherAccount .
	
	portfolioToAdd := Portfolio new.
	portfolioToAdd addAccount: account.
	
	anotherPortfolioToAdd := Portfolio new.
	anotherPortfolioToAdd addAccount: anotherAccount.
	
	portfolio := Portfolio new.
	portfolio addPortfolio: portfolioToAdd .
	portfolio addPortfolio: anotherPortfolioToAdd .

	self assert: portfolio balance = 80.
	
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'FG 5/16/2022 21:38:55'!
test07PortfolioBalanceIsTheSumOfAllItsPortfoliosAndAccounts

	|account anotherAccount portfolioAccount portfolio portfolioToAdd anotherPortfolioToAdd|
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account .
	
	anotherAccount := ReceptiveAccount new.
	Withdraw register: 20 on: anotherAccount .
	
	portfolioToAdd := Portfolio new.
	portfolioToAdd addAccount: account.
	
	anotherPortfolioToAdd := Portfolio new.
	anotherPortfolioToAdd addAccount: anotherAccount.
	
	portfolio := Portfolio new.
	portfolio addPortfolio: portfolioToAdd .
	portfolio addPortfolio: anotherPortfolioToAdd .

	portfolioAccount := ReceptiveAccount new.
	Deposit register: 56 on: portfolioAccount .
	portfolio addAccount: portfolioAccount .
	
	self assert: portfolio balance = 136.
	
	! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:44'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:48'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:52'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 5/16/2022 16:18:39'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 5/16/2022 16:19:11'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| deposit withdraw account |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 200.
	withdraw := Withdraw for: 50.
	
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:14:01'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 50 on: account1.
		
	self assert: 1 equals: account1 transactions size.
	self assert: (account1 transactions includes: deposit1).
! !


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


!Deposit methodsFor: 'balance' stamp: 'FG 5/16/2022 20:21:52'!
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



!Withdraw methodsFor: 'value' stamp: 'FG 5/16/2022 20:21:57'!
addToBalance: aBalanceToBeAddedTo

	^aBalanceToBeAddedTo - value.! !

!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
Object subclass: #Portfolio
	instanceVariableNames: 'accounts portfolios'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'accessing' stamp: 'FG 5/16/2022 21:20:32'!
addAccount: aReceptiveAccount 
	
	accounts add: aReceptiveAccount.! !

!Portfolio methodsFor: 'accessing' stamp: 'FG 5/16/2022 21:36:27'!
addPortfolio: aPortfolioToBeAdded 
	
	portfolios add: aPortfolioToBeAdded.! !

!Portfolio methodsFor: 'accessing' stamp: 'FG 5/16/2022 21:43:12'!
balance
	|partialBalance| 
	
	partialBalance := portfolios sum: [:aPortfolio | aPortfolio balance] ifEmpty: [0].
	partialBalance		:= partialBalance + (accounts sum: [:anAccount | anAccount balance] ifEmpty: [0]).
	^partialBalance! !

!Portfolio methodsFor: 'accessing' stamp: 'FG 5/16/2022 21:36:14'!
initialize

	accounts := OrderedCollection new.
	portfolios := OrderedCollection new.! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Ejercicio'!
Object subclass: #ReceptiveAccount
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


!ReceptiveAccount methodsFor: 'balance' stamp: 'FG 5/16/2022 20:19:25'!
balance

	"^transactions sum: [ :aTransaction | (aTransaction isKindOf: Deposit) ifTrue: [aTransaction value] ifFalse: [-1 * aTransaction value] ] ifEmpty: [ 0 ]."
	
	|acc|
	acc := 0.
	transactions do: [:aTransaction | acc := aTransaction addToBalance: acc. ].
	^acc.! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !
