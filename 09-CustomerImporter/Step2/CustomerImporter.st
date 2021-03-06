!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'tests' stamp: 'FG 6/26/2022 19:05:44'!
test01ImportValidDataCorrectly

	self importReadStream: self validImportData.

	self assertImportedRightNumberOfCustomers.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly ! !

!ImportTest methodsFor: 'tests' stamp: 'FG 6/26/2022 18:41:38'!
test02CustomerRecordMustStartWithC

	self shouldFailImport: self invalidBeginningCustomerRecord
	of: Customer withError: CustomerImporter invalidRecordType.! !

!ImportTest methodsFor: 'tests' stamp: 'FG 6/26/2022 19:03:34'!
test03CustomerRecordMustBeCOnly

	self shouldFailImport: self invalidCustomerRecord
	of: Customer withError: CustomerImporter invalidRecordType! !

!ImportTest methodsFor: 'tests' stamp: 'FG 6/26/2022 19:03:43'!
test04AddressRecordMustBeAOnly

	self shouldFailImport: self invalidAddressRecord
	of: Address withError: CustomerImporter invalidRecordType.! !

!ImportTest methodsFor: 'tests' stamp: 'FG 6/26/2022 19:03:51'!
test05AddressMustBeImportedAfterCustomer

	self shouldFailImport: self addressWithoutCustomerRecord
	of: Address withError:  CustomerImporter addressMustHaveACustomer.! !

!ImportTest methodsFor: 'tests' stamp: 'FG 6/26/2022 19:03:59'!
test06CustomerRecordCannotHaveLessThanFiveColumns
	
	self shouldFailImport: self customerRecordWithLessThanFiveColumns
	of: Customer withError:  CustomerImporter customerRecordInvalidSize.! !

!ImportTest methodsFor: 'tests' stamp: 'FG 6/26/2022 19:04:06'!
test07CustomerRecordMustHaveFiveColumns
	
	self shouldFailImport: self customerRecordWithMoreThanFiveColumns
	of: Customer withError: CustomerImporter customerRecordInvalidSize! !

!ImportTest methodsFor: 'tests' stamp: 'FG 6/26/2022 19:04:14'!
test08AddressRecordMustHaveSixColumns

	self shouldFailImport: self addressRecordWithWrongNumberOfColumns
	of: Address withError: CustomerImporter addressRecordInvalidSize! !


!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:22:05'!
assertAddressOf: importedCustomer at: aStreetName hasNumber: aNumber town: aTown zipCode: aZipCode province: aProvince

	| importedAddress |

	importedAddress := importedCustomer addressAt: aStreetName ifNone: [ self fail ].
	self assert: aStreetName equals: importedAddress streetName.
	self assert: aNumber equals: importedAddress streetNumber.
	self assert: aTown equals: importedAddress town.
	self assert: aZipCode equals: importedAddress zipCode.
	self assert: aProvince equals: importedAddress province.

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:27:57'!
assertCustomerWithIdentificationType: anIdType number: anIdNumber hasFirstName: aFirstName lastName: aLastName

	| importedCustomer |

	importedCustomer := self customerWithIdentificationType: anIdType number: anIdNumber.

	self assert: aFirstName equals: importedCustomer firstName.
	self assert: aLastName equals: importedCustomer lastName.
	self assert: anIdType equals: importedCustomer identificationType.
	self assert: anIdNumber equals: importedCustomer identificationNumber.

	^importedCustomer

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:12:18'!
assertImportedRightNumberOfCustomers

	^ self assert: 2 equals: (session selectAllOfType: Customer) size! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:45'!
assertJuanPerezWasImportedCorrectly

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'C' number: '23-25666777-9' hasFirstName: 'Juan' lastName: 'Perez'.
	self assertAddressOf: importedCustomer at: 'Alem' hasNumber: 1122 town: 'CABA' zipCode: 1001 province: 'CABA'
	! !

!ImportTest methodsFor: 'assertions' stamp: 'FG 6/25/2022 12:18:35'!
assertPepeSanchezWasImportedCorrecty

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assertAddressOf: importedCustomer at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedCustomer at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'.


	! !

!ImportTest methodsFor: 'assertions' stamp: 'FG 6/26/2022 19:05:20'!
shouldFailImport: aReadStreamToImport of: aClassToImport withError: anErrorMessage
	
	self should: [self importReadStream: aReadStreamToImport.]
	raise: Error - MessageNotUnderstood
	withExceptionDo: [ :anError |
		self assert: anErrorMessage equals: anError messageText. 
		self assert: 0 equals: (session selectAllOfType: aClassToImport) size. ]
	
! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 00:27:50'!
setUp

	session := DataBaseSession for: (Array with: Address with: Customer).
	session beginTransaction.
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 00:28:23'!
tearDown

	session commit.
	session close.
	! !


