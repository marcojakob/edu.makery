---
layout: post
title: "JavaFX 2 Tutorial Part III - Interacting with the User"
date: 2012-11-20 17:30
updated: 2012-12-18
comments: true
categories: [English, JavaFX]
published: true
---

{% img /images/javafx-addressapp/part-3/addressapp01.png %}

## Topics in Part III ##
* **React to selection changes** in the table.
* Add functionality to the **add**, **edit**, and **remove** buttons.
* Create a custom **popup dialog** to edit a person.
* **Validating user input**.

<!-- more -->

### Other Tutorial Parts ###
* [Part I - Scene Builder](/blog/2012/11/16/javafx-tutorial-addressapp-1)
* [Part II - Model and TableView](/blog/2012/11/17/javafx-tutorial-addressapp-2)
* **Part III - Interacting with the User**
* [Part IV - CSS Styling](/blog/2012/11/26/javafx-tutorial-addressapp-4)
* [Part V - Storing Data as XML](/blog/2012/11/27/javafx-tutorial-addressapp-5)
* [Part VI - Statistics Chart](/blog/2012/12/04/javafx-tutorial-addressapp-6)
* [Part VII - Deployment with e(fx)clipse](/blog/2012/12/18/javafx-tutorial-addressapp-7)

## React to Table Selections ##
Obviousely, we haven't used the right side of our application, yet. The idea is when the user selects a person in the table, the details about that person should be displayed on the right side.

First, let's add a new method inside `PersonOverviewController` that helps us fill the labels with the data from a single `Person`.

Create a method called `showPersonDetails(Person person)`. Go trough all the labels and set the text using `setText(...)` with details from the person. If `null` is passed as parameter, all labels should be cleared.

```java PersonOverviewController.java
	/**
	 * Fills all text fields to show details about the person.
	 * If the specified person is null, all text fields are cleared.
	 * 
	 * @param person the person or null
	 */
	private void showPersonDetails(Person person) {
  
    // use setText(...) on all labels with info from the person object
    // use setText("") on all labels if the person is null
	}
```

### Convert the Birthday Date to a String ###
If you've implemented the method above, you will have noticed that we need a way to convert the `Calendar` from the birthday field to a String. In a `Label` we can only display Strings.

We will use the conversion from `Calendar` and `String` (and vice versa) in several places. It's good practice to create a helper class with `static` methods for this. We'll call it `CalendarUtil` and place it in a seperate package called `ch.makery.address.util`:

{% include_code javafx-addressapp/part-3/CalendarUtil.java %}

