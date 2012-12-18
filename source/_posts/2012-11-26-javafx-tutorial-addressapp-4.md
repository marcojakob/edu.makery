---
layout: post
title: "JavaFX 2 Tutorial Part IV - CSS Styling"
date: 2012-11-26 13:00
comments: true
categories: [English, JavaFX]
published: true
---

{% img /images/javafx-addressapp/part-4/addressapp01.png %}

## Topics in Part IV ##
* **CSS Styling**
* Adding an **Application Icon**

<!-- more -->

### Other Tutorial Parts ###
* [Part I - Scene Builder](/blog/2012/11/16/javafx-tutorial-addressapp-1)
* [Part II - Model and TableView](/blog/2012/11/17/javafx-tutorial-addressapp-2)
* [Part III - Interacting with the User](/blog/2012/11/20/javafx-tutorial-addressapp-3) 
* **Part IV - CSS Styling**
* [Part V - Storing Data as XML](/blog/2012/11/27/javafx-tutorial-addressapp-5)
* [Part VI - Statistics Chart](/blog/2012/12/04/javafx-tutorial-addressapp-6)
* [Part VII - Deployment with e(fx)clipse](/blog/2012/12/18/javafx-tutorial-addressapp-7)

## CSS Styling ##
In JavaFX you can style your user interface using Cascading Style Sheets (CSS). This is great! It's never been as easy to customize the appearance of a Java application.

In this tutorial we will create a *DarkTheme* inspired by the Windows 8 Metro design. The css for the buttons is based on the blog post [JMetro - Windows 8 Metro controls on Java](http://pixelduke.wordpress.com/2012/10/23/jmetro-windows-8-controls-on-java/) by Pedro Duque Vieira.


### Getting Familiar with CSS ###
If you want to style your JavaFX application you should have a basic understanding of CSS in general. A good place to start is this [CSS tutorial](http://www.csstutorial.net/).

For more JavaFX specific information about CSS:

* [Skinning JavaFX Applications with CSS](http://docs.oracle.com/javafx/2/css_tutorial/jfxpub-css_tutorial.htm) - Tutorial by Oracle
* [JavaFX CSS Reference](http://docs.oracle.com/cd/E17802_01/javafx/javafx/1.3/docs/api/javafx.scene/doc-files/cssref.html) - Official Reference


### Default JavaFX CSS ###
The default source for CSS styles is a file called **`caspian.css`**. This css file can be found in the Java FX jar file `jfxrt.jar` located in your Java folder under `/jdk_x.x.x/jre/lib/jfxrt.jar`.

This default style sheet is always applied to a JavaFX application. By adding a custom style sheet we can override the default styles of the `caspian.css`.   
Hint: It helps to look at the default CSS file to see which styles you might need to override. 


### Attaching CSS Style Sheets ###
Add the following CSS file called `DarkTheme.css` to the *view* package.

{% include_code javafx-addressapp/part-4/DarkTheme.css %}

We now need to attach the CSS to our Scene. We could do this programmatically in Java code, but we'll use the Scene Builder to add it to our fxml files: 


#### Attach CSS to RootLayout.fxml ####
Open the file `RootLayout.fxml` in Scene Builder. Select the root `BorderPane` in the Hierarchy view. Under properties add the `DarkTheme.css` file as stylesheet.


#### Attach CSS to PersonEditDialog.fxml ####
Open the file `PersonEditDialog.fxml` in Scene Builder. Select the root `AnchorPane` and choose `DarkTheme.css` in the properties view as stylesheet.

The background is still white, so add the Style Class `background` to the root `AnchorPane`.

{% img /images/javafx-addressapp/part-4/addressapp02.png %}

Select the OK button and choose *Default Button* in the Properties View. This will change its color and make this the default button when the *enter* key is pressed by the user.


#### Attach CSS to PersonOverview.fxml ####
Open the file `PersonOverview.fxml` in Scene Builder. Select the root `AnchorPane` in the Hierarchy view. Under properties add the `DarkTheme.css` file as stylesheet.

{% img /images/javafx-addressapp/part-4/addressapp03.png %}

You should already see some changes now: The table and the buttons are black. If you select a button and look at the CSS part in the Properties view you will see that there already is a default style class called `button`.

{% img /images/javafx-addressapp/part-4/addressapp04.png %}

All class styles `.button` from `caspian.css` apply to those buttons. Since we've redefined (and thus overridden) some of those styles in our custom CSS, the appearance of the buttons change automatically.

You might need to adjust the size of the buttons so that all text is displayed.

Select the right `AnchorPane` that is inside the `SplitPane`. Go to the Properties view and use the plus (+) sign to add a Style Class. Select the `background` style class. The background should now turn black.

{% img /images/javafx-addressapp/part-4/addressapp05.png %}
{% img /images/javafx-addressapp/part-4/addressapp06.png %}

If there is a white border around the table, select the `TableView` and choose 0 for all anchors in the Layout view. Now the table should take up all the left space.


#### Labels with different style ####
Right now, all the labels on the right side have the same size. There are already some styles defined in the css file called `.label-header` and `.label-bright` that we'll use to further style the labels.

Select the *Person Details* label and add `label-header` as a Style Class.

{% img /images/javafx-addressapp/part-4/addressapp07.png %}

To each label in the right column (where the actual person details are displayed), add the css Style Class `label-bright`.


## Adding an Application Icon ##
Right now our application just has the default icon in the title bar and taks bar:

{% img /images/javafx-addressapp/part-4/addressapp08.png %}

It looks much nicer with a custom icon:

{% img /images/javafx-addressapp/part-4/addressapp09.png %}


### The Icon File ###
A possible place to get free icons is [Icon Finder](http://www.iconfinder.com). I downloaded a little [address book icon](http://www.iconfinder.com/icondetails/86957/32/).

Create a (normal) folder inside your AddressApp project called **resources** and a subfolder called **images** in it. Put the icon of your choice inside the images folder. Your folder structure should look something like this now:

{% img /images/javafx-addressapp/part-4/addressapp10.png %}


### Set Icon to Scene ###
To set the icon for our scene add the following line to the `start(...)` method in `MainApp.java`

```java
this.primaryStage.getIcons().add(new Image("file:resources/images/address_book_32.png"));
```

The whole `start(...)` method will look something like this now:
```java MainApp.java
public void start(Stage primaryStage) {
  this.primaryStage = primaryStage;
  this.primaryStage.setTitle("AddressApp");
  // Set the application icon
  this.primaryStage.getIcons().add(new Image("file:resources/images/address_book_32.png"));
  
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
```

You can also add an icon to the stage of the person edit dialog, of course.

---

### What's Next? ###
In [Tutorial Part V](/blog/2012/11/27/javafx-tutorial-addressapp-5) we will add XML storage for our data.


### Download ###
[Source of Tutorial Part IV](/downloads/javafx-addressapp/part-4/addressapp-part-4.zip) as Eclipse Project.