!ImportTest methodsFor: 'customer' stamp: 'HAW 5/22/2022 18:14:22'!
customerWithIdentificationType: anIdType number: anIdNumber

	^ (session
		select: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]
		ofType: Customer) anyOne! !


!ImportTest methodsFor: 'test data' stamp: 'FG 6/25/2022 11:58:55'!
addressRecordWithWrongNumberOfColumns
	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,1636,BsAs'! !

!ImportTest methodsFor: 'test data' stamp: 'FG 6/25/2022 11:28:36'!
addressWithoutCustomerRecord
	^ ReadStream on:
	'A,San Martin,3322,Olivos,1636,BsAs'! !

!ImportTest methodsFor: 'test data' stamp: 'FG 6/25/2022 11:48:33'!
customerRecordWithLessThanFiveColumns
	^ ReadStream on:
'C,Pepe,Sanchez'! !

!ImportTest methodsFor: 'test data' stamp: 'FG 6/25/2022 11:54:17'!
customerRecordWithMoreThanFiveColumns
	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444,extracolumn'! !

!ImportTest methodsFor: 'test data' stamp: 'FG 6/26/2022 19:05:20'!
importReadStream: aReadStreamToImport

	^ CustomerImporter valueFrom: aReadStreamToImport into: session! !

!ImportTest methodsFor: 'test data' stamp: 'FG 6/25/2022 11:21:23'!
invalidAddressRecord
	^ ReadStream on:
	'C,Pepe,Sanchez,D,22333444
AA,San Martin,3322,Olivos,1636,BsAs'! !

!ImportTest methodsFor: 'test data' stamp: 'FG 6/25/2022 11:10:13'!
invalidBeginningCustomerRecord
		^ ReadStream on:
			'X,Pepe,Sanchez,D,22333444'! !

!ImportTest methodsFor: 'test data' stamp: 'FG 6/25/2022 11:11:17'!
invalidCustomerRecord
	^ ReadStream on:
			'CC,Pepe,Sanchez,D,22333444'! !

!ImportTest methodsFor: 'test data' stamp: 'FG 6/25/2022 12:18:43'!
validImportData

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !


!classDefinition: #Address category: 'CustomerImporter'!
Object subclass: #Address
	instanceVariableNames: 'id streetName streetNumber town zipCode province'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province

	^province! !

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province: aProvince

	province := aProvince
	! !


!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 17:55:46'!
isAt: aStreetName

	^streetName = aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName

	^streetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName: aStreetName

	streetName := aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber

	^streetNumber ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber: aStreetNumber

	streetNumber := aStreetNumber ! !


!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town

	^town! !

!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town: aTown

	town := aTown! !


!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode

	^zipCode! !

!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode: aZipCode

	zipCode := aZipCode! !


!classDefinition: #Customer category: 'CustomerImporter'!
Object subclass: #Customer
	instanceVariableNames: 'id firstName lastName identificationType identificationNumber addresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addAddress: anAddress

	addresses add: anAddress ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 17:55:17'!
addressAt: aStreetName ifNone: aNoneBlock

	^addresses detect: [ :address | address isAt: aStreetName ] ifNone: aNoneBlock ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addresses

	^ addresses! !


!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName

	^firstName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName: aName

	firstName := aName! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName

	^lastName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName: aLastName

	lastName := aLastName
! !


!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber

	^identificationNumber ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber: anIdentificationNumber

	identificationNumber := anIdentificationNumber! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType

	^identificationType ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType: anIdentificationType

	identificationType := anIdentificationType! !


!Customer methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initialize

	super initialize.
	addresses := OrderedCollection new.! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
Object subclass: #CustomerImporter
	instanceVariableNames: 'session readStream line newCustomer record'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'HAW 5/22/2022 18:06:47'!
initializeFrom: aReadStream into: aSession
	session := aSession.
	readStream := aReadStream.! !


!CustomerImporter methodsFor: 'evaluating - assertions' stamp: 'FG 6/25/2022 11:33:55'!
assertCustomerHasBeenPreviouslyImported

	^ (newCustomer isNil) ifTrue: [ self error: self class addressMustHaveACustomer]! !

!CustomerImporter methodsFor: 'evaluating - assertions' stamp: 'FG 6/25/2022 12:03:02'!
assertValidAddressRecordSize

	^ record size = 6 ifFalse: [ self error: self class addressRecordInvalidSize ]! !

!CustomerImporter methodsFor: 'evaluating - assertions' stamp: 'FG 6/25/2022 11:55:46'!
assertValidCustomerRecordSize

	^ (record size = 5) ifFalse: [self error: self class customerRecordInvalidSize]! !


