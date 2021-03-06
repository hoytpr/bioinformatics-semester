---
layout: page
element: notes
title: Introduction to the Shell
language: Shell
---

#### Questions:
- What is a command shell and why would I use one?

#### Objectives:
- Explain how the shell relates to the keyboard, the screen, the operating system, and users' programs.
- Explain when and why command-line interfaces should be used instead of graphical interfaces.

### Setup
Make sure you've downloaded and installed the files and directories for 
the [setup for this lesson]({{ site.baseurl }}/computer-setup).

### Background
At a high level, computers do four things:

-   run programs
-   store data
-   communicate with each other, and
-   interact with us


They can do the last of these in many different ways,
including through a keyboard and mouse, touch screen interfaces, or using speech recognition systems.
While touch and voice interfaces are becoming more commonplace, most interaction is still
done using traditional screens, mice, touchpads and keyboards.

We are all familiar with **graphical user interfaces** (GUI): windows, icons and pointers.
They are easy to learn and fantastic for simple tasks where a vocabulary consisting of
"click" translates easily into "do the thing I want". But this magic relies on 
wanting a simple set of things, and having programs that can do exactly those things.

If you wish to do complex, purpose-specific things it helps to have a richer means
of expressing your instructions to the computer. It doesn't need to be complicated or
difficult, just a vocabulary of commands and a simple grammar for using them.

This is what the shell provides - a **simple language** and a **command-line interface** 
to use it through. 

The heart of a command-line interface is a **read-evaluate-print loop** (REPL). It is called
so because when you type a command and press <kbd>Return</kbd> (also known as <kbd>Enter</kbd>) the shell
reads your command,
evaluates (or "executes") it,
prints the output of your command,
loops back and waits for you to enter another command.
 
### The Shell

