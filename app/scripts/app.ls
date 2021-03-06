'use strict'


mainT='''<div class="container" stage ng-click="stageClick()">
  <span
    class="{{distractor.sprite}} {{options.turning}} positioned"
    style="top:{{distractor.top}};left:{{distractor.left}};font-size:{{distractor.size}}px;color:{{distractor.colour}};opacity:{{distractor.opacity}}">
  </span>
  <span  ng-click="starClick($event)"
    class="{{display.sprite}} {{options.turning}} positioned"
    style="top:{{display.top}};left:{{display.left}};font-size:{{display.size}}px;color:black"></span>
  <h1 class="text-center" style="opacity:0.2">{{scope.idle()}}</h1>
</div>
<div class="alert">
  {{s1()}} {{messages()}} {{penalties()}}
</div>
<div class="container">
  <div class="row">
    <div class="span4">
      <h4>Last Reaction Time</h4>
      <div class="row">
        <div class="span2 alert alert-info">
          <div class="text-center" style="font-size:30px">{{display.ms | number:0}} ms</div>
        </div>
      </div>
      <h4>Options</h4>
      <label class="checkbox">
        <input type="checkbox" ng-model="options.size">
        <i class="icon-fullscreen"> </i>Vary size
      </label>
      <label class="checkbox">
        <input type="checkbox" ng-model="options.shape">
        <i class="icon-asterisk"> </i>Shape distractors
      </label>
      <label class="checkbox">
        <input type="checkbox" ng-model="options.turning" ng-true-value="icon-spin" ng-false-value="">
        <i class="icon-refresh"> </i>Star and distractors turn
      </label>
      <label class="checkbox">
        <input type="checkbox" ng-model="options.location">
        <i class="icon-move"> </i>Vary star location
      </label>
      <label class="checkbox">
        <input type="checkbox" ng-model="options.colour">
        <i class="icon-tint"> </i>Coloured distractors
      </label>
      <label class="checkbox">
        <input type="checkbox" ng-model="options.onstar" >
        <i class="icon-hand-up"> </i>Click on star required
      </label>
      <label class="checkbox">
        <input type="checkbox" ng-model="options.penalties">
        <i class="icon-ban-circle"> </i>Penalties
      </label>
    </div>
    <div class="span8">
      <button class="btn pull-right" ng-click="clearLog()">Clear Table</button>
      <h4>Your times (ms)</h4>
      <table class="table table-striped">
        <thead>
          <tr>
            <th>Reaction<br />time</th>
            <th>after<br />penalties</th>
            <th>Time<br />hidden</th>
            <th>Active<br />options</th>
          </tr>
        </thead>
        <tbody>
          <tr ng-repeat="t in display.times">
            <td>{{t.ms | number:0}}</td>
            <td>{{t.time | number:0}}</td>
            <td>{{t.hidden | number:0}}</td>
            <td>
              <i class="icon-fullscreen" style="opacity:{{t.options.size}}"> </i>
              <i class="icon-asterisk" style="opacity:{{t.options.shape}}"> </i>
              <i class="icon-refresh" style="opacity:{{t.options.turning}}"> </i>
              <i class="icon-move" style="opacity:{{t.options.location}}"> </i>
              <i class="icon-tint" style="opacity:{{t.options.colour}}"> </i>
              <i class="icon-hand-up" style="opacity:{{t.options.onstar}}"> </i>
              <i class="icon-ban-circle" style="opacity:{{t.options.penalties}}"> </i>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</div>
'''


angular.module 'reactionTimerApp', ['ngRoute', 'ngTouch']
  .config ($routeProvider) ->
    $routeProvider.when '/', {
      template: mainT
      controller: 'MainCtrl'
    } .otherwise {
      redirectTo: '/'
    }

