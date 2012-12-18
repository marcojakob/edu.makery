---
layout: post
title: "JavaFX TableView Filter"
date: 2012-12-18 23:30
comments: true
categories: [English, JavaFX]
published: true
---
The JavaFX 2 TableView lacks the ability for filtering. The intention before JavaFX 2.0 shipped was to include a `FilteredList` that would wrap an `ObservableList` (see Oracle forum [Filter rows on TableView](https://forums.oracle.com/forums/thread.jspa?threadID=2350647)). Unfortunately, the filtering was removed again. It will appear in JavaFX 8 which won't be released before late 2013.

In this post I will explain how we can manually do row filtering in JavaFX 2.

<!-- more -->

## Example Set Up ##
As an example we'll create a simple table that displays `Person`s. The table should be filtered whenever the user enters something in the text field. 

{% img /images/javafx-tableview-filter/tableview-filter-01.png %}

I prefer to define the user interface in `fxml` (with Scene Builder). The `fxml` looks like this:

{% include_code javafx-tableview-filter/PersonTable.fxml lang:xml %}

We'll need a class `Person` for the model:

{% include_code javafx-tableview-filter/Person.java %}

We'll need a `MainApp` to load everything:

{% include_code javafx-tableview-filter/MainApp.java %}

The most interesting part is the `PersonTableController` which I'll discuss a bit more now.


## Filtering ##
For the filtering to work, we need **two** `ObservableList`s. One list contains the original **master data** while the other contains the **filtered data** that will be displayed in the table.

The constructor puts the same sample data in both the `masterData` and `filteredData` lists. In the beginning nothing is filtered and the two lists contain the same data.

We'll also add a `ListChangeListener` to the `masterData`. Whenever something changes in `masterData` we'll also have to update the `filteredData`.

Now let's take a look at the code: 

{% include_code javafx-tableview-filter/PersonTableController.java %}


### Reacting to User Entering a Filter String ###
At the end of the method `initialize()` we add a `ChangeListener` to the text property of the `TextField`. Whenever the user changes the text, the `updateFilteredData()` method is called.

In `updateFilteredData()` we remove all items in `filteredData` and only add the data matching the current filter. 


### Changing Filter Behaviour ###
The method `matchesFilter(...)` determines which `Person`s will be displayed. I chose to look both in the `firstName` and `lastName` fields for a match of the String while ignoring the case.

You could a different kind of filter behaviour in this method like Regular Expressions.


### Reapply Table Sort Order ###
Whenever we change the filtering, the table must be resorted. The method `reapplyTableSortOrder()` is responsible to remove and set the sort order again.


## Conclusion ##
Event though this might not be the fastest and most generic filtering approach, it's still sufficient for many cases. For a more comfortable filtering we'll have to wait for JDK 8.