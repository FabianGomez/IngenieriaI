!classDefinition: #MarsRoverLoggerTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverLoggerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverLoggerTest methodsFor: 'setup' stamp: 'FG 6/2/2022 11:39:58'!
createLoggerFollowingHeadingOn: marsRover

	^ MarsRoverLogger followHeadingChangesOn: marsRover! !

!MarsRoverLoggerTest methodsFor: 'setup' stamp: 'FG 6/2/2022 11:39:31'!
createLoggerFollowingPositionOn: marsRover

	^ MarsRoverLogger followPositionChangesOn: marsRover! !

!MarsRoverLoggerTest methodsFor: 'setup' stamp: 'FG 6/2/2022 11:54:44'!
createMarsRoverHeadingEast

	^MarsRover at: 1@1 heading: MarsRoverHeadingEast.
	
! !

!MarsRoverLoggerTest methodsFor: 'setup' stamp: 'FG 6/2/2022 11:38:22'!
createMarsRoverHeadingNorth

	^ MarsRover at: 1@1 heading: MarsRoverHeadingNorth! !

!MarsRoverLoggerTest methodsFor: 'setup' stamp: 'FG 6/2/2022 11:56:13'!
createMarsRoverProxyOf: aMarsRover 
	
	^MarsRoverProxy of: aMarsRover ! !


!MarsRoverLoggerTest methodsFor: 'test' stamp: 'FG 6/2/2022 11:55:38'!
test01LoggerOverPositionChangesShouldBeEmptyAfterProcesingEmptyCommand

	| marsRover proxy logger |
	
	marsRover := self createMarsRoverHeadingNorth.
	proxy := self createMarsRoverProxyOf: marsRover.
	logger := self createLoggerFollowingPositionOn: proxy.
	
	marsRover process: ''.
	
	self assert: logger readStream atEnd.! !

!MarsRoverLoggerTest methodsFor: 'test' stamp: 'FG 6/2/2022 11:56:46'!
test02LoggerOverPositionChangesShouldLogNewPositionAfterMovingToTheNorth

	| marsRover logger logStream proxy |
	
	marsRover := self createMarsRoverHeadingNorth.
	proxy := self createMarsRoverProxyOf: marsRover.
	logger := self createLoggerFollowingPositionOn: proxy.
		
	marsRover process: 'f'.
	
	logStream := logger readStream.
	self assert: '1@2' equals: logStream nextLine.
	self assert: logStream atEnd.
! !

!MarsRoverLoggerTest methodsFor: 'test' stamp: 'FG 6/2/2022 11:57:00'!
test03LoggerOverPositionChangesShouldLogNewPositionAfterMovingToTheShouth

	| marsRover logger logStream proxy |
	
	marsRover := self createMarsRoverHeadingNorth.
	proxy := self createMarsRoverProxyOf: marsRover.
	logger := self createLoggerFollowingPositionOn: proxy.
	
	marsRover process: 'b'.
	
	logStream := logger readStream.
	self assert: '1@0' equals: logStream nextLine.
	self assert: logStream atEnd.
! !

!MarsRoverLoggerTest methodsFor: 'test' stamp: 'FG 6/2/2022 11:57:20'!
test04LoggerOverPositionChangesShouldLogNewPositionAfterMovingToTheEastAndWest

	| marsRover logger logStream proxy |
	
	marsRover := self createMarsRoverHeadingEast.
	proxy := self createMarsRoverProxyOf: marsRover.
	logger := self createLoggerFollowingPositionOn: proxy.
	
	marsRover process: 'fb'.
	
	logStream := logger readStream.
	self assert: '2@1' equals: logStream nextLine.
	self assert: '1@1' equals: logStream nextLine.
	self assert: logStream atEnd.

! !

!MarsRoverLoggerTest methodsFor: 'test' stamp: 'FG 6/2/2022 11:57:36'!
test05LoggerOverHeadingChangesShouldLogNewHeadingAfterRotateToTheEast

	| marsRover logger logStream proxy |
	
	marsRover := self createMarsRoverHeadingNorth.
	proxy := self createMarsRoverProxyOf: marsRover.
	logger := self createLoggerFollowingHeadingOn: proxy.
	
	marsRover process: 'r'.
	
	logStream := logger readStream.
	self assert: 'East' equals: logStream nextLine.
	self assert: logStream atEnd.

! !

