---
layout: page
element: notes
title: Navigating Files and Directories
language: Shell
---

#### Questions:
- How can I move around on my computer?
- How can I see what files and directories I have?
- How can I specify the location of a file or directory on my computer?
#### Objectives:
- Learn the basic shell commands for files and directories
- Understand absolute paths vs. relative paths.
- Demonstrate the use of tab completion, and explain its advantages.

### Nelle learned about "home" first

Nelle has taken a workshop that taught her the basics of setting up her 
computer using the BASH shell. She learned that the part of the operating 
system responsible for managing files and directories 
is called the **file system**.
It organizes our data into files (which hold information), and directories 
(also called "folders" which hold files or other directories).

Several commands are frequently used to create, inspect, rename, and 
delete files and directories. To understand what Nelle is doing 
(and why) as she is setting up for her first anaalyses, 
we'll need to use our BASH shell on our computers.

After opening our terminal window, let's find out "where we are" by 
running a command called `pwd` (which stands for "print working directory"). 
Directories are like *places* - at any time while we are using the 
shell we are in exactly one place, called our **current working directory**. 
Commands mostly read and write files in the 
current working directory, so knowing where you are before running
a command is **important**. `pwd` shows you where you are:

~~~
$ pwd
/Users/nelle
~~~

Here, the computer's response is `/Users/nelle`. This important 
directory is not just the current working directory, it 
is Nelle's **home directory**. 

So let's go over that again... We can be any place in the file structure, 
and `pwd` will tell us where we are, *i.e.* the current working directory. 
BUT there is only ONE home directory per user.

> ### Home Directory Variations
>
> After installing GitBash we have to understand and accept that different
> operating systems have different places for the scientists' home directory. 
> for Windows the home directory is on hard drive "C" and 
> the output of `pwd` is:
> ~~~
> $ pwd
> /c/Users/<username>
> ~~~
> NOTE that whenever you see this format: `"<username>"`, it is referring to 
> **ANY** username like yours or mine. For any commands using this format, You 
> would type in your username rather than the actual `"<username>"` letters. 
> Mine would be `/c/Users/hoyt`, but on a Mac mine would be `/Users/hoyt`   

The home directory path will look different on different operating systems.
On Linux it may look like `/home/nelle`,
and on older Windows versions it could look like `C:\Documents and Settings\nelle`.  
A typical Windows 10 file structure will look like the image below, using hard drive `C:` as 
the "root" directory (more on that later), but our setup instructions should
**start** you in your `Users` directory (e.g. `Users/<username>`), 
with at least a `Desktop` directory inside `Users/<username>/`. There might be
lots of files in your `Desktop` directory, but we'll only use the `data-shell`
directory for this lesson. The differences may be confusing but   
the GitBash window will show you similar outputs once we start 
our lesson about moving through files and directories. 

![The Actual File System]({{ site.baseurl }}/materials/Nelles_directory_structure.png)

**One more reminder**: In future examples, we've used an Apple Macintosh 
output as the default - if you are on a Linux or Windows computer, the
output may differ slightly, but should be generally similar.  

To understand what a "home directory" is,
let's have a look at how the file system as a whole is organized.  For the
sake of this example, we'll be
illustrating the filesystem on **our scientist Nelle's computer**.  After this
illustration, you should have learned commands to explore your **own filesystem**,
which will be constructed in a similar way.  

On ***Nelle's*** computer, the filesystem looks like this:

![The File System]({{ site.baseurl }}/materials/Root2Users.png)

At the top is the **root directory**
that holds everything else.
We refer to it using a slash character, `/`, and 
this is the leading slash in `/Users/nelle`.

