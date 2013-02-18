---
layout: post
title: "JavaFX 2 Tutorial Part I - Scene Builder"
date: 2012-11-16 22:00
comments: true
categories: [English, JavaFX]
---

{% img /images/javafx-addressapp/part-1/addressapp01.png %}

## Goal ##
The goal of this tutorial is to learn how to create graphical user interfaces with **JavaFX 2** and **Scene Builder**. We will cover many features of JavaFX 2 by creating an **Address Application** and enhancing it step-by-step.

## Topics in Part I
* Getting to know JavaFX 2
* Creating and starting a JavaFX Project
* Using Scene Builder to design the user interface
* Basic application structure using the Model View Controller (MVC) pattern

<!-- more -->

### Other Tutorial Parts ###
* **Part I - Scene Builder**
* [Part II - Model and TableView](/blog/2012/11/17/javafx-tutorial-addressapp-2) 
* [Part III - Interacting with the User](/blog/2012/11/20/javafx-tutorial-addressapp-3) 
* [Part IV - CSS Styling](/blog/2012/11/26/javafx-tutorial-addressapp-4)
* [Part V - Storing Data as XML](/blog/2012/11/27/javafx-tutorial-addressapp-5)
* [Part VI - Statistics Chart](/blog/2012/12/04/javafx-tutorial-addressapp-6)
* [Part VII - Deployment with e(fx)clipse](/blog/2012/12/18/javafx-tutorial-addressapp-7)

