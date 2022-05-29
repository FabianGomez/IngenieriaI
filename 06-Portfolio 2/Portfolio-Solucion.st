!classDefinition: #PortfolioTest category: 'Portfolio-Solucion'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:16:26'!
test01BalanceOfPortfolioWithoutAccountsIsZero

	self assert: 0 equals: Portfolio new balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 5/27/2021 17:36:04'!
test02BalanceOfPortfolioWithAccountsIsSumOfAccountsBalance

	| account portfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: account balance equals: portfolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:23:25'!
test03BalanceOfPortfolioIsCalculatedRecursivelyOnPortfolios

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortofolio |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount.
	composedPortofolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolioAccount balance + simplePortfolio balance) equals: composedPortofolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:15'!
test04PortfolioWithoutAccountsHasNoRegisteredTransaction

	self deny: (Portfolio new hasRegistered: (Deposit for: 100))! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:11'!
test05PortfolioHasRegisteredItsAccountsTransactions

	| account portfolio deposit |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: (portfolio hasRegistered: deposit)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:06'!
test06PortfolioLooksForRegisteredTransactionsRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolio hasRegistered: simplePortfolioAccountDeposit).
	self assert: (composedPortfolio hasRegistered: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:10'!
test07PortfolioHasNoTransactionWhenHasNoAccounts

	self assert: Portfolio new transactions isEmpty! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 6/22/2020 07:31:19'!
test08PortfolioTransactionsIncludesAllItsAccountsTransactions

	| account portfolio accountDeposit anotherAccount portfolioTransactions anotherAccountWithdraw |
	
	account := ReceptiveAccount new.
	accountDeposit := Deposit register: 100 on: account.
	anotherAccount := ReceptiveAccount new.
	anotherAccountWithdraw := Withdraw register: 100 on: account.
	portfolio := Portfolio with: account.
	
	portfolioTransactions := portfolio transactions.
	
	self assert: 2 equals: portfolioTransactions size.
	self assert: (portfolioTransactions includes: accountDeposit).
	self assert: (portfolioTransactions includes: anotherAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:20'!
test09PortfolioTransactionsAreCalculatedRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit composedPortfolioTransactions |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	composedPortfolioTransactions := composedPortfolio transactions.
	self assert: 2 equals: composedPortfolioTransactions size.
	self assert: (composedPortfolioTransactions includes: simplePortfolioAccountDeposit).
	self assert: (composedPortfolioTransactions includes: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:24'!
test10PortfolioCanNotIncludeTheSameAccountMoreThanOnce

	| account portfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	
	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: portfolio accountsSize.
			self assert: (portfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:28'!
test11PortfolioCanNotIncludeAccountOfItsPortfolios

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	composedPortfolio := Portfolio with: simplePortfolio.
	
	self 
		should: [ composedPortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: composedPortfolio accountsSize.
			self assert: (composedPortfolio accountsIncludes: simplePortfolio) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:32'!
test12PortfolioCanNotIncludeItself

	| account simplePortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	
	self 
		should: [ simplePortfolio add: simplePortfolio ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: simplePortfolio accountsSize.
			self assert: (simplePortfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:01:51'!
test13ComposedPortfolioCanNotHaveParentPortfolioAccount

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio new.
	composedPortfolio := Portfolio with: simplePortfolio.
	composedPortfolio add: account.
	
	self 
		should: [ simplePortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: simplePortfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:12:16'!
test14ComposedPortfolioCanNotHaveAccountOfAnyRootParentRecursively

	| account leftParentPortfolio leftRootParentPortfolio portfolio rightParentPortfolio rightRootParentPortfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	leftParentPortfolio := Portfolio with: portfolio .
	leftRootParentPortfolio := Portfolio with: leftParentPortfolio.
	leftRootParentPortfolio add: account.
	
	rightParentPortfolio := Portfolio with: portfolio .
	rightRootParentPortfolio := Portfolio with: rightParentPortfolio.
	rightRootParentPortfolio add: account.

	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/29/2019 16:31:18'!
test15PortfolioCanNotIncludeAnyOfTheComposedAccountOfPortfolioToAdd

	| portfolioToAdd portfolioToModify rootPortfolio sharedAccount |
	
	sharedAccount := ReceptiveAccount new.
	portfolioToModify := Portfolio new.
	rootPortfolio := Portfolio with: sharedAccount with: portfolioToModify.
	portfolioToAdd := Portfolio with: sharedAccount.
	
	self 
		should: [ portfolioToModify add: portfolioToAdd ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolioToModify accountsIsEmpty ]! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Solucion'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:48'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:54'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:02'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:46'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:54'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:21:24'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 100 on: account1.
		
	self assert: 1 equals: account1 transactions size .
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #ReportTest category: 'Portfolio-Solucion'!
TestCase subclass: #ReportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReportTest methodsFor: 'setUp' stamp: 'FG 5/29/2022 10:02:50'!
accountSummaryLinesFor: anAccount

	|accountSummary |
	
	accountSummary := AccountSummaryReport for: anAccount.
	^accountSummary makeReport.! !

!ReportTest methodsFor: 'setUp' stamp: 'FG 5/29/2022 09:37:42'!
calculateTransferNetFor: anAccountToReport

	| transferNet |
	
	transferNet := TransferNetReport for: anAccountToReport.
	^transferNet makeReport.! !


!ReportTest methodsFor: 'testing transfer net' stamp: 'FG 5/29/2022 09:40:31'!
testTransferNet01ReceptiveAccountWithoutTransactionsReturnsZero

	|account transferNetValue |
	
	account := ReceptiveAccount new.
	transferNetValue := self calculateTransferNetFor: account.
	
	self assert: transferNetValue equals: 0.! !

!ReportTest methodsFor: 'testing transfer net' stamp: 'FG 5/29/2022 09:40:54'!
testTransferNet02ReceptiveAccountWithDepositTransferReturnsAmountOfTransfer

	|accountToDeposit accountToWithdraw transferNetValue |
	
	accountToDeposit := ReceptiveAccount new.
	accountToWithdraw := ReceptiveAccount new.
	
	Transfer register: 10 from: accountToWithdraw to: accountToDeposit.
	
	transferNetValue := self calculateTransferNetFor: accountToDeposit.	
	
	self assert: transferNetValue equals: 10.! !

!ReportTest methodsFor: 'testing transfer net' stamp: 'FG 5/29/2022 09:41:07'!
testTransferNet03ReceptiveAccountWithSeveralDepositTransfersReturnsAmountOfTransfers

	|accountToDeposit accountToWithdraw transferNetValue |
	
	accountToDeposit := ReceptiveAccount new.
	accountToWithdraw := ReceptiveAccount new.
	
	Transfer register: 10 from: accountToWithdraw to: accountToDeposit.
	Transfer register: 50 from: accountToWithdraw to: accountToDeposit.

	transferNetValue := self calculateTransferNetFor: accountToDeposit .
	
	self assert: transferNetValue equals: 60.! !

!ReportTest methodsFor: 'testing transfer net' stamp: 'FG 5/29/2022 09:41:27'!
testTransferNet04ReceptiveAccountWithSeveralWithdrawTransfersReturnsAmountOfTransfers

	|accountToDeposit accountToWithdraw transferNetValue |
	
	accountToDeposit := ReceptiveAccount new.
	accountToWithdraw := ReceptiveAccount new.
	
	Transfer register: 10 from: accountToWithdraw to: accountToDeposit.
	Transfer register: 50 from: accountToWithdraw to: accountToDeposit.

	transferNetValue := self calculateTransferNetFor: accountToWithdraw .	
	
	self assert: transferNetValue equals: -60.! !

!ReportTest methodsFor: 'testing transfer net' stamp: 'FG 5/29/2022 09:41:44'!
testTransferNet05ReceptiveAccountWithDepositsDoesNotAffectValue

	|accountToDeposit accountToWithdraw transferNetValue |
	
	accountToDeposit := ReceptiveAccount new.
	accountToWithdraw := ReceptiveAccount new.
	
	Transfer register: 10 from: accountToWithdraw to: accountToDeposit.
	Transfer register: 50 from: accountToWithdraw to: accountToDeposit.
	Deposit register: 10 on: accountToDeposit.

	transferNetValue := self calculateTransferNetFor: accountToDeposit .
	
	self assert: transferNetValue equals: 60.! !

!ReportTest methodsFor: 'testing transfer net' stamp: 'FG 5/29/2022 09:41:59'!
testTransferNet06ReceptiveAccountWithWithdrawsDoesNotAffectValue

	|accountToDeposit accountToWithdraw transferNetValue |
	
	accountToDeposit := ReceptiveAccount new.
	accountToWithdraw := ReceptiveAccount new.
	
	Transfer register: 10 from: accountToWithdraw to: accountToDeposit.
	Transfer register: 50 from: accountToWithdraw to: accountToDeposit.
	Withdraw register: 10 on: accountToWithdraw.

	transferNetValue := self calculateTransferNetFor: accountToWithdraw.
	
	self assert: transferNetValue equals: -60.! !

!ReportTest methodsFor: 'testing transfer net' stamp: 'FG 5/29/2022 09:42:15'!
testTransferNet07PortfolioWithoutTransactionsReturnsZero

	|portfolio transferNetValue |
	
	portfolio := Portfolio new.
	
	transferNetValue := self calculateTransferNetFor: portfolio.
	
	self assert: transferNetValue equals: 0.! !

!ReportTest methodsFor: 'testing transfer net' stamp: 'FG 5/29/2022 09:45:06'!
testTransferNet08PortfolioWithAccountReturnsItsAccountValue

	|portfolio accountToDeposit accountToWithdraw transferNetValue transferNetAccountValue|
	
	accountToDeposit := ReceptiveAccount new.
	accountToWithdraw := ReceptiveAccount new.
	portfolio := Portfolio with: accountToDeposit.
	
	Transfer register: 10 from: accountToWithdraw to: accountToDeposit.
		
	transferNetValue := self calculateTransferNetFor: portfolio.
	
	transferNetAccountValue := self calculateTransferNetFor: accountToDeposit .
	
	self assert: transferNetValue equals: transferNetAccountValue.! !

!ReportTest methodsFor: 'testing transfer net' stamp: 'FG 5/29/2022 09:44:01'!
testTransferNet09PortfolioWithPortfolioReturnsItsPortfolioValue

	|portfolio childPortfolio accountToDeposit accountToWithdraw transferNetValue transferNetChildValue |
	
	accountToDeposit := ReceptiveAccount new.
	accountToWithdraw := ReceptiveAccount new.
	childPortfolio := Portfolio with: accountToDeposit.
	portfolio := Portfolio with: childPortfolio.
	
	Transfer register: 10 from: accountToWithdraw to: accountToDeposit.
		
	transferNetValue := self calculateTransferNetFor: portfolio .
	
	transferNetChildValue := self calculateTransferNetFor: childPortfolio.
	
	self assert: transferNetValue equals: transferNetChildValue.! !


!ReportTest methodsFor: 'assertions' stamp: 'FG 5/29/2022 10:11:04'!
assertLinesOfAccountSumaryFor: anAccount AreEqualTo: linesToBeEqual 

	| lines |
		
	lines := self accountSummaryLinesFor: anAccount.
	
	self assert: lines size equals: linesToBeEqual size.
	
	1 to: lines size do: [ :anIndex | self assert: (lines at: anIndex) equals: (linesToBeEqual at: anIndex). ].
! !


!ReportTest methodsFor: 'testing account summary' stamp: 'FG 5/29/2022 10:12:13'!
testAccountSummary01ReceptiveAccountWithoutTransactionsReturnsOnlyBalance

	|account lines |
	
	account := ReceptiveAccount new.
	lines := OrderedCollection with: 'Balance = 0'.
	self assertLinesOfAccountSumaryFor: account AreEqualTo: lines.! !

!ReportTest methodsFor: 'testing account summary' stamp: 'FG 5/29/2022 10:13:25'!
testAccountSummary02ReceptiveAccountWithDepositReturnsDepositLineAndBalance

	|account lines |
	
	account := ReceptiveAccount new.
	Deposit register: 10 on: account.
	
	lines := OrderedCollection with: 'Depósito por 10.' with:  'Balance = 10'.
	self assertLinesOfAccountSumaryFor: account AreEqualTo: lines.

! !

!ReportTest methodsFor: 'testing account summary' stamp: 'FG 5/29/2022 10:14:29'!
testAccountSummary03ReceptiveAccountWithSeveralDepositsReturnsAllDepositLinesAndBalance

	|account lines |
	
	account := ReceptiveAccount new.
	Deposit register: 10 on: account.
	Deposit register: 50 on: account.
	Deposit register: 100 on: account.

	lines := OrderedCollection with: 'Depósito por 10.' with: 'Depósito por 50.' with: 'Depósito por 100.' with:  'Balance = 160'.
	self assertLinesOfAccountSumaryFor: account AreEqualTo: lines.

! !

!ReportTest methodsFor: 'testing account summary' stamp: 'FG 5/29/2022 10:15:01'!
testAccountSummary04ReceptiveAccountWithSeveralWithdrawsReturnsAllWithdrawLinesAndBalance

	|account lines |
	
	account := ReceptiveAccount new.
	Withdraw register: 10 on: account.
	Withdraw register: 100 on: account.

	lines := OrderedCollection with: 'Extracción por 10.' with: 'Extracción por 100.' with:  'Balance = -110'.
	self assertLinesOfAccountSumaryFor: account AreEqualTo: lines.

! !

!ReportTest methodsFor: 'testing account summary' stamp: 'FG 5/29/2022 10:15:38'!
testAccountSummary05ReceptiveAccountWithSeveralDepositTransfersReturnsAllDepositTransferLinesAndBalance

	|account accountFromTransfer lines |
	
	account := ReceptiveAccount new.
	accountFromTransfer := ReceptiveAccount new.
	
	Transfer register: 10 from: accountFromTransfer to: account.
	Transfer register: 40 from: accountFromTransfer to: account.

	lines := OrderedCollection with: 'Entrada por transferencia de 10.' with: 'Entrada por transferencia de 40.' with:  'Balance = 50'.
	self assertLinesOfAccountSumaryFor: account AreEqualTo: lines.

! !

!ReportTest methodsFor: 'testing account summary' stamp: 'FG 5/29/2022 10:16:01'!
testAccountSummary06ReceptiveAccountWithSeveralWithdrawTransfersReturnsAllWithdrawTransferLinesAndBalance

	|account accountToTransfer lines |
	
	account := ReceptiveAccount new.
	accountToTransfer := ReceptiveAccount new.
	
	Transfer register: 10 from: account to: accountToTransfer.
	Transfer register: 40 from: account to: accountToTransfer.

	lines := OrderedCollection with: 'Salida por transferencia de 10.' with: 'Salida por transferencia de 40.' with:  'Balance = -50'.
	self assertLinesOfAccountSumaryFor: account AreEqualTo: lines.

! !

!ReportTest methodsFor: 'testing account summary' stamp: 'FG 5/29/2022 10:16:43'!
testAccountSummary07PortfolioWithoutTransactionsReturnsOnlyBalance

	|portfolio lines |
	
	portfolio := Portfolio new.
	
	lines := OrderedCollection with: 'Balance = 0'.
	self assertLinesOfAccountSumaryFor: portfolio AreEqualTo: lines.! !

!ReportTest methodsFor: 'testing account summary' stamp: 'FG 5/29/2022 10:19:12'!
testAccountSummary08PortfolioWithReceptiveAccountReturnsAccountSummaryOfItsAccount

	|portfolio account linesForAccount linesForPortfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 50 on: account.
	Withdraw register: 10 on: account.
	Deposit register: 40 on: account.
	
	portfolio := Portfolio with: account.
	
	linesForAccount := self accountSummaryLinesFor: account.
	
	linesForPortfolio := self accountSummaryLinesFor: portfolio.

	self assert: linesForAccount equals: linesForPortfolio.! !

!ReportTest methodsFor: 'testing account summary' stamp: 'FG 5/29/2022 10:20:44'!
testAccountSummary09PortfolioWithSeveralReceptiveAccountReturnsAccountSummaryOfItsAccounts

	|portfolio account anotherAccount lines|
	
	account := ReceptiveAccount new.
	Deposit register: 50 on: account.
	Withdraw register: 10 on: account.
	anotherAccount := ReceptiveAccount new.
	Deposit register: 40 on: anotherAccount.
	
	portfolio := Portfolio with: account with: anotherAccount.
	
	lines := OrderedCollection with: 'Depósito por 50.' with: 'Extracción por 10.' with: 'Depósito por 40.' with:  'Balance = 80'.
	self assertLinesOfAccountSumaryFor: portfolio AreEqualTo: lines.
		
		! !

!ReportTest methodsFor: 'testing account summary' stamp: 'FG 5/29/2022 10:22:29'!
testAccountSummary10PortfolioWithSeveralPortfoliosReturnsAccountSummaryOfItsPortfolios

	|portfolio childPortfolio account anotherAccount lines|
	
	account := ReceptiveAccount new.
	Deposit register: 50 on: account.
	Withdraw register: 10 on: account.
	anotherAccount := ReceptiveAccount new.
	Deposit register: 40 on: anotherAccount.
	
	childPortfolio := Portfolio with: anotherAccount.
	portfolio := Portfolio with: account with: childPortfolio.
	
	lines := OrderedCollection with: 'Depósito por 50.' with: 'Extracción por 10.' with: 'Depósito por 40.' with:  'Balance = 80'.
	self assertLinesOfAccountSumaryFor: portfolio AreEqualTo: lines.
		
		! !


!classDefinition: #TransferTest category: 'Portfolio-Solucion'!
TestCase subclass: #TransferTest
	instanceVariableNames: 'amountToTransfer accountToDeposit accountToWithdraw'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferTest methodsFor: 'testing' stamp: 'FG 5/29/2022 10:30:55'!
setUp

	amountToTransfer := 10.
	accountToDeposit := ReceptiveAccount new.
	accountToWithdraw := ReceptiveAccount new. ! !

!TransferTest methodsFor: 'testing' stamp: 'FG 5/29/2022 10:30:55'!
test01TransferAffectsBalanceCorrectly

	Transfer register: amountToTransfer from: accountToWithdraw to: accountToDeposit .
	
	self assert: accountToDeposit balance equals: amountToTransfer.
	self assert: accountToWithdraw balance equals:  (- 1 * amountToTransfer). ! !

!TransferTest methodsFor: 'testing' stamp: 'FG 5/29/2022 10:30:55'!
test02TransferAccountTransactionsAreRegistered

	| transfer |
	transfer := Transfer register: amountToTransfer from: accountToWithdraw to: accountToDeposit.
	
	self assert: (accountToWithdraw hasRegistered: transfer withdrawTransfer).
	self assert: (accountToDeposit hasRegistered: transfer depositTransfer).
! !

!TransferTest methodsFor: 'testing' stamp: 'FG 5/29/2022 10:30:55'!
test03TransferAccountTransactionsKnowTheTransfer

	| transferRegistered  |

	transferRegistered := Transfer register: amountToTransfer from: accountToWithdraw to: accountToDeposit.
	
	
	self assert: transferRegistered withdrawTransfer transfer equals: transferRegistered.
	self assert: transferRegistered depositTransfer transfer equals: transferRegistered.
! !

!TransferTest methodsFor: 'testing' stamp: 'FG 5/29/2022 10:30:55'!
test04TransferAccountTransactionsKnowValue

	| transferRegistered |
	
	transferRegistered := Transfer register: amountToTransfer from: accountToWithdraw to: accountToDeposit .
	
	
	self assert: transferRegistered withdrawTransfer value equals: amountToTransfer.
	self assert: transferRegistered depositTransfer value equals: amountToTransfer.
! !

!TransferTest methodsFor: 'testing' stamp: 'FG 5/29/2022 10:30:55'!
test05TransferKnowsValue

	| transferRegistered |
	
	transferRegistered := Transfer register: amountToTransfer from: accountToWithdraw to: accountToDeposit.
	
	self assert: transferRegistered value equals: amountToTransfer.
! !

!TransferTest methodsFor: 'testing' stamp: 'FG 5/29/2022 09:22:07'!
test06TransferAmountShouldBePositive
	

  	self should: [ Transfer register: 0 from: accountToWithdraw to: accountToDeposit. ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | self assert: Transfer transferAmountShouldBePositiveErrorMessage equals: anError messageText. ]! !

!TransferTest methodsFor: 'testing' stamp: 'FG 5/29/2022 10:30:55'!
test07TransferAccountsShouldBeDifferent
	
  	self should: [ Transfer register: amountToTransfer from: accountToDeposit to: accountToDeposit . ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | self assert: Transfer transferAccountsShouldBeDifferentErrorMessage equals: anError messageText. ]! !


!classDefinition: #Account category: 'Portfolio-Solucion'!
Object subclass: #Account
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:23:47'!
hasRegistered: aTransaction

	self subclassResponsibility ! !

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:24:25'!
isComposedBy: anAccount

	self subclassResponsibility ! !


!Account methodsFor: 'balance' stamp: 'HAW 5/25/2019 12:23:40'!
balance

	self subclassResponsibility ! !


!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:27'!
addTransactionsTo: aCollectionOfTransactions

	self subclassResponsibility ! !

!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:15'!
transactions

	self subclassResponsibility ! !


!Account methodsFor: 'reporting' stamp: 'FG 5/28/2022 17:32:36'!
makeReport: aReport

	self subclassResponsibility.! !


!Account methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:24:04'!
addedTo: aPortfolio

	self subclassResponsibility ! !


!classDefinition: #Portfolio category: 'Portfolio-Solucion'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:20'!
accountsIncludes: anAccount

	^accounts includes: anAccount ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:05:04'!
accountsIsEmpty
	
	^accounts isEmpty ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:06'!
accountsSize
	
	^accounts size! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:19:20'!
add: accountToAdd

	self assertCanAdd: accountToAdd.
		
	accounts add: accountToAdd.
	accountToAdd addedTo: self 
	! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:17:31'!
rootParents
	
	| rootParents |
	
	rootParents := Set new.
	self addRootParentsTo: rootParents.
	
	^ rootParents! !


!Portfolio methodsFor: 'initialization' stamp: 'HAW 5/25/2019 12:03:18'!
initialize

	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:19:36'!
balance
	
	^accounts sum: [ :anAccount | anAccount balance ] ifEmpty: [ 0 ]! !


!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:42:55'!
addTransactionsTo: aCollectionOfTransactions

	accounts do: [ :anAccount | anAccount addTransactionsTo: aCollectionOfTransactions ]! !

!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:32'!
transactions
	
	| transactions |
	
	transactions := OrderedCollection new.
	accounts do: [ :anAccount | anAccount addTransactionsTo: transactions ].
	
	^transactions ! !


!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:02:59'!
addedTo: aPortfolio 
	
	parents add: aPortfolio ! !


!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:20:56'!
anyRootParentIsComposedBy: accountToAdd

	^self rootParents anySatisfy: [ :aParent | aParent isComposedBy: accountToAdd]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:28:29'!
hasRegistered: aTransaction

	^accounts anySatisfy: [ :anAccount | anAccount hasRegistered: aTransaction ]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/29/2019 16:24:54'!
isComposedBy: anAccount

	^ self = anAccount or: [ accounts anySatisfy: [ :composedAccount | (composedAccount isComposedBy: anAccount) or: [ anAccount isComposedBy: composedAccount ]]]! !


!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:17:31'!
addRootParentsTo: rootParents

	parents 
		ifEmpty: [ rootParents add: self ] 
		ifNotEmpty: [ parents do: [ :aParent | aParent addRootParentsTo: rootParents ]]! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:20:36'!
assertCanAdd: accountToAdd

	(self anyRootParentIsComposedBy: accountToAdd) ifTrue: [ self signalCanNotAddAccount ].
! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 11:48:34'!
signalCanNotAddAccount
	
	self error: self class canNotAddAccountErrorMessage! !


!Portfolio methodsFor: 'reporting' stamp: 'FG 5/29/2022 10:36:43'!
makeReport: aReport
	
	accounts do: [ :anAccount |		anAccount makeReport: aReport.	].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Solucion'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:48:55'!
canNotAddAccountErrorMessage
	
	^'Can not add repeated account to a portfolio'! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:18:21'!
with: anAccount

	^self new 
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:23:59'!
with: anAccount with: anotherAccount

	^self new 
		add: anAccount;
		add: anotherAccount;
		yourself! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Solucion'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'FG 5/27/2022 15:27:29'!
initialize

	super initialize.
	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:52'!
addTransactionsTo: aCollectionOfTransactions

	aCollectionOfTransactions addAll: transactions ! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'FG 5/27/2022 15:27:12'!
balance

	^transactions 
		inject: 0
		into: [ :currentBalance :transaction | transaction affectBalance: currentBalance ].! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'FG 5/27/2022 15:30:04'!
hasRegistered: aTransaction

	^transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:54:51'!
isComposedBy: anAccount

	^self = anAccount ! !


!ReceptiveAccount methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:03:32'!
addedTo: aPortfolio 
	
	! !


!ReceptiveAccount methodsFor: 'reporting' stamp: 'FG 5/28/2022 17:33:25'!
makeReport: aReport
	
	transactions do: [ :transaction | transaction makeReport: aReport ].
		! !


!classDefinition: #AccountTransaction category: 'Portfolio-Solucion'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:39'!
affectBalance: aBalance

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'reporting' stamp: 'FG 5/28/2022 17:34:41'!
makeReport: aReport
	
	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Solucion'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/21/2019 18:54:27'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:02'!
affectBalance: aBalance

	^aBalance + value ! !


!Deposit methodsFor: 'reporting' stamp: 'FG 5/28/2022 17:34:57'!
makeReport: aReport 
	
	aReport reportForDeposit: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Solucion'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #TransferMovement category: 'Portfolio-Solucion'!
AccountTransaction subclass: #TransferMovement
	instanceVariableNames: 'transfer account'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferMovement methodsFor: 'value' stamp: 'FG 5/27/2022 15:25:42'!
value

	self subclassResponsibility.! !


!TransferMovement methodsFor: 'accessing' stamp: 'FG 5/27/2022 15:25:53'!
transfer 

	self subclassResponsibility.! !


!TransferMovement methodsFor: 'balance' stamp: 'FG 5/27/2022 15:23:36'!
affectBalance: aBalance

	self subclassResponsibility.! !


!TransferMovement methodsFor: 'initialization' stamp: 'FG 5/27/2022 15:22:39'!
registerTransfer: aTransfer on: anAccount
	
	self subclassResponsibility.! !


!TransferMovement methodsFor: 'reporting' stamp: 'FG 5/28/2022 17:35:12'!
makeReport: aReport 
	
	self subclassResponsibility.! !


!classDefinition: #DepositTransfer category: 'Portfolio-Solucion'!
TransferMovement subclass: #DepositTransfer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!DepositTransfer methodsFor: 'initialization' stamp: 'FG 5/29/2022 10:26:18'!
registerTransfer: aTransfer on: anAccountToDeposit 
	 
	transfer := aTransfer.
	account := anAccountToDeposit.
	
	anAccountToDeposit register: self. ! !


!DepositTransfer methodsFor: 'accessing' stamp: 'FG 5/27/2022 14:34:38'!
transfer

	^transfer! !


!DepositTransfer methodsFor: 'balance' stamp: 'FG 5/27/2022 15:04:48'!
affectBalance: aBalance 
	
	^aBalance + self value.! !


!DepositTransfer methodsFor: 'value' stamp: 'FG 5/27/2022 15:04:37'!
value

	^transfer value! !


!DepositTransfer methodsFor: 'reporting' stamp: 'FG 5/28/2022 17:35:18'!
makeReport: aReport 
	
	aReport reportForDepositTransfer: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DepositTransfer class' category: 'Portfolio-Solucion'!
DepositTransfer class
	instanceVariableNames: ''!

!DepositTransfer class methodsFor: 'instance creation' stamp: 'FG 5/29/2022 10:26:36'!
registerTransfer: aTransfer on: anAccountDeposit 

	^self new registerTransfer: aTransfer on: anAccountDeposit ! !


!classDefinition: #WithdrawTransfer category: 'Portfolio-Solucion'!
TransferMovement subclass: #WithdrawTransfer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!WithdrawTransfer methodsFor: 'initialization' stamp: 'FG 5/29/2022 10:27:22'!
registerTransfer: aTransfer on: anAccountToWithdraw

	transfer := aTransfer.
	account := anAccountToWithdraw.
	
	anAccountToWithdraw register: self. ! !


!WithdrawTransfer methodsFor: 'accessing' stamp: 'FG 5/27/2022 14:34:25'!
transfer

	^transfer! !


!WithdrawTransfer methodsFor: 'value' stamp: 'FG 5/27/2022 15:05:28'!
value 

	^ transfer value.! !


!WithdrawTransfer methodsFor: 'balance' stamp: 'FG 5/27/2022 15:05:34'!
affectBalance: aBalance 
	
	^aBalance - self value ! !


!WithdrawTransfer methodsFor: 'reporting' stamp: 'FG 5/28/2022 17:35:34'!
makeReport: aReport

	aReport reportForWithdrawTransfer: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WithdrawTransfer class' category: 'Portfolio-Solucion'!
WithdrawTransfer class
	instanceVariableNames: ''!

!WithdrawTransfer class methodsFor: 'instance creation' stamp: 'FG 5/29/2022 10:27:00'!
registerTransfer: aTransfer on: anAccountToWithdraw

	^self new registerTransfer: aTransfer on: anAccountToWithdraw! !


!classDefinition: #Withdraw category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:15'!
affectBalance: aBalance

	^aBalance - value! !


!Withdraw methodsFor: 'reporting' stamp: 'FG 5/28/2022 17:35:42'!
makeReport: aReport

	aReport reportForWithdraw: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Solucion'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Report category: 'Portfolio-Solucion'!
Object subclass: #Report
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Report methodsFor: 'reporting' stamp: 'FG 5/28/2022 17:24:48'!
makeReport

	^self subclassResponsibility.! !

!Report methodsFor: 'reporting' stamp: 'FG 5/28/2022 17:27:17'!
reportForDeposit: aDepositToReport

	self subclassResponsibility.! !

!Report methodsFor: 'reporting' stamp: 'FG 5/28/2022 17:27:27'!
reportForDepositTransfer: aDepositTransferToReport

	self subclassResponsibility.! !

!Report methodsFor: 'reporting' stamp: 'FG 5/28/2022 17:27:44'!
reportForWithdraw: aWithdrawToReport

	self subclassResponsibility.! !

!Report methodsFor: 'reporting' stamp: 'FG 5/28/2022 17:27:38'!
reportForWithdrawTransfer: aWithdrawTransferToReport

	self subclassResponsibility.! !


!Report methodsFor: 'initialization' stamp: 'FG 5/28/2022 17:23:34'!
initializeFor: anAccountToReport

	self subclassResponsibility.! !


!classDefinition: #AccountSummaryReport category: 'Portfolio-Solucion'!
Report subclass: #AccountSummaryReport
	instanceVariableNames: 'summary account'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountSummaryReport methodsFor: 'reporting' stamp: 'FG 5/29/2022 10:36:05'!
makeReport
	
	account makeReport: self.
	"Asumimos que el balance se debía imprimir solo una vez por reporte"
	"Que si se realiza un reporte sobre un portfolio que tiene varias receptiveaccounts, el balance sólo debe aparecer
	abajo de todo el resumen y no por cada receptiveaccounts"
	summary add: ('Balance = ', account balance asString).
	
	^summary.
	
	! !


!AccountSummaryReport methodsFor: 'reporting - private' stamp: 'FG 5/28/2022 17:28:04'!
reportForDeposit: aDeposit

	summary add: ('Depósito por ', aDeposit value asString, '.').! !

!AccountSummaryReport methodsFor: 'reporting - private' stamp: 'FG 5/28/2022 17:29:26'!
reportForDepositTransfer: aDepositTransfer

	summary add: ('Entrada por transferencia de ', aDepositTransfer value asString, '.').! !

!AccountSummaryReport methodsFor: 'reporting - private' stamp: 'FG 5/28/2022 17:29:11'!
reportForWithdraw: aWithdraw

	summary add: ('Extracción por ', aWithdraw value asString, '.').! !

!AccountSummaryReport methodsFor: 'reporting - private' stamp: 'FG 5/28/2022 17:28:54'!
reportForWithdrawTransfer: aWithdrawTransfer

	summary add: ('Salida por transferencia de ', aWithdrawTransfer value asString, '.').! !


!AccountSummaryReport methodsFor: 'initialization' stamp: 'FG 5/28/2022 16:48:41'!
initializeFor: anAccountToSummarize

	account := anAccountToSummarize.
	summary := OrderedCollection new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountSummaryReport class' category: 'Portfolio-Solucion'!
AccountSummaryReport class
	instanceVariableNames: ''!

!AccountSummaryReport class methodsFor: 'instance creation' stamp: 'FG 5/28/2022 16:47:59'!
for: anAccountToSummarize

	^self new initializeFor: anAccountToSummarize.! !


!classDefinition: #TransferNetReport category: 'Portfolio-Solucion'!
Report subclass: #TransferNetReport
	instanceVariableNames: 'account value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferNetReport methodsFor: 'reporting - private' stamp: 'FG 5/28/2022 17:30:55'!
reportForDeposit: aDeposit

	^self! !

!TransferNetReport methodsFor: 'reporting - private' stamp: 'FG 5/28/2022 17:31:08'!
reportForDepositTransfer: aDepositTransfer

	value := value + aDepositTransfer value.! !

!TransferNetReport methodsFor: 'reporting - private' stamp: 'FG 5/28/2022 17:31:22'!
reportForWithdraw: aWithdraw

	^self! !

!TransferNetReport methodsFor: 'reporting - private' stamp: 'FG 5/28/2022 17:31:35'!
reportForWithdrawTransfer: aWithdrawTransfer

	value := value - aWithdrawTransfer value.! !


!TransferNetReport methodsFor: 'reporting' stamp: 'FG 5/28/2022 17:34:26'!
makeReport
	
	account makeReport: self.
	^value.! !


!TransferNetReport methodsFor: 'initialization' stamp: 'FG 5/28/2022 17:06:05'!
initializeFor: anAccountToBeReported
	
	account := anAccountToBeReported.
	value := 0.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferNetReport class' category: 'Portfolio-Solucion'!
TransferNetReport class
	instanceVariableNames: ''!

!TransferNetReport class methodsFor: 'instance creation' stamp: 'FG 5/28/2022 17:04:35'!
for: anAccountToBeReported

	^self new initializeFor: anAccountToBeReported.! !


!classDefinition: #Transfer category: 'Portfolio-Solucion'!
Object subclass: #Transfer
	instanceVariableNames: 'withdraw deposit value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Transfer methodsFor: 'accessing' stamp: 'FG 5/27/2022 14:17:27'!
depositTransfer
	
	^deposit! !

!Transfer methodsFor: 'accessing' stamp: 'FG 5/27/2022 14:16:43'!
withdrawTransfer
	
	^withdraw! !


!Transfer methodsFor: 'initialization' stamp: 'FG 5/29/2022 09:29:14'!
register: anAmountToTransfer from: anAccountToWithdraw to: anAccountToDeposit 
	
	value := anAmountToTransfer.
	deposit := DepositTransfer registerTransfer: self on: anAccountToDeposit.
	withdraw := WithdrawTransfer registerTransfer: self on: anAccountToWithdraw.! !


!Transfer methodsFor: 'value' stamp: 'FG 5/27/2022 15:03:16'!
value

	^value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: 'Portfolio-Solucion'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'assertions' stamp: 'FG 5/27/2022 15:46:47'!
assertAmountIsPositive: anAmountToTransfer

	^ anAmountToTransfer <= 0 ifTrue: [ self error: self transferAmountShouldBePositiveErrorMessage]! !

!Transfer class methodsFor: 'assertions' stamp: 'FG 5/29/2022 09:28:34'!
assertShouldBeDifferentAccountToDeposit: anAccountToDeposit andAccountToWithdraw: anAccountToWithdraw

	^ anAccountToWithdraw = anAccountToDeposit ifTrue: [ self error: self transferAccountsShouldBeDifferentErrorMessage]! !


!Transfer class methodsFor: 'error messages' stamp: 'FG 5/29/2022 09:26:24'!
transferAccountsShouldBeDifferentErrorMessage

	^'Transfer should be registered between two different accounts'! !

!Transfer class methodsFor: 'error messages' stamp: 'FG 5/27/2022 15:44:56'!
transferAmountShouldBePositiveErrorMessage

	^'Transfer should be registered with an amount bigger than zero'! !


!Transfer class methodsFor: 'instance creation' stamp: 'FG 5/29/2022 09:28:34'!
register: anAmountToTransfer from: anAccountToWithdraw to: anAccountToDeposit 
	
	self assertAmountIsPositive: anAmountToTransfer.
	self assertShouldBeDifferentAccountToDeposit: anAccountToDeposit andAccountToWithdraw: anAccountToWithdraw. 
	
	^self new register: anAmountToTransfer from: anAccountToWithdraw to: anAccountToDeposit! !
