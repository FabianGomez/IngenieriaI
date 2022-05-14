!classDefinition: #MarsRoverTests category: 'MarsRover'!
TestCase subclass: #MarsRoverTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 16:03:04'!
test01RoverDoesNothingWhenEmptyCommandsAreSent

	| marsRover |
	
	marsRover := MarsRover startsAt: 0@0 headingAt: South.
	
	marsRover process: ''.
	
	self assert: (marsRover isAtPosition: 0@0 heading: South).  

	! !

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 16:03:09'!
test02RoverStartingAtSouthChangesHeadingWhenRecievesCommandR

	| marsRover |
	
	marsRover := MarsRover startsAt: 0@0 headingAt: South.
	
	marsRover process: 'r'.
	
	self assert: (marsRover isAtPosition: 0@0 heading: West).  

	! !

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 16:03:14'!
test03RoverStartingAtSouthChangesHeadingWhenRecievesCommandL

	| marsRover |
	
	marsRover := MarsRover startsAt: 0@0 headingAt: South.
	
	marsRover process: 'l'.
	
	self assert: (marsRover isAtPosition: 0@0 heading: East).  

	! !

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 16:03:21'!
test04RoverStartingAtEastChangesHeadingWhenRecievesCommandR

	| marsRover |
	
	marsRover := MarsRover startsAt: 0@0 headingAt: East.
	
	marsRover process: 'r'.
	
	self assert: (marsRover isAtPosition: 0@0 heading: South).  

	! !

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 16:03:25'!
test05RoverStartingAtEastChangesHeadingWhenRecievesCommandL

	| marsRover |
	
	marsRover := MarsRover startsAt: 0@0 headingAt: East.
	
	marsRover process: 'l'.
	
	self assert: (marsRover isAtPosition: 0@0 heading: North).  

	! !

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 16:03:29'!
test06RoverStartingAtNorthChangesHeadingWhenRecievesCommandR

	| marsRover |
	
	marsRover := MarsRover startsAt: 0@0 headingAt: North.
	
	marsRover process: 'r'.
	
	self assert: (marsRover isAtPosition: 0@0 heading: East).  

	! !

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 16:03:34'!
test07RoverStartingAtNorthChangesHeadingWhenRecievesCommandL

	| marsRover |
	
	marsRover := MarsRover startsAt: 0@0 headingAt: North.
	
	marsRover process: 'l'.
	
	self assert: (marsRover isAtPosition: 0@0 heading: West).  

	! !

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 16:03:40'!
test08RoverStartingAtWestChangesHeadingWhenRecievesCommandR

	| marsRover |
	
	marsRover := MarsRover startsAt: 0@0 headingAt: West.
	
	marsRover process: 'r'.
	
	self assert: (marsRover isAtPosition: 0@0 heading: North).  

	! !

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 16:03:44'!
test09RoverStartingAtWestChangesHeadingWhenRecievesCommandL

	| marsRover |
	
	marsRover := MarsRover startsAt: 0@0 headingAt: West.
	
	marsRover process: 'l'.
	
	self assert: (marsRover isAtPosition: 0@0 heading: South).  

	! !

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 16:03:47'!
test10RoverStartingAtSouthChangesPositionWhenRecievesCommandF

	| marsRover |
	
	marsRover := MarsRover startsAt: 0@0 headingAt: South.
	
	marsRover process: 'f'.
	
	self assert: (marsRover isAtPosition: 0@-1 heading: South).  

	! !

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 16:03:51'!
test11RoverStartingAtSouthChangesPositionWhenRecievesCommandB

	| marsRover |
	
	marsRover := MarsRover startsAt: 0@0 headingAt: South.
	
	marsRover process: 'b'.
	
	self assert: (marsRover isAtPosition: 0@1 heading: South).  

	! !

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 16:03:55'!
test12RoverStartingAtEastChangesPositionWhenRecievesCommandF

	| marsRover |
	
	marsRover := MarsRover startsAt: 0@0 headingAt: East.
	
	marsRover process: 'f'.
	
	self assert: (marsRover isAtPosition: 1@0 heading: East).  

	! !

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 16:03:58'!
test13RoverStartingAtEastChangesPositionWhenRecievesCommandB

	| marsRover |
	
	marsRover := MarsRover startsAt: 0@0 headingAt: East.
	
	marsRover process: 'b'.
	
	self assert: (marsRover isAtPosition: -1@0 heading: East).  

	! !

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 16:04:03'!
test14RoverStartingAtNorthChangesPositionWhenRecievesCommandF

	| marsRover |
	
	marsRover := MarsRover startsAt: 0@0 headingAt: North.
	
	marsRover process: 'f'.
	
	self assert: (marsRover isAtPosition: 0@1 heading: North).  

	! !

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 16:04:06'!
test15RoverStartingAtNorthChangesPositionWhenRecievesCommandB

	| marsRover |
	
	marsRover := MarsRover startsAt: 0@0 headingAt: North.
	
	marsRover process: 'b'.
	
	self assert: (marsRover isAtPosition: 0@-1 heading: North).  

	! !

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 16:04:09'!
test16RoverStartingAtWestChangesPositionWhenRecievesCommandF

	| marsRover |
	
	marsRover := MarsRover startsAt: 0@0 headingAt: West.
	
	marsRover process: 'f'.
	
	self assert: (marsRover isAtPosition: -1@0 heading: West).  

	! !

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 16:04:12'!
test17RoverStartingAtWestChangesPositionWhenRecievesCommandB

	| marsRover |
	
	marsRover := MarsRover startsAt: 0@0 headingAt: West.
	
	marsRover process: 'b'.
	
	self assert: (marsRover isAtPosition: 1@0 heading: West).  

	! !

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 12:00:59'!
test18RoverStartingAtAnyPositionChangePositionWhenRecievesACommand

	| marsRover |
	
	marsRover := MarsRover startsAt: 5@5 headingAt: North.
	
	marsRover process: 'b'.
	
	self assert: (marsRover isAtPosition: 5@4 heading: North).  

	! !

