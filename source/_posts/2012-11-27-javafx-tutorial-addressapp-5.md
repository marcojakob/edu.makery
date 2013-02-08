---
layout: post
title: "JavaFX 2 Tutorial Part V - Storing Data as XML"
date: 2012-11-27 22:00
updated: 2013-02-08
comments: true
categories: [English, JavaFX]
published: true
---

{% img /images/javafx-addressapp/part-5/addressapp01.png %}

## Topics in Part V ##
* **Persisting data as XML**
* Using the JavaFX **FileChooser**
* Using the JavaFX **Menu**
* Saving the last opened file path in **user preferences**

<!-- more -->

### Other Tutorial Parts ###
* [Part I - Scene Builder](/blog/2012/11/16/javafx-tutorial-addressapp-1)
* [Part II - Model and TableView](/blog/2012/11/17/javafx-tutorial-addressapp-2) 
* [Part III - Interacting with the User](/blog/2012/11/20/javafx-tutorial-addressapp-3) 
* [Part IV - CSS Styling](/blog/2012/11/26/javafx-tutorial-addressapp-4)
* **Part V - Storing Data as XML**
* [Part VI - Statistics Chart](/blog/2012/12/04/javafx-tutorial-addressapp-6)
* [Part VII - Deployment with e(fx)clipse](/blog/2012/12/18/javafx-tutorial-addressapp-7)

## Saving User Preferences ##
Java allows us to save some application state using a class called `Preferences`. Depending on the operating system, the `Preferences` are saved in different places (e.g. the registry file in Windows).

We won't be able to use `Preferences` to store our entire address book. But it allows us to save some simple application state. One such thing is the path to the *last opened file*. With this information we could load the last application state whenever the user restarts the application.

The following two methods take care of saving and retrieving Preferences. Add them to the end of your `MainApp` class.

```java MainApp.java
/**
 * Returns the person file preference, i.e. the file that was last opened.
 * The preference is read from the OS specific registry. If no such
 * preference can be found, null is returned.
 * 
 * @return
 */
public File getPersonFilePath() {
  Preferences prefs = Preferences.userNodeForPackage(MainApp.class);
  String filePath = prefs.get("filePath", null);
  if (filePath != null) {
    return new File(filePath);
  } else {
    return null;
  }
}

/**
 * Sets the file path of the currently loaded file.
 * The path is persisted in the OS specific registry.
 * 
 * @param file the file or null to remove the path
 */
public void setPersonFilePath(File file) {
  Preferences prefs = Preferences.userNodeForPackage(MainApp.class);
  if (file != null) {
    prefs.put("filePath", file.getPath());
    
    // Update the stage title
    primaryStage.setTitle("AddressApp - " + file.getName());
  } else {
    prefs.remove("filePath");
    
    // Update the stage title
    primaryStage.setTitle("AddressApp");
  }
}
```


## Persisting Data as XML ##
At the moment our address application's data only resides in memory. Every time we close the application, the data is lost. So it's about time to start thinking persistently storing data.

