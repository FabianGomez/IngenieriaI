!classDefinition: #MarsRoverTests category: 'MarsRover'!
TestCase subclass: #MarsRoverTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRoverTests methodsFor: 'as yet unclassified' stamp: 'FF 5/12/2022 20:57:59'!
test01RoverStaysAtOrignWhenRecievesEmptyStringHeadingSouth
	|marsRover|
	
	marsRover := MarsRover new.
	
	self assert: (marsRover process: '') isAt = (0@0).
	self assert: (marsRover process: '') heading = (#South).! !

!MarsRoverTests methodsFor: 'as yet unclassified' stamp: 'FF 5/12/2022 21:03:12'!
test02RoverChangesHeadingWhenRecievesCommandR
	|marsRover|
	
	marsRover := MarsRover new.
	
	marsRover process: 'r'.
	
	self assert: marsRover isAt = (0@0).
	self assert: marsRover heading = (#West).! !

!MarsRoverTests methodsFor: 'as yet unclassified' stamp: 'FF 5/12/2022 21:18:47'!
test03RoverChangesHeadingToEastWhenRecievesCommandL
	|marsRover|
	
	marsRover := MarsRover new.
	
	marsRover process: 'l'.
	
	self assert: marsRover isAt = (0@0).
	self assert: marsRover heading = (#East).! !


!classDefinition: #MarsRover category: 'MarsRover'!
Object subclass: #MarsRover
	instanceVariableNames: 'heading'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRover methodsFor: 'accessing' stamp: 'FF 5/12/2022 21:13:23'!
heading
	^heading.! !

!MarsRover methodsFor: 'accessing' stamp: 'FF 5/12/2022 21:12:30'!
headingTo: aSymbol 
	heading := aSymbol.! !

!MarsRover methodsFor: 'accessing' stamp: 'FF 5/12/2022 20:56:44'!
isAt
	^0@0.! !

!MarsRover methodsFor: 'accessing' stamp: 'FF 5/12/2022 21:25:26'!
process: aString 
	aString isEmpty ifTrue:[^self].
	(aString = 'r') ifTrue: [^self headingTo: #West].
	^self headingTo: #East.  ! !


!MarsRover methodsFor: 'initialization' stamp: 'FF 5/12/2022 21:17:28'!
initialize
	heading := #South.! !