!MarsRoverLoggerTest methodsFor: 'test' stamp: 'FG 6/2/2022 11:57:53'!
test06LoggerOverHeadingChangesShouldLogNewHeadingAfterRotateToTheSouth

	| marsRover logger logStream proxy |
	
	marsRover := self createMarsRoverHeadingEast.
	proxy := self createMarsRoverProxyOf: marsRover.
	logger := self createLoggerFollowingHeadingOn: proxy.
	
	marsRover process: 'r'.
	
	logStream := logger readStream.
	self assert: 'South' equals: logStream nextLine.
	self assert: logStream atEnd.

! !

!MarsRoverLoggerTest methodsFor: 'test' stamp: 'FG 6/2/2022 11:57:59'!
test07LoggerOverHeadingChangesShouldLogNewHeadingAfterFullRotation

	| marsRover logger logStream proxy |
	
	marsRover := self createMarsRoverHeadingEast.
	proxy := self createMarsRoverProxyOf: marsRover.
	logger := self createLoggerFollowingHeadingOn: proxy.
	
	marsRover process: 'rrrr'.
	
	logStream := logger readStream.
	self assert: 'South' equals: logStream nextLine.
	self assert: 'West' equals: logStream nextLine.
	self assert: 'North' equals: logStream nextLine.
	self assert: 'East' equals: logStream nextLine.
	self assert: logStream atEnd.

! !

!MarsRoverLoggerTest methodsFor: 'test' stamp: 'FG 6/2/2022 11:58:16'!
test08LoggerOverHeadingAndPositionChangesShouldLogAllChanges

	| marsRover logger logStream proxy |
	
	marsRover := self createMarsRoverHeadingNorth .
	proxy := self createMarsRoverProxyOf: marsRover.
	logger := MarsRoverLogger followHeadingAndPositionChangesOn: proxy.
	
	marsRover process: 'frfr'.
	
	logStream := logger readStream.
	self assert: '1@2' equals: logStream nextLine.
	self assert: 'East' equals: logStream nextLine.
	self assert: '2@2' equals: logStream nextLine.
	self assert: 'South' equals: logStream nextLine.
	self assert: logStream atEnd.

! !


!classDefinition: #MarsRoverTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:21:23'!
test01DoesNotMoveWhenNoCommand

	self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: '' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:12'!
test02IsAtFailsForDifferentPosition

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@2 heading: self north)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:31'!
test03IsAtFailsForDifferentHeading

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@1 heading: self south)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:17'!
test04IncrementsYAfterMovingForwardWhenHeadingNorth

	self 
		assertIsAt: 1@3 
		heading: self north 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:11'!
test06DecrementsYAfterMovingBackwardsWhenHeadingNorth

	self 
		assertIsAt: 1@1 
		heading: self north 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:59'!
test07PointToEashAfterRotatingRightWhenHeadingNorth

	self 
		assertIsAt: 1@2 
		heading: self east 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:51'!
test08PointsToWestAfterRotatingLeftWhenPointingNorth

	self 
		assertIsAt: 1@2 
		heading: self west 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:45'!
test09DoesNotProcessInvalidCommand

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: self north.
	
	self 
		should: [ marsRover process: 'x' ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: marsRover invalidCommandErrorDescription.
			self assert: (marsRover isAt: 1@2 heading: self north) ]! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:39'!
test10CanProcessMoreThanOneCommand

	self 
		assertIsAt: 1@4 
		heading: self north 
		afterProcessing: 'ff' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:31'!
test11IncrementsXAfterMovingForwareWhenHeadingEast

	self 
		assertIsAt: 2@2 
		heading: self east 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:19'!
test12DecrementsXAfterMovingBackwardWhenHeadingEast

	self 
		assertIsAt: 0@2 
		heading: self east 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:14'!
test13PointsToSouthAfterRotatingRightWhenHeadingEast

		self 
		assertIsAt: 1@2 
		heading: self south 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:05'!
test14PointsToNorthAfterRotatingLeftWhenPointingEast

		self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:00'!
test15ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingSouth

	self 
		assertIsAt: 1@1 
		heading: self west 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self south 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:52'!
test16ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingWest

	self 
		assertIsAt: 0@2 
		heading: self north 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self west 
! !


!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:31'!
east

	^ MarsRoverHeadingEast ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:38'!
north

	^ MarsRoverHeadingNorth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:45'!
south

	^ MarsRoverHeadingSouth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:54'!
west

	^ MarsRoverHeadingWest ! !


!MarsRoverTest methodsFor: 'assertions' stamp: 'HAW 10/7/2021 20:20:47'!
assertIsAt: newPosition heading: newHeadingType afterProcessing: commands whenStartingAt: startPosition heading: startHeadingType

	| marsRover |
	
	marsRover := MarsRover at: startPosition heading: startHeadingType. 
	
	marsRover process: commands.
	
	self assert: (marsRover isAt: newPosition heading: newHeadingType)! !