### Prerequisites ###
* Latest [Java JDK 7](http://www.oracle.com/technetwork/java/javase/downloads/index.html) that includes **JavaFX 2.2** or greater.
* Eclipse 4.2 or greater with e(fx)clipse plugin. The easiest way is to download the preconfigured distro from the [e(fx)clipse website](http://efxclipse.org/install.html).
* [Scene Builder 1.1](http://www.oracle.com/technetwork/java/javafx/overview/index.html) or greater


### Preparation and Helpful Links ###
Play around with the JavaFX widgets in the [JavaFX Ensemble](http://download.oracle.com/otndocs/products/javafx/2.2/samples/Ensemble/index.html#SAMPLES):

* JavaFX Ensemble is a gallery of over 100 sample applications that use a wide range of JavaFX features.
* Contains source code for each sample.
* Contains links to API documentation (JavaDoc).

Some other helpful links:

* [JavaFX Tutorials](http://docs.oracle.com/javafx/2/get_started/jfxpub-get_started.htm) - Official Tutorials by Oracle
* [JavaFX 2 API](http://docs.oracle.com/javafx/2/api/) - JavaDoc for JavaFX classes
* [Java 7 API](http://docs.oracle.com/javase/7/docs/api/) - JavaDoc for the standard Java classes

Now, let's get started!

## Create a new JavaFX Project ##
In Eclipse (with e(fx)clipse installed) go to *File | New | Other...* and choose *JavaFX Project*.
Specify the Name of the project (i.e. AddressApp).

### Create the Packages ###
Right from the start we will follow good software design principles. One very important principle is that of [**Model-View-Controller** (MVC)](http://de.wikipedia.org/wiki/Model_View_Controller). According to this we divide our code into three units and create a package for each (Right-click on the src-folder, *New... | Package*):

* For the controller classes: `ch.makery.address`
* For the view classes: `ch.makery.address.view`
* For the model classes: `ch.makery.address.model`


## Create the FXML Layout File ##
There are two ways to create the user interface. Either using an XML file or programming everything in Java. Looking around the internet you will encounter both. We will use XML (ending in .fxml) for most parts. I find it a cleaner way to keep the controller and model separated from each other. Further, we can use the graphical Scene Builder to edit the XML. That means we will almost never have to directly work with XML.

Right-click on the view package and create a new *FXML Document* called `PersonOverview`.   
{% img /images/javafx-addressapp/part-1/addressapp03.png 400 %}
{% img /images/javafx-addressapp/part-1/addressapp04.png 400 %}


## Design with Scene Builder ##
**Note:** If you get stuck somewhere, watch the [Getting Started with JavaFX Scene Builder](http://www.youtube.com/watch?v=rHcnsEoSK_c) YouTube Film. This helps a lot!

Right-click on `PersonOverview.fxml` and choose *Open with Scene Builder*. Now you should see the Scene Builder with just an *AncherPane* (visible under Hierarchy on the left).

1. Select the *Anchor Pane* in your Hierarchy and adjust the size under Layout (right side):   
{% img /images/javafx-addressapp/part-1/addressapp05.png %}

2. Add a *Split Pane (Horizontal Flow)* by dragging it from the Library into the main area. Right-click and select *Fit to Parent*.   
{% img /images/javafx-addressapp/part-1/addressapp06.png %}

3. Add a *TableView* into the left side. Select the TableView (not a Column) and set the following layout constraints. Inside an *AnchorPane* you can always set anchors to the four borders ([more information on Layouts](http://docs.oracle.com/javafx/2/layout/builtin_layouts.htm)).   
{% img /images/javafx-addressapp/part-1/addressapp07.png %}

4. Go to the menu *Preview | Preview in Window* to see, whether it behaves right. Try resizing the window. The TableView should always keep the 10px distance to the surrounding border.

5. Change the column text (under Properties) to "First Name" and "Last Name" and adjust the sizes.   
{% img /images/javafx-addressapp/part-1/addressapp08.png %}

6. Add a *Label* on the right side with the text "Person Details". Adjust it's Layout using anchors.
7. Add a *GridPane* on the right side, select it and adjust it's Layout.    
{% img /images/javafx-addressapp/part-1/addressapp09.png %}

8. Add some rows (under *Layout | GridPane Rows*). Add labels to the cells.   
{% img /images/javafx-addressapp/part-1/addressapp10.png %}

9. Add the three buttons at the bottom. Tipp: Select all of them, right-click and call *Wrap In | HBox*. This groups them together. You might need to specify a Spacing inside the HBox.

10. Now you should see something like the following. Please test it using the Preview Menu.      
{% img /images/javafx-addressapp/part-1/addressapp11.png %}


## Creating the Main Application ##
We need another FXML for our root layout which will contain a menu bar and wraps the just created `PersonOverview.fxml?`.

1. Create another *FXML Document* inside the view package called `RootLayout.fxml`. This time, choose *BorderPane* as the root element.   
{% img /images/javafx-addressapp/part-1/addressapp12.png %}

2. Open it in the Scene Builder.
3. Resize the *BorderPane* with *Pref Width* set to 600 and *Pref Height* set to 400.   
{% img /images/javafx-addressapp/part-1/addressapp13.png %}

4. Add a *MenuBar* into the TOP Slot. We will not implement the menu functionality at the moment.   
{% img /images/javafx-addressapp/part-1/addressapp14.png %}

5. Now, we need to create the Main Java that starts up our application with the `RootLayout.fxml` and adds the `PersonOverview.fxml` in the center. 

6. Right-click on the controller package, *New | Other...* and choose *JavaFX Main Class*. We'll call it `MainApp`.   
{% img /images/javafx-addressapp/part-1/addressapp15.png 400 %}


### Understanding the JavaFX Main class ###
The generated `MainApp.java` class extends from `Application` and contains two methods. This is the basic structure that we need to start a JavaFX Application. The most important part for us is the `start(Stage primaryStage)` method. It is automatically called when we run the application.

As you see, the `start(...)` method receives a `Stage` as parameter. It's good to understand the basic concept of a graphical application with JavaFX:   
{% img /images/javafx-addressapp/part-1/javafx-hierachy.gif %}   
*Image Source: http://www.oracle.com/*

It's like a theater play: The Stage is the main container which is usually a Window with a border and the typical minimize, maximize and close buttons. Inside the Stage you add a Scene which can, of course, be switched out by another Scene. Inside the Scene the actual JavaFX nodes like AnchorPane, TextBox, etc. are added.

Open `MainApp.java` and replace the code with the following:

```java MainApp.java
package ch.makery.address;

import java.io.IOException;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;

public class MainApp extends Application {
	
	private Stage primaryStage;
	private BorderPane rootLayout;
	
	@Override
	public void start(Stage primaryStage) {
		this.primaryStage = primaryStage;
		this.primaryStage.setTitle("AddressApp");
		
		try {
			// Load the root layout from the fxml file
			FXMLLoader loader = new FXMLLoader(MainApp.class.getResource("view/RootLayout.fxml"));
			rootLayout = (BorderPane) loader.load();
			Scene scene = new Scene(rootLayout);
			primaryStage.setScene(scene);
			primaryStage.show();
		} catch (IOException e) {
			// Exception gets thrown if the fxml file could not be loaded
			e.printStackTrace();
		}
		
		showPersonOverview();
	}
	
	/**
	 * Returns the main stage.
	 * @return
	 */
	public Stage getPrimaryStage() {
		return primaryStage;
	}
	
	/**
	 * Shows the person overview scene.
	 */
	public void showPersonOverview() {
		try {
			// Load the fxml file and set into the center of the main layout
			FXMLLoader loader = new FXMLLoader(MainApp.class.getResource("view/PersonOverview.fxml"));
			AnchorPane overviewPage = (AnchorPane) loader.load();
			rootLayout.setCenter(overviewPage);
			
		} catch (IOException e) {
			// Exception gets thrown if the fxml file could not be loaded
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
		launch(args);
	}
}
```

Try to understand the code. The various comments should give you some hints about what's going on.

If you run the application now, you should see something like the screenshot at the beginning of this post.

---

### What's Next? ###
In [Tutorial Part II](/blog/2012/11/17/javafx-tutorial-addressapp-2) we will add some data and functionality to our AddressApp.


### Download ###
[Source of Tutorial Part I](/downloads/javafx-addressapp/part-1/addressapp-part-1.zip) as Eclipse Project

















