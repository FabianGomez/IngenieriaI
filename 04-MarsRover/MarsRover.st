!classDefinition: #MarsRoverTests category: 'MarsRover'!
TestCase subclass: #MarsRoverTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRoverTests methodsFor: 'as yet unclassified' stamp: 'FG 5/12/2022 20:58:12'!
test01RoverDoesNothingWhenEmptyStringIsSent

	|marsRover|
	
	marsRover := MarsRover new.
	
	marsRover process: ''.
	
	self assert: marsRover position = (0@0).
	self assert: marsRover heading = #South. 
	
	! !

!MarsRoverTests methodsFor: 'as yet unclassified' stamp: 'FG 5/12/2022 20:56:28'!
test02RoverChangesHeadingWhenRecievesProcessR

	|marsRover|
	
	marsRover := MarsRover new.
	
	marsRover process: 'r'.
	
	self assert: marsRover position = (0@0).
	self assert: marsRover heading = (#West). 
	! !

!MarsRoverTests methodsFor: 'as yet unclassified' stamp: 'FG 5/12/2022 21:18:03'!
test03RoverChangesHeadingWhenRecievesProcessL

	|marsRover|
	
	marsRover := MarsRover new.
	
	marsRover process: 'l'.
	
	self assert: marsRover position = (0@0).
	self assert: marsRover heading = (#East). 
	! !


!classDefinition: #MarsRover category: 'MarsRover'!
Object subclass: #MarsRover
	instanceVariableNames: 'heading'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRover methodsFor: 'action' stamp: 'FG 5/12/2022 21:12:14'!
headingTo: aSymbol 
	heading := aSymbol.! !

!MarsRover methodsFor: 'action' stamp: 'FG 5/12/2022 21:25:23'!
process: aListOfCommandsToBeProcess 
	
	
	(aListOfCommandsToBeProcess isEmpty) ifTrue: [^self].
		
	(aListOfCommandsToBeProcess = 'r') ifTrue: [ ^self headingTo: #West].
	self headingTo: #East.! !


!MarsRover methodsFor: 'testing' stamp: 'FG 5/12/2022 21:13:04'!
heading
	^heading.! !

!MarsRover methodsFor: 'testing' stamp: 'FG 5/12/2022 20:54:26'!
position
	^0@0.! !


!MarsRover methodsFor: 'initialization' stamp: 'FG 5/12/2022 21:16:27'!
initialize

	heading := #South.! !