Note that you can change the format of the date by changing the constant `DATE_FORMAT`. For all possible formats see [`SimpleDateFormat`](http://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html) in the Java API.


### Listen for Table Selection Changes ###
To get informed when the user selects a person in the person table, we need to *listen for changes*.

If you're not familiar with the concept of *anonymous classes* you might want to take a look at an [explanation in German](http://openbook.galileocomputing.de/javainsel9/javainsel_08_001.htm#mj58cf4fadac5cc0924b9451626df2228c) or [English](http://inheritingjava.blogspot.ch/2011/02/chapter-54-anonymous-inner-classes.html).

There is an interface in JavaFX called [`ChangeListener`](http://docs.oracle.com/javafx/2/api/javafx/beans/value/ChangeListener.html) with one method called `changed(...)`. We need an *anonymous class* that implements this interface and add it to our person table. That sounds quite complicated. I'll explain it, but first let's take a look at the new code, added to the `initialize()` method in `PersonOverviewController`:

```java PersonOverviewController.java
@FXML
private void initialize() {
  // Initialize the person table
  firstNameColumn.setCellValueFactory(new PropertyValueFactory<Person, String>("firstName"));
  lastNameColumn.setCellValueFactory(new PropertyValueFactory<Person, String>("lastName"));
  // Auto resize columns
  personTable.setColumnResizePolicy(TableView.CONSTRAINED_RESIZE_POLICY);

  // clear person
  showPersonDetails(null);
  
  // Listen for selection changes
  personTable.getSelectionModel().selectedItemProperty().addListener(new ChangeListener<Person>() {

    @Override
    public void changed(ObservableValue<? extends Person> observable,
        Person oldValue, Person newValue) {
      showPersonDetails(newValue);
    }
  });
}
```

In **line 10** we reset the person details. If you've implemented `showPersonDetails(...)` correctly this should set an empty String to all text fields.

In **line 13** we get the *selectedItemProperty* of the person table and add a listener to it. The new `ChangeListener` is of type `Person` since we have `Person` objects in the table. Now, whenever the user selects a person in the table, the method `changed(...)` is called. We take the newly selected person and pass it to the `showPersonDetails(...)` method.

Try to **run your application** at this point. Verify that when you select a person in the table, details about that person are displayed on the right.

If something doesn't work, you can compare your `PersonOverviewController` class with [PersonOverviewController.java](/downloads/javafx-addressapp/part-3/PersonOverviewController.java).


## The Delete Button ##
Our user interface already contains a delete button, but without any functionality. We can select the action for a button inside the *Scene Builder*. Any method inside our controller that is annotated with `@FXML` (or is public) is accessible by the *Scene Builder*. Thus, let's first create the delete method at the end of our `PersonOverviewController` class:

```java PersonOverviewController.java
/**
 * Called when the user clicks on the delete button.
 */
@FXML
private void handleDeletePerson() {
  int selectedIndex = personTable.getSelectionModel().getSelectedIndex();
  personTable.getItems().remove(selectedIndex);
}
```

Now, open the `PersonOverview.fxml` file in *SceneBuilder*. Select the *Delete* button, open the *Code* view and choose `#handleDeletePerson` in the dropdown of **On Action**.

*Scene Builder Problem*: In my version of Scene Builder (1.1 beta_11) the methods did not appear. I had to go to the root AnchorPane (in Hierarchy view), delete the controller class, hit enter and add the controller class again. Now, the methods appear in the dropdown. Hope [this bug](http://javafx-jira.kenai.com/browse/DTL-5402) will be corrected soon.

{% img /images/javafx-addressapp/part-3/addressapp02.png %}


### Error Handling ###
If you run the application at this point, you should be able to delete selected persons from the table. But what happenes, if you **click the delete button if no person is selected** in the table? 

There will be an `ArrayIndexOutOfBoundsException` because it could not remove a person item at index `-1`. The index `-1` was returned by `getSelectedIndex()` which means that there was no selection.

To ignore such an error is not very nice, of course. We should let the user know that he/she must select a person before deleting. Even better would be if we disabled the button so that the user doesn't even have the chance to do something wrong. I'll show how to do the first approach here.

We'll add a popup dialog to inform the user. You'll need to **add a library** for the Dialogs: 

1. Download the newest **javafx-dialogs-x.x.x.jar** file from my [GitHub Page](https://github.com/marcojakob/javafx-ui-sandbox/tree/master/javafx-dialogs/dist).
2. Create a **lib** subfolder in the project and add the jar file to this folder.
3. Add the jar file to the project's classpath: In Eclipse *right-click on the jar file | Build Path | Add to Build Path*.

With some changes made to the `handleDeletePerson()` method, we can show a popup dialog whenever the user pushes the delete button while no person is selected in the table:

```java PersonOverviewController.java
/**
 * Called when the user clicks on the delete button.
 */
@FXML
private void handleDeletePerson() {
  int selectedIndex = personTable.getSelectionModel().getSelectedIndex();
  if (selectedIndex >= 0) {
    personTable.getItems().remove(selectedIndex);
  } else {
    // Nothing selected
    Dialogs.showWarningDialog(mainApp.getPrimaryStage(),
        "Please select a person in the table.",
        "No Person Selected", "No Selection");
  }
}
```


## The New and Edit Buttons ##
The new and edit buttons are a bit more work: We'll need a new custom dialog (a.k.a stage) with a form to ask the user for details about the person.

1. Create a new fxml file called `PersonEditDialog.fxml` inside the view package.
2. Use a `GridPane`, `Label`s, `TextBoxe`s and `Button`s to create a Dialog like the following:   
{% img /images/javafx-addressapp/part-3/addressapp03.png %}   
If you don't to do the work, you can download this [PersonEditDialog.fxml](/downloads/javafx-addressapp/part-3/PersonEditDialog.fxml). 

3. Create the controller `PersonEditDialogController`:   
{% include_code javafx-addressapp/part-3/PersonEditDialogController.java %}

* A few things to note about this controller:
  * The `setPerson(...)` method can be called from another class to set the person that is to be edited.
  * When the user clicks the OK butten, the `handleOk()` method is called. First, some validation is done by calling the `isInputValid()` method. Only if validation was successful, the person object is filled with the data that the user entered. Those changes will directly be applied to the person object that was passed to `setPerson(...)`!
  * The boolean `okClicked` is used so that the caller can determine whether the user clicked the OK or Cancel button.


### Opening the Dialog ###
Add a method to load and display the edit person dialog inside our `MainApp`:   
```java MainApp.java
/**
 * Opens a dialog to edit details for the specified person. If the user
 * clicks OK, the changes are saved into the provided person object and
 * true is returned.
 * 
 * @param person the person object to be edited
 * @return true if the user clicked OK, false otherwise.
 */
public boolean showPersonEditDialog(Person person) {
  try {
    // Load the fxml file and create a new stage for the popup
    FXMLLoader loader = new FXMLLoader(MainApp.class.getResource("view/PersonEditDialog.fxml"));
    AnchorPane page = (AnchorPane) loader.load();
    Stage dialogStage = new Stage();
    dialogStage.setTitle("Edit Person");
    dialogStage.initModality(Modality.WINDOW_MODAL);
    dialogStage.initOwner(primaryStage);
    Scene scene = new Scene(page);
    dialogStage.setScene(scene);
    
    // Set the person into the controller
    PersonEditDialogController controller = loader.getController();
    controller.setDialogStage(dialogStage);
    controller.setPerson(person);
    
    // Show the dialog and wait until the user closes it
    dialogStage.showAndWait();
    
    return controller.isOkClicked();
    
  } catch (IOException e) {
    // Exception gets thrown if the fxml file could not be loaded
    e.printStackTrace();
    return false;
  }
}
```

Add the following methods to the `PersonOverviewController`:   
```java PersonOverviewController.java
/**
 * Called when the user clicks the new button.
 * Opens a dialog to edit details for a new person.
 */
@FXML
private void handleNewPerson() {
  Person tempPerson = new Person();
  boolean okClicked = mainApp.showPersonEditDialog(tempPerson);
  if (okClicked) {
    mainApp.getPersonData().add(tempPerson);
  }
}

/**
 * Called when the user clicks the edit button.
 * Opens a dialog to edit details for the selected person.
 */
@FXML
private void handleEditPerson() {
  Person selectedPerson = personTable.getSelectionModel().getSelectedItem();
  if (selectedPerson != null) {
    boolean okClicked = mainApp.showPersonEditDialog(selectedPerson);
    if (okClicked) {
      refreshPersonTable();
      showPersonDetails(selectedPerson);
    }
    
  } else {
    // Nothing selected
    Dialogs.showWarningDialog(mainApp.getPrimaryStage(),
        "Please select a person in the table.",
        "No Person Selected", "No Selection");
  }
}

/**
 * Refreshes the table. This is only necessary if an item that is already in
 * the table is changed. New and deleted items are refreshed automatically.
 * 
 * This is a workaround because otherwise we would need to use property
 * bindings in the model class and add a *property() method for each
 * property. Maybe this will not be necessary in future versions of JavaFX
 * (see http://javafx-jira.kenai.com/browse/RT-22599)
 */
private void refreshPersonTable() {
  int selectedIndex = personTable.getSelectionModel().getSelectedIndex();
  personTable.setItems(null);
  personTable.layout();
  personTable.setItems(mainApp.getPersonData());
  // Must set the selected index again (see http://javafx-jira.kenai.com/browse/RT-26291)
  personTable.getSelectionModel().select(selectedIndex);
}
```

Open the `PersonOverview.fxml` file in Scene Builder. Choose the corresponding methods in *On Action* for the new and edit buttons.


## Done! ##
You should have a working *Address Application* now. The application is able to add, edit, and delete persons. There is even some validation for the text fields to avoid bad user entries.

I hope the concepts and structure of this application will get you started with writing your own JavaFX application! Have fun and stay tuned for possible future tutorials.

---

### What's Next? ###
In [Tutorial Part IV](/blog/2012/11/26/javafx-tutorial-addressapp-4) we will add some CSS styling.


### Download ###
[Source of Tutorial Part III](/downloads/javafx-addressapp/part-3/addressapp-part-3.zip) as Eclipse Project.



