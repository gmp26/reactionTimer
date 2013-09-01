'use strict'

angular.module 'reactionTimerApp'
  .controller 'MainCtrl', <[$scope $timeout $window]> ++ ($scope,$timeout,$window) ->

 
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

    $scope.setOptionIcons = (s) ->
      #debugger
      s.size = if options.size then 1 else 0
      s.shape = if +options.shape != 0 then 1 else 0
      s.turning = if options.turning then 1 else 0
      s.location = if options.location then 1 else 0
      s.colour = if +options.colour != 0 then 1 else 0
      s.onstar = if +options.onstar != 0 then 1 else 0
      s.penalties = if options.penalties then 1 else 0

    display = $scope.display = {}
    distractor = $scope.distractor = {}

    const idle = 'idle'
    const hidden = 'hidden'
    const timing = 'timing'

    state = $scope.state = {}

    reset = $scope.reset = ->
      display.sprite = 'icon-star'
      display.ms = '?'
      display.penalties = 0
      display.size = 50
      display.times = []
      display.message = ''
      display.top = '100px'
      display.left = '100px'

      distractor.sprite = 'icon-star'
      distractor.size = 50
      distractor.top = '100px'
      distractor.left = '100px'
      distractor.colour = 'black'
      distractor.opacity = 0

      state.phase = idle
      state.startTime = 0
      state.stageWidth = 300
      state.stageHeight = 300
      state.x = 0.5
      state.y = 0.5

    reset!

    setDisplay = $scope.setDisplay = (obj) ->
      for key, value of obj
        display[key] = value

    setDistractor = $scope.setDistractor = (obj) ->
      for key, value of obj
        distractor[key] = value

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
        'There is a 100ms penalty for each early click. '
      else
        ''

    $scope.distractors = [
      'icon-eye-open'
      'icon-ban-refresh'
      'icon-repeat'
      'icon-circle-arrow-right'
      'icon-move'
      'icon-star'
    ]

    randInterval = $scope.randInt = (from, to, tval) ->
      from + (to - from)*(if tval? then tval else Math.random!)

    randPick = (list) ->
      r = list.length * Math.random!
      list[Math.floor r]

    $scope.updateTime = ->
      if state.phase == timing
        display.ms = Date.now! - state.startTime
        if display.ms >= 10000
          stop!
        else
          $timeout $scope.updateTime, 20

    logTimes = ->
      display.ms = Date.now! - state.startTime
      row.time = display.ms + 100 * display.penalties
      row.ms = display.ms
      row.penalties = display.penalties
      newRow = {}
      for key, val of row
        newRow[key] = val
      display.times[*] = newRow

    $scope.clearLog = ->
      display.times = []

    $scope.setLocation = (obj, x, y) ->
      obj.left = (x*(state.stageWidth - 2*display.size)).toFixed(0) + 'px'
      obj.top = (y*(state.stageHeight - display.size)).toFixed(0) + 'px'

    $timeout (-> $scope.setLocation display, 0.5, 0.5), 10

    $scope.palette = <[
      black
      orange
      green
      purple
    ]>

    $scope.showDistractor = ->
      distractor.opacity = (1+Math.random!)/2.toFixed(1)

      distractor.size = if options.size
        randInterval 30, 200
      else
        50

      distractor.sprite = if options.shape
        if options.colour
          randPick $scope.distractors
        else
          randPick $scope.distractors.filter (!= 'icon-star')
      else
        'icon-star'

      distractor.colour = if options.colour
        if distractor.sprite == 'icon-star'
          randPick $scope.palette.filter (!='black')
        else
          randPick $scope.palette
      else
        'black'

      $scope.setLocation distractor, Math.random!, Math.random!

      $timeout ->
        distractor.opacity = 0
      , 500

    reappear = $scope.reappear = ->
      display.sprite = 'icon-star'
      state.phase = timing
      state.startTime = Date.now!
      $timeout $scope.updateTime, 20

    row = {options: {}}
    hide = $scope.hide = ->
      state.phase = hidden
      display.sprite = 'icon-none'
      $scope.setOptionIcons row.options
      row.hidden = randInterval 2000, 4000
      $timeout reappear, row.hidden

      display.size = if options.size then randInterval 30, 200 else 50

      if options.location
        $scope.setLocation display, Math.random!, Math.random!
      if options.colour || options.shape
        if Math.random! < 0.5
          $timeout $scope.showDistractor, (randInterval 500, 1400)
        if Math.random! < 0.75
          $timeout $scope.showDistractor, (randInterval 1800, row.hidden-200)

    penalise = $scope.penalise = ->
      $scope.display.penalties++

    stop = $scope.stop = ->
      logTimes!
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