!classDefinition: #MarsRoverTrackerTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverTrackerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverTrackerTest methodsFor: 'test' stamp: 'FG 6/2/2022 12:04:44'!
test01SeveralTrackersOverPositionChangesShouldNotifyAllChanges

	| marsRover logger window logStream proxy |
	
	marsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth .
	proxy := MarsRoverProxy of: marsRover.
	logger := MarsRoverLogger followPositionChangesOn: proxy.
	window := MarsRoverWindow followPositionChangesOn: proxy.

	marsRover process: 'ff'.
	
	logStream := logger readStream.
	self assert: '1@2' equals: logStream nextLine.
	self assert: '1@3' equals: logStream nextLine.
	self assert: logStream atEnd.
	
	self assert: '1@3' equals: window position.! !

!MarsRoverTrackerTest methodsFor: 'test' stamp: 'FG 6/2/2022 12:05:28'!
test02SeveralTrackersOverHeadingChangesShouldNotifyAllChanges

	| marsRover logger window logStream proxy |
	
	marsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth .
	proxy := MarsRoverProxy of: marsRover.
	logger := MarsRoverLogger followHeadingChangesOn: proxy.
	window := MarsRoverWindow followHeadingChangesOn: proxy.

	marsRover process: 'rr'.
	
	logStream := logger readStream.
	self assert: 'East' equals: logStream nextLine.
	self assert: 'South' equals: logStream nextLine.
	self assert: logStream atEnd.
	
	self assert: 'Apuntando al Sur' equals: window heading.! !


!classDefinition: #MarsRoverWindowTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverWindowTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverWindowTest methodsFor: 'test' stamp: 'FG 6/2/2022 11:59:24'!
test01WindowOverPositionChangesReturnsEmptyPositionAfterProcesingEmptyCommand

	| marsRover window proxy |
	
	marsRover := self createMarsRoverHeadingNorth.
	proxy := self createMarsRoverProxyOf: marsRover.
	window := self createWindowFollowingPositionOn: proxy.
	
	marsRover process: ''.
	
	self assert: '' equals: window position.	! !

!MarsRoverWindowTest methodsFor: 'test' stamp: 'FG 6/2/2022 12:00:04'!
test02WindowOverPositionChangesReturnsNewPositionAfterMovingToTheNorth

	| marsRover window proxy |
	
	marsRover := self createMarsRoverHeadingNorth.
	proxy := self createMarsRoverProxyOf: marsRover.
	window := self createWindowFollowingPositionOn: proxy.
	
	marsRover process: 'f'.
	
	self assert: '1@2' equals: window position.	! !

!MarsRoverWindowTest methodsFor: 'test' stamp: 'FG 6/2/2022 12:00:13'!
test03WindowOverPositionChangesReturnsNewPositionAfterMovingToTheSouth

	| marsRover window proxy |
	
	marsRover := self createMarsRoverHeadingNorth.
	proxy := self createMarsRoverProxyOf: marsRover.
	window := self createWindowFollowingPositionOn: proxy.
	
	marsRover process: 'b'.
	
	self assert: '1@0' equals: window position.	! !

!MarsRoverWindowTest methodsFor: 'test' stamp: 'FG 6/2/2022 12:00:21'!
test04WindowOverPositionChangesReturnsNewPositionAfterMovingToTheEastAndWest

	| marsRover window proxy |
	
	marsRover := self createMarsRoverHeadingEast.
	proxy := self createMarsRoverProxyOf: marsRover.
	window := self createWindowFollowingPositionOn: proxy.
		
	marsRover process: 'f'.
	
	self assert: '2@1' equals: window position.	
	
	marsRover process: 'b'.
	
	self assert: '1@1' equals: window position.	! !

!MarsRoverWindowTest methodsFor: 'test' stamp: 'FG 6/2/2022 12:00:49'!
test05WindowOverHeadingChangesReturnsEmptyHeadingAfterProcesingEmptyCommand

	| marsRover window proxy |
	
	marsRover := self createMarsRoverHeadingNorth.
	proxy := self createMarsRoverProxyOf: marsRover.
	window := self createWindowFollowingHeadingOn: proxy.
	
	marsRover process: ''.
	
	self assert: '' equals: window heading.	
	self assert: '' equals: window position.	! !

