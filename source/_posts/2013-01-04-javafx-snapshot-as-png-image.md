---
layout: post
title: "JavaFX Snapshot as PNG Image"
date: 2013-01-04 14:00
comments: true
categories: [English, JavaFX]
published: true
---
JavaFX 2.2 and above provides a convenient `snapshot` feature. It takes a snapshot of any node or scene.

The following method saves the `barChart` node as a `png` image:

```java
@FXML
public void saveAsPng() {
	WritableImage image = barChart.snapshot(new SnapshotParameters(), null);
	
	// TODO: probably use a file chooser here
	File file = new File("chart.png");
	
    try {
        ImageIO.write(SwingFXUtils.fromFXImage(image, null), "png", file);
    } catch (IOException e) {
    	// TODO: handle exception here
    }
}
```

Note: You could test this code with our **AddressApp** example (see download at the end of [AddressApp Tutorial Part VII](/blog/2012/12/18/javafx-tutorial-addressapp-7)). Just add the `saveAsPng()` method to the `BirthdayStatisticsController` class and call the method through some action (e.g. a new button).