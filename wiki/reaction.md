# Reactive Document/Programming

##  Literate Programming/Document

## Angular Directives

    <i-clickable bind="myvar" range="[1,2,3]"></i-clickable>
    <div i-clickable='bind="myvar" range="[1,2,3]"'></div>

Note: attr > value

    <div i-clickable='bind="myvar"'  bind="myv1"></div>

    the real bind is "myv1"

* i-clickable/i-slidable/i-playable

  * ngModel: the variable to control
  * readonly: true/false (must be using in parameters) 
    * u can use "ng-readonly" for using attribute.
  * values: 
    * null: a number ForLoop
    * array: In a List, [1,3,4,8, 'a', 'b']
    * function
      * In a custom rangeFunc:
          rangeFn = (value, config, looped)->
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
* i-flash: to show the changed value in document.
  * i-falsh-off: used in attribute.
  * off: used in options
  * effect: not impl.
  * delay: not impl.
* i-playable: image/htmlElement carousel
  * delay: 100ms
  * effect: transition effect
  * paused:
  * goto:
  * onState:
* i-executable: the ngModel is the source code can be excutable. the element's text is running result.
  * ngModel: the source code in it
  * language: the language of the source code, the default is coffeescript.
  * canvas: true/false, show canvas or not
  * console: true/false, if true show debug and error info here
* i-editor: derived from ui-codemirror(but i wish can div and textarea together...)
    * editor: visible, collapsed, editable
      * collapsed: the code collapsed or not.



## Markdown Reactive Format Extension

The Markdown Reactive Format Extension is similar to the regular Markdown syntax
for links. the displayed text is in the between the brackets, `[]`, the variable
and other configurations is in the following braces, `{}`, it's a json object.

* [result is ?]{variable: 3} :  variable = 3;  "result is {{variable}}"
* [result]{variable} :  variable="result";{{variable}}
* [20 dsjds]{variable: "10..100 by 10", adjust:"click" } : variable=20, range in 10..100 step = 10
  the default is slide mode, but can change to click or auto mode.
* [light on]{variable: ["on", "half-on", "off"]}
  the default is click mode, but can change to slide or auto mode.
* ![]{}: used to render something.



## Dev Internal

* display value:
  * `<div ng-bind="var" i-flash/>`
* reactive value:
  * `<div ng-bind-template="result is {{variable}}" i-clickable="{variable: "10..100 by 10"}" i-show-changed/>`


https://github.com/angular-ui/ui-codemirror/blob/master/ui-codemirror.js
https://github.com/angular-ui/bootstrap/blob/master/src/buttons/buttons.js
https://github.com/angular/angular.js/blob/master/src/ng/directive/input.js
http://jsfiddle.net/dalcib/6kabF/2/   -- 
http://jsfiddle.net/simpulton/GeAAB/  -- sharemsg
http://jsfiddle.net/simpulton/EMA5X/  -- animateoin

