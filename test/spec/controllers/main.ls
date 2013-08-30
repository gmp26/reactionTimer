'use strict'

describe 'Controller: MainCtrl', (_) ->

  var MainCtrl
  var scope
  var $timeout
  const idle = 'idle'
  const hidden = 'hidden'
  const timing = 'timing'

  beforeEach module 'ngMock'

  # load the controller's module
  beforeEach module 'reactionTimerApp'

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope, _$timeout_, $window) ->

    scope := $rootScope.$new!
    $timeout := _$timeout_
    MainCtrl := $controller 'MainCtrl', {
      $scope: scope,
      $timeout: $timeout
      $window: $window
    }

  it 'should start idle with all options off', ->
    expect scope.options .toEqual {
      size: false
      shape: 0
      turning: false
      location: false
      colour: 0
      onstar: 0
      penalties: false
    }
    expect scope.state.phase .toEqual idle

  it 'should hide the star on an idle click, then reappear', ->
    scope.state.phase = idle
    scope.stageClick!
    expect scope.state.phase .toBe hidden
    expect scope.display.sprite .toBe 'icon-none'

    $timeout.flush!
    expect scope.state.phase .toBe timing
    expect scope.display.sprite .toBe 'icon-star'

  it 'after reappearance it should log time and go idle on click', ->
    scope.state.phase = idle
    scope.stageClick!
    $timeout.flush!

    # pretend that 500ms has elapsed
    scope.state.startTime -= 500
    scope.stageClick!
    expect scope.display.ms .toBe 500
    expect scope.state.phase .toBe idle
    expect scope.display.penalties .toBe 0

  it 'should log penalties if clicked while hidden', ->
    scope.state.phase = hidden
    oops = 3
    for i til oops
      scope.stageClick!
    expect scope.display.penalties .toBe oops

  it 'should clear penalties after cycle has stopped', ->
    scope.display.penalties = 6
    scope.stop!
    expect scope.display.penalties .toBe 0

  it 'should clear display and state on reset', ->
    scope.setDisplay {
      sprite: 'icon-none'
      ms: 1000
      penalties: 20
      size: 200
      times: [1,2,2]
      message: 'oops!'
    }
    scope.setState {
      phase: hidden
      startTime: 2000
    }
    scope.reset!
    expect scope.display .toEqual {
      sprite: 'icon-star'
      ms: '?'
      penalties: 0
      size: 50
      times: []
      message: ''
    }
    expect scope.state .toEqual {
      phase: idle
      startTime: 0
    }

  it 'should maintain a millisecond count in timing phase', ->
    spyOn scope, 'updateTime'
    scope.reappear!
    $timeout.flush!
    expect scope.updateTime .toHaveBeenCalled!
    scope.reset!

  describe 'scope.randInt', (_) ->
    it 'should generate random numbers in given range', ->
      r = scope.randInt
      expect r 3 5 0 .toEqual 3
      expect r 3 5 1 .toEqual 5
      expect r 3 5 0.5 .toEqual 4
      expect r 3 5 0.8 .toEqual 4.6
      expect r 3 5 0.24 .toEqual 3.48