!CustomerImporter methodsFor: 'evaluating' stamp: 'FG 6/25/2022 10:45:49'!
value

	[ self hasLineToImport ] whileTrue: [
		self createRecord.
		self importRecord.
	].

	! !


!CustomerImporter methodsFor: 'evaluating - private' stamp: 'FG 6/25/2022 10:45:42'!
createRecord

	record := line findTokens: $,.
! !

!CustomerImporter methodsFor: 'evaluating - private' stamp: 'FG 6/25/2022 11:01:41'!
hasLineToImport

	line := readStream nextLine. 
	^line notNil! !

!CustomerImporter methodsFor: 'evaluating - private' stamp: 'FG 6/25/2022 11:52:24'!
importCustomer
	self assertValidCustomerRecordSize.
	newCustomer := Customer new.
			newCustomer firstName: record second.
			newCustomer lastName: record third.
			newCustomer identificationType: record fourth.
			newCustomer identificationNumber: record fifth.
			session persist: newCustomer! !

!CustomerImporter methodsFor: 'evaluating - private' stamp: 'FG 6/25/2022 12:03:02'!
importCustomerAddress

	| newAddress |
			self assertValidAddressRecordSize.
			newAddress := Address new.
			self assertCustomerHasBeenPreviouslyImported.
			newCustomer addAddress: newAddress.
			newAddress streetName: record second.
			newAddress streetNumber: record third asNumber .
			newAddress town: record fourth.
			newAddress zipCode: record fifth asNumber .
			newAddress province: record sixth! !

!CustomerImporter methodsFor: 'evaluating - private' stamp: 'FG 6/25/2022 11:03:41'!
importRecord

	(self isCustomerRecord) ifTrue: [ ^self importCustomer ].
	(self isAddressRecord) ifTrue: [ ^self importCustomerAddress ].
	self error: self class invalidRecordType.! !

!CustomerImporter methodsFor: 'evaluating - private' stamp: 'FG 6/25/2022 11:22:37'!
isAddressRecord

	^ record first = 'A'! !

!CustomerImporter methodsFor: 'evaluating - private' stamp: 'FG 6/25/2022 11:13:57'!
isCustomerRecord

	^ record first = 'C'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 18:06:47'!
from: aReadStream into: aSession
	^self new initializeFrom: aReadStream into: aSession! !


!CustomerImporter class methodsFor: 'importing' stamp: 'HAW 5/22/2022 18:11:27'!
valueFrom: aReadStream into: aSession

	^(self from: aReadStream into: aSession) value! !


!CustomerImporter class methodsFor: 'error messages' stamp: 'FG 6/25/2022 11:31:10'!
addressMustHaveACustomer
	^'Address cannot be imported if a customer had not been imported fist'! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'FG 6/25/2022 11:59:28'!
addressRecordInvalidSize
	^'Address record must have six columns'! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'FG 6/25/2022 12:01:33'!
customerRecordInvalidSize
	^'Customer record must have five columns'.! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'FG 6/25/2022 11:27:39'!
invalidRecordType
	^'The record does not have a valid type'! !


!classDefinition: #DataBaseSession category: 'CustomerImporter'!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 00:19:29'!
beginTransaction

	! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 19:17:36'!
commit

	(tables at: Customer ifAbsent: [#()]) do: [ :aCustomer | self persistAddressesOf: aCustomer ]
	! !


!DataBaseSession methodsFor: 'closing' stamp: 'HAW 5/22/2022 00:19:29'!
close

	! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
delay

	(Delay forMilliseconds: 100) wait! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 19:29:06'!
objectsOfType: aType

	^ tables at: aType ifAbsent: [ #() ]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
persistAddressesOf: anObjectWithAddresses

	anObjectWithAddresses addresses do: [ :anAddress | self persist: anAddress ]
	! !


!DataBaseSession methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	tables := Dictionary new.
	id := 0.! !


!DataBaseSession methodsFor: 'id' stamp: 'HAW 5/22/2022 00:19:29'!
newIdFor: anObject

	id := id + 1.
	^id! !


!DataBaseSession methodsFor: 'persistance' stamp: 'HAW 5/22/2022 00:19:29'!
persist: anObject

	| table |

	self delay.
	table := tables at: anObject class ifAbsentPut: [ Set new ].

	self defineIdOf: anObject.
	table add: anObject.

	(anObject isKindOf: Customer) ifTrue: [ self persistAddressesOf: anObject ].! !


!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 19:29:06'!
select: aCondition ofType: aType

	self delay.
	^(self objectsOfType: aType) select: aCondition ! !

!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 19:29:06'!
selectAllOfType: aType

	self delay.
	^(self objectsOfType: aType) copy ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataBaseSession class' category: 'CustomerImporter'!
DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 00:19:29'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !
