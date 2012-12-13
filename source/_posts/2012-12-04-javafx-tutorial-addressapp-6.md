---
layout: post
title: "JavaFX 2 Tutorial Part VI - Statistics Chart"
date: 2012-12-04 12:00
comments: true
categories: [English, JavaFX]
published: true
---

{% img /images/javafx-addressapp/part-6/addressapp01.png %}

## Topics in Part VI ##
* Creating a **Statistics Chart** to display birthday distribution.

<!-- more -->

### Other Tutorial Parts ###
* [Part I - Scene Builder](/blog/2012/11/16/javafx-tutorial-addressapp-1)
* [Part II - Model and TableView](/blog/2012/11/17/javafx-tutorial-addressapp-2) 
* [Part III - Interacting with the User](/blog/2012/11/20/javafx-tutorial-addressapp-3) 
* [Part IV - CSS Styling](/blog/2012/11/26/javafx-tutorial-addressapp-4)
* [Part V - Storing Data as XML](/blog/2012/11/27/javafx-tutorial-addressapp-5)
* **Part VI - Statistics Chart**


## Birthday Statistics ##
All our people in the AddressApp have a birthday. Wouldn't it be nice to have some statistics about when our people celebrate their birthday.

We'll use a **Bar Chart** containing a bar for each month. Each bar shows how many people have their birthday in that particular month.


## The Statistics FXML View ##
1. We start by creating a `BirthdayStatistics.fxml` file inside our `ch.makery.address.view` package (*Right-click on package | New | other... | New FXML Document*).
2. Open the `BirthdayStatistics.fxml` file in Scene Builder.
3. Select the root `AnchorPane` and set the *Pref Width* to 620 and the *Pref Height* to 450.
4. Add a `BarChart` to the `AnchorPane`.
5. Right-click on the `BarChart` and select *Fit to Parent*.
6. Save the fxml file, go to Eclipse and refresh the project.

Before we'll come back to Scene Builder, we'll first create the controller and wire everything up in our MainApp.


## The Statistics Controller ##
In the controller package `ch.makery.address` create a Java class called `BirthdayStatisticsController.java`.

Let's first take a look at the entire controller class before I start explaining:

{% include_code javafx-addressapp/part-6/BirthdayStatisticsController.java %}

### How the Controller Works ###
1. The controller will need access to two elements from our FXML file:
   * The `barChar`: It has the type `String` and `Integer`. The `String` is used for the month on the x-axis and the `Integer` is used for the number of people in a specific month.
   We'll use the reference to the `BarChart` to set our data.
   * The `xAxis`: We'll use this to add the month Strings.   

2. The `initialize()` method fills the x-axis with a list of all the months.

3. The `setPersonData(...)` method will be accessed by the `MainApp` class to set the person data. It loops through all persons and counts the birthdays per month.

4. The `createMonthDataSeries(...)` method takes the array with a number for each month and creates the chart data. For each month a new `XYChart.Data` object is created with the month name and the number of people having their birthday in this month. Each `XYChart.Data` object will represent one bar in the chart.


## Connecting View and Controller ##
1. Open `BirthdayStatistics.fxml` in Scene Builder.
2. Select the root `AncherPane` and add the `BirthdayStatisticsController` as controller (in Code View).
3. Select the `BarChart` and choose `barChart` as fx:id Property.
4. Select the `CategoryAxis` and choose `xAxis` as fx:id Property.
5. You may add a title to the chart, remove the legend, etc. for further styling the chart.


## Connecting the View/Controller with MainApp ##
We'll use the same mechanism for our *birthday statistics* that we used for the *edit person dialog*: A simple popup dialog containing.

Add the following method to your `MainApp` class:

```java MainApp.java
/**
 * Opens a dialog to show birthday statistics. 
 */
public void showBirthdayStatistics() {
  try {
    // Load the fxml file and create a new stage for the popup
    FXMLLoader loader = new FXMLLoader(MainApp.class.getResource("view/BirthdayStatistics.fxml"));
    AnchorPane page = (AnchorPane) loader.load();
    Stage dialogStage = new Stage();
    dialogStage.setTitle("Birthday Statistics");
    dialogStage.initModality(Modality.WINDOW_MODAL);
    dialogStage.initOwner(primaryStage);
    Scene scene = new Scene(page);
    dialogStage.setScene(scene);
    
    // Set the persons into the controller
    BirthdayStatisticsController controller = loader.getController();
    controller.setPersonData(personData);
    
    dialogStage.show();
    
  } catch (IOException e) {
    // Exception gets thrown if the fxml file could not be loaded
    e.printStackTrace();
  }
}
```

Everything is set up, but we don't have anyone who actually calls the new `showBirthdayStatistics()` method. Luckily we already have a menu in `RootLayout.fxml` that can be used for this purpose.


### Show Birthday Statistics Menu ###
In your `RootLayoutController` add the following method which will handle user clicks on the *show birthday statistics* menu item: 

```java RootLayoutController.java	
/**
 * Opens the birthday statistics.
 */
@FXML
private void handleShowBirthdayStatistics() {
  mainApp.showBirthdayStatistics();
}
```

Now open the `RootLayout.fxml` file with Scene Builder.

Select the *Show Statistics* `MenuItem` and choose `#handleShowBirthdayStatistics` for `On Action` (in Code view)   

**Remember:** You might need to remove the controller from the root, hit enter and set it again if the `handle...` method does not appear. Because of a [bug](http://javafx-jira.kenai.com/browse/DTL-5402) in Scene Builder.

{% img /images/javafx-addressapp/part-6/addressapp02.png %}

Go to Eclipse, refresh the project and **test it**.


## More Information on JavaFX Charts ##
A good place for more information is the official Oracle tutorial on [Using JavaFX Charts](http://docs.oracle.com/javafx/2/charts/jfxpub-charts.htm).

---

### What's Next? ###
I hope this tutorial was a help for you to get started with JavaFX and you'll be able to write your own JavaFX project from here. I might add some further JavaFX blog posts outside of this tutorial series, we'll see...

I appreciate any feedback. Feel free to write comments if you have any suggestions or if something was unclear.


### Download Source ###
[Source of Tutorial Part VI](/downloads/javafx-addressapp/part-6/addressapp-part-6.zip) as Eclipse Project.


