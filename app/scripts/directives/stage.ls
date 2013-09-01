'use strict';

angular.module 'reactionTimerApp'
  .directive 'stage', <[$window $timeout]> ++ ($window, $timeout) ->
    restrict: 'A'
    link: (scope, element, attrs) -> 

      if !scope.state
       scope.state = {}

      setBounds = !~>
        console.log "resize"
        scope.state.stageWidth = element.0.offsetWidth
        scope.state.stageHeight = element.0.offsetHeight
        scope.setLocation scope.display, 0.5, 0.5

      angular.element($window) .on 'resize', ~>
        scope.$apply setBounds

      $timeout setBounds, 0