### Why XML? ###
One of the most common ways to persist data is using a database. Databases usually contain some kind of relational data (like tables) while the data we need to save are objects. This is called the [object-relational impedance mismatch](http://wikipedia.org/wiki/Object-relational_impedance_mismatch). It is quite some work to match objects to relational database tables. There are some of frameworks that help with the matching (e.g. [Hibernate](http://www.hibernate.org/), the most popular one) but it still requires quite some work to set up.

For our simple data model it's much easier to use XML. We'll use a library called [XStream](http://xstream.codehaus.org/). With just a few lines of code this will allow us to generate XML output like this:

```xml sample.xml
<list>
  <person>
    <firstName>Hans</firstName>
    <lastName>Muster</lastName>
    <street>some street</street>
    <postalCode>1234</postalCode>
    <city>some city</city>
    <birthday>
      <time>1354035227734</time>
      <timezone>Europe/Berlin</timezone>
    </birthday>
  </person>
  <person>
    <firstName>Anna</firstName>
    <lastName>Best</lastName>
    <street>some street</street>
    <postalCode>1234</postalCode>
    <city>some city</city>
    <birthday>
      <time>1354035227734</time>
      <timezone>Europe/Berlin</timezone>
    </birthday>
  </person>
</list>
```


### Reading and Writing Files ###
Since Java 7 there are some convenient classes to deal with reading and writing files. For a detailed tutorial see Oracle's [File I/O Tutorial](http://docs.oracle.com/javase/tutorial/essential/io/fileio.html).

Since we might need to read/write files in different places of our application we'll create a handy `FileUtil` helper class. This class provides one static method for reading from a file and one for writing to a file. Copy the following file into the `ch.makery.util` package:

{% include_code javafx-addressapp/part-5/FileUtil.java %}


### Using XStream ###
To use XStream we need three libraries. Add the following libraries to the project's *lib* folder and add them to the build path (right click on libraries).

* [xstream-1.4.3.jar](/downloads/javafx-addressapp/part-5/xstream-1.4.3.jar) - XStream main library
* [xmlpull-1.1.3.1.jar](/downloads/javafx-addressapp/part-5/xmlpull-1.1.3.1.jar) - XmlPull to detect available parsers 
* [xpp3_min-1.1.4c.jar](/downloads/javafx-addressapp/part-5/xpp3_min-1.1.4c.jar) - Xpp3, a fast pull parser

You can also download the three libraries from the [XStream download page](http://xstream.codehaus.org/download.html).

We'll make our `MainApp` class responsible for reading and writing the person data. Add the following two methods to the end of `MainApp.java`:

```java MainApp.java
/**
 * Loads person data from the specified file. The current person data will
 * be replaced.
 * 
 * @param file
 */
@SuppressWarnings("unchecked")
public void loadPersonDataFromFile(File file) {
  XStream xstream = new XStream();
  xstream.alias("person", Person.class);
  
  try {
    String xml = FileUtil.readFile(file);
    
    ArrayList<Person> personList = (ArrayList<Person>) xstream.fromXML(xml);
    
    personData.clear();
    personData.addAll(personList);
    
    setPersonFilePath(file);
  } catch (Exception e) { // catches ANY exception
    Dialogs.showErrorDialog(primaryStage,
        "Could not load data from file:\n" + file.getPath(),
        "Could not load data", "Error", e);
  }
}

/**
 * Saves the current person data to the specified file.
 * 
 * @param file
 */
public void savePersonDataToFile(File file) {
  XStream xstream = new XStream();
  xstream.alias("person", Person.class);

  // Convert ObservableList to a normal ArrayList
  ArrayList<Person> personList = new ArrayList<>(personData);
  
  String xml = xstream.toXML(personList);
  try {
    FileUtil.saveFile(xml, file);
    
    setPersonFilePath(file);
  } catch (Exception e) { // catches ANY exception
    Dialogs.showErrorDialog(primaryStage,
        "Could not save data to file:\n" + file.getPath(),
        "Could not save data", "Error", e);
  }
}
```

The save method uses `xstream.toXML(...)` to convert the list of `Person` objects into an XML representation. The load method uses `xstream.fromXML(...)` to convert the xml data back to a list of `Person`s. 

If anything goes wrong, an error dialog is presented to the user.



## Handling Menu Actions ##
In our `RootLayout.fxml` there is already a menu, but we haven't used it yet. Before we add action to the menu we'll first create all menu items.

Open the `RootLayout.fxml` file in Scene Builder and drag the necessary menu items from the *library view* to the menu bar in the *hierarchy view*. Create a **New**, **Open...**, **Save**, **Save As...**, and **Exit** menu item. You may also use separators between some items.

{% img /images/javafx-addressapp/part-5/addressapp02.png %}

Hint: Using the *Accelerator* setting under properties you can set shortcut keys to menu items.


### The RootLayoutController ###
For handling menu actions we'll need a new controller class. Create a class `RootLayoutController` inside the controller package `ch.makery.address`. 

Add the following content to the controller:

{% include_code javafx-addressapp/part-5/RootLayoutController.java %}

The controller contains an `@FXML` method for each menu item.

#### FileChooser ####
Take note of the methods that use the `FileChooser` class inside `RootLayoutController` above. First, a new object of the class `FileChooser` is created. Then, an extension filter is added so that only files ending in `.xml` are displayed. Finally, the file chooser is displayed on top of the primary stage.

If the user closes the dialog without choosing a file, `null` is returned. Otherwise, we get the selected file and we can pass it to the `loadPersonDataFromFile(...)` or `savePersonDataToFile(...)` method of `MainApp`. 


### Connecting the fxml View to the Controller ###
1. Open `RootLayout.fxml` in Scene Builder. Select the root `BorderPane`. In the Code view select the `RootLayoutController` as Controller class. 

2. Select each menu item in the Hierarchy view. In the Code view under *On Action* you should see a choice of all the `@FXML` methods of the controller. Choose the corresponding method for each menu item.   
{% img /images/javafx-addressapp/part-5/addressapp03.png %}   
*If you don't see the choices in On Action*: Because of a [bug](http://javafx-jira.kenai.com/browse/DTL-5402) in Scene Builder you have to remove the controller from the root, hit enter, and add it again. I had to do this after every restart of Scene Builder! (**fixed in Scene Builder 1.1 beta 17 and above!**)

3. Close Scene Builder and hit **Refresh (F5)** on your project's root folder. This will make Eclipse aware of the changes you made in Scene Builder.


### Connecting the MainApp and RootLayoutController ###
In several places, the `RootLayoutController` needs a reference back to the `MainApp`. We haven't passed the reference to the `RootLayoutController` yet.

So, open the `MainApp` class and replace the `start(...)` method with the following code:

```java MainApp.java
@Override
public void start(Stage primaryStage) {
  this.primaryStage = primaryStage;
  this.primaryStage.setTitle("AddressApp");
  this.primaryStage.getIcons().add(new Image("file:resources/images/address_book_32.png"));
  
  try {
    // Load the root layout from the fxml file
    FXMLLoader loader = new FXMLLoader(MainApp.class.getResource("view/RootLayout.fxml"));
    rootLayout = (BorderPane) loader.load();
    Scene scene = new Scene(rootLayout);
    primaryStage.setScene(scene);
    
    // Give the controller access to the main app
    RootLayoutController controller = loader.getController();
    controller.setMainApp(this);
    
    primaryStage.show();
  } catch (IOException e) {
    // Exception gets thrown if the fxml file could not be loaded
    e.printStackTrace();
  }
  
  showPersonOverview();
  
  // Try to load last opened person file
  File file = getPersonFilePath();
  if (file != null) {
    loadPersonDataFromFile(file);
  }
}
```

Notice the two changes: The lines that *give the controller access to the main app* and the last three lines to *load the last opened person file*.


## How It Works ##
Doing a test drive of your application you should be able to use the menus to save the person data to a file and load it again. After a restart, it should automatically load the last used file.

Let's see how it all works together:

1. The application is started using the `main(...)` method inside `MainApp`.
2. The constructor `public MainApp()` is called and adds some sample data.
3. `MainApp`s `start(...)` method is called and initializes the root layout from `RootLayout.fxml`. The fxml file has the information about which controller to use and links the view to its `RootLayoutController`. 
4. The `MainApp` gets the `RootLayoutController` from the fxml loader and passes a reference to itself to the controller. With this reference the controller can later access the (public) methods of `MainApp`.
5. At the end of the `start(...)` method we try to get the *last opened person file* from `Preferences`. If the `Preferences` know about such an XML file, we'll load the data from this XML file. This will apparently overwrite the sample data from the constructor. 

---

### What's Next? ###
In Tutorial [Part VI](/blog/2012/12/04/javafx-tutorial-addressapp-6) we'll add a birthday statistics chart.


### Download ###
[Source of Tutorial Part V](/downloads/javafx-addressapp/part-5/addressapp-part-5.zip) as Eclipse Project.


