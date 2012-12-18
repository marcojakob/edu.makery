---
layout: post
title: "GameGridKara 2.0 Released"
date: 2012-10-03 13:00
comments: true
categories: [English, Java]
---
{% img /images/kara/gamegridkara-logo-large.png GameGridKara %} 

GameGridKara version 2.0 has been released (see a [change log](http://www.swisseduc.ch/informatik/karatojava/gamegridkara/changes.html)).

## Features ##
* Complete beginners course in German and English
* Combination of Kara and [GameGrid](http://www.gamegrid.ch) for a simple introduction to Java programming
* Use **any programming IDE like Eclipse, Netbeans or BlueJ**
* 16-20 lessons
* 12 handouts for students
* 24 Kara scenarios
* 38+ exercises with solutions
* Programming of a Sokoban game with self-designed levels, a highscore, etc.

## Sample Scenario ##
That's how a simple scenario of GameGridKara looks like in Eclipse. You will find the complete exercise on the handout for chapter 1 (see downloads).

{% img /images/kara/gamegridkara-eclipse.png GameGridKara in Eclipse %}

What does the program in the screenshot do? It will get Kara around the first tree. The complete program can be written inside the `act()` method. For more complex scenarios you will likely have to create additional methods.

<!-- more -->

Kara's world in the scenario above is loaded from the WorldSetup.txt file:
``` text WorldSetup.txt
World: Kara 07 Around Tree 
X: 10
Y: 2

@ # #  #.
```
`X` and `Y` attributes define the width and height of the world. `@` represents the location of Kara while `#` stands for a tree and `.` for a leaf. The size of the world and the actor positions can easily be changed by editing the *WorldSetup.txt* file. You can also design new world setups by placing actors inside the world with the mouse and using the context menu | `saveWorldSetupToFile()` to save it to a file. 


## How to Get Started ##
To use the predefined scenarios you can import the scenarios into your development environment (see downloads below).

### Create Your Own Scenarios ###
To create your own scenarios you will need to put the following two libraries on the classpath:

* GameGridKara-2.2.0.jar
* JGameGrid-2.20.jar

You can extract the two libraries from any scenario (see downloads below).

Each scenario must have *one Java class* and a *WorldSetup.txt* file as seen above. Here is a complete example of a Java class where the actual program will be written:

``` java MyKara.java
import kara.gamegrid.Kara;
import kara.gamegrid.KaraWorld;

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
	
	
	/**
	 * The main-method is the start of the program where the Kara world is loaded <br>
	 * <i>Die main-Methode ist der Start des Programms, wo die Kara Welt geladen wird</i>
	 */
	public static void main(String[] args) {
		KaraWorld world = new KaraWorld("WorldSetup.txt", MyKara.class);
		world.show();
	}
}
```
The `main(...)` method is needed to setup and start the world. You need to tell GameGridKara the name of the world setup file and provide the class in which to look for the `act()` method.


## GameGridKara Downloads ##
Instructions, handouts, and scenarios can be downloaded from the Swisseduc website:   
[{% img nobox middle /images/swisseduc.png 'GameGridKara on Swisseduc (English)' %} GameGridKara Downloads (English)](http://www.swisseduc.ch/informatik/karatojava/gamegridkara/gamegridkara-english.html)   
[{% img nobox middle /images/swisseduc.png 'GameGridKara on Swisseduc (German)' %} GameGridKara Downloads (German)](http://www.swisseduc.ch/informatik/karatojava/gamegridkara/index.html)

The GameGridKara source can be found on GitHub (feedback and bug reports are welcome!):   
[{% img nobox middle /images/glyphicons_github.png 'GameGridKara on GitHub' %} GameGridKara Source on GitHub](https://github.com/marcojakob/gamegrid-kara)


## Feedback ##
I would appreciate any feedback of your experience with GameGridKara. You can write an [E-Mail](/about) or leave a comment at the bottom of this blog entry. If you create your own exercises and scenarios I would be glad to post or link them on this blog so others could use them too.