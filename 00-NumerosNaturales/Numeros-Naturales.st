!classDefinition: #I category: 'Numeros-Naturales'!
DenotativeObject subclass: #I
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros-Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'I class' category: 'Numeros-Naturales'!
I class
	instanceVariableNames: ''!

!I class methodsFor: 'next' stamp: 'ARM 3/31/2022 21:18:47'!
next

	^II! !


!I class methodsFor: 'operations' stamp: 'FG 4/9/2022 10:22:09'!
* unMultiplicando

	^ unMultiplicando.! !

!I class methodsFor: 'operations' stamp: 'FG 4/9/2022 10:22:26'!
+ unSumando

	^ unSumando next.! !

!I class methodsFor: 'operations' stamp: 'FG 4/9/2022 11:16:15'!
- unSustraendo
	
	^self error: self negativeNumbersNotSupportedErrorDescription.! !

!I class methodsFor: 'operations' stamp: 'FG 4/9/2022 11:17:15'!
/ unDivisor
	
	self = unDivisor ifTrue: [^self].
	self error: self canNotDivideByBiggerNumberErrorDescription.! !

!I class methodsFor: 'operations' stamp: 'FG 4/9/2022 10:44:11'!
sustraeteDe: unMinuendo
	
	^ unMinuendo previous.! !


!I class methodsFor: 'error messages' stamp: 'FG 4/9/2022 11:50:51'!
canNotDivideByBiggerNumberErrorDescription

	^ II canNotDivideByBiggerNumberErrorDescription.! !

!I class methodsFor: 'error messages' stamp: 'FG 4/9/2022 11:51:22'!
negativeNumbersNotSupportedErrorDescription

	^ 'Los números negativos no son soportados'! !


!classDefinition: #II category: 'Numeros-Naturales'!
DenotativeObject subclass: #II
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros-Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'II class' category: 'Numeros-Naturales'!
II class
	instanceVariableNames: 'next previous'!

!II class methodsFor: 'operaciones' stamp: 'FG 4/9/2022 10:37:50'!
* unMultiplicando

	^ unMultiplicando + (self previous * unMultiplicando).! !

!II class methodsFor: 'operaciones' stamp: 'FG 4/9/2022 10:34:13'!
+ unSumando

	^previous + unSumando next! !

!II class methodsFor: 'operaciones' stamp: 'FG 4/9/2022 11:14:03'!
- unSustraendo
	
	^unSustraendo sustraeteDe: self.! !

!II class methodsFor: 'operaciones' stamp: 'FG 4/9/2022 11:49:45'!
/ unDivisor

	unDivisor = self ifTrue: [^I].
	unDivisor = I ifTrue: [^self].
	[self - unDivisor] ifError: [^ self error: self canNotDivideByBiggerNumberErrorDescription ].
	^ I + ((self - unDivisor) / unDivisor).! !

!II class methodsFor: 'operaciones' stamp: 'FG 4/9/2022 10:43:03'!
sustraeteDe: unMinuendo

	^unMinuendo previous - self previous.
! !


!II class methodsFor: 'next & previous' stamp: 'FG 4/9/2022 11:09:30'!
nameOfNext
	(self name endsWith: 'CMXCIX') ifTrue:[^(self name withoutSuffix: 'CMXCIX'), 'M'].
	(self name endsWith: 'DCCCXCIX') ifTrue:[^(self name withoutSuffix: 'DCCCXCIX'), 'CM'].
	(self name endsWith: 'CDXCIX') ifTrue:[^(self name withoutSuffix: 'CDXCIX'), 'D'].
	(self name endsWith: 'CCCXCIX') ifTrue:[^(self name withoutSuffix: 'CCCXCIX'), 'CD'].
	(self name endsWith: 'XCIX') ifTrue:[^(self name withoutSuffix: 'XCIX'), 'C'].
	(self name endsWith: 'LXXXIX') ifTrue:[^(self name withoutSuffix: 'LXXXIX'), 'XC'].
	(self name endsWith: 'XLIX') ifTrue:[^(self name withoutSuffix: 'XLIX'), 'L'].
	(self name endsWith: 'XXXIX') ifTrue:[^(self name withoutSuffix: 'XXXIX'), 'XL'].
	(self name endsWith: 'IX') ifTrue:[^(self name withoutSuffix: 'IX'), 'X'].
	(self name endsWith: 'VIII') ifTrue:[^(self name withoutSuffix: 'VIII'), 'IX'].
	(self name endsWith: 'IV') ifTrue:[^(self name withoutSuffix: 'IV'), 'V'].
	(self name endsWith: 'III') ifTrue:[^(self name withoutSuffix: 'III'), 'IV'].
	^ self name, 'I'.! !

!II class methodsFor: 'next & previous' stamp: 'FG 4/9/2022 10:46:28'!
next
	next ifNotNil:[^next].
	next _ II createChildNamed: (self nameOfNext).
	next previous: self.
	^next! !

!II class methodsFor: 'next & previous' stamp: 'ARM 3/31/2022 21:26:45'!
previous

	^previous! !

!II class methodsFor: 'next & previous' stamp: 'ARM 3/31/2022 21:20:55'!
previous: unNatural 
	
	previous _ unNatural! !

!II class methodsFor: 'next & previous' stamp: 'FG 4/9/2022 11:00:48'!
removeAllNext
	
	next ifNotNil: 
	[next removeAllNext.
	next removeFromSystem.
	next := nil.]! !


!II class methodsFor: 'error messages' stamp: 'FG 4/9/2022 11:50:36'!
canNotDivideByBiggerNumberErrorDescription

	^ 'No se puede dividir por un número mayor'! !


!II class methodsFor: '--** private fileout/in **--' stamp: 'FG 4/9/2022 12:03:39'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := III.
	previous := I.! !


!classDefinition: #III category: 'Numeros-Naturales'!
II subclass: #III
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros-Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'III class' category: 'Numeros-Naturales'!
III class
	instanceVariableNames: ''!

!III class methodsFor: '--** private fileout/in **--' stamp: 'FG 4/9/2022 12:03:39'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IV.
	previous := II.! !


!classDefinition: #IV category: 'Numeros-Naturales'!
II subclass: #IV
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros-Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IV class' category: 'Numeros-Naturales'!
IV class
	instanceVariableNames: ''!

!IV class methodsFor: '--** private fileout/in **--' stamp: 'FG 4/9/2022 12:03:39'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := V.
	previous := III.! !


!classDefinition: #V category: 'Numeros-Naturales'!
II subclass: #V
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros-Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'V class' category: 'Numeros-Naturales'!
V class
	instanceVariableNames: ''!

!V class methodsFor: '--** private fileout/in **--' stamp: 'FG 4/9/2022 12:03:39'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := VI.
	previous := IV.! !


!classDefinition: #VI category: 'Numeros-Naturales'!
II subclass: #VI
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros-Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'VI class' category: 'Numeros-Naturales'!
VI class
	instanceVariableNames: ''!

!VI class methodsFor: '--** private fileout/in **--' stamp: 'FG 4/9/2022 12:03:39'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := nil.
	previous := V.! !

II initializeAfterFileIn!
III initializeAfterFileIn!
IV initializeAfterFileIn!
V initializeAfterFileIn!
VI initializeAfterFileIn!