---
layout: page
element: notes
title: Project Organization
language: Shell
---
### Questions:
- What [options](#options) for this course curricula exist?
- How can I organize my file system for a new bioinformatics project?
- How can I document my work?

### Objectives:
- Create a file system for a bioinformatics project.
- Explain what types of files should go in your `docs`, `data`, and `results` directories.
- Use the `history` command and a text editor like `nano` to document your work on your project.

### Getting your project started

**Project organization** is one of the most **important** parts of 
a sequencing project, and yet is often overlooked amidst the
excitement of getting a first look at new data. You can always reorganize your project when (for example) you decide to publish the data, but it's much better to get yourself organized from the beginning.   

You should approach your sequencing project similar to any 
biological experiment, which ideally begins with good 
experimental design. 

> We're going to *assume* that you've 
> already designed a beautiful sequencing experiment to 
> address your biological hypothesis, collected appropriate 
> samples, are using appropriate controls, and that you 
> have enough statistical power to 
> answer the questions you're interested in asking... RIGHT ?!?!? 
> These steps are all incredibly important, but beyond the scope 
> of these lessons. 

For all of those steps (collecting 
specimens, extracting DNA, prepping your samples, etc.)
you've likely kept a **lab notebook** that details how 
and why you did each step. However, the process of documentation 
doesn't start or stop at the sequencer!  

Genomics projects can quickly accumulate hundreds of files across 
dozens of folders. Every computational analysis you perform over 
the course of your project is going to create
**many** files, which becomes a problem when you'll *inevitably 
want to run some of those analyses again, or document 
how you performed the analyses*. Try to think in 
terms of your "past-self", "present-self" and "future self". 
For instance, your present-self might have made significant 
headway into your project, but then has to remember the PCR conditions
your past-self used to create your sequencing library months prior. 

Examples of just a few "future-self" questions that might arise: 
- What were your best alignment results?
- Which folder were they in: Analysis1, AnalysisRedone, or AnalysisRedone2?
- Which quality cutoff did you use?
- What version of a given program did you use to implement your analysis?

The only way to prevent these from being problems is by good documentation!
It's worthwhile to consider your future-self as an entirely separate 
collaborator. The better your documentation is, the more this 
'collaborator' will thank you!

Luckily enough, recording your computational experiments is 
even easier than recording lab data. Copy/Paste will become
your friend, sensible file names will make your analysis 
understandable (by you and your collaborators), and 
writing the methods section for your next paper should be easy! 
With this in mind, let's have a look at the best practices for 
documenting your genomics project. 
<a name="options"></a>
## Options for this course

Here is where the course and the workshops start to diverge into ***options***.    
**Option A** is to use an online cloud computing resource (currently AWS) as is 
described in the [Data Carpentry Genomics Workshop Setup pages](https://datacarpentry.org/genomics-workshop/setup.html).     
**Option B** is on the same page as **Option A** but is "Using the lessons on 
your local machine". For Windows users, this works, mostly, using the 
Ubuntu for Windows 10 Bash shell. For Mac or Linux machines, you might want to go for it!!!    
**Option C** might be available where you work using the University's supercomputers.     
[**Option D**]({{ site.baseurl }}/materials/genomics-project-organization-optionD/#optionD) 
is a great option. Clicking this link will open a NEW Lesson on the [Cyverse "Atmosphere"](https://www.cyverse.org/atmosphere) 
if the cloud instance remains available.

### Option A using AWS

***AWS:*** Follow the instructions on the [Data Carpentry Genomics Workshop Setup pages](https://datacarpentry.org/genomics-workshop/setup.html). 

While logged into your AWS instance (or from inside of a 
terminal window)     
We start by **creating a directory**
that we can use for the rest of the workshop/lesson. First navigate 
to your AWS home directory. Use `cd` <kbd>Enter</kbd>, and 
confirm that you are in the correct directory using the `pwd` command.

~~~
$ cd
$ pwd
~~~

You should see the following as output: 

~~~
/home/dcuser  
~~~

> #### In-class Exercise  
> Use the `mkdir` command to make the following directories:   
> - `dc_workshop`
> - `dc_workshop/docs`
> - `dc_workshop/data`
> - `dc_workshop/results`
> 
> > #### Solution
> > 
> > ~~~
> > $ mkdir dc_workshop
> > $ mkdir dc_workshop/docs
> > $ mkdir dc_workshop/data
> > $ mkdir dc_workshop/results
> > ~~~

Use `ls -R` to verify that you have created these directories. The `-R` option for `ls` stands for recursive. This option causes
`ls` to return the contents of each subdirectory within the directory
iteratively. 

~~~
$ ls -R dc_workshop
~~~

You should see the following output:

~~~
dc_workshop/:
data  docs  results

dc_workshop/data:

dc_workshop/docs:

dc_workshop/results: 
~~~

### Organizing your files

Before beginning any analysis, it's important to save a copy of your
raw data. The raw data should never be changed. Regardless of how
sure you are that you want to carry out a particular data cleaning
step, there's always the chance that you'll change your mind later 
or that there will be an error in carrying out the data cleaning and
you'll need to go back a step in the process. Having a raw copy of 
your data that you never modify guarantees that you will always be
able to start over if something goes wrong with your analysis. When
starting any analysis, you can make a copy of your raw data file and
do your manipulations on that file, rather than the raw version. We
learned in [the READINGS for today's lesson](http://www.datacarpentry.org/shell-genomics/03-working-with-files/#file-permissions) how to prevent overwriting our raw data
files by setting restrictive file permissions. 

> NOTE: We previously used the `chmod` command in the Bash shell 
> to make files executable, but this didn't work in the Windows 
> `GitBash` terminal. This is a good time to review file permissions 
> while we are using a "real" linux environment.

We will store any results generated from our analysis in
the `results` folder. This guarantees that we won't confuse results
file and data files in six months or two years when your 
future self is looking
back through your files in preparation for publishing your study.

The `docs` folder is the place to store notes about how your analyses 
were carried out, any written contextual analysis of your
results, and documents related to your eventual publication.

### Documenting your activity on the project

When carrying out wet-lab analyses, most scientists work from a 
written protocol and keep a hard copy of written notes in their lab
notebook. Daily notes include any things they did differently from the 
written protocol. This detailed
record-keeping process is **just as important** when doing computational
analyses. Luckily, it's easier to record the steps you've 
carried out computationally than it is when working at the bench.

The **`history`** command is a convenient way to document all the
commands you have used while analyzing and manipulating your project
files. Let's document the work we have done on our project so far. 

View the commands that you have used so far during this session using `history`:

~~~
$ history
~~~

You should see that history contains all your entered shell commands. 
There are probably more commands than you have used for the current
project. To view the last **`n`** lines of your history 
(where `n` = approximately the last few lines you think relevant) 
we can use `tail`. 
For our example, to view the last 7 shell commands:

~~~   
$ history | tail -n 7
~~~

Using your knowledge of the shell, use the append 
redirect `>>` to create a file called
`dc_workshop_log_XXXX_XX_XX.sh` (Use the four-digit year, 
two-digit month, and two digit day, *e.g.*
`dc_workshop_log_2020_10_27.sh`)  

You may have noticed that your history contains the `history` 
command itself. To remove this redundancy
from our log, let's use the `nano` text editor to fix the file:  

~~~
$ nano dc_workshop_log_2020_10_27.sh
~~~

(Remember to replace the `2020_10_27` with your *actual*
lesson or workshop date.)

From the `nano` screen, you can use your cursor to navigate, type, and delete line numbers, or any redundant lines.   

> #### Navigating in Nano
> 
> We know `nano` is useful and not too complicated, but it can be frustrating to edit documents, because you 
> can't use your mouse to navigate to the part of the document you would like to edit.
> Here are some useful keyboard shortcuts for moving around within a text document in 
> `nano`. You can find more information by typing <kbd>Ctrl</kbd>-<kbd>G</kbd> within `nano`.
> 
> | key     | action |
> | ------- | ---------- |
> | <kbd>Ctrl</kbd>-<kbd>Space</kbd> | to move forward one word |
> | <kbd>Alt</kbd>-<kbd>Space</kbd> | to move back one word |
> | <kbd>Ctrl</kbd>-<kbd>A</kbd> | to move to the beginning of the current line |
> | <kbd>Ctrl</kbd>-<kbd>E</kbd> | to move to the end of the current line |
> | <kbd>Ctrl</kbd>-<kbd>W</kbd> | to search |
> 

Add a date line and comment to the line where you have created the directory, for example:   

~~~
# 2020_10_27   
# Created sample directories for the Data Carpentry workshop  
~~~

The bash shell treats the `#` character as a comment character.    
**Any text on a line after a `#` character is ignored by bash** 
when evaluating the text 
as code with [one exception](https://en.wikipedia.org/wiki/Shebang_(Unix)). 

Next, remove any lines of the history that are not relevant by 
navigating to those lines and using your 
delete key. Save your file and close `nano`.

Your file should look something like this: 

~~~
# 2020_10_27
# Created sample directories for the Data Carpentry workshop

mkdir dc_workshop
mkdir dc_workshop/docs
mkdir dc_workshop/data
mkdir dc_workshop/results
~~~

If you keep this file up to date, you can use it to re-do your work on 
your project if something happens to your results files. To demonstrate 
how this works, first delete
your `dc_workshop` directory and all of its subdirectories. 
Look at your directory 
contents to verify the directory is gone. 

~~~
$ rm -r dc_workshop
$ ls
shell_data	dc_workshop_log_2020_10_27.sh
~~~

Then run your workshop log file as a bash script. You should see the `dc_workshop`
directory and all of its subdirectories reappear. 

~~~
$ bash dc_workshop_log_2020_10_27.sh
$ ls
shell_data	dc_workshop dc_workshop_log_2020_10_27.sh
~~~

It's important that we keep our workshop log file outside of our `dc_workshop` directory
if we want to use it to recreate our work. It's also important for us to keep it up to
date by regularly updating with the commands that we used to generate our results files.

**Congratulations!** You've finished your introduction to using the shell for genomics
projects. You now know how to navigate your file system, create, copy, move,
and remove files and directories, and automate repetitive tasks using scripts and 
wildcards. With this solid foundation, you're ready to move on to apply all of these new
skills to carrying out more sophisticated bioinformatics
analysis work. Don't worry if everything doesn't feel perfectly comfortable yet. We're
going to have many more opportunities for practice as we move forward on our 
bioinformatics journey!

#### References
[A Quick Guide to Organizing Computational Biology Projects](http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1000424)

### Keypoints:
- Spend the time to organize your file system when you start a new project. Your future self will thank you!
- Always save a write-protected copy of your raw data.
