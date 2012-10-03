---
layout: post
title: "GreenfootKara 2.0 Released"
date: 2012-10-03 12:00
comments: true
categories: English
---
{% img /images/kara/greenfootkara-logo-large.png 'GreenfootKara' %} 

GreenfootKara version 2.0 has been released (see a [change log](http://www.swisseduc.ch/informatik/karatojava/greenfootkara/changes.html)).

## Features ##
* Complete beginners course in German and English
* Combination of Kara and [Greenfoot](http://greenfoot.org) for a simple introduction to Java programming
* **Uses Greenfoot as a simple programming IDE**
* 16-20 lessons
* 12 handouts for students
* 24 Kara scenarios
* 38+ exercises with solutions
* Programming of a Sokoban game with self-designed levels, a highscore, etc.

## Sample Scenario ##
That's how a simple scenario of GreenfootKara looks like. You will find the complete exercise on the handout for chapter 1 (see downloads).

{% img /images/kara/greenfootkara-screenshot.png GreenfootKara in Eclipse %}

What does the program in the screenshot do? It will get Kara around the first tree. The complete program can be written inside the `act()` method. For more complex scenarios you will likely have to create additional methods.

<!-- more -->

Kara's world in the scenario above is loaded from the WorldSetup.txt file:
``` text WorldSetup.txt
World: Kara 07 Around Tree 
X: 10
Y: 10




@ # #  #.
```
`X` and `Y` attributes define the width and height of the world. `@` represents the location of Kara while `#` stands for a tree and `.` for a leaf. The size of the world and the actor positions can easily be changed by editing the *WorldSetup.txt* file. You can also design new world setups by placing actors inside the world with the mouse and using the context menu | `saveWorldSetupToFile()` to save it to a file. 


## How to Get Started ##
First you must download and install [Greenfoot](http://greenfoot.org/downloads). After the installation you should be able to open and compile the predefined scenarios (see downloads below).

### Create Your Own Scenarios ###
To create your own scenarios I recommend to just copy an existing scenario and make changes to the *WorldSetup.txt* file and the *MyKara* class.

Here is an example of a complete MyKara class:

``` java MyKara.java
/**
 * MyKara is a subclass of Kara. Therefore, it inherits all methods of Kara: <p>
 * 
 * <i>MyKara ist eine Unterklasse von Kara. Sie erbt damit alle Methoden der Klasse Kara:</i> <p>
 * 
 * Actions:     move(), turnLeft(), turnRight(), putLeaf(), removeLeaf() <b>
 * Sensors:     onLeaf(), treeFront(), treeLeft(), treeRight(), mushroomFront()
 */
public class MyKara extends Kara {
	
    /**
     * In the 'act()' method you can write your program for Kara <br>
     * <i>In der Methode 'act()' koennen die Befehle fuer Kara programmiert werden</i>
     */
	public void act() {
		move();
		turnRight();
		move();
		
		stop();
	}
}
```
To change the name of the world setup file that is used to build the world: Change the String constant `WORLD_SETUP_FILE` inside the *KaraWorld* class.


## GreenfootKara Downloads ##
Instructions, handouts, and scenarios can be downloaded from the Swisseduc website:   
[{% img nobox middle /images/swisseduc.png 'GreenfootKara on Swisseduc (English)' %} GreenfootKara Downloads (English)](http://www.swisseduc.ch/informatik/karatojava/greenfootkara/greenfootkara-english.html)   
[{% img nobox middle /images/swisseduc.png 'GreenfootKara on Swisseduc (German)' %} GreenfootKara Downloads (German)](http://www.swisseduc.ch/informatik/karatojava/greenfootkara/index.html)

The GreenfootKara source can be found on GitHub (feedback and bug reports are welcome!):   
[{% img nobox middle /images/glyphicons_github.png 'GreenfootKara on GitHub' %} GreenfootKara Source on GitHub](https://github.com/marcojakob/greenfoot-kara)


## Feedback ##
I would appreciate any feedback of your experience with GreenfootKara. You can write an [E-Mail](/about) or leave a comment at the bottom of this blog entry. If you create your own exercises and scenarios I would be glad to post or link them on this blog so others could use them too.