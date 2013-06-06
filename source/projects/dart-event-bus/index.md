---
layout: page
title: Dart Event Bus
comments: false
footer: true
javascript: [event_bus_example.dart.js, dart.js]
css: [event_bus_example.css]
---

A simple Event Bus using Dart [Streams](http://api.dartlang.org/docs/releases/latest/dart_async/Stream.html) 
for decoupling applications.

## Installation Instructions and Source Code ##
[{% img nobox middle /images/glyphicons_github.png 'Dart Event Bus on GitHub' %} Dart Event Bus](https://github.com/marcojakob/dart-event-bus) on GitHub.


## Demo ##

<div id="example-container">
  <div class="listener" id="listener-1">
    Listener 1
    <textarea></textarea>
    <button class="listen-a">Listen for Event A</button>
    <button class="listen-b">Listen for Event B</button>
    <button class="pause">Pause</button>
    <button class="resume">Resume</button>
    <button class="cancel">Cancel</button>
  </div>
  <div class="listener" id="listener-2">
    Listener 2
    <textarea></textarea>
    <button class="listen-a">Listen for Event A</button>
    <button class="listen-b">Listen for Event B</button>
    <button class="pause">Pause</button>
    <button class="resume">Resume</button>
    <button class="cancel">Cancel</button>
  </div>
  <div class="event">
    <button id="fire-button-a">Fire Event A [1]</button>
    <label id="fire-label-a"></label>
  </div>
  <div class="event">
    <button id="fire-button-b">Fire Event B [1]</button>
    <label id="fire-label-b"></label>
  </div>
</div>

## Event Bus Pattern ##
An Event Bus follows the publish/subscribe pattern. It allows listeners to 
subscribe for events and publishers to fire events. This enables objects to
interact without requiring to explicitly define listeners and keeping track of
them.

### Event Bus and MVC ###
The Event Bus pattern is especially helpful for decoupling [MVC](http://wikipedia.org/wiki/Model_View_Controller) 
(or [MVP](http://wikipedia.org/wiki/Model_View_Presenter)) applications.

**One group of MVC** is not a problem.

![Model-View-Controller](https://raw.github.com/marcojakob/dart-event-bus/master/doc/mvc.png)

But as soon as there are **multiple groups of MVCs**, those groups will have to talk
to each other. This creates a tight coupling between the controllers.

![Multi Model-View-Controllers](https://raw.github.com/marcojakob/dart-event-bus/master/doc/mvc-multi.png)

By communication through an **Event Bus**, the coupling is reduced.

![Event Bus](https://raw.github.com/marcojakob/dart-event-bus/master/doc/event-bus.png)

## Usage ##
See [Dart Event Bus on GitHub](https://github.com/marcojakob/dart-event-bus).