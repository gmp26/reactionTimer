'use strict'

angular.module 'reactionTimerApp'
  .controller 'MainCtrl', <[$scope $timeout]> ++ ($scope,$timeout) ->

    $scope.options = {
      size: false
      shape: 0
      turning: false
      location: false
      colour: 0
      onstar: 0
      penalties: false
    }
    options = $scope.options

    $scope.optionIcons = ->
      icon = (name) ->
        "<i class='icon-" + name + "'> </i>"
      s = ''
      s += icon 'fullscreen' if options.size
      s += icon 'asterisk' if options.shape != 0
      s += icon 'refresh' if options.turning
      s += icon 'move' if options.location
      s += icon 'tint' if options.colour != 0
      s += icon 'hand-up' if options.onstar != 0
      s += icon 'ban-circle' if options.penalties
      s

    $scope.display = {
      sprite: 'icon-star'
      ms: 0
      penalties: 0
      size: 50
      times: []
      message: ''
    }
    display = $scope.display

    const idle = 'idle'
    const hidden = 'hidden'
    const timing = 'timing'

    $scope.state = {
      phase: idle
      startTime: 0
    }
    state = $scope.state

    reset = $scope.reset = ->
      display.sprite = 'icon-star'
      display.ms = '?'
      display.penalties = 0
      display.size = 50
      display.times = []
      display.message = ''

      state.phase = idle
      state.startTime = 0

    reset!

    setDisplay = $scope.setDisplay = (obj) ->
      for key, value of obj
        display[key] = value

    setState = $scope.setState = (obj) ->
      for key, value of obj
        state[key] = value

    var timerId

    $scope.idle = ->
      if $scope.state.phase == idle
        'idling'
      else
        ''

    s1 = [
      'Click anywhere on the stage to make the star vanish, and click again when it reappears.'
      'Click on the star to make it vanish, and click on the star again when it reappears.'
    ]
    $scope.s1 = -> s1[options.onstar / 4]

    messages = [
      ''
      'Do not click when a different shape appears.'
      'Do not click when a star that is not black appears.'
      'Do not click when a different shape or a star that is not black appears.'
      ''
      'Do not click on a different shape.'
      'Do not click on a star that is not black.'
      'Do not click on a different shape or a not black star.'
    ]

    $scope.messages = ->
      key = +options.onstar + +options.colour + +options.shape
      messages[key]

    $scope.penalties = ->
      if options.penalties
        'There is a 0.1 second penalty for each early click. '
      else
        ''

    distractors = [
      'icon-eye-open'
      'icon-ban-refresh'
      'icon-repeat'
      'icon-circle-arrow-right'
      'icon-move'
    ]

    randInterval = $scope.randInt = (from, to, tval) ->
      from + (to - from)*(if tval? then tval else Math.random!)

    $scope.updateTime = ->
      if state.phase == timing
        display.ms = Date.now! - state.startTime
        $timeout $scope.updateTime, 20

    reappear = $scope.reappear = ->
      display.sprite = 'icon-star'
      state.phase = timing
      state.startTime = Date.now!
      $timeout $scope.updateTime, 20

    hide = $scope.hide = ->
      state.phase = hidden
      display.sprite = 'icon-none'
      $timeout reappear, (randInterval 2000, 4000)

    penalise = $scope.penalise = ->
      $scope.display.penalties++

    stop = $scope.stop = ->
      display.ms = Date.now! - state.startTime
      display.times[*] = {
        time: display.ms + 100 * display.penalties
        ms: display.ms
        penalties: display.penalties
        idling: 0
        hidden: 0
        options: $scope.optionIcons!
      }
      state.phase = idle
      $scope.display.penalties = 0
      display.sprite = 'icon-star'

    stageClick = $scope.stageClick = ->
      switch state.phase
      | idle => hide!
      | hidden => penalise!
      | timing => stop!
      | otherwise $scope.messages = -> 'invalid phase'

    return 1