---
layout: post
title: "JavaFX 2 Tutorial Part VII - Deployment with e(fx)clipse"
date: 2012-12-18 01:00
updated: 2013-02-11
comments: true
categories: [English, JavaFX]
published: true
---

**Updated Feb 11th, 2013**: New instructions for Deployment on Mac OS. Thank you Eskil for providing me with this information!

{% img /images/javafx-addressapp/part-7/addressapp01.png %}

I thought I'd write one last part of this tutorial series to show how to deploy (i.e. package and publish) the AddressApp.

Download example AddressApp as 

* Windows exe installer: [AddressApp-0.7.exe](https://www.dropbox.com/s/jk5ilt3p47c674z/AddressApp-0.7.exe).
* MacOS dmg drag-and-drop installer: [AddressApp.dmg](https://www.dropbox.com/s/cfpr4bh25u8qsmz/AddressApp.dmg) - Thank you Eskil for providing this!


## Topics in Part VII ##
* Deploying our JavaFX application as **Native Package** with e(fx)clipse

<!-- more -->

### Other Tutorial Parts ###
* [Part I - Scene Builder](/blog/2012/11/16/javafx-tutorial-addressapp-1)
* [Part II - Model and TableView](/blog/2012/11/17/javafx-tutorial-addressapp-2) 
* [Part III - Interacting with the User](/blog/2012/11/20/javafx-tutorial-addressapp-3) 
* [Part IV - CSS Styling](/blog/2012/11/26/javafx-tutorial-addressapp-4)
* [Part V - Storing Data as XML](/blog/2012/11/27/javafx-tutorial-addressapp-5)
* [Part VI - Statistics Chart](/blog/2012/12/04/javafx-tutorial-addressapp-6) 
* **Part VII - Deployment with e(fx)clipse**


## What is Deployment ##
Deplyoment is the process of packaging and delivering software to the user. This is a crucial part of software development since it's the first contact a user has with our software.

Java advertises with the slogan **Write Once, Run Anywhere** to illustrate the *cross-platform* benefits of the Java language. Ideally, this means that our Java application can be run on any device equipped with a Java virtual machine (JVM).

In the past, the user experience for installing a Java application hasn't always been smooth. If the user didn't have the required Java version on his system, he had to be directed to install it first. This lead to some difficulties, e.g. need for admin rights, compatibility issues between Java versions, etc.

Fortunately, JavaFX 2 provides a new deployment option called **Native Packaging** (also called Self-Contained Application Package). A native package is a bundle containing both your application code and the (platform-specific) Java Runtime. 

The official JavaFX documentation by Oracle contains an extensive guide for all possible [JavaFX deployment options](http://docs.oracle.com/javafx/2/deployment/jfxpub-deployment.htm). 

In this post I will show how to create a **Native Package** with with Eclipse and the [**e(fx)clipse plugin**](http://efxclipse.org). My current e(fx)clipse version is **0.1.1**.


## Create a Native Package ##
The goal is to create a self-contained application in a single folder on the user's computer. Here is how it will look like for our AddressApp (on Windows):

{% img /images/javafx-addressapp/part-7/addressapp02.png %}

The `app` folder contains our application data and the `runtime` folder contains the platform-specific Java runtime.

To make it even more comfortable for the user, we'll provide an installer:

* A `.exe` file installer on windows
* A `dmg` (drag and drop) installer for MacOS.

The e(fx)clipse plugin will help us generate the native package and installer.


### Step 1 - eclipse.ini ###

**Note**: Step 1 might not be necessary with e(fx)clipse 0.8.0 and above. See [Tom Schindl's comment](/blog/2012/12/18/javafx-tutorial-addressapp-7#comment-742775781) below (the author of e(fx)clipse).

JavaFX uses a tool called [Ant](http://ant.apache.org/) to build and package the application. This tool is already included in Eclipse. As Ant depends on the JDK we need to make shure Eclipse itself runs with the JDK (not the JRE).

1. Close Eclipse.
2. Find the folder of your Eclipse installation and open the file `eclipse.ini` in a text editor. This file contains Eclipse startup settings. On Mac OS X, eclipse.ini can be found by right-clicking Eclipse.app and selecting "Show package contents". The file is located under Contents/MacOS.
3. After the line `openFile` add `-vm` and then specify your **jdk installation directory**. The end of the file should now look like this:
```text eclipse.ini
openFile
-vm
C:\Program Files\Java\jdk1.7.0_09\bin\javaw.exe
-vmargs
-Xms40m
-Xmx512m
```

**Mac OS**: For Mac OS, path can be something like /Library/Java/JavaVirtualMachines/jdk1.7.0_07.jdk/Contents/Home/bin/java (In my version the javaw.exe does not exist but I specified "java" instead which seemed no problem)


### Step 2 - Installer Icons ###
We would like to have some nice icons for our installer:

1. Download [AddressApp.ico](/downloads/javafx-addressapp/part-7/AddressApp.ico), [AddressApp-setup-icon.bmp](/downloads/javafx-addressapp/part-7/AddressApp-setup-icon.bmp) and [AddressApp.icns](/downloads/javafx-addressapp/part-7/AddressApp.icns).
2. Copy the three icons to the project root of your AddressApp project in Eclipse.

{% img /images/javafx-addressapp/part-7/addressapp03.png %}


### Step 3 - Edit build.fxbuild ###
The file `build.fxbuild` is used by e(fx)clipse to generate a file that will be used by the Ant build tool. If you don't have a `build.fxbuild` file, create a new *Java FX Project* in Eclipse and copy the generated file.

1. Open `build.fxbuild` from your project root.
2. Fill out all the fields containing a star. For Mac OS: Do not use spaces in Application title as this seems to cause a problem.    
{% img /images/javafx-addressapp/part-7/addressapp04.png %}

3. Switch to the **Deploy** tab at the bottom.
4. Select the *Native Package* check box.   
{% img /images/javafx-addressapp/part-7/addressapp05.png %}

5. Go back to the **Overview** tab and click on the link `Generate ant build.xml only` (found on the right side).
6. Verify that a new `build` folder and a file `build.xml` is created.


### Step 4 - Edit build.xml ###
E(fx)clipse has generated a file `build/build.xml` which is ready to be executed by **Ant**. As e(fx)clipse (in the current version 0.1.1) can't be told to include additional resources like our `resources` folder and the few installer icons we've added above, we have to manually edit the `build.xml`:

Open `build.xml` and find the path `fxant`. Add one line for the `${basedir}` (will make our installer icons available):

```xml build.xml
    <path id="fxant">
      <filelist>
        <file name="${java.home}\..\lib\ant-javafx.jar"/>
        <file name="${java.home}\lib\jfxrt.jar"/>
        <file name="${basedir}"/>
      </filelist>
    </path>
```

Find the following block further down in the file:

```xml
		<fx:resources id="appRes">
			<fx:fileset dir="dist" includes="AddressApp.jar"/>
			<fx:fileset dir="dist" includes="libs/*"/>
		</fx:resources> 
```

**Replace** the four lines obove with the following code:

```xml
		<mkdir dir="dist/resources" />
		<copy todir="dist/resources" >
			<fileset dir="../resources" />
		</copy>
		
		<mkdir dir="package" />
		<mkdir dir="package/windows" />
		<copy todir="package/windows">
			<fileset dir="..">
				<include name="AddressApp.ico" />
				<include name="AddressApp-setup-icon.bmp" />
			</fileset>
		</copy>
		
		<mkdir dir="package/macosx" />
		<copy todir="package/macosx">
			<fileset dir="..">
				<include name="AddressApp.icns" />
			</fileset>
		</copy>		
		
		<fx:resources id="appRes">
			<fx:fileset dir="dist" includes="AddressApp.jar"/>
			<fx:fileset dir="dist" includes="libs/*"/>
			<fx:fileset dir="dist" includes="resources/**"/>
		</fx:resources> 
```


### Step 5 (WINDOWS) - Windows exe Installer ###
{% img /images/javafx-addressapp/part-7/addressapp06.png %}

With **Inno Setup** we can create a Windows Installer of our application as a single `.exe` file. The resulting `.exe` will perform a user level installation (no admin permissions required). A shortcut will be created (menu or desktop)

1. Download [Inno Setup 5 or later](http://www.jrsoftware.org/isdl.php). Install Inno Setup on your computer. Our Ant script will use it to automatically generate the installer.
2. Add the path to Inno Setup (e.g. `C:\Program Files (x86)\Inno Setup 5`) to the `PATH` variable in your windows environment variables.


### Step 5 (MAC) - MacOS dmg Installer ###
{% img /images/javafx-addressapp/part-7/addressapp07.png %}

To create a Mac OS `dmg` drag-and-drop installer, no additional tool is required.

Note: For the installer image to work it must have exactly the same name as the application.


### Step 5 (LINUX etc.) - Linux rpm Installer ###
For other packaging options (`msi` for windows, `rpm` for Linux) see this native packaging [blog post](https://blogs.oracle.com/talkingjavadeployment/entry/native_packaging_for_javafx) or this [oracle documentation](http://docs.oracle.com/javafx/2/deployment/self-contained-packaging.htm#A1324980).


### Step 6 - Run build.xml ###
As a final step, we run the `build.xml` with Ant: *Right-click* on the `build.xml` file | *Run As* | *Ant Build*.

{% img /images/javafx-addressapp/part-7/addressapp08.png %}

The building **will take a while**, about 1 minute on my computer.

If everything was successful, you should find the native bundle in the folder `build/deploy/bundles`:

* Windows: The file `AddressApp-1.0.exe` can be used as a single file to install the application. This installer will copy the bundle to `C:/Users/[yourname]/AppData/Local/AddressApp`.
* Hint: You could also use the subfolder `build/deploy/bundles/AddressApp` to deploy the application as a `.zip` file.


---

### What's Next? ###
I hope this tutorial was a help for you to get started with JavaFX and you'll be able to write your own JavaFX project from here. I might add some further JavaFX blog posts outside of this tutorial series, we'll see...

I appreciate any feedback. Feel free to write comments if you have any suggestions or if something was unclear.

### Download Source ###
[Source of Tutorial Part VII](/downloads/javafx-addressapp/part-7/addressapp-part-7.zip) as Eclipse Project.


