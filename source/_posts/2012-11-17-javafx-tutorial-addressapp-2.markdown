---
layout: post
title: "JavaFX 2 Tutorial Part II - Model and TableView"
date: 2012-11-17 00:30
comments: true
categories: [English, JavaFX]
---

{% img /images/javafx-addressapp/part-2/addressapp01.png %}

## Topics in Part II ##
* Creating a **model** class
* Using the model class in an **ObservableList**
* Show data in the **TableView** using **Controllers**

<!-- more -->

### Other Tutorial Parts ###
* [Part I - Scene Builder](/blog/2012/11/16/javafx-tutorial-addressapp-1)
* **Part II - Model and TableView**
* [Part III - Interacting with the User](/blog/2012/11/20/javafx-tutorial-addressapp-3) 
* [Part IV - CSS Styling](/blog/2012/11/26/javafx-tutorial-addressapp-4)
* [Part V - Storing Data as XML](/blog/2012/11/27/javafx-tutorial-addressapp-5)
* [Part VI - Statistics Chart](/blog/2012/12/04/javafx-tutorial-addressapp-6) 


## Create the Model Class ##
We need a model class to hold information about the people in our address book. Add a new class to the model package (`ch.makery.address.model`) called `Person`. This makes sense, since we want to manage people and their addresses. The `Person` class will have a few instance variables for the name, address and birthday. Add the following code to the class:

{% include_code javafx-addressapp/part-2/Person.java %}


## A List of Persons ##
The main Data that our application manages is a bunch of persons. Let's create a list for `Person` objects inside the `MainApp` class. All other controller classes will later get access to the list inside the `MainApp`. 

### ObservableList ###
We are working with JavaFX view classes that always need to be informed about any changes made to the list of persons. This is important, since otherwise the view would not be in sync with the data. For this purpose, JavaFX introduces some new [Collection classes](http://docs.oracle.com/javafx/2/collections/jfxpub-collections.htm). 

From those collections, we need the `ObservableList`. To create a new `ObservableList`, add the following code at the beginning of the `MainApp` class. We'll also add a constructor that creates some sample data and a public getter method:

```java MainApp.java
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

  // ...

	/**
	 * The data as an observable list of Persons.
	 */
	private ObservableList<Person> personData = FXCollections.observableArrayList();

	/**
	 * Constructor
	 */
	public MainApp() {
		// Add some sample data
		personData.add(new Person("Hans", "Muster"));
		personData.add(new Person("Ruth", "Mueller"));
		personData.add(new Person("Heinz", "Kurz"));
		personData.add(new Person("Cornelia", "Meier"));
		personData.add(new Person("Werner", "Meyer"));
		personData.add(new Person("Lydia", "Kunz"));
		personData.add(new Person("Anna", "Best"));
		personData.add(new Person("Stefan", "Meier"));
		personData.add(new Person("Martin", "Mueller"));
	}
  
	/**
	 * Returns the data as an observable list of Persons. 
	 * @return
	 */
	public ObservableList<Person> getPersonData() {
		return personData;
	}
  
// ...
```


## The PersonOverviewController ##
Now let's finally view some data in our table.

1. Create a normal class inside the controller package called `PersonOverviewController.java`.
2. We'll add some instance variables that give us access to the table and the labels inside the view. The fields and some methods have a special `@FXML` annotation. This is necessary for the fxml file to have access to those variables. After we have everything set up in the fxml file, the application will automatically fill the variables when the fxml file is loaded. So let's add the following code:

Note: Remember to always use the javafx imports (not awt or swing)!

```java PersonOverviewController.java
public class PersonOverviewController {
	@FXML
	private TableView<Person> personTable;
	@FXML
	private TableColumn<Person, String> firstNameColumn;
	@FXML
	private TableColumn<Person, String> lastNameColumn;
	
	@FXML
	private Label firstNameLabel;
	@FXML
	private Label lastNameLabel;
	@FXML
	private Label streetLabel;
	@FXML
	private Label postalCodeLabel;
	@FXML
	private Label cityLabel;
	@FXML
	private Label birthdayLabel;
	
	// Reference to the main application
	private MainApp mainApp;
	
	/**
	 * The constructor.
	 * The constructor is called before the initialize() method.
	 */
	public PersonOverviewController() {
	}
	
	/**
	 * Initializes the controller class. This method is automatically called
	 * after the fxml file has been loaded.
	 */
	@FXML
	private void initialize() {
    // Initialize the person table
		firstNameColumn.setCellValueFactory(new PropertyValueFactory<Person, String>("firstName"));
		lastNameColumn.setCellValueFactory(new PropertyValueFactory<Person, String>("lastName"));
	}
  
	/**
	 * Is called by the main application to give a reference back to itself.
	 * 
	 * @param mainApp
	 */
	public void setMainApp(MainApp mainApp) {
		this.mainApp = mainApp;
		
		// Add observable list data to the table
		personTable.setItems(mainApp.getPersonData());
	}
}
```

Now this code will need some explanation:

* All fields and methods where the fxml file needs access must be annotated with `@FXML`. Actually, only if they are private, but it's better to have them private and mark them with the annotation!.
* The `initialize()` method is automatically called after the fxml file has been loaded. At this time, all the FXML fields should have been initialized already.
* The `PropertyValueFactory` that we set on the table colums are used to determine which field inside the `Person` objects should be used for the particular column.
* The `setMainApp(...)` method must be called by the `MainApp` class. This gives us a way to access the `MainApp` object and get the list of data and other things. In fact, let's do that call right now. Replace the `showPersonOverview()` method with the following. It contains two additional lines:

```java MainApp.java
	/**
	 * Shows the person overview scene.
	 */
	public void showPersonOverview() {
		try {
			// Load the fxml file and set into the center of the main layout
			FXMLLoader loader = new FXMLLoader(MainApp.class.getResource("view/PersonOverview.fxml"));
			AnchorPane overviewPage = (AnchorPane) loader.load();
			rootLayout.setCenter(overviewPage);
			
			// Give the controller access to the main app
			PersonOverviewController controller = loader.getController();
			controller.setMainApp(this);
			
		} catch (IOException e) {
			// Exception gets thrown if the fxml file could not be loaded
			e.printStackTrace();
		}
	}
```


## Hook the view to the Controller ##
We're almost there! But one little thing is missing: We haven't told our `PersonOverview.fxml` file yet, which controller to use and which element should match to which field inside the controller.

1. Open `PersonOverview.fxml` with the Scene Builder.
2. Select the topmost *AnchorPane* in the Hierarchy.
3. Open *Code* on the right side and select the `PersonOverviewController` as **controller class**.   
{% img /images/javafx-addressapp/part-2/addressapp02.png %}

4. Select the TableView and choose under Properties the `personTable` field as **fx:id**.   
{% img /images/javafx-addressapp/part-2/addressapp03.png %}

5. Do the same for the columns and select `firstNameColumn` and `lastNameColumn` respectively.
6. For each label in the second column, choose the corresponding **fx:id**.
7. Important: Go back to Eclipse and refresh the entire AddressApp project (F5). This is necessary because Eclipse sometimes doesn't know about changes that were made inside the Scene Builder.


## Start the Application ##
When you start your application now, you should see something like the screenshot at the beginning of this blog post.   

Congratulations!

---

### What's Next? ###
In [Tutorial Part III](/blog/2012/11/20/javafx-tutorial-addressapp-3) we will add more functionality like adding, deleting and editing Persons.


### Download ###
[Source of Tutorial Part II](/downloads/javafx-addressapp/part-2/addressapp-part-2.zip) as Eclipse Project