!MarsRoverTests methodsFor: 'testing' stamp: 'FG 5/14/2022 16:07:04'!
test19RoverMovesWhenReceivesMoreThanOneCommand

	| marsRover |
	
	marsRover := MarsRover startsAt: 0@0 headingAt: North.
	
	marsRover process: 'frfffllllbffb'.
	
	self assert: (marsRover isAtPosition: 3@1 heading: East).  

	! !


!classDefinition: #Heading category: 'MarsRover'!
Object subclass: #Heading
	instanceVariableNames: 'marsRover'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!Heading methodsFor: 'initialization' stamp: 'FG 5/14/2022 11:34:24'!
initializeFor: aMarsRoverToBeHeadingOf

	marsRover := aMarsRoverToBeHeadingOf.! !


!Heading methodsFor: 'processing' stamp: 'FG 5/14/2022 11:18:44'!
process: aCommand

	^self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Heading class' category: 'MarsRover'!
Heading class
	instanceVariableNames: ''!

!Heading class methodsFor: 'instance creation' stamp: 'FG 5/14/2022 11:30:35'!
for: aMarsRover

	self subclassResponsibility.! !


!classDefinition: #East category: 'MarsRover'!
Heading subclass: #East
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!East methodsFor: 'processing' stamp: 'FG 5/14/2022 15:52:58'!
process: aCommand
	(aCommand = $f)  ifTrue: [marsRover moveForwardEast].
	(aCommand = $b) ifTrue: [marsRover moveBackwardEast].
	(aCommand = $r) ifTrue: [marsRover turnToSouth].
	(aCommand = $l) ifTrue: [marsRover turnToNorth].
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'East class' category: 'MarsRover'!
East class
	instanceVariableNames: ''!

!East class methodsFor: 'instance creation' stamp: 'FG 5/14/2022 11:35:54'!
for: aMarsRoverToBeHeadingOf

	^self new initializeFor: aMarsRoverToBeHeadingOf.! !


!classDefinition: #North category: 'MarsRover'!
Heading subclass: #North
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!North methodsFor: 'processing' stamp: 'FG 5/14/2022 15:53:18'!
process: aCommand
	(aCommand = $f) ifTrue: [marsRover moveForwardNorth].
	(aCommand = $b) ifTrue: [marsRover moveBackwardNorth].
	(aCommand = $r) ifTrue: [marsRover turnToEast ].
	(aCommand = $l) ifTrue: [marsRover turnToWest ].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'North class' category: 'MarsRover'!
North class
	instanceVariableNames: ''!

!North class methodsFor: 'instance creation' stamp: 'FG 5/14/2022 11:35:58'!
for: aMarsRoverToBeHeadingOf

	^self new initializeFor: aMarsRoverToBeHeadingOf.! !


!classDefinition: #South category: 'MarsRover'!
Heading subclass: #South
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!South methodsFor: 'processing' stamp: 'FG 5/14/2022 15:53:35'!
process: aCommand
	
	(aCommand =$f) ifTrue: [marsRover moveForwardSouth].
	(aCommand = $b) ifTrue: [marsRover moveBackwardSouth].
	(aCommand = $r) ifTrue: [marsRover turnToWest].
	(aCommand = $l) ifTrue: [marsRover turnToEast].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'South class' category: 'MarsRover'!