!MarsRoverWindowTest methodsFor: 'test' stamp: 'FG 6/2/2022 12:00:57'!
test06WindowOverHeadingChangesReturnsNewHeadingAfterRotateToTheEast

	| marsRover window proxy |
	
	marsRover := self createMarsRoverHeadingNorth.
	proxy := self createMarsRoverProxyOf: marsRover.
	window := self createWindowFollowingHeadingOn: proxy.
	
	marsRover process: 'r'.
	
	self assert: 'Apuntando al Este' equals: window heading.	
	self assert: '' equals: window position.	! !

!MarsRoverWindowTest methodsFor: 'test' stamp: 'FG 6/2/2022 12:01:03'!
test07WindowOverHeadingChangesReturnsNewHeadingAfterRotateToTheSouth

	| marsRover window proxy |
	
	marsRover := self createMarsRoverHeadingEast.
	proxy := self createMarsRoverProxyOf: marsRover.
	window := self createWindowFollowingHeadingOn: proxy.
	
	marsRover process: 'r'.
	
	self assert: 'Apuntando al Sur' equals: window heading.	
	self assert: '' equals: window position.	! !

!MarsRoverWindowTest methodsFor: 'test' stamp: 'FG 6/2/2022 12:01:10'!
test08WindowOverHeadingChangesReturnsNewHeadingAfterRotateToTheNorthAndWest

	| marsRover window proxy |
	
	marsRover := self createMarsRoverHeadingSouth.
	proxy := self createMarsRoverProxyOf: marsRover.
	window := self createWindowFollowingHeadingOn: proxy.
	
	marsRover process: 'r'.
	
	self assert: 'Apuntando al Oeste' equals: window heading.	
	self assert: '' equals: window position.	
		
	marsRover process: 'r'.
	
	self assert: 'Apuntando al Norte' equals: window heading.	
	self assert: '' equals: window position.	! !

!MarsRoverWindowTest methodsFor: 'test' stamp: 'FG 6/2/2022 12:01:23'!
test09WindowOverHeadingAndPositionChangesShouldChangeBothVariables

	| marsRover window proxy |
	
	marsRover := self createMarsRoverHeadingSouth.
	proxy := self createMarsRoverProxyOf: marsRover.
	window := MarsRoverWindow followHeadingAndPositionChangesOn: proxy.
	
	marsRover process: 'r'.
	
	self assert: 'Apuntando al Oeste' equals: window heading.	
	self assert: '' equals: window position.	

	marsRover process: 'f'.
	
	self assert: 'Apuntando al Oeste' equals: window heading.	
	self assert: '0@1' equals: window position.	! !


!MarsRoverWindowTest methodsFor: 'setup' stamp: 'FG 6/2/2022 11:29:57'!
createMarsRoverHeadingEast

	^ MarsRover at: 1@1 heading: MarsRoverHeadingEast! !

!MarsRoverWindowTest methodsFor: 'setup' stamp: 'FG 6/2/2022 11:29:00'!
createMarsRoverHeadingNorth

	^ MarsRover at: 1@1 heading: MarsRoverHeadingNorth! !

!MarsRoverWindowTest methodsFor: 'setup' stamp: 'FG 6/2/2022 11:29:32'!
createMarsRoverHeadingSouth

	^ MarsRover at: 1@1 heading: MarsRoverHeadingSouth! !

!MarsRoverWindowTest methodsFor: 'setup' stamp: 'FG 6/2/2022 11:59:48'!
createMarsRoverProxyOf: aMarsRover 

	^MarsRoverProxy of: aMarsRover.! !

!MarsRoverWindowTest methodsFor: 'setup' stamp: 'FG 6/2/2022 11:36:22'!
createWindowFollowingHeadingOn: marsRover

	^ MarsRoverWindow followHeadingChangesOn: marsRover! !

!MarsRoverWindowTest methodsFor: 'setup' stamp: 'FG 6/2/2022 11:35:52'!
createWindowFollowingPositionOn: marsRover

	^ MarsRoverWindow followPositionChangesOn: marsRover! !


!classDefinition: #MarsRover category: 'MarsRover-WithHeading'!
Object subclass: #MarsRover
	instanceVariableNames: 'position head proxy'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:48:45'!
invalidCommandErrorDescription
	
	^'Invalid command'! !

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:50:26'!
signalInvalidCommand
	
	self error: self invalidCommandErrorDescription ! !


!MarsRover methodsFor: 'initialization' stamp: 'FG 6/2/2022 12:08:04'!
initializeAt: aPosition heading: aHeadingType

	position := aPosition.
	head := aHeadingType for: self.
	proxy := MarsRoverProxyNullObject new.! !


