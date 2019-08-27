---
layout: page
element: notes
title: Working With Files and Directories
language: Shell
---
### Questions:

- How can I create, copy, and delete files and directories?
- How can I edit files?

### Important Objectives to Learn

- Understand you location in a directory hierarchy that matches a given diagram.
- Create files in that hierarchy using an editor or by copying and renaming existing files.
- Delete, copy and move specified files and/or directories.

`___________________________________________________________________________________________________`

## Creating directories
We now know how to explore files and directories,
but how do we create them in the first place?

### Step one: see where we are and what we already have
Let's go back to our `data-shell` directory on the Desktop
and use `ls -F` to see what it contains:

~~~
$ pwd
/Users/nelle/Desktop/data-shell
$ ls -F
creatures/  data/  molecules/  north-pacific-gyre/  notes.txt  pizza.cfg  solar.pdf  writing/
~~~

### Create a directory

Let's create a new directory called `thesis` using the command `mkdir thesis`
(which has no output):

~~~
$ mkdir thesis
~~~

As you might guess from its name,
`mkdir` means "make directory". 
Since `thesis` is a relative path
(*i.e.*, does not have a leading slash, like `/what/ever/thesis`),
the new directory is created within the current working directory:

~~~
$ ls -F
creatures/  data/  molecules/  north-pacific-gyre/  notes.txt  pizza.cfg  solar.pdf  thesis/  writing/
~~~

## Two ways of doing the same thing
We just want to mention that using the shell to create a directory is no different than using a GUI.
In fact, you can open the current shell directory `Desktop/data-shell` using your operating system's graphical file explorer
and the `thesis` directory will appear there too.
While the shell and the file explorer are two different ways of interacting with the files,
the files and directories themselves are the same.

## Good names for files and directories

Complicated names of files and directories can make your life painful
when working on the command line. Here we provide a few useful
tips for the names of your files.

1. Don't use whitespaces.

   Whitespaces can make a name more meaningful
   but because whitespace is used to separate arguments on the command line
   it is better to completely avoid them in names of files and directories.
   You can use `-` or `_` instead of whitespace.

2. Don't begin the name with `-` (dash) or `.` (period).

   Commands treat names starting with `-` as options or flags!
   Files with names beginning with a `.` are automatically "hidden".

3. Inside the name, stick with letters, numbers, `.` (period or 'full stop'), `-` (dash) and `_` (underscore).

   Many other characters have special meanings on the command line.
   We will learn about some of these during this lesson.
   There are special characters that can cause your command to not work as
   expected and can even result in data loss.

**Important:** If you need to refer to names of files or directories that have whitespace
or another non-alphanumeric character, you should surround the name in quotes (`""`).

Since we've just created the `thesis` directory, there's nothing in it yet:

~~~
$ ls -F thesis
			<-- (nothing is returned)
~~~

### Create a text file
Let's change our working directory to `thesis` using `cd`,
then run a text editor called `nano` to create a file called `draft.txt`:

~~~
$ cd thesis
$ nano draft.txt
~~~

> ### Text vs. Whatever
>
> We usually call programs like Microsoft Word or LibreOffice Writer "text
> editors", but we need to be a bit more careful when it comes to
> programming. By default, Microsoft Word uses `.docx` files to store not
> only text, but also formatting information (fonts, headings, and so
> on). This extra information isn't stored as text, and doesn't mean
> anything to many shell tools. They expect input files to contain
> nothing but the letters, digits, and punctuation from a standard computer
> keyboard. When editing programs, therefore, you must use a plain
> text editor (or be very careful to save files as plain text).

