!classDefinition: #CantSuspend category: 'CodigoRepetido-Ejercicio'!
Error subclass: #CantSuspend
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #NotFound category: 'CodigoRepetido-Ejercicio'!
Error subclass: #NotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #CustomerBookTest category: 'CodigoRepetido-Ejercicio'!
TestCase subclass: #CustomerBookTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBookTest methodsFor: 'testing' stamp: 'FG 4/14/2022 14:58:06'!
ExecuteBlock: aClosure inCustomerBook: aCustomerBook on: anAction do: anErrorClosure
	
	[ aClosure value: aCustomerBook.
	self fail ]
		on: anAction 
		do: [ :anError | 
			anErrorClosure value: anError ].! !

!CustomerBookTest methodsFor: 'testing' stamp: 'FG 4/14/2022 14:59:59'!
ExecuteBlock: aClosure inCustomerBook: aCustomerBook onCantSuspendDo: anErrorClosure
	
	self ExecuteBlock: aClosure inCustomerBook: aCustomerBook on: CantSuspend  do: anErrorClosure.! !

!CustomerBookTest methodsFor: 'testing' stamp: 'FG 4/14/2022 14:59:05'!
ExecuteBlock: aClosure inCustomerBook: aCustomerBook onErrorDo: anErrorClosure
	
	self ExecuteBlock: aClosure inCustomerBook: aCustomerBook on: Error  do: anErrorClosure.! !

!CustomerBookTest methodsFor: 'testing' stamp: 'FG 4/14/2022 14:34:47'!
ExecuteBlock: aClosure inCustomerBook: aCustomerBook shouldNotTakeMoreMilisecondsThan: miliseconds
	
	| millisecondsAfterRunning millisecondsBeforeRunning |
	
	millisecondsBeforeRunning := Time millisecondClockValue * millisecond.
	aClosure value: aCustomerBook.
	millisecondsAfterRunning := Time millisecondClockValue * millisecond.
	
	self assert: (millisecondsAfterRunning-millisecondsBeforeRunning) < (miliseconds * millisecond)
	! !

!CustomerBookTest methodsFor: 'testing' stamp: 'FG 4/14/2022 14:49:23'!
ExecuteBlock: aClosure inCustomerBook: aCustomerBook test: aClosureToTest

	aClosure value: aCustomerBook.
	aClosureToTest value.


	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'FG 4/14/2022 14:35:28'!
test01AddingCustomerShouldNotTakeMoreThan50Milliseconds

	| customerBook |
	
	customerBook := CustomerBook new.
	
	self ExecuteBlock: [:aCustomerBook | aCustomerBook addCustomerNamed: 'John Lennon'] inCustomerBook: customerBook shouldNotTakeMoreMilisecondsThan: 50. 
	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'FG 4/14/2022 14:35:41'!
test02RemovingCustomerShouldNotTakeMoreThan100Milliseconds

	| customerBook paulMcCartney |
	
	customerBook := CustomerBook new.
	paulMcCartney := 'Paul McCartney'.
	
	customerBook addCustomerNamed: paulMcCartney.
	
	self ExecuteBlock: [:aCustomerBook | aCustomerBook removeCustomerNamed: paulMcCartney] inCustomerBook: customerBook shouldNotTakeMoreMilisecondsThan: 100. 
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'FG 4/14/2022 14:35:48'!
test03CanNotAddACustomerWithEmptyName 

	| customerBook |
			
	customerBook := CustomerBook new.
	
	self ExecuteBlock: [:aCustomerBook | aCustomerBook addCustomerNamed: ''] inCustomerBook: customerBook onErrorDo: [ :anError | 
			self assert: anError messageText = CustomerBook customerCanNotBeEmptyErrorMessage.
			self assert: customerBook isEmpty ] 	! !

!CustomerBookTest methodsFor: 'testing' stamp: 'FG 4/14/2022 14:35:56'!
test04CanNotRemoveAnInvalidCustomer
	
	| customerBook johnLennon |
			
	customerBook := CustomerBook new.
	johnLennon := 'John Lennon'.
	customerBook addCustomerNamed: johnLennon.
	
	self ExecuteBlock: [:aCustomerBook | aCustomerBook removeCustomerNamed: 'Paul McCartney'] inCustomerBook: customerBook onErrorDo: [ :anError | 
			self assert: customerBook numberOfCustomers = 1.
			self assert: (customerBook includesCustomerNamed: johnLennon) ] 	! !

!CustomerBookTest methodsFor: 'testing' stamp: 'FG 4/14/2022 14:49:42'!
test05SuspendingACustomerShouldNotRemoveItFromCustomerBook

	| customerBook paulMcCartney|
	
	customerBook := CustomerBook new.
	paulMcCartney := 'Paul McCartney'.
	
	self ExecuteBlock: 		[ :aCustomerBook | 		aCustomerBook addCustomerNamed: paulMcCartney. 		aCustomerBook suspendCustomerNamed: paulMcCartney.]
	inCustomerBook: customerBook 
	test: [ self assert: 0 equals: customerBook numberOfActiveCustomers.
		self assert: 1 equals: customerBook numberOfSuspendedCustomers.
		self assert: 1 equals: customerBook numberOfCustomers.
		self assert: (customerBook includesCustomerNamed: paulMcCartney).]
	
	

	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'FG 4/14/2022 14:51:00'!