Inside the `root` directory are several other directories like:
- `bin` (which is where some built-in programs are stored),
- `data` (for miscellaneous data files),
- `Users` (where users' personal directories are located),
- `tmp` (for temporary files that don't need to be stored long-term),
-  and more.  

We know that our **current working directory** `/Users/nelle` is stored 
inside `/Users` because `/Users` is the first part of its name.
Similarly, we know that `/Users` is stored inside the root directory `/`
because its name begins with `/`.

> ### Slashes
>
> Notice that there are two meanings for the `/` character.
> When it appears at the front of a file or directory name,
> it refers to the root directory. When it appears *inside or between* 
> directory or file names, it's just a separator.

Inside (or "below") the `/Users` directory,
we find one directory for each user with an account on Nelle's computer.
We know Nelle has an account with the directory `nelle`, and 
also her colleagues *imhotep* and *larry* have accounts.  

![Home Directories]({{ site.baseurl }}/materials/root2guys.png)

The user *imhotep*'s files are stored in `/Users/imhotep`,
user *larry*'s in `/Users/larry`,
and Nelle's in `/Users/nelle`.  Nelle is the current user logged in to 
the computer in our examples, and this is why we get `/Users/nelle` 
as our home directory.  

Typically, when you open a new command prompt you will be in
**your** home directory to start.

Now let's learn a command to see the contents of our
own filesystem.  We can see what's in our home directory by running `ls`,
which stands for "listing":

~~~
$ ls
Applications Documents    Library      Music        Public
Desktop      Downloads    Movies       Pictures
~~~

(Again, your results may be slightly different depending on your operating
system and how your filesystem is customized.)

`ls` prints the names of the files and directories in the current directory. 
We can make its output more comprehensible by using the **flag** `-F`
(also known as a **switch** or an **option**),
which tells `ls` to add a marker (specifically, a trailing **`/`**) indicating if 
the items in the directory are files, or directories. Any item name with a `/` 
at the end is a **directory**. 
Depending on your settings, the `ls` command might also use colors to indicate 
whether each entry is a file or directory. 

~~~
$ ls -F
Applications/ Documents/    Library/      Music/        Public/
Desktop/      Downloads/    Movies/       Pictures/
~~~

Here,
we can see our home directory contains mostly other directories 
(or more commonly: **sub-directories**).
If you see any names in your output that don't have trailing slashes,
those must be **files**.

**Note** that there is a space between `ls` and `-F`:
without it, the shell thinks we're trying to run a command 
called `ls-F`, which doesn't exist.

### Getting help

`ls` has lots of other **flags**. There are two common ways to find out how 
to use a command and what flags it accepts:

1. We can pass a `--help` flag to the command, such as:
    ~~~
    $ ls --help
    ~~~

2. We can read its manual with `man`, such as:
    ~~~
    $ man ls 
    ~~~

**Depending on your environment you might find that only one of these works
(either `man` or `--help`).**
We'll describe both ways below.

#### The `--help` flag

Many bash commands, and programs that people have written that can be
run from within bash, support a `--help` flag to display more
information on how to use the command or program.


~~~
$ ls --help

Usage: ls [OPTION]... [FILE]...
List information about the FILEs (the current directory by default).
Sort entries alphabetically if none of -cftuvSUX nor --sort is specified.

Mandatory arguments to long options are mandatory for short options too.
  -a, --all                  do not ignore entries starting with .
  -A, --almost-all           do not list implied . and ..
      --author               with -l, print the author of each file
  -b, --escape               print C-style escapes for nongraphic characters
      --block-size=SIZE      scale sizes by SIZE before printing them; e.g.,
                               '--block-size=M' prints sizes in units of
                               1,048,576 bytes; see SIZE format below
  -B, --ignore-backups       do not list implied entries ending with ~
  -c                         with -lt: sort by, and show, ctime (time of last
                               modification of file status information);
                               with -l: show ctime and sort by name;
                               otherwise: sort by ctime, newest first
  -C                         list entries by columns
      --color[=WHEN]         colorize the output; WHEN can be 'always' (default
                               if omitted), 'auto', or 'never'; more info below
  -d, --directory            list directories themselves, not their contents
  -D, --dired                generate output designed for Emacs' dired mode
  -f                         do not sort, enable -aU, disable -ls --color
  -F, --classify             append indicator (one of */=>@|) to entries
      --file-type            likewise, except do not append '*'
      --format=WORD          across -x, commas -m, horizontal -x, long -l,
                               single-column -1, verbose -l, vertical -C
      --full-time            like -l --time-style=full-iso
  -g                         like -l, but do not list owner
      --group-directories-first
                             group directories before files;
                               can be augmented with a --sort option, but any
                               use of --sort=none (-U) disables grouping
  -G, --no-group             in a long listing, don't print group names
  -h, --human-readable       with -l and/or -s, print human readable sizes
                               (e.g., 1K 234M 2G)
      --si                   likewise, but use powers of 1000 not 1024
  -H, --dereference-command-line
                             follow symbolic links listed on the command line
      --dereference-command-line-symlink-to-dir
                             follow each command line symbolic link
                               that points to a directory
      --hide=PATTERN         do not list implied entries matching shell PATTERN
                               (overridden by -a or -A)
      --indicator-style=WORD  append indicator with style WORD to entry names:
                               none (default), slash (-p),
                               file-type (--file-type), classify (-F)
  -i, --inode                print the index number of each file
  -I, --ignore=PATTERN       do not list implied entries matching shell PATTERN
  -k, --kibibytes            default to 1024-byte blocks for disk usage
  -l                         use a long listing format
  -L, --dereference          when showing file information for a symbolic
                               link, show information for the file the link
                               references rather than for the link itself
  -m                         fill width with a comma separated list of entries
  -n, --numeric-uid-gid      like -l, but list numeric user and group IDs
  -N, --literal              print raw entry names (don't treat e.g. control
                               characters specially)
  -o                         like -l, but do not list group information
  -p, --indicator-style=slash
                             append / indicator to directories
  -q, --hide-control-chars   print ? instead of nongraphic characters
      --show-control-chars   show nongraphic characters as-is (the default,
                               unless program is 'ls' and output is a terminal)
  -Q, --quote-name           enclose entry names in double quotes
      --quoting-style=WORD   use quoting style WORD for entry names:
                               literal, locale, shell, shell-always,
                               shell-escape, shell-escape-always, c, escape
  -r, --reverse              reverse order while sorting
  -R, --recursive            list subdirectories recursively
  -s, --size                 print the allocated size of each file, in blocks
  -S                         sort by file size, largest first
      --sort=WORD            sort by WORD instead of name: none (-U), size (-S),
                               time (-t), version (-v), extension (-X)
      --time=WORD            with -l, show time as WORD instead of default
                               modification time: atime or access or use (-u);
                               ctime or status (-c); also use specified time
                               as sort key if --sort=time (newest first)
      --time-style=STYLE     with -l, show times using style STYLE:
                               full-iso, long-iso, iso, locale, or +FORMAT;
                               FORMAT is interpreted like in 'date'; if FORMAT
                               is FORMAT1<newline>FORMAT2, then FORMAT1 applies
                               to non-recent files and FORMAT2 to recent files;
                               if STYLE is prefixed with 'posix-', STYLE
                               takes effect only outside the POSIX locale
  -t                         sort by modification time, newest first
  -T, --tabsize=COLS         assume tab stops at each COLS instead of 8
  -u                         with -lt: sort by, and show, access time;
                               with -l: show access time and sort by name;
                               otherwise: sort by access time, newest first
  -U                         do not sort; list entries in directory order
  -v                         natural sort of (version) numbers within text
  -w, --width=COLS           set output width to COLS.  0 means no limit
  -x                         list entries by lines instead of by columns
  -X                         sort alphabetically by entry extension
  -Z, --context              print any security context of each file
  -1                         list one file per line.  Avoid '\n' with -q or -b
      --help     display this help and exit
      --version  output version information and exit

The SIZE argument is an integer and optional unit (example: 10K is 10*1024).
Units are K,M,G,T,P,E,Z,Y (powers of 1024) or KB,MB,... (powers of 1000).

Using color to distinguish file types is disabled both by default and
with --color=never.  With --color=auto, ls emits color codes only when
standard output is connected to a terminal.  The LS_COLORS environment
variable can change the settings.  Use the dircolors command to set it.

Exit status:
 0  if OK,
 1  if minor problems (e.g., cannot access subdirectory),
 2  if serious trouble (e.g., cannot access command-line argument).

GNU coreutils online help: <http://www.gnu.org/software/coreutils/>
Full documentation at: <http://www.gnu.org/software/coreutils/ls>
or available locally via: info '(coreutils) ls invocation'
~~~

**That's a lot of help!** We can't go through all this today, just remember you 
should always know that `--help` is there for you. 

But when things go wrong there are also error messages that can be helpful:

#### Unsupported command-line options
If you try to use an option (flag) that is not supported, `ls` and other commands
will usually print an error message similar to:

~~~
$ ls -j
ls: invalid option -- 'j'
Try 'ls --help' for more information.
~~~

### The `man` command

The other way to learn about `ls` is to type: 
~~~
$ man ls
~~~

This will turn your terminal into a page with a description 
of the `ls` command and its options and, if you're lucky, some examples
of how to use it.

To navigate through the `man` pages,
you may use <kbd>↑</kbd> and <kbd>↓</kbd> to move line-by-line,
or try <kbd>B</kbd> and <kbd>Spacebar</kbd> to skip up and down by a full page.
To search for a character or word in the `man` pages, 
use <kbd>/</kbd> followed by the character or word you are searching for. 
Sometimes a search will result in multiple hits.  If so, you can move between hits 
using <kbd>N</kbd> (for moving forward) and <kbd>Shift</kbd>+<kbd>N</kbd> (for moving backward).

To **quit** the `man` pages, press <kbd>Q</kbd>. 

### Manual pages on the web

Of course there is a third way to access help for commands:
searching the internet *via* your web browser. 
When using an internet search, including the phrase `unix man page` in your search
query will help to find relevant results (*e.g.* `unix man page ls`).

GNU provides links to its
[manuals](http://www.gnu.org/manual/manual.html) including the
[core GNU utilities](http://www.gnu.org/software/coreutils/manual/coreutils.html),
which covers many commands introduced within this lesson.

### Looking at our project directories

We can also use `ls` to see the contents of a different directory.  Let's take a
look at our `Desktop` directory by running `ls -F Desktop`. This means we want
to run the command `ls`, with the `-F` flag, using the **argument** `Desktop`.
Using an ***argument*** (in this example:`Desktop`) tells `ls` that
we want a listing of something ***other than our current working directory:***

~~~
$ ls -F Desktop
data-shell/
(NOTE: all other files and directories will be listed)
~~~

Your output should be a list of all the files and sub-directories on your
Desktop, including the `data-shell` directory you downloaded at
the [setup for this lesson]({{ site.baseurl }}/computer-setup). You should look at your Desktop 
in your operating system's graphical user interface (the GUI) to confirm that
your output is accurate. 

It's important to recognize that when using a bash shell the 
***organization*** of the files in a file system is ***critical***.
This **hierarchical** organizing helps us keep track of our work.
Rather than putting hundreds of files in our home directory 
(which would be like piling hundreds of printed papers on our desk)
we should use informative names for the directories or files, 
and place our directories in a meaningful hierarchy. 

Now that we know the `data-shell` directory is located on our Desktop, we
can do two things.  

First, we can look at its contents, using the same strategy as before, passing
a directory name to `ls`:

~~~
$ ls -F Desktop/data-shell
creatures/          molecules/          notes.txt          solar.pdf
data/               north-pacific-gyre/ pizza.cfg          writing/
~~~
(Note that the data-shell directory has both directories and ordinary files.)

Second, we can actually change our location to a different directory, so
we are no longer located in our home directory. The command to change 
locations is **`cd`** followed by a directory name. 

> Although `cd` stands for "change directory",
> it's misleading because the command doesn't change the directory,
> it changes which directory we are "in" (changes the *working directory*)
> based on the shell's hierarchical directory structure.

Let's say we want to move to the `data` directory we saw above.  We can
use the following series of commands to get there:

~~~
$ cd Desktop
$ cd data-shell
$ cd data
~~~

Type these commands to move us from our home directory, onto our Desktop, then into
the `data-shell` directory, then into the `data` directory.  

> You might notice that after typing each command, nothing is printed to the terminal.
> This is normal.  Many shell commands will not output anything to the 
> screen when successfully executed.  

If we run **`pwd`** ("print working directory") we can see where we are;

~~~
$ pwd
/Users/nelle/Desktop/data-shell/data
~~~

If we run `ls -F` now,
it lists only the contents of the working directory: `data`,  
because... that's where we are!

~~~
$ ls -F
amino-acids.txt   elements/     pdb/	        salmon.txt
animals.txt       morse.txt     planets.txt     sunspot.txt
~~~

We now know how to go **down** the directory tree, but
***how do we go up***?  We might try the following:

~~~
$ cd data-shell
-bash: cd: data-shell: No such file or directory
~~~

But we get an error!  Why is this?  

Because `cd` can only see sub-directories *inside* (or "below") your 
current working directory.  There are different ways to see directories 
*above* your current location and we'll start with the simplest.  

There is a shortcut in the shell to move up one directory level
that looks like this:

~~~
$ cd ..
~~~

The **`..`** is a special directory indicator meaning:
"the directory containing this one", or more commonly,
the **parent** of the current directory.
After running the `cd ..` command, we can run `pwd`, 
and we're in `/Users/nelle/Desktop/data-shell`.

~~~
$ pwd
/Users/nelle/Desktop/data-shell
~~~

We haven't seen the special directory indicator `..` before because it doesn't 
show up when we run `ls`.  But if we ***want*** to display it, we can give `ls` 
the **`-a`** flag:

~~~
$ ls -F -a
./   .bash_profile  data/      north-pacific-gyre/  pizza.cfg  thesis/
../  creatures/     molecules/ notes.txt            solar.pdf  writing/
~~~

Let's go through this output carefully. 
The flag `-a` stands for "show all". It forces `ls` to show us all files 
and directories, including the parent directory's `..` special indicator. 
Notice the flag `-a` makes `ls` display ***another*** special directory indicator 
that's a single "dot" or: **`.`**, which is a shortcut for "the current working directory".
For example, and to be clear, if we're in the `/Users/nelle` directory, the `..` refers to the 
`/Users` directory, and a `.` ***by itself*** means the "current working directory"
or in this example:    
`/Users/nelle`

#### About Hidden Files

Finally, the bash shell will "hide" any file or 
directory from the `ls` command if their ***name begins*** with "`.`" 
This is ***completely different*** than the `.` special directory indicator!

The `ls -F -a` command shows the hidden directories `..` and `.`, 
plus we also see the hidden file `.bash_profile`. This is a common file 
and usually contains shell configuration
settings. If you see other hidden files and directories beginning
with `.` they are probably special files and directories
used to configure different programs on your computer. These aren't changed very often.
The prefix `.` is used to prevent these
configuration files from being changed accidently, and to reduce 
clutter in the terminal when a standard `ls` command is used.

#### Orthogonality

To make memorizing commands and flags of the BASH shell easier,
the special indicators `.` and `..` don't belong to **just** the command `cd`;
they are interpreted the same way by **every** command program.
For example, if we are in `/Users/nelle`,
the command `ls ..` will give us a listing of `/Users`
(without changing our current working directory).
When meanings of flags are the same no matter which command uses them,
programmers say they are **orthogonal**. 
Orthogonal systems are easier for people to learn
because there are fewer parts to memorize.
Also note that in most command line tools, multiple flags can be combined 
with **no spaces** between the flags and a single dash `-`.
For example: `ls -Fa` is equivalent to `ls -F -a`.

### Moving on!
These then, are the basic commands for navigating the filesystem on your computer:
`pwd`, `ls` and `cd`.  Let's explore some variations on those commands.  
First, type `cd` on its own, without specifying a directory.

~~~
$ cd
~~~

How can you check what happened?  `pwd` gives us the answer!  

~~~
$ pwd
/Users/nelle
~~~

It turns out that `cd` without any argument will return you to your home directory,
which is great if you've gotten lost in your own filesystem. 

Let's try returning to the `data` directory.  Last time we used
three commands, but we can actually string together the directories
to move to `data` in one step:

~~~
$ cd Desktop/data-shell/data
~~~

Check that we've moved to the right place by running `pwd` and `ls -F`  

### Relative vs. Absolute Paths

If we want to move up one level from the data directory, we could use the`cd ..` command.  But
there is another way to move to any directory, regardless of your
current location.  

So far, when specifying directory names, or even a directory path (as above),
we have been using **relative paths**.  When you use a relative path with a command
like `ls` or `cd`, it tries to find that location  **from where we are**,
rather than from the root of the file system.  

However, it is possible to specify the **absolute path** to a directory by
including its entire path from the root directory, which is indicated by a
leading slash.  The leading `/` tells the computer to 
**follow the path from the root of the file system**, so it always refers to 
exactly one directory, no matter where we are when we run the command.

Probably the best example of an absolute path is when you use the `pwd` 
command. This always displays your location in the filesystem 
hierachy starting at the root directory. From within `data` we can type
`pwd` and it gives us the absolute path to `data-shell`. This absolute path 
lets us move to our `data-shell` directory from anywhere on
the filesystem. 

~~~
$ pwd
/Users/nelle/Desktop/data-shell/data
~~~
Now we know that we can get to our `data-shell` 
folder from anywhere in the filesytem by typing:
~~~
$ cd /Users/nelle/Desktop/data-shell
~~~
Try running the `cd` command without arguments to go to our home folder, 
then run the `cd` command above. Afterwards run `pwd` and `ls -F` 
to ensure that we're in the directory we expect.
(NOTE: This may not work exactly the same depending on your operating system)

### Two More Shortcuts

The shell interprets the character `~` (tilde) at the start of a path to
mean "the current user's home directory". For example, if Nelle's home
directory is `/Users/nelle`, then `~/data` is equivalent to
`/Users/nelle/data`. This only works if it is the first character in the
path: `here/there/~/elsewhere` is *not* `here/there/Users/nelle/elsewhere`.

Another shortcut is the `-` (dash) character.  `cd` will translate `-` into
*the previous directory I was in*, which is faster than having to remember,
then type, the full path.  This is a *very* efficient way of moving back
and forth between directories. The difference between `cd ..` and `cd -` is
that the former brings you *up*, while the latter brings you *back*. You can
think of it as the *Last Channel* button on a TV remote.

### Example Exercises 

> #### Relative Path Resolution
>
> Using the filesystem diagram below, if `pwd` displays `/Users/thing`,
> what will `ls -F ../backup` display?
>
> 1.  `../backup: No such file or directory`
> 2.  `2012-12-01 2013-01-08 2013-01-27`
> 3.  `2012-12-01/ 2013-01-08/ 2013-01-27/`
> 4.  `original/ pnas_final/ pnas_sub/`
>
> ![File System for Challenge Questions]({{ site.baseurl }}/fig/filesystem-challenge.svg)
>
> > #### Solution
> > 1. No: there *is* a directory `backup` in `/Users`.
> > 2. No: this is the content of `Users/thing/backup`,
> >    but with `..` we asked for one level further up.
> > 3. No: see previous explanation.
> > 4. Yes: `../backup/` refers to `/Users/backup/`.
> 

> #### `ls` Reading Comprehension
>
> Assuming a directory structure as in the above Figure
> (File System for Challenge Questions), if `pwd` displays `/Users/backup`,
> and `-r` tells `ls` to display things in reverse order,
> what command will result in the following output:
>
> ~~~
> pnas_sub/ pnas_final/ original/
> ~~~
>
> 1.  `ls pwd`
> 2.  `ls -r -F`
> 3.  `ls -r -F /Users/backup`
> 4.  Either #2 or #3 above, but not #1.
>
> > #### Solution
> >  1. No: `pwd` is not the name of a directory.
> >  2. Yes: `ls` without directory argument lists files and directories
> >     in the current directory.
> >  3. Yes: uses the absolute path explicitly.
> >  4. Correct: see explanations above.
> 

### Nelle's Pipeline: Organizing Files

Knowing just this much about files and directories,
Nelle is ready to organize the files that the protein assay machine will create.
First, she creates a directory called `north-pacific-gyre`
(to remind herself where the data came from).
Inside that, she creates a directory called `2012-07-03`,
which is the date she started processing the samples.
She used to use names like `conference-paper` and `revised-results`,
but she found them hard to understand after a couple of years.
(The final straw was when she found herself creating
a directory called `revised-revised-results-3`)

#### Using dates in filenames

Nelle names her directories beginning with "year-month-day",
including leading zeroes for months and days, ("yyyy-mm-dd")
because the shell displays file and directory names in alphabetical order.
If she used month names,
December would come before July;
if she didn't use leading zeroes,
November ('11') would come before July ('7') (Do you know why this is true?). 
Similarly, putting the year first
means that June 2012 will come before June 2013.
{: .callout}

Each of her physical samples is labeled according to her lab's convention
with a unique ten-character ID,
such as "NENE01729A".
This is what she used in her collection log
to record the location, time, depth, and other characteristics of the sample,
so she decides to use it as part of each data file's name.
Since the assay machine's output will be plain text,
she will call her files `NENE01729A.txt`, `NENE01812A.txt`, and so on.
All 1520 files will go into the same directory.

### TAB-completion

Now in her current directory `data-shell`,
Nelle can see her files using the command:

~~~
$ ls north-pacific-gyre/2012-07-03/
~~~

This is a lot to type, but she can let the shell do most of the work 
using what is called **tab completion**.
If she types:

~~~
$ ls nor
~~~

and then presses <kbd>Tab</kbd> (the tab key on her keyboard),
the shell automatically completes the directory name for her:

~~~
$ ls north-pacific-gyre/
~~~

If she presses <kbd>Tab</kbd> again,
Bash will add `2012-07-03/` to the command,
since it's the only possible completion.
Pressing <kbd>Tab</kbd> again does nothing,
since there are 19 possibilities;
but pressing <kbd>Tab</kbd> one more time shows the list of all the 
files to help her choose.
This **tab completion** is an extremely useful tool that you should practice
and we will use it with many other tools as we go on.

#### Lesson Keypoints:

- Information is stored in files, which are stored in directories (folders).
- Directories can also store other directories, which forms a hieerarchical directory tree.
- `cd <path>` changes the current working directory.
- `ls <path>` prints a listing of a specific file or directory; `ls` on its own lists the current working directory.
- `pwd` prints the user's current working directory.
- `/` on its own is the root directory of the whole file system.
- A relative path specifies a location starting from the current working directory.
- An absolute path specifies a location from the root of the file system.
- `..` means 'the directory above the current one'; `.` by itself means 'the current directory'.