> ### Which Text Editor?
>
> We use `nano` in examples because it is one of the 
> least complex text editors. However, it may 
> not be powerful enough, or flexible enough, for all your work
> after this workshop. On Unix systems (such as Linux and Mac OS X),
> many programmers use [Emacs](http://www.gnu.org/software/emacs/) or
> [Vim](http://www.vim.org/) (both of which require more time to learn), 
> or a graphical editor such as
> [Gedit](http://projects.gnome.org/gedit/). On Windows, you may wish to
> use [Notepad++](http://notepad-plus-plus.org/).  Windows also has a built-in
> text editor called `notepad` that can be run from the command line in the same
> way as `nano` for the purposes of this lesson.  
>
> No matter what editor you use, you will need to know where it searches
> for and saves files. If you start it from the shell, it will (probably)
> use your *current working directory* as its default location. 

Let's type in a few lines of text.

![Nano in Action]({{ site.baseurl }}/fig/nano-screenshot.png)

Once we're happy with our text, we can press <kbd>Ctrl</kbd>+<kbd>O</kbd> (press the Ctrl or Control key and, while
holding it down, press the O key) to write our data to disk
(we'll be asked what file we want to save this to:
press <kbd>Return</kbd> to accept the suggested default of `draft.txt`).
Now our file is saved, and we can use `Ctrl-X` to quit the editor and
return to the shell.

> ### Control, Ctrl, or ^ Key
>
> The __<kbd>Control</kbd>__ key (sometimes referred to as the "Command Key" 
> on a Mac) is also called the "Ctrl" key. There are various ways
> in which using the <kbd>Control</kbd> key may be described. For example, you may
> see an instruction to press the <kbd>Control</kbd> key and, while holding it down,
> press the <kbd>X</kbd> key, described as any of:
>
> * `Control-X`
> * `Control+X`
> * `Ctrl-X`
> * `Ctrl+X`
> * `^X`
> * `C-x`
>
> In nano, along the bottom of the screen you'll see `^G Get Help ^O WriteOut`.
> This means that you can use `Control-G` to get help and `Control-O` to save your
> file.

nano doesn't leave any output on the screen after it exits,
but `ls` now shows that we have created a file called `draft.txt`:

~~~
$ ls
draft.txt
~~~

### Creating Files a Different Way

We have seen how to create text files using the `nano` editor.
Now, try the following command in your **home** directory:

~~~
$ cd      # go to your home directory
$ touch my_file.txt
~~~

Now use `ls` to inspect the files in your home directory (or using the GUI file explorer),
and you should see a new file named `my_file.txt`. When you inspect the file 
with `ls -s` (the `-s` flag stands for "size"), 
note that the size of `my_file.txt` is `0`(kilobytes).  In other words, it contains no data.
If you open `my_file.txt` using your text editor it is blank.

Some programs do not generate output files themselves, but instead require that empty files 
have already been generated. That's when `touch` becomes very valuable. 

## Removing files and directories

Return to the `data-shell` directory using `cd Desktop/data-shell`.
Let's tidy up the `thesis` directory by removing the draft we created:

~~~
$ cd thesis
$ rm draft.txt
~~~

The `rm` is short for "remove" and this command removes (deletes) files.
If we run `ls` again,
its output is empty once more,
which tells us that our file is gone:

~~~
$ ls

~~~

> ## Deleting Is Forever!
>
> ***The Unix shell doesn't have a trash bin that we can recover deleted***
> ***files from*** (though most graphical interfaces allow this 
> including those for Linux).  Instead,
> when we delete files using the command-line
> their storage space on disk can be recycled. 

Now, let's *re-create* `draft.txt`

~~~
$ pwd
/Users/nelle/Desktop/data-shell/thesis
$ nano draft.txt
$ ls
draft.txt
~~~

Now let's move up one directory to `/Users/nelle/Desktop/data-shell` using `cd ..`

~~~
$ cd ..
~~~

Notice if we try to remove the entire `thesis` directory using `rm thesis`,
we get an error message:

~~~
$ rm thesis
rm: cannot remove `thesis': Is a directory
~~~

This happens because `rm` by default *only works on files, not directories*. However, It *can* remove directories if they are completely empty.

To really get rid of `thesis` we must also delete the file `draft.txt`.
We can do this with `-r` or the [recursive](https://en.wikipedia.org/wiki/Recursion) option for `rm`

~~~
$ rm -r thesis
$ ls
~~~

## Using `rm` Safely

Removing the files in a directory recursively can be a **very dangerous**
operation. If we're concerned about what we might be deleting we should
add the "interactive" flag `-i` to `rm` which will ask us for confirmation
before each step!

~~~
$ rm -r -i thesis
rm: descend into directory ‘thesis’? y
rm: remove regular file ‘thesis/draft.txt’? y
rm: remove directory ‘thesis’? y
~~~

This goes into the directory, removes everything in the directory, then 
removes the directory itself, asking
at each step for you to confirm the deletion.

## Moving files and directories
Let's create that directory and file one more time.
Note that this time we're running `nano` *from* the `data-shell` directory using 
the path `thesis/draft.txt`, rather than going *into* the `thesis` directory 
and running `nano` on `draft.txt` there.

~~~
$ pwd
/Users/nelle/Desktop/data-shell
$ mkdir thesis
$ nano thesis/draft.txt
$ ls thesis
draft.txt
~~~

But `draft.txt` isn't a particularly informative name,
so let's change the file's name (rename the file) using `mv`,
which is short for "move":

~~~
$ mv thesis/draft.txt thesis/quotes.txt
~~~

The first argument tells `mv` what we're "moving",
while the second argument tells `mv` where it should go.
In this case, we're moving `thesis/draft.txt` to `thesis/quotes.txt`,
which has the same effect as renaming the file.
Sure enough, `ls` shows us that `thesis` now contains one file called `quotes.txt`:

~~~
$ ls thesis
quotes.txt
~~~

One has to be **careful** when specifying the target file name, since `mv` will
***silently*** overwrite any existing file with the same name, which could
lead to data loss. We can protect ourselves by using the additional flag, `mv -i` 
(or `mv --interactive`), can be used to make `mv` ask you for confirmation 
before overwriting.

Unlike the `rm` command, `mv` works on directories containing files!

Let's move `quotes.txt` into the current working directory.
We use `mv` once again,
but this time we'll just use the name of a directory as the second argument
to tell `mv` that we want to keep the filename,
but put the file somewhere new.
(This is why the command is called "move".)
In this case,
the directory name we use is the special directory name `.` that we mentioned earlier.

~~~
$ mv thesis/quotes.txt .
~~~

The effect is to move the file from the directory it was in to the *current working directory*.
`ls` now shows us that the `thesis` directory is empty:

~~~
$ ls thesis
~~~

Further (and we will use this often),
`ls` with a *filename* as an argument only lists that file.
We can use this to see that `quotes.txt` is still in our current directory:

~~~
$ ls quotes.txt
quotes.txt
~~~

### Copying files and directories

The `cp` (copy) command works very much like `mv`,
except it copies a file instead of moving it.
But `cp` can make a copy with a new name also! 
Try this, and then check that `cp` worked as expected using `ls`
with ***two paths*** as arguments --- like most Unix commands,
`ls` can be given multiple paths at once:

~~~
$ cp quotes.txt thesis/quotations.txt
$ ls quotes.txt thesis/quotations.txt
quotes.txt   thesis/quotations.txt
~~~

To prove that we made a copy,
let's delete the `quotes.txt` file in the current directory
and then run that same `ls` again.

~~~
$ rm quotes.txt
$ ls quotes.txt thesis/quotations.txt
ls: cannot access quotes.txt: No such file or directory
thesis/quotations.txt
~~~

This time the shell tells us that it can't find `quotes.txt` in the current directory,
but it does find the copy named `quotations.txt` in `thesis` that we didn't delete.

> ## What's In A Name?
>
> You may have noticed that all of Nelle's files' names are "something dot
> something", and in this part of the lesson, we always used the extension
> `.txt`.  This is just a convention: We can call a file `mythesis` (no extension) or
> almost anything else we want. However, most people use two-part names
> most of the time to help them (and their programs) tell different kinds
> of files apart. The second part of such a name is called the
> **filename extension**, and indicates
> what type of data the file holds: `.txt` signals a plain text file, `.pdf`
> indicates a PDF document, `.cfg` is a configuration file full of parameters
> for some program or other, `.png` is a PNG image, and so on.
>
> These are just a conventions, albeit important ones ([and for you word geeks, "albeit" is an interesting word](https://en.wiktionary.org/wiki/albeit)). All computer files contain
> bytes: it's up to us and our programs to interpret those bytes
> according to the rules for plain text files, PDF documents, configuration
> files, images, and so on.
>
> To be clear: Naming a PNG image of a whale as `whale.mp3` doesn't somehow
> magically turn it into a recording of whalesong, though it *might*
> cause trouble (for example if the operating system tries to open it with a music player)

### Exercises: Using wildcards for accessing multiple files at once

Often one needs to copy or move several files at once. This can be done by providing a list of individual filenames, or specifying a naming *pattern* using wildcards.  

## Wildcards

*Make sure you are in the `Desktop\data-shell\molecules` directory.* 
Type `ls -F`

**`*`** is a **wildcard**. It matches ***zero or more
characters***, so `*.pdb` matches `ethane.pdb`, `propane.pdb`, and every
file that ends with ".pdb". On the other hand, `p*.pdb` only matches
`pentane.pdb` and `propane.pdb`, because the "p" at the front only
matches filenames that begin with the letter "p".

```
ls p*.pdb
pentane.pdb  propane.pdb
```

**`?`** is also a wildcard, but it only matches a ***single character***. This
means that `p?.pdb` would match `pi.pdb` or `p5.pdb` (if we had these two
files in the `molecules` directory), but not `propane.pdb`.

We can use any number of wildcards at a time: for example, `p*.p?*`
matches anything that starts with a "p" and ends with " . " then "p", and at
least one more character (since the `?` ***MUST match one character***), and
the final `*` can match any number of characters). Thus, `p*.p?*` would
match `preferred.practice`, and even `p.pi` (since the first `*` can
match no characters at all), but not `quality.practice` (doesn't start
with "p") or `preferred.p` (there isn't at least one character after the
" .p").

```
ls p*.p?*
pentane.pdb  propane.pdb
```

If a wildcard expression does not match
any file, Bash will pass the expression as an argument to the command.
For example; typing `ls *.pdf` in the `molecules` directory
(which has no files with names ending with `.pdf`) results in
an error message.

```
ls *.pdf
ls: cannot access '*.pdf': No such file or directory
```

<!--

However, generally commands like `wc` and `ls` see the lists of
file names matching these expressions, but not the wildcards
themselves. It is the shell, not the other programs, that deals with
expanding wildcards, and this is another example of orthogonal design.

> ## More on Wildcards
>
> Sam has a directory containing calibration data, datasets, and descriptions of
> the datasets:
>
> ~~~
> 2015-10-23-calibration.txt
> 2015-10-23-dataset1.txt
> 2015-10-23-dataset2.txt
> 2015-10-23-dataset_overview.txt
> 2015-10-26-calibration.txt
> 2015-10-26-dataset1.txt
> 2015-10-26-dataset2.txt
> 2015-10-26-dataset_overview.txt
> 2015-11-23-calibration.txt
> 2015-11-23-dataset1.txt
> 2015-11-23-dataset2.txt
> 2015-11-23-dataset_overview.txt
> ~~~
> {: .language-bash}
>
> Before heading off to another field trip, she wants to back up her data and
> send some datasets to her colleague Bob. Sam uses the following commands
> to get the job done:
>
> ~~~
> $ cp *dataset* /backup/datasets
> $ cp ____calibration____ /backup/calibration
> $ cp 2015-____-____ ~/send_to_bob/all_november_files/
> $ cp ____ ~/send_to_bob/all_datasets_created_on_a_23rd/
> ~~~
> -----------------------------------------
>
> Help Sam by filling in the blanks.
>
> > ## Solution
> > ```
> > $ cp *calibration.txt /backup/calibration
> > $ cp 2015-11-* ~/send_to_bob/all_november_files/
> > $ cp *-23-dataset* ~send_to_bob/all_datasets_created_on_a_23rd/
> > ```
> > {: .language-bash}
> {: .solution}
{: .challenge}

> ## Organizing Directories and Files
>
> Jamie is working on a project and she sees that her files aren't very well
> organized:
>
> ~~~
> $ ls -F
> ~~~
> {: .language-bash}
> ~~~
> analyzed/  fructose.dat    raw/   sucrose.dat
> ~~~
>
> The `fructose.dat` and `sucrose.dat` files contain output from her data
> analysis. What command(s) covered in this lesson does she need to run so that the commands below will
> produce the output shown?
>
> ~~~
> $ ls -F
> ~~~
> {: .language-bash}
> ~~~
> analyzed/   raw/
> ~~~
> {: .output}
> ~~~
> $ ls analyzed
> ~~~
> {: .language-bash}
> ~~~
> fructose.dat    sucrose.dat
> ~~~
> {: .output}
>
> > ## Solution
> > ```
> > mv *.dat analyzed
> > ```
> > 
> > Jamie needs to move her files `fructose.dat` and `sucrose.dat` to the `analyzed` directory.
> > The shell will expand *.dat to match all .dat files in the current directory.
> > The `mv` command then moves the list of .dat files to the "analyzed" directory.

> ## Copy a folder structure but not the files
>
> You're starting a new experiment, and would like to duplicate the file
> structure from your previous experiment without the data files so you can
> add new data.
>
> Assume that the file structure is in a folder called '2016-05-18-data',
> which contains a `data` folder that in turn contains folders named `raw` and
> `processed` that contain data files.  The goal is to copy the file structure
> of the `2016-05-18-data` folder into a folder called `2016-05-20-data` and
> remove the data files from the directory you just created.
>
> Which of the following set of commands would achieve this objective?
> What would the other commands do?
>
> ~~~
> $ cp -r 2016-05-18-data/ 2016-05-20-data/
> $ rm 2016-05-20-data/raw/*
> $ rm 2016-05-20-data/processed/*
> ~~~
> {: .language-bash}
> ~~~
> $ rm 2016-05-20-data/raw/*
> $ rm 2016-05-20-data/processed/*
> $ cp -r 2016-05-18-data/ 2016-5-20-data/
> ~~~
> {: .language-bash}
> ~~~
> $ cp -r 2016-05-18-data/ 2016-05-20-data/
> $ rm -r -i 2016-05-20-data/
> ~~~
> {: .language-bash}
> >
> > ## Solution
> > The first set of commands achieves this objective.
> > First we have a recursive copy of a data folder.
> > Then two `rm` commands which remove all files in the specified directories.
> > The shell expands the '*' wild card to match all files and subdirectories.
> >
> > The second set of commands have the wrong order: 
> > attempting to delete files which haven't yet been copied,
> > followed by the recursive copy command which would copy them.
> >
> > The third set of commands would achieve the objective, but in a time-consuming way:
> > the first command copies the directory recursively, but the second command deletes
> > interactively, prompting for confirmation for each file and directory.
> {: .solution}
{: .challenge}

-->

### Keypoints to Remember
- `touch <filename>` creates a blank (empty) file for text.
- `cp <old> <new>` copies a file.
- `mkdir <path>` creates a new directory.
- `mv <old> <new>` moves (or renames) a file *or* directory.
- `rm <path>` removes (deletes) a file. `rm -r <path>` removes a folder and all files.
- `*` matches zero or more characters in a filename, so `*.txt` matches all files ending in `.txt`.
- `?` matches any single character in a filename (but can't match nothing), so `?.txt` matches `a.txt` but *not* `any.txt` or `.txt`.
- Use of the Control key may be described in many ways, including `Ctrl-X`, `Control-X`, and `^X`.
- The shell does not have a trash bin: once something is deleted, it's really gone.
- Depending on the type of work you do, you may need a more powerful text editor than `nano`.
