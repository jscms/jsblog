# Reactive Document/Programming

##  Literate Programming/Document

## Angular Directives

* i-clickable
* i-slidable
* i-playable
  * bind: variable
  * //range: "10..100 by 2" put it into markdown parse
  * range: [lowest, highest, step, lowestIn, highestIn]
    * lowest: 10, null means no limits
    * highest: 100
    * step: 2, null means step = 1
    * lowestIn: true, null means true
    * highestIn: true
* i-show-changed: to show the changed value in document.
  * delay: show time.
  * effect: fade

* act-click
* act-slide
* act-play: {delay: 100ms, effect="", paused: true, goto:"index", onState: "" }
* act-type = {var:'title', type:'number'}
  `<input ng-model="title" />`


ng-model="value" 

or {{val}}

ng-react="click|slide, range=[1..10]+1"
range=['ab','cc', 'df']

clickable="range: "


## Dev Internal

* display value:
  * `<div ng-bind="var" i-show-changed/>`
* reactive value:
  * `<div ng-bind-template="result is {{variable}}" i-clickable="{variable: "10..100 by 10"}" i-show-changed/>`


## Markdown Reactive Format Extension

* [result is ?]{variable: 3} :  variable = 3;  "result is {{variable}}"
* [result]{variable} :  variable="result";{{variable}}
* [20 dsjds]{variable: "10..100 by 10", adjust:"click" } : variable=20, range in 10..100 step = 10
  the default is slide mode, but can change to click or auto mode.
* [light on]{variable: ["on", "half-on", "off"]}
  the default is click mode, but can change to slide or auto mode.
* ![]{}