!MarsRover methodsFor: 'heading' stamp: 'FG 6/2/2022 12:08:58'!
changeHeadingAndNotifyChanges: AMarsRoverHeadingClassToUpdate

	head := AMarsRoverHeadingClassToUpdate for: self.
	proxy headingChangedTo: head.! !

!MarsRover methodsFor: 'heading' stamp: 'FG 5/31/2022 18:37:55'!
headEast

	self changeHeadingAndNotifyChanges: MarsRoverHeadingEast! !

!MarsRover methodsFor: 'heading' stamp: 'FG 5/31/2022 18:38:14'!
headNorth
	
	self changeHeadingAndNotifyChanges: MarsRoverHeadingNorth! !

!MarsRover methodsFor: 'heading' stamp: 'FG 5/31/2022 18:38:24'!
headSouth
	
	self changeHeadingAndNotifyChanges: MarsRoverHeadingSouth! !

!MarsRover methodsFor: 'heading' stamp: 'FG 5/31/2022 18:38:32'!
headWest
	
	self changeHeadingAndNotifyChanges: MarsRoverHeadingWest! !

!MarsRover methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	head rotateLeft! !

!MarsRover methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	head rotateRight! !


!MarsRover methodsFor: 'testing' stamp: 'HAW 10/7/2021 20:16:32'!
isAt: aPosition heading: aHeadingType

	^position = aPosition and: [ head isHeading: aHeadingType ]! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:51'!
isBackwardCommand: aCommand

	^aCommand = $b! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:19'!
isForwardCommand: aCommand

	^aCommand = $f ! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:51'!
isRotateLeftCommand: aCommand

	^aCommand = $l! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:21'!
isRotateRightCommand: aCommand

	^aCommand = $r! !


!MarsRover methodsFor: 'moving' stamp: 'FG 6/2/2022 12:08:14'!
changePositionAndNotifyChanges: aPositionToBeAdded

	position := position + aPositionToBeAdded.
	proxy positionChangedTo: position.! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	head moveBackward! !

!MarsRover methodsFor: 'moving' stamp: 'FG 6/1/2022 19:10:35'!
moveEast

	self changePositionAndNotifyChanges: 1@0.! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	head moveForward! !

!MarsRover methodsFor: 'moving' stamp: 'FG 6/1/2022 19:10:35'!
moveNorth

	self changePositionAndNotifyChanges: (0@1).! !

!MarsRover methodsFor: 'moving' stamp: 'FG 6/1/2022 19:10:35'!
moveSouth

	self changePositionAndNotifyChanges: (0@-1).! !

!MarsRover methodsFor: 'moving' stamp: 'FG 6/1/2022 19:10:35'!
moveWest

	self changePositionAndNotifyChanges: (-1@0).	! !


!MarsRover methodsFor: 'command processing' stamp: 'FG 6/1/2022 19:57:26'!
position 

	^position.
! !

!MarsRover methodsFor: 'command processing' stamp: 'HAW 6/30/2018 19:48:26'!
process: aSequenceOfCommands

	aSequenceOfCommands do: [:aCommand | self processCommand: aCommand ]
! !

!MarsRover methodsFor: 'command processing' stamp: 'HAW 8/22/2019 12:08:50'!
processCommand: aCommand

	(self isForwardCommand: aCommand) ifTrue: [ ^ self moveForward ].
	(self isBackwardCommand: aCommand) ifTrue: [ ^ self moveBackward ].
	(self isRotateRightCommand: aCommand) ifTrue: [ ^ self rotateRight ].
	(self isRotateLeftCommand: aCommand) ifTrue: [ ^ self rotateLeft ].

	self signalInvalidCommand.! !


!MarsRover methodsFor: 'proxy' stamp: 'FG 6/2/2022 11:45:38'!
proxeeOf: aMarsRoverProxy

	proxy := aMarsRoverProxy.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRover-WithHeading'!
MarsRover class
	instanceVariableNames: 'headings'!

!MarsRover class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:10:30'!
at: aPosition heading: aHeadingType
	
	^self new initializeAt: aPosition heading: aHeadingType! !


!classDefinition: #MarsRoverHeading category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverHeading
	instanceVariableNames: 'marsRover'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'testing' stamp: 'HAW 10/7/2021 20:15:38'!
isHeading: aHeadingType

	^self isKindOf: aHeadingType ! !


!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'initialization' stamp: 'HAW 10/7/2021 20:11:59'!
initializeFor: aMarsRover 
	
	marsRover := aMarsRover.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverHeading class' category: 'MarsRover-WithHeading'!
MarsRoverHeading class
	instanceVariableNames: ''!