The Shell is a program which runs other programs rather than doing calculations itself.
The most common Unix shell is Bash, (the Bourne Again SHell --- so-called because 
it's derived from a shell written by Stephen Bourne).
Bash is the default shell on most modern implementations of Unix
and in most packages that provide Unix-like tools for Windows.

### What does it look like?

A typical shell window (sometimes called a "terminal" window) looks something like:

~~~
bash-3.2$ 
bash-3.2$ ls -F / 
Applications/         System/
Library/              Users/
Network/              Volumes/
bash-3.2$ 
~~~

This is an example of the **comand line interface** we mentioned.
The first line shows only a **prompt** ("bash-3.2$"),
indicating that the shell (in this case, a version "3.2") is ***waiting for input***.
Technically, only the "$" is the "prompt", but your shell (or other shell windows) 
may include additional informative text with the prompt.    
Most importantly:    
When typing commands, either from these lessons or from other sources,
*do not type the prompt*, only the commands that follow it.

In the above example, the part that **you** type is the second 
line of the example:

`ls -F /`

This typically has the following structure: a **command**,
followed by **flags** (also called **options** or **switches**), followed by an **argument**.

**Commands** are actually special programs that are built into the Shell, 
and are mostly the same for all types of "shells" available.

**Flags** start with a single dash (`-`) or two dashes (`--`), and change the behavior of a command.

**Arguments** tell the command what to operate on (e.g. files and directories).

Sometimes flags and arguments are referred to as ***parameters***.
A command can be called with more than one flag and more than one argument: or, a
command may not require an argument or a flag.

In the second line of the example above, our **command** is `ls`, 
with a <kbd>SPACE</kbd> followed by the **flag** `-F`, another <kbd>SPACE</kbd>, and an
**argument** `/`. Arguments are *not always* used. Importantly, each 
part is separated by **spaces**!

If you omit the space 
between `ls` and `-F` the shell will look for a command called `ls-F`, which 
doesn't exist. Also, ***capitalization matters***: `ls -f` is different from `ls -F` 
(EXCEPTION: Windows systems, and therefore GitBash, don't always care about 
capitalization of the **command** but the flags must be capatalized correctly). 

On the next line we see the **output** that our command produced. In this case it is a listing 
of files and folders in a location called `/` - we'll cover what all these mean 
later today. Those using a macOS might recognize the output in this example.

The final part is when the shell again prints the prompt and waits for you to type the next 
command.

In the examples for this lesson, we'll show the prompt as `$ `. Your prompt may look 
different, and if you want can make your 
prompt look the same by executing the command `PS1='$ '`. But you can also leave 
your prompt as it is - often the extra information in the prompt includes who and where 
you are.

Open a shell window (Windows users open the "GitBash" window) and try 
executing `ls -F /` for yourself (don't forget that spaces
and capitalization are important!). You can change the prompt too, if you like.

### How does the shell know what `ls` and its flags mean?

Every command is a **program** stored somewhere on the computer, and the shell keeps a
list of places to search for these commands (the list is in a **variable** called `PATH`, 
but those are concepts we'll meet later and are not too important at the moment). 
Right now, the most important thing to remember is
that commands, flags and arguments are separated by spaces.

So let's look at the REPL (read-evaluate-print loop) in our example. Notice that the
"evaluate" step is made of two parts:

1. Read what was typed (`ls -F /` in our example)  
    The shell uses the spaces to split the line into the command, flags, and arguments
2. Evaluate:  
    a. Find a program called `ls`  
    b. Execute it, passing it the flags and arguments (`-F` and `/`) to 
       interpret as the program sees fit 
3. Print the output produced by the program
4. Then print the prompt again and wait for you to enter another command.

> ## Command not found 
> If the shell can't find a program whose name is the command you typed, it 
> will print an error message like:
> 
> ~~~
> $ ls-F
> -bash: ls-F: command not found
> ~~~
> 
> Usually this means that you have mis-typed the command. In this case we omitted
> the space between `ls` and `-F`. 

### Is the Shell difficult?

The Shell is more difficult than interacting with a GUI, and that 
will take some effort and time to learn. An important difference however is that a GUI 
presents you with **pre-defined** choices and you select one. 
With a **command line interface** (CLI) 
there are many more choices that are combinations 
of commands and parameters, more like words in a language than buttons on a screen. They
are not presented to you so
you must learn a few, like learning some vocabulary in a new language. But a small 
number of commands gets you a long way, and we'll cover an essential few today.

### The Shell provides flexibility and automation 

Learning the grammar of a shell is important because it allows you to 
combine existing tools into powerful
pipelines and handle large volumes of data automatically. Sequences of
commands can be written into a *script*, improving the reproducibility of 
workflows and allowing you to repeat them easily.

In addition, the command line is often the easiest way to interact with remote machines and supercomputers.
Familiarity with the shell is pretty much essential to run a variety 
of specialized tools and resources used on 
high-performance computing systems.
As clusters and cloud computing systems become more essential for scientific data crunching,
being able to interact with the shell is a necessary skill.
We can build on the command-line skills covered here
to tackle a wide range of scientific questions and computational challenges.

### Download our lesson data

Make sure you've downloaded and installed the files and directories for 
the [setup for this lesson]({{ site.baseurl }}/computer-setup).
If not, download the 56Mb ["data-shell.zip" file from Canvas](https://canvas.okstate.edu/files/4006292/download?download_frd=1) and place the 
file on your desktop using your GUI interface (if you are using one). 
If the link above doesn't work, you will have to log into Canvas 
at [the course site](https://canvas.okstate.edu/courses/78098), and go to the "Files" to download. 
Then unzip the file using your computers' GUI operating system and you should have a folder 
named "data-shell" on your Desktop. This is where we begin exploring the BASH shell.
To make sure everything is set up properly, open your Shell Window and type:
```
$ cd
```
Hit the "return" key, then type:
```
$ ls Desktop/data-shell

creatures/          Jul26-2019-history.txt  pizza.cfg
data/               molecules/              sample_submission.txt
DataOrgSpreadTest/  north-pacific-gyre/     solar.pdf
IsolateData.csv     notes.txt               writing/
````
The output should be similar to the one above. 

### Nelle's Pipeline: A Starting Point

Nelle Nemo, a marine biologist,
has just returned from a six-month survey of the
[North Pacific Gyre](http://en.wikipedia.org/wiki/North_Pacific_Gyre),
where she has been sampling gelatinous marine life in the
[Great Pacific Garbage Patch](http://en.wikipedia.org/wiki/Great_Pacific_Garbage_Patch).
She has 1520 samples in all and now needs to:

1.  Run each sample through an assay machine
    that will measure the relative abundance of 300 different proteins.
    The machine's output for each individual sample is
    a file with one line for each of the 300 proteins.
2.  Calculate statistics for each of the proteins separately
    using a program her supervisor wrote called `goostats`.
3.  Write up results.
    Her supervisor would really like her to do this by the end of the month
    so that her paper can appear in an upcoming special issue of *Aquatic Goo Letters*.

It takes about half an hour for the assay machine to process each sample.
The good news is that
it only takes two minutes to set each one up.
Since her lab has eight assay machines that she can use simultaneously,
this assay step will "only" take about two weeks.

The bad news is that if she has to run `goostats` by hand using a GUI,
she'll have to select a file using an "open file" dialog, 1520 times.
At 30 seconds per sample,
the whole process will take more than 12 hours
(and that's assuming the best-case scenario where she is ready to select the next file
as soon as the previous sample analysis has finished).
Only a machine could do this without taking breaks, so it'll probably 
take much longer than 12 hours. Also the chances of her selecting all 1520 files correctly 
and keeeping the outputs perfectly organized are practically zero.
But Nelle really doesn't want to miss that paper deadline.

The next few lessons will explore what she can do instead.
More specifically,
they explain how she can use a command shell to run the `goostats` program,
and use **loops** to automate the repetitive steps *e.g.* entering file names,
so that her computer can work 24 hours a day while she writes her paper.

As a bonus,
once she has put a processing pipeline together,
she will be able to use it again whenever she collects more data.

#### Keypoints:
- The shell uses a read-evaluate-print-loop cycle.
- Most commands take flags (options) which begin with a `-`.
- Identify commands, flags, and filenames.
- A shell is a program whose primary purpose is to read commands and run other programs.

[Go to the next lesson]({{ site.baseurl }}/materials/shell02)