South class
	instanceVariableNames: ''!

!South class methodsFor: 'instance creation' stamp: 'FG 5/14/2022 11:36:03'!
for: aMarsRoverToBeHeadingOf

	^self new initializeFor: aMarsRoverToBeHeadingOf.! !


!classDefinition: #West category: 'MarsRover'!
Heading subclass: #West
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!West methodsFor: 'processing' stamp: 'FG 5/14/2022 15:53:50'!
process: aCommand
	
	(aCommand = $f) ifTrue: [marsRover moveForwardWest].
	(aCommand = $b) ifTrue: [marsRover moveBackwardWest].
	(aCommand = $r) ifTrue: [marsRover turnToNorth ].
	(aCommand = $l) ifTrue: [marsRover turnToSouth ].
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'West class' category: 'MarsRover'!
West class
	instanceVariableNames: ''!

!West class methodsFor: 'instance creation' stamp: 'FG 5/14/2022 11:36:08'!
for: aMarsRoverToBeHeadingOf

	^self new initializeFor: aMarsRoverToBeHeadingOf.! !


!classDefinition: #MarsRover category: 'MarsRover'!
Object subclass: #MarsRover
	instanceVariableNames: 'heading position'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRover methodsFor: 'processing' stamp: 'FG 5/14/2022 15:52:07'!
process: aListOfCommandsToProcess 
	
	aListOfCommandsToProcess isEmpty ifTrue: [^self.].
	aListOfCommandsToProcess do: [:aCommandToProcess | heading process: aCommandToProcess ].! !


!MarsRover methodsFor: 'testing' stamp: 'FG 5/14/2022 10:51:25'!
isAtPosition: aPosition heading: aDirectionClass 
	^aPosition = position and: [heading isKindOf: aDirectionClass].! !


!MarsRover methodsFor: 'initialization' stamp: 'FG 5/14/2022 12:02:24'!
initializeStartsAt: aStartingPosition headingAt: aStartingHeadingClass 
	position := aStartingPosition.
	heading := aStartingHeadingClass for: self.! !


!MarsRover methodsFor: 'turning - private' stamp: 'FG 5/14/2022 11:29:45'!
turnToEast

	heading  := East for: self.! !

!MarsRover methodsFor: 'turning - private' stamp: 'FG 5/14/2022 11:52:00'!
turnToNorth

	heading  := North for: self.! !

!MarsRover methodsFor: 'turning - private' stamp: 'FG 5/14/2022 11:52:09'!
turnToSouth

	heading  := South for: self.! !

!MarsRover methodsFor: 'turning - private' stamp: 'FG 5/14/2022 11:38:22'!
turnToWest

	heading  := West for: self.! !


!MarsRover methodsFor: 'moving - private' stamp: 'FG 5/14/2022 16:00:32'!
moveBackwardEast

	self moveForwardWest.! !

!MarsRover methodsFor: 'moving - private' stamp: 'FG 5/14/2022 16:00:47'!
moveBackwardNorth

	self moveForwardSouth .! !

!MarsRover methodsFor: 'moving - private' stamp: 'FG 5/14/2022 16:01:03'!
moveBackwardSouth

	self moveForwardNorth.! !

!MarsRover methodsFor: 'moving - private' stamp: 'FG 5/14/2022 16:01:23'!
moveBackwardWest

	self moveForwardEast.! !

!MarsRover methodsFor: 'moving - private' stamp: 'FG 5/14/2022 15:39:23'!
moveForwardEast

	position := position + (1@0).! !

!MarsRover methodsFor: 'moving - private' stamp: 'FG 5/14/2022 15:39:33'!
moveForwardNorth

	position := position + (0@1).! !

!MarsRover methodsFor: 'moving - private' stamp: 'FG 5/14/2022 15:39:40'!
moveForwardSouth

	position := position + (0@-1).! !

!MarsRover methodsFor: 'moving - private' stamp: 'FG 5/14/2022 15:39:50'!
moveForwardWest

	position := position + (-1@0).! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRover'!
MarsRover class
	instanceVariableNames: ''!

!MarsRover class methodsFor: 'instance creation' stamp: 'FG 5/14/2022 12:01:57'!
startsAt: aStartingPosition headingAt: aStartingHeadingClass 
	^self new initializeStartsAt: aStartingPosition headingAt: aStartingHeadingClass ! !