!MarsRoverHeading class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:11:35'!
for: aMarsRover 
	
	^self new initializeFor: aMarsRover ! !


!classDefinition: #MarsRoverHeadingEast category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingEast
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveWest! !

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveEast! !


!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headNorth! !

!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headSouth! !


!MarsRoverHeadingEast methodsFor: 'logging visitor' stamp: 'FG 5/31/2022 07:43:32'!
accept: aVisitor 
	
	^aVisitor visitMarsRoverHeadingEast: self! !


!classDefinition: #MarsRoverHeadingNorth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingNorth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveSouth! !

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveNorth! !


!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headWest! !

!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headEast! !


!MarsRoverHeadingNorth methodsFor: 'logging visitor' stamp: 'FG 5/31/2022 07:57:28'!
accept: aVisitor 
	
	^aVisitor visitMarsRoverHeadingNorth: self! !


!classDefinition: #MarsRoverHeadingSouth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingSouth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveNorth! !

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveSouth! !


!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headEast! !

!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headWest! !


!MarsRoverHeadingSouth methodsFor: 'logging visitor' stamp: 'FG 5/31/2022 07:54:25'!
accept: aVisitor 
	
	^aVisitor visitMarsRoverHeadingSouth: self! !


!classDefinition: #MarsRoverHeadingWest category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingWest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	^marsRover moveEast! !

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveWest! !


!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headSouth! !

!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headNorth! !


!MarsRoverHeadingWest methodsFor: 'logging visitor' stamp: 'FG 5/31/2022 07:57:53'!
accept: aVisitor 
	
	^aVisitor visitMarsRoverHeadingWest: self! !


!classDefinition: #MarsRoverProxy category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverProxy
	instanceVariableNames: 'headingTrackers positionTrackers proxee'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverProxy methodsFor: 'initialization' stamp: 'FG 6/2/2022 11:49:35'!
initializeOf: aMarsRover

	positionTrackers := OrderedCollection new.
	headingTrackers := OrderedCollection new.
	proxee := aMarsRover.
	aMarsRover proxeeOf: self.! !


!MarsRoverProxy methodsFor: 'tracking' stamp: 'FG 6/2/2022 11:42:09'!
followHeadingChangesWith: aMarsRoverTracker

	headingTrackers add: aMarsRoverTracker! !

!MarsRoverProxy methodsFor: 'tracking' stamp: 'FG 6/2/2022 11:42:22'!
followPositionChangesWith: aMarsRoverTracker
	
	positionTrackers add: aMarsRoverTracker.! !

!MarsRoverProxy methodsFor: 'tracking' stamp: 'FG 6/2/2022 11:48:19'!
headingChangedTo: aHeading

	headingTrackers do: [:aHeadingTracker | aHeadingTracker headingChangedTo: aHeading ]! !

