---
layout: post
title: "JavaFX 2 Dialogs"
date: 2012-10-30 00:45
comments: true
categories: [English, JavaFX]
---
When programming a graphical user interface (GUI) there are occasions where you'll need a simple popup dialog to communicate with the user. In Swing (the predecessor of JavaFX) there is a convenient class called [JOptionPane](http://docs.oracle.com/javase/tutorial/uiswing/components/dialog.html) for such dialogs. A similar class doesn't exist in JavaFX 2.x (yet).

Fortunately, the authors of JavaFX [published](http://fxexperience.com/2012/10/announcing-the-javafx-ui-controls-sandbox/) some user interface controls they are currently working on. Those controls might be added in a future version of JavaFX.

One of those ui controls is a class called `Dialogs.java` which is exactly what we need.

## How To Use the Dialogs ##
1. Download the newest **javafx-dialogs-x.x.x.jar** file from my [GitHub Downloads Page](https://github.com/marcojakob/javafx-ui-sandbox/downloads). I put all necessary classes, css files and images inside this jar.
2. Add the jar file to your project (usually inside a **lib** subfolder).
3. Add the jar file to the project's classpath: In Eclipse *right-click on the jar file* | *Build Path* | *Add to Build Path*. Now Eclipse knows about the library.
4. Then add one of the following lines:

### Information Dialog ###
{% img /images/javafx-dialogs/javafx-information-dialog.png JavaFX Information Dialog %}

```java
Dialogs.showInformationDialog(stage, "I have a great message for you!", 
    "Information Dialog", "title");
```
<!-- more -->

### Warning Dialog ###
{% img /images/javafx-dialogs/javafx-warning-dialog.png JavaFX Warning Dialog %}

```java
Dialogs.showWarningDialog(stage, "Careful with the next step!", "Warning Dialog", "title");
```

### Error Dialog ###
{% img /images/javafx-dialogs/javafx-error-dialog.png JavaFX Error Dialog %}

```java
Dialogs.showErrorDialog(stage, "Ooops, there was an error!", "Error Dialog", "title");
```

You may also provide an exception:

```java
Dialogs.showErrorDialog(stage, "Ooops, there was an error!", "Error Dialog With Exception", 
    "title", new FileNotFoundException("Could not find file blabla.txt"));
```

### Confirm Dialog ###
{% img /images/javafx-dialogs/javafx-confirmation-dialog.png JavaFX Confirm Dialog %}

```java
DialogResponse response = Dialogs.showConfirmDialog(stage, 
    "Do you want to continue?", "Confirm Dialog", "title");
```

You may provide `DialogOptions` like this:

```java
DialogResponse response = Dialogs.showConfirmDialog(stage, "Are you ok with this?", 
		"Confirm Dialog With Options", "title", DialogOptions.OK_CANCEL);
```

The response will either be `DialogResponse.YES`, `DialogResponse.NO`, `DialogResponse.CANCEL`, `DialogResponse.OK`, or `DialogResponse.CLOSED`.


### Input Dialog ###
{% img /images/javafx-dialogs/javafx-input-dialog.png JavaFX Input Dialog %}

```java
String input = Dialogs.showInputDialog(stage, "Please enter your name:", "Input Dialog", "title");
```

If you provide some choices, a combobox will be displayed:
{% img /images/javafx-dialogs/javafx-input-dialog-choices.png JavaFX Input Dialog with Choices %}

```java
List<String> choices = new ArrayList<>();
choices.add("a");
choices.add("b");
choices.add("c");
		
String input = Dialogs.showInputDialog(stage, "Choose your color:", 
    "Input Dialog With Choices", "title", "b", choices);
```

## Bugs / Questions ##
If you have questions or found a bug please leave a comment below or report an [issue on GitHub](https://github.com/marcojakob/javafx-ui-sandbox).