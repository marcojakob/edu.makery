---
layout: post
title: "Introduction to Programming with Kara"
date: 2012-10-02 22:00
comments: true
categories: English
---
Kara offers a playful introduction to fundamental concepts of programming. Kara is a ladybug that lives in a simple world with trees, leafs and mushrooms.

{% img /images/kara/kara.png Kara %}
{% img /images/kara/mushroom.png Mushroom %}
{% img /images/kara/leaf.png Leaf %}
{% img /images/kara/tree.png Tree %}

The rules of Kara's world are simple:

#### Actions ####
* Kara can move around with `move()` (Kara can push a mushroom, can step on leafs but can't walk through trees)
* Kara turns left or right with `turnLeft()` or `turnRight()`
* Kara puts down a leaf with `putLeaf()`
* Kara picks up a leaf with `removeLeaf()`

#### Sensors ####
* Kara checks if he stands on a leaf with `onLeaf()`
* Kara checks if there is a tree with `treeFront()`, `treeLeft()`, or `treeRight()`
* Kara checks if there is a mushroom in front with `mushroomFront()`


### A Sample Exercise ###
Kara is placed in the following world setup and must be programmed to collect all leafs until he reaches the tree:

{% img /images/kara/kara-example-collect-leafs.png Kara Collects Leafs %}

One solution would be as follows:

{% codeblock lang:java %}
while (!treeFront()) {
  if (onLeaf()) {
    removeLeaf();
  }
  move();
}
{% endcodeblock %}