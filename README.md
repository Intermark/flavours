![banner](resources/banner.png)

**Problem**

One codebase. Multiple Google Play Store submissions with different icons, XML resources, build configurations, etc.

**Solution**

```
$ flavours install
$ flavours create
```

**About**

Flavours is a command-line run ruby gem that reads from a .json file to create new [Product Flavors](http://tools.android.com/tech-docs/new-build-system/user-guide#TOC-Product-flavors) and adds them to your Android application's `build.gradle` file to make creating new apps a breeze. It allows you to have one code-base that can create a multitude of apps without very much involvement from you, the developer.

**TL;DR:** You can whitelabel Android apps extremely easily now.

**Requirements**

Flavours requires your Android application use the Gradle build system.

## Table of Contents

* [Installation](#installation)
* [Set Up](#set-up)
* [Formatting flavours.json](#formatting-flavoursjson)
* [Creating Flavors](#creating-flavors)
* [The Future](#the-future)
* [Contributing](#contributing)

## Installation

flavours is officially hosted on [RubyGems](http://rubygems.org/gems/flavours), so installation is a breeze:

    $ gem install flavours

## Set Up

Run `flavours install` in your app's main directory. This will create a file, `flavours.json`, where the configurations will be used to build out from here. You are almost ready to start creating new apps!

## Formatting flavours.json

Here's a basic gist of how to format your `flavours.json` file:

```json
{
    "flavours": [
        {
            "flavourName": "YourFlavor",
            "packageName": "somePackageName",
            "buildConfig": {
                "API_KEY": "someApiKey"
            },
            "iconUrl": "https://someurl.com/image.png",
            "colorsXML": {
                "primaryColor": "#E51919"
            },
            "stringsXML": {
                "someString": "someValue"
            }
        },
        {
            "flavourName": "YourFlavor2",
            "packageName": "somePackageName2",
            "buildConfig": {
                "API_KEY": "someApiKey"
            },
            "iconUrl": "https://someurl.com/image.png",
            "colorsXML": {
                "primaryColor": "#E51919"
            },
            "stringsXML": {
                "someString": "someValue"
            }
        }
    ]
}
```

In the top-level of the JSON file, we have the main key/value pair:

* `flavours`

This section contains an array of key/value pairs that correspond to each product flavor you'd like to create. Here are all of the possiblities:

* `flavourName`
* `iconURL` or `iconPath`
* `packageName`
* `buildConfig`
* `colorsXML`
* `stringsXML`
* `settingsXML`
* `drawables`

`flavourName` is required to build that Product Flavor. However, the other options are all optional. `[buildConfig, colorsXML, stringsXML]` all house more key/values that will be be turned in to XML, or `String` properties in the `BuildConfig.java` file specific to that Flavor.

`settingsXML` has a slightly different format. It's an array of objects with key/value pairs:

```json
"settingsXML": [
    {
        "type": "drawable",
        "name": "someDrawable",
        "value": "@drawable/someDrawable"
    }
]
```

This results in a settings.xml file where the lines look like this:

`<item name="NAME" type="TYPE">VALUE</item>`

`drawables` also has a slightly different format. It's an array of objects with key/value pairs like `settingsXML` is, but the pairs are slightly different.

```json
"drawables": [
    {
        "name": "some_image.png",
        "path": "path/relative/to/project/an_image.png"
    }
]
```

What this does is finds an image relative to your directory at the specified `path` key/value and then makes a copy of it to the appropriate `{flavour}/res/drawable` folder. It doesn't permanently move your file, just duplicates it in the correct spot. It puts it in a general drawable folder instead of one like drawable-hdpi. 

## Creating Flavors

Now that you're set up - it's time to run this bad boy! Make sure that you have updated your `flavours.json` file with the correct information for your apps, and then run the following command inside the project directory.

`flavours create -m NameOfMainAppModule`

What this does is goes to your `flavours.json` file and looks for your various flavors and attempts to add them to your `build.gradle` file in that specific module's folder. It will also go to the interwebs and download the file in the `iconURL` parameter if it's present and then chop it up into the different sizes your app needs.

**Other Options**

* `-d, --directory` - if not in the current directory, specify a new path
* `-u, --url` - the url of a flavours formatted JSON file

`flavours create -m NameOfMainAppModule -d ~/Path/To/App -u http://someurl.com/flavours.json`

## Global Options

`--dontlog` will not log the status/operations to the console.

`--help` will fill you in on what you need to do for an action.

## The Future

* Unit Tests
* Google Play Store deployment of Apps

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