test06RemovingASuspendedCustomerShouldRemoveItFromCustomerBook

	| customerBook paulMcCartney|
	
	customerBook := CustomerBook new.
	paulMcCartney := 'Paul McCartney'.
	
	self ExecuteBlock: 		[ :aCustomerBook | 	aCustomerBook addCustomerNamed: paulMcCartney.
		aCustomerBook suspendCustomerNamed: paulMcCartney.
		aCustomerBook removeCustomerNamed: paulMcCartney.]
	inCustomerBook: customerBook 
	test: [ self assert: 0 equals: customerBook numberOfActiveCustomers.
		self assert: 0 equals: customerBook numberOfSuspendedCustomers.
		self assert: 0 equals: customerBook numberOfCustomers.
		self deny: (customerBook includesCustomerNamed: paulMcCartney).]


	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'FG 4/14/2022 14:56:21'!
test07CanNotSuspendAnInvalidCustomer
	
	| customerBook johnLennon |
			
	customerBook := CustomerBook new.
	johnLennon := 'John Lennon'.
	customerBook addCustomerNamed: johnLennon.
	
	self ExecuteBlock: [ :aCustomerBook |
		aCustomerBook suspendCustomerNamed: 'George Harrison'. ]
	inCustomerBook:  customerBook
	onCantSuspendDo: [ :anError | 
		self assert: customerBook numberOfCustomers = 1.
		self assert: (customerBook includesCustomerNamed: johnLennon) ]
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'FG 4/14/2022 15:01:19'!
test08CanNotSuspendAnAlreadySuspendedCustomer
	
	| customerBook johnLennon |
			
	customerBook := CustomerBook new.
	johnLennon := 'John Lennon'.
	customerBook addCustomerNamed: johnLennon.
	customerBook suspendCustomerNamed: johnLennon.
	
	self ExecuteBlock: [ :aCustomerBook | aCustomerBook suspendCustomerNamed: johnLennon. ]
	inCustomerBook: customerBook 
	onCantSuspendDo: [ :anError | 
			self assert: customerBook numberOfCustomers = 1.
			self assert: (customerBook includesCustomerNamed: johnLennon) ]
! !


!classDefinition: #CustomerBook category: 'CodigoRepetido-Ejercicio'!
Object subclass: #CustomerBook
	instanceVariableNames: 'suspended active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBook methodsFor: 'testing' stamp: 'FG 4/14/2022 15:34:28'!
includesCustomerNamed: aName

	^(self includesCustomerNamedOnActiveCustomers: aName) or: [ self includesCustomerNamedOnSuspendedCustomers: aName ]! !

!CustomerBook methodsFor: 'testing' stamp: 'FG 4/14/2022 15:33:52'!
includesCustomerNamedOnActiveCustomers: aName

	^ active includes: aName! !

!CustomerBook methodsFor: 'testing' stamp: 'FG 4/14/2022 15:33:37'!
includesCustomerNamedOnSuspendedCustomers: aName

	^ suspended includes: aName! !

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
isEmpty
	
	^active isEmpty and: [ suspended isEmpty ]! !


!CustomerBook methodsFor: 'initialization' stamp: 'NR 9/17/2020 07:23:04'!
initialize

	active := OrderedCollection new.
	suspended:= OrderedCollection new.! !


!CustomerBook methodsFor: 'customer management' stamp: 'FG 4/14/2022 15:28:05'!
addCustomerNamed: aName

	aName isEmpty ifTrue: [ self signalCustomerNameCannotBeEmpty ].
	(self includesCustomerNamed: aName) ifTrue: [ self signalCustomerAlreadyExists ].
	
	active add: aName ! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
numberOfActiveCustomers
	
	^active size! !

!CustomerBook methodsFor: 'customer management' stamp: 'FG 4/14/2022 15:05:50'!
numberOfCustomers
	
	^ self numberOfActiveCustomers + self numberOfSuspendedCustomers .! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 9/19/2018 17:36:09'!
numberOfSuspendedCustomers
	
	^suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'FG 4/14/2022 15:16:28'!
removeCustomerNamed: aName 
 
	^ active remove: aName ifAbsent: [ ^ suspended remove: aName ifAbsent: [^ NotFound signal.]]! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:52'!
signalCustomerAlreadyExists 

	self error: self class customerAlreadyExistsErrorMessage! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:51'!
signalCustomerNameCannotBeEmpty 

	self error: self class customerCanNotBeEmptyErrorMessage ! !

!CustomerBook methodsFor: 'customer management' stamp: 'FG 4/14/2022 15:37:07'!
suspendCustomerNamed: aName 
	
	(self includesCustomerNamedOnActiveCustomers: aName) ifFalse: [^CantSuspend signal].
	
	active remove: aName.
	
	suspended add: aName
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerBook class' category: 'CodigoRepetido-Ejercicio'!
CustomerBook class
	instanceVariableNames: ''!

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 4/11/2022 07:18:12'!
customerAlreadyExistsErrorMessage

	^'Customer already exists!!!!!!'! !

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 4/11/2022 07:18:16'!
customerCanNotBeEmptyErrorMessage

	^'Customer name cannot be empty!!!!!!'! !
