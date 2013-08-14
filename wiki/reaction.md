# Reactive Document/Programming

##  Literate Programming/Document

## Angular Directives

    <i-clickable bind="myvar" range="[1,2,3]"></i-clickable>
    <div i-clickable='bind="myvar" range="[1,2,3]"'></div>

Note: attr > value

    <div i-clickable='bind="myvar"'  bind="myv1"></div>

    the real bind is "myv1"

* i-clickable/i-slidable/i-playable

  * bind: variable
  * readonly: true/false (must be using in parameters) 
    * u can use "ng-readonly" for using attribute.
  * values: 
    * null: a number ForLoop
    * array: In a List, [1,3,4,8]
    * function
      * In a custom rangeFunc:
          rangeFn = (value, config)->
            # get the new value
            value+1
  * //range: "10..100 by 2" put it into markdown parse
  * range(attr): 
    * {min:-Infinity, max: Infinity, step: 1, minIn: true, maxIn: true}
      * min: 10, -Infinity means no limits
      * max: 100, Infinity means no limits
      * step: 2, null means step = 1
      * minIn: true, null means true
      * maxIn: true
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
