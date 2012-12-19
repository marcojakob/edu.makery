---
layout: post
title: "JavaFX TableView Cell Renderer"
date: 2012-12-19 03:00
comments: true
categories: [English, JavaFX]
published: true
---
In this post I will show how to customize the rendering of a JavaFX 2 TableView. The *Birthday* column in the screenshot below is a formatted `Calendar` object. Depending on the year, the text color is changed. 

{% img /images/javafx-tableview-cell-renderer/javafx-tableview-cell-renderer-01.png %}

<!-- more -->

## How a Table Cell is Rendered ##
Each table cell will receive an object, in our case it is an instance of `Person`. To do the rendering, the cell will need a [`Cell Value Factory`](http://docs.oracle.com/javafx/2/api/javafx/scene/control/TableColumn.html#setCellValueFactory(javafx.util.Callback)) and a [`Cell Factory`](http://docs.oracle.com/javafx/2/api/javafx/scene/control/TableColumn.html#setCellFactory(javafx.util.Callback)):

### Cell Value Factory ###
The cell must know which part of `Person` it needs to display. For all cells in the *birthday column* this will be the `Person`s `birthday` value.

This is our birthday column:

```java
private TableColumn<Person, Calendar> birthdayColumn;
```

And later during initialization, we'll set the `Cell Value Factory`:
```java
birthdayColumn.setCellValueFactory(
    new PropertyValueFactory<Person, Calendar>("birthday"));
```

So far nothing too fancy.


### Cell Factory ###
Once the cell has the value, it must know how to display that value. In our case, the birthday's `Calendar` value must be formatted and colored depending on the year.

```java
birthdayColumn.setCellFactory(new Callback<TableColumn<Person, Calendar>, TableCell<Person, Calendar>>() {
	@Override
	public TableCell<Person, Calendar> call(TableColumn<Person, Calendar> param) {
		return new TableCell<Person, Calendar>() {
    
			@Override
			protected void updateItem(Calendar item, boolean empty) {
				super.updateItem(item, empty);
        
              if (!empty) {
                // Use a SimpleDateFormat or similar in the format method
                setText(format(item));
                
                if (item.get(Calendar.YEAR) == 2011) {
                  setTextFill(Color.CHOCOLATE);
                } else {
                  setTextFill(Color.BLACK);
                }
              }
			}
		};
	}
});
```

The `Cell Factory` contains some complicated stuff (*Callback*, *Generics* and *Anonymous Inner Classes*). Don't worry too much about all this. Just focus on the important part which is the `updateItem(...)` method. 

This `updateItem(...)` method gets called whenever the cell should be rendered. We receive the `Calendar` item that must be rendered. If empty is `true` we don't do anything. Otherwise we format the item and set the text of the cell. Depending on the year, we also set the text color.


## ListView and TreeView ##
Note that the JavaFX 2 [`ListView`](http://docs.oracle.com/javafx/2/api/javafx/scene/control/ListView.html) and [`TreeView`](http://docs.oracle.com/javafx/2/api/javafx/scene/control/TreeView.html) are rendered in a very similar way.


## Download ##
Download the complete [tableview-cell-renderer example](/downloads/javafx-tableview-cell-renderer/javafx-tableview-cell-renderer.zip).
