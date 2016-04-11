# flozone
An Atom toolbar to help you achieve flow state (aka "the Zone") and stay there through interruptions.

# Why flozone
As found by [Parnin](http://blog.ninlabs.com/2013/01/programmer-interrupted/):
>Episodic memory is the recollection of past events.

>Software developers continually encounter new learning experiences about their craft. Retaining and making use of those such acquired knowledge requires that developers are able to recollect those experiences from their episodic memory. When recalling from episodic memory, developers commonly experience failures that limit their ability to recall essential details or recollect the key events. For example, a developer may forget the changes they performed for a programming task, or forget details such as a the blog post that was used for implementing a part of the task.

`flozone` takes this idea to the simplest manifestation - a toolbar that uses the familiar media player metaphor to help you remember what you're doing and help you tide through interruptions

# Features
`flozone` is a toggle-able toolbar that sits on top of your Atom window and allows you to start on a particular task by naming it. You continue to work on your task until you're done, registering it by hitting the stop button or typing a new task.
![Screenshot](https://raw.githubusercontent.com/groktools/lilbro/master/flozone.png)

If/When you're interrupted in the middle of your task, you 'pause' the task by hitting the Pause button on the flow bar, and once the pesky interruption is done, you're reminded of your task because its name is front and center, and you can get back to the zone by pressing the Rewind button. This rewinds the last of your 15 actions in the IDE with enough delay for you to follow along, like so:

![Screenshot](https://raw.githubusercontent.com/groktools/lilbro/master/flozone-1.png)

... and then fast-forwards to your latest change by redoing all of the changes it just undid, like so:

![Screenshot](https://raw.githubusercontent.com/groktools/lilbro/master/flozone-2.png)

Yes, you could do this manually, but this plugin makes the computer work for you!

# Install

Download from the Atom packages site or install via apm - TBD.

# Status
4/4/2016: Basic functionality working. See Todos.md for next steps
