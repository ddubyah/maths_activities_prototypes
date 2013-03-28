# Maths Activity Prototypes

Experiments in creating maths activities for the web. The goal was to find an approach for creating engaging, interactive activities that can be used to illustrate, simulate and assess concepts associated with maths and the sciences.

The project contains 3 main experiments, accessible from the home page menu. View them [here](http://cdsmopen.github.com/maths_activities_prototypes/) or clone the project and run it up yourself.

## Project Pages


### [Experiments in d3](http://cdsmopen.github.com/maths_activities_prototypes/#experiments/d3playground)

Click on the co-ordinate values on the right of the page, and change them to see the geometry update. If at first you don't see anything, hit "reset". Save what you've done and reload it later with "save" and "load" (duh). This was a simple experiment to:

- draw some simple geometry
- create axis that update dynamically to accommodate the full range of coordinates.
- play with labeling the geometry
- Use backbone collections and models to represent geometry that could be visualised with d3
- Use localStorage to save geometry for later use

### [Right Angled Triangles](http://cdsmopen.github.com/maths_activities_prototypes/#maths/ra_triangles)

Use the form on the right to set the width and height for a right angled triangle. The geometry view should update automatically. The axis should adjust to accommodate any values (within reason). 

Once your triangle has been saved, you should see a permalink (to allow you to retrieve your triangle - I mean, why wouldn't you) and a link to "enlarge me", which allows you to use your creation on the "Enlargement" page (see below).

This was primarily an experiment in passing geometry between views. Imagine the triangle creator as the authoring step for the enlargement activity.

### [Enlargement](http://cdsmopen.github.com/maths_activities_prototypes/#maths/exercises/enlargement)

This page allows you to "enlarge" some geometry (in this case, a triangle you lovingly prepared earlier) around a customisable origin point. Use the "scalor" input on the right to set the size of the enlargement. Use the "x" and "y" inputs to set the origin point about which the enlargement takes place. You can even drag the origin point around! Whoop! 

## Built with:

- [d3.js](http://d3js.org) for visualisations
- [Backbone.js](http://backbonejs.org/) as an application framework
- [Backbone.localStorage](https://github.com/jeromegn/Backbone.localStorage) to allow local storage, rather than require a backend
- jquery, underscore - the usual suspects

- Yeoman.io
	- require.js
	- Bower.js
	- Grunt.js

## Installation

### Pre-Requirements

- [node.js](http://nodejs.org)
- [git](http://git-scm.com/downloads) for working with the repo

## Getting Started

Clone the repo to your local machine. From the command line run `npm install` to install the node dependencies. Then run `bower install` to install the client side dependencies.

Preview the project with `npm start`. 

# Coming Soon...

- Lessons Learned
- Documentation
- Tests?