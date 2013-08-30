'use strict'

angular.module 'reactionTimerApp', []
  .config ($routeProvider) ->
    $routeProvider.when '/', {
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    } .otherwise {
      redirectTo: '/'
    }