!MarsRoverProxy methodsFor: 'tracking' stamp: 'FG 6/2/2022 11:47:46'!
positionChangedTo: aPosition

	positionTrackers do: [:aPositionTracker | aPositionTracker positionChangedTo: aPosition ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverProxy class' category: 'MarsRover-WithHeading'!
MarsRoverProxy class
	instanceVariableNames: ''!

!MarsRoverProxy class methodsFor: 'instance creation' stamp: 'FG 6/2/2022 11:43:48'!
of: aMarsRover

	^ self new initializeOf: aMarsRover.! !


!classDefinition: #MarsRoverProxyNullObject category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverProxyNullObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverProxyNullObject methodsFor: 'tracking' stamp: 'FG 6/2/2022 12:07:16'!
headingChangedTo: aHeading

	^self! !

!MarsRoverProxyNullObject methodsFor: 'tracking' stamp: 'FG 6/2/2022 12:07:29'!
positionChangedTo: aPosition

	^self! !


!classDefinition: #MarsRoverTracker category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverTracker
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverTracker methodsFor: 'initialization' stamp: 'FG 5/31/2022 18:43:50'!
followHeadingAndPositionChangesOn: aMarsRoverToFollowPositionAndHeading 

	self subclassResponsibility ! !

!MarsRoverTracker methodsFor: 'initialization' stamp: 'FG 5/31/2022 18:44:24'!
followHeadingChangesOn: aMarsRoverToFollowHeading

	self subclassResponsibility ! !

!MarsRoverTracker methodsFor: 'initialization' stamp: 'FG 5/31/2022 18:44:01'!
followPositionChangesOn: aMarsRoverToFollowPosition 

	self subclassResponsibility ! !


!MarsRoverTracker methodsFor: 'events listener' stamp: 'FG 5/31/2022 18:42:51'!
headingChangedTo: aMarsRoverHeading

	self subclassResponsibility ! !

!MarsRoverTracker methodsFor: 'events listener' stamp: 'FG 5/31/2022 18:42:46'!
positionChangedTo: aPosition

	self subclassResponsibility ! !

!MarsRoverTracker methodsFor: 'events listener' stamp: 'FG 5/31/2022 18:42:10'!
visitMarsRoverHeadingEast: aMarsRoverHeadingEast 

	self subclassResponsibility ! !

!MarsRoverTracker methodsFor: 'events listener' stamp: 'FG 5/31/2022 18:42:26'!
visitMarsRoverHeadingNorth: aMarsRoverHeadingNorth

	self subclassResponsibility ! !

!MarsRoverTracker methodsFor: 'events listener' stamp: 'FG 5/31/2022 18:42:35'!
visitMarsRoverHeadingSouth: aMarsRoverHeadingSouth

	self subclassResponsibility ! !

!MarsRoverTracker methodsFor: 'events listener' stamp: 'FG 5/31/2022 18:42:19'!
visitMarsRoverHeadingWest: aMarsRoverHeadingWest 

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverTracker class' category: 'MarsRover-WithHeading'!
MarsRoverTracker class
	instanceVariableNames: ''!

!MarsRoverTracker class methodsFor: 'instance creation' stamp: 'FG 6/1/2022 18:09:50'!
of: aMarsRover 

	^self new of: aMarsRover ! !


!classDefinition: #MarsRoverLogger category: 'MarsRover-WithHeading'!
MarsRoverTracker subclass: #MarsRoverLogger
	instanceVariableNames: 'log'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverLogger methodsFor: 'initialization' stamp: 'FG 5/31/2022 08:05:14'!
followHeadingAndPositionChangesOn: aMarsRoverToFollowPositionAndHeading 
	
	aMarsRoverToFollowPositionAndHeading followHeadingChangesWith: self.
	aMarsRoverToFollowPositionAndHeading followPositionChangesWith: self.
! !

!MarsRoverLogger methodsFor: 'initialization' stamp: 'FG 5/31/2022 07:41:13'!
followHeadingChangesOn: aMarsRoverToFollowHeading
	
	aMarsRoverToFollowHeading followHeadingChangesWith: self! !

!MarsRoverLogger methodsFor: 'initialization' stamp: 'FG 5/31/2022 07:21:49'!
followPositionChangesOn: aMarsRoverToFollowPosition 
	
	aMarsRoverToFollowPosition followPositionChangesWith: self.! !

!MarsRoverLogger methodsFor: 'initialization' stamp: 'FG 5/31/2022 07:24:31'!
initialize

	log  := WriteStream on: ''! !


!MarsRoverLogger methodsFor: 'accessing' stamp: 'FG 5/31/2022 07:24:11'!
readStream
	
	^ReadStream on: log contents.! !


!MarsRoverLogger methodsFor: 'events listener' stamp: 'FG 5/31/2022 07:42:46'!
headingChangedTo: aMarsRoverHeading
	
	aMarsRoverHeading accept: self.! !

!MarsRoverLogger methodsFor: 'events listener' stamp: 'FG 5/31/2022 07:32:18'!
positionChangedTo: aPosition

	log print: aPosition; newLine! !

!MarsRoverLogger methodsFor: 'events listener' stamp: 'FG 5/31/2022 07:43:53'!
visitMarsRoverHeadingEast: aMarsRoverHeadingEast 
	
	log nextPutAll: 'East'; newLine! !

!MarsRoverLogger methodsFor: 'events listener' stamp: 'FG 5/31/2022 07:58:26'!
visitMarsRoverHeadingNorth: aMarsRoverHeadingNorth
	
	log nextPutAll: 'North'; newLine! !

!MarsRoverLogger methodsFor: 'events listener' stamp: 'FG 5/31/2022 07:54:46'!
visitMarsRoverHeadingSouth: aMarsRoverHeadingSouth
	
	log nextPutAll: 'South'; newLine! !

!MarsRoverLogger methodsFor: 'events listener' stamp: 'FG 5/31/2022 07:58:11'!
visitMarsRoverHeadingWest: aMarsRoverHeadingWest
	
	log nextPutAll: 'West'; newLine! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverLogger class' category: 'MarsRover-WithHeading'!
MarsRoverLogger class
	instanceVariableNames: ''!

!MarsRoverLogger class methodsFor: 'instance creation' stamp: 'FG 5/31/2022 08:04:06'!
followHeadingAndPositionChangesOn: aMarsRoverToFollowPositionAndHeading 
	
	^self new followHeadingAndPositionChangesOn: aMarsRoverToFollowPositionAndHeading ! !

!MarsRoverLogger class methodsFor: 'instance creation' stamp: 'FG 5/31/2022 07:40:46'!
followHeadingChangesOn: aMarsRoverToFollowHeading
	
	^self new followHeadingChangesOn: aMarsRoverToFollowHeading ! !

!MarsRoverLogger class methodsFor: 'instance creation' stamp: 'FG 5/31/2022 07:21:01'!
followPositionChangesOn: aMarsRoverToFollowPosition 

	^self new followPositionChangesOn: aMarsRoverToFollowPosition ! !


!classDefinition: #MarsRoverWindow category: 'MarsRover-WithHeading'!
MarsRoverTracker subclass: #MarsRoverWindow
	instanceVariableNames: 'position heading'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverWindow methodsFor: 'initialization' stamp: 'FG 6/1/2022 19:51:27'!
followHeadingAndPositionChangesOn: aMarsRoverToFollowPositionAndHeading 
	
	aMarsRoverToFollowPositionAndHeading followHeadingChangesWith: self.
	aMarsRoverToFollowPositionAndHeading followPositionChangesWith: self.! !

!MarsRoverWindow methodsFor: 'initialization' stamp: 'FG 6/1/2022 19:51:45'!
followHeadingChangesOn: aMarsRoverToFollowHeading
	
	aMarsRoverToFollowHeading followHeadingChangesWith: self. ! !

!MarsRoverWindow methodsFor: 'initialization' stamp: 'FG 5/31/2022 18:53:00'!
followPositionChangesOn: aMarsRoverToFollowPosition

	aMarsRoverToFollowPosition followPositionChangesWith: self.
	! !

!MarsRoverWindow methodsFor: 'initialization' stamp: 'FG 5/31/2022 15:08:41'!
initialize 

	position := ''.
	heading := ''.
	! !


!MarsRoverWindow methodsFor: 'accessing' stamp: 'FG 5/31/2022 15:07:42'!
heading
	
	^heading.! !

!MarsRoverWindow methodsFor: 'accessing' stamp: 'FG 5/31/2022 14:52:56'!
position
	
	^position! !


!MarsRoverWindow methodsFor: 'events listener' stamp: 'FG 6/1/2022 19:43:31'!
headingChangedTo: aMarsRoverHeading
	
	aMarsRoverHeading accept: self.! !

!MarsRoverWindow methodsFor: 'events listener' stamp: 'FG 5/31/2022 14:59:44'!
positionChangedTo: aPosition

	position := aPosition asString.! !

!MarsRoverWindow methodsFor: 'events listener' stamp: 'FG 5/31/2022 15:18:41'!
visitMarsRoverHeadingEast: aMarsRoverHeadingEast 
	
	heading := 'Apuntando al Este'.! !

!MarsRoverWindow methodsFor: 'events listener' stamp: 'FG 5/31/2022 15:23:45'!
visitMarsRoverHeadingNorth: aMarsRoverHeadingNorth
	
	heading := 'Apuntando al Norte'.! !

!MarsRoverWindow methodsFor: 'events listener' stamp: 'FG 5/31/2022 15:21:04'!
visitMarsRoverHeadingSouth: aMarsRoverHeadingSouth
	
	heading := 'Apuntando al Sur'.! !

!MarsRoverWindow methodsFor: 'events listener' stamp: 'FG 5/31/2022 15:23:24'!
visitMarsRoverHeadingWest: aMarsRoverHeadingWest
	
	heading := 'Apuntando al Oeste'.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverWindow class' category: 'MarsRover-WithHeading'!
MarsRoverWindow class
	instanceVariableNames: ''!

!MarsRoverWindow class methodsFor: 'instance creation' stamp: 'FG 5/31/2022 15:27:06'!
followHeadingAndPositionChangesOn: aMarsRover 
	
	^self new followHeadingAndPositionChangesOn: aMarsRover ! !

!MarsRoverWindow class methodsFor: 'instance creation' stamp: 'FG 5/31/2022 15:05:35'!
followHeadingChangesOn: aMarsRoverToFollowHeading 
	^self new followHeadingChangesOn: aMarsRoverToFollowHeading. ! !

!MarsRoverWindow class methodsFor: 'instance creation' stamp: 'FG 5/31/2022 14:51:27'!
followPositionChangesOn: aMarsRoverToFollowPosition 

	^self new followPositionChangesOn: aMarsRoverToFollowPosition ! !
