---
layout: page
element: notes
title: Scripts and Working with Genomic Data
language: Shell
---
### Questions:
- How can we automate a commonly used set of commands?
### Objectives:
- Use the `nano` text editor to modify text files.
- Write a basic shell script.
- Use the `bash` command to execute a shell script.
- Use `chmod` to make a script an executable program.
- Start working with remote computer systems

### Writing files review

We've been able to do a lot of work with files that already exist, but what if we want to write our own files. We're not going to type in a FASTA file, but we'll see as we go through other tutorials, there are a lot of reasons we'll want to write a file, or edit an existing file.

To add text to files, we're going to use a text editor called Nano. We're going to create a file to take notes about what we've been doing with the data files in `~/shell_data/untrimmed_fastq`.

This is good practice when working in bioinformatics. We can create a file called a `README.txt` that describes the data files in the directory or documents how the files in that directory were generated.  As the name suggests it's a file that we or others should read to understand the information in that directory.

Let's change our working directory to `~/shell_data/untrimmed_fastq` using `cd`,
then run `nano` to create a file called `README.txt`:

~~~
$ cd ~/shell_data/untrimmed_fastq
$ nano README.txt
~~~

<!--

You should see something like this: 

![nano201711.png]({{ site.baseurl }}/fig/nano201711.png)

The text at the bottom of the screen shows the keyboard shortcuts for performing various tasks in `nano`. We will talk more about how to interpret this information soon.

-->

> #### Which Editor?
>
> Remember when when we say, "`nano` is a text editor," we really do mean "text": it can
> only work with plain character data, not tables, images, or any other
> human-friendly media. We use it in examples because it is one of the 
> least complex text editors. However, because of this trait, it may 
> not be powerful enough or flexible enough for the work you need to do
> after this workshop. On Unix systems (such as Linux and Mac OS X),
> many programmers use [Emacs](http://www.gnu.org/software/emacs/) or
> [Vim](http://www.vim.org/) (both of which require more time to learn), 
> or a graphical editor such as
> [Gedit](http://projects.gnome.org/gedit/). On Windows, you may wish to
> use [Notepad++](http://notepad-plus-plus.org/).  Windows also has a built-in
> editor called `notepad` that can be run from the command line in the same
> way as `nano` for the purposes of this lesson.  
>
> No matter what editor you use, you will need to know where it searches
> for and saves files. If you start it from the shell, it will (probably)
> use your current working directory as its default location. If you use
> your computer's start menu, it may want to save files in your desktop or
> documents directory instead. You can change this by navigating to
> another directory the first time you "Save As..."

Let's type in a few lines of text. Describe what the files in this
directory are or what you've been doing with them.
Once we're happy with our text, we can press <kbd>Ctrl</kbd>-<kbd>O</kbd> (press the <kbd>Ctrl</kbd> or <kbd>Control</kbd> key and, while
holding it down, press the <kbd>O</kbd> key) to write our data to disk. You'll be asked what file we want to save this to:
press <kbd>Return</kbd> to accept the suggested default of `README.txt`.

Once our file is saved, we can use <kbd>Ctrl</kbd>-<kbd>X</kbd> to quit the editor and
return to the shell.

> ### Control, Ctrl, or ^ Key
>
> The Control key is also called the "Ctrl" key. There are various ways
> in which using the Control key may be described. For example, you may
> see an instruction to press the <kbd>Ctrl</kbd> key and, while holding it down,
> press the <kbd>X</kbd> key, described as any of:
>
> * `Control-X`
> * `Control+X`
> * `Ctrl-X`
> * `Ctrl+X`
> * `^X`
> * `C-x`
>
> In `nano`, along the bottom of the screen you'll see `^G Get Help ^O WriteOut`.
> This means that you can use <kbd>Ctrl</kbd>-<kbd>G</kbd> to get help and <kbd>Ctrl</kbd>-<kbd>O</kbd> to save your
> file.

Now you've written a file. You can take a look at it with `less` or `cat`, or open it up again and edit it with `nano`.

> ### Exercise
>
> Open `README.txt` and add the date to the top of the file and save the file. 
>
> > ### Solution
> > 
> > Use `nano README.txt` to open the file.  
> > Add today's date and then use <kbd>Ctrl</kbd>-<kbd>X</kbd> to exit and `y` to save.
> >

### Writing scripts

A really powerful thing about the command line is that you can write scripts. Scripts let you save commands to run them and also lets you put multiple commands together. Though writing scripts may require an additional time investment initially, this can save you time as you run them repeatedly. Scripts can also address the challenge of reproducibility: if you need to repeat an analysis, you retain a record of your command history within the script.

One thing we will commonly want to do with sequencing results is pull out bad reads and write them to a file to see if we can figure out what's going on with them. We're going to look for reads with long sequences of N's like we did before, but now we're going to write a script, so we can run it each time we get new sequences, rather than type the code in by hand each time.

Bad reads have a lot of N's, so we're going to look for  `NNNNNNNNNN` with `grep`. We want the whole FASTQ record, so we're also going to get the one line above the sequence and the two lines below. We also want to look in all the files that end with `.fastq`, so we're going to use the `*` wildcard.

~~~
grep -B1 -A2 NNNNNNNNNN *.fastq | grep -v "\--" > scripted_bad_reads.txt
~~~

We're going to create a new file to put this `grep` command in. We'll call it `bad-reads-script.sh`. The `sh` isn't required, but using that extension tells us that it's a shell script.

~~~
$ nano bad-reads-script.sh
~~~

Type your `grep` command into the file and save it as before. Be careful that you did not add the `$` at the beginning of the line.

Now comes the fun part. We can **run** this script as a computer program. Type:

~~~
$ bash bad-reads-script.sh
~~~

It will look like nothing happened, but now if you look at `scripted_bad_reads.txt`, you can see that there are now reads in the file.

### Making the script into a program

We had to type `bash` because we needed to tell the computer what program to use to run this script. Instead we can turn this script into its own program. We need to tell it that it's a program by making it executable. We can do this by changing the file permissions. We talked about permissions in [an earlier episode](http://www.datacarpentry.org/shell-genomics/03-working-with-files/).

First, let's look at the current permissions.

~~~
$ ls -l bad-reads-script.sh
-rw-rw-r-- 1 user group 0 Oct 25 21:46 bad-reads-script.sh
~~~

Without going into great details, the permissions are most commonly 
divided into three types: **`r` "read", `w` "write", and `x` "execute".**
Also, the first position is reserved for descriptors, and the most 
common descriptor is: **`d` "directory".** 

Finally, the 10 permission indicators are actually four separate sections:

| Position 1 | Positions 2-3-4 | Positions 5-6-7 | Positions 8-9-10 |
|-------|---------|-----------|----------|
| Descriptor | Current User or Owner Permissions | Group Permissions | Everybody Permissions|

For each section, the user or group permissions can be set independently. This 
user-and-group model means that for each file, every user on the system falls 
into one of three categories: the owner/user of the file, someone in the file’s 
group, and everyone else. Permissions can be carefully adjusted depending on whether 
you are logged on as an administrator, or you are  part of a specific group.

We see that `bad-reads-script.sh` permissions are `-rw-r--r--`. This shows that the file 
can be read by every group or user and also *written to* by the file owner 
(you, because you made the file, and you are the current user or administrator of your 
computer). We can visualize the permissions as a table:

<table class="table table-striped" style="width:400px">
<tr><td></td><th>user</th><th>group</th><th>everyone</th></tr>
<tr><th>read</th><td>yes</td><td>yes</td><td>yes</td></tr>
<tr><th>write</th><td>yes</td><td>no</td><td>no</td></tr>
<tr><th>execute</th><td>no</td><td>no</td><td>no</td></tr>
</table>

We want to **change** these permissions so that the 
file can be executed as a program. 

We use the command `chmod` to change permissions for any file or directory. 
Here we are adding (`+`) executable permissions (`+x`).

> #### Windows Users: LEARN THIS! 
> **This doesn't work in the GitBash terminal on your laptop, but *will* work when you
> log onto a remote system! (Even when using Gitbash!)**
> 
> These commands work when you are using 
> a real Unix environment, including Macs. However, Windows systems, even when running 
> a Bash shell program cannot use `chmod`. This is because Windows, defines permissions 
> by [access control lists](https://docs.microsoft.com/en-us/windows/win32/secauthz/access-control-lists), or ACLs. An ACL is a paired list of a “who” with a “what”. 
> For example, you could give a collaborator (who) permission 
> to append data to a file (what) without giving them permission to delete it. We will not address 
> these issues today, but we WILL say that Windows users **can execute scripts locally** because the 
> operating system interprets whether the *contents* of the file are executable or not.  

To add "execute" permissions to a script use:
~~~
$ chmod +x bad-reads-script.sh
~~~

Now let's look at the permissions again.

~~~
$ ls -l bad-reads-script.sh
-rwxr-xr-x 1 user group 0 Oct 25 21:46 bad-reads-script.sh
~~~

Now we see that it says `-rwxr-xr-x`. 
> NOTE: The `chmod` command will change permissions for all user types
> when used this way. There are alternate methods that change permissions individually,
> but we aren't covering those methods at this time.

The `x`'s now tell us we 
can run the script as a program. So, let's try it! We'll need to put `./` at the beginning 
so the computer knows to look here (the current working directory) for the program.

~~~
$ ./bad-reads-script.sh
~~~

The script should run the same way as before, but now we've created our very own computer program!

### Log on to a Remote System

To continue this lesson, we want to connect to a remote system.
We can use a remote cloud instance or here at OSU we can use Cowboy.
To log on to Cowboy, start a NEW and SEPARATE terminal window.

Once the new terminal is open, connect to Cowboy using the command:
`ssh <username>@cowboy.hpc.okstate.edu`

If you see a warning about the computer not being known, type "yes" to accept the computer.
You should then see a request for your password. Type in your password.
NOTE: You won't see anything when you type your password. The cursor won't even move.
That's expected, so keep typing!
```
$ ssh phoyt@cowboy.hpc.okstate.edu
phoyt@cowboy.hpc.okstate.edu's password:
Last login: Thu Aug  8 12:28:36 2019 from 139.78.154.30
Welcome to Cowboy!
```

**Congratulations!** You have used the command-line interface to
connect to a remote supercomputer! This is a big step forward when 
working in genomics!

You should be in your "home" directory. Because all the commands we have learned so far work exactly the same on Cowboy, you can confirm you are in your home directory by typing:
```
pwd
/home/phoyt
```
### Pause for a moment

Now your training takes on new power! While we had fun learning commands and working 
with files on our laptops (or desktops), it's important to realize that now you are 
on a supercomputer. The computing power available to you has now increased by a ginormous 
amount (that's a lot). We will explore some of this power later, but for now just 
realize how ALL the commands you have learned, can now be applied to your home 
directory on a supercomputer. Do you want to make sub-directories? Use `mkdir`. 
Want to create a text file? Use `nano`. Write a script? Yep, you can do that too. 

### Moving and Downloading Data

So far, we've worked with data that is pre-loaded on the class website, and this is similar 
to if the data was available on an "instance" in the cloud. Usually, however,
most analyses begin with moving data into the cloud instance. Below we'll show you 
some commands to download data onto your computer as if it was an instance, 
or to move data between your computer and the cloud. [For more details on a cloud 
instance, follow this link.]({{ site.baseurl  }}/materials/extras/instance)
<a name="cloud"></a>
### Getting data *from* the cloud

There are two programs that will download data from a remote server to your local
machine (or your remote instance): `wget` and `curl`. They were designed to do 
slightly different tasks by default, so you'll need to give the programs 
somewhat different options to get the same behavior, but they are 
mostly interchangeable.

 - `wget` is short for "world wide web get", and it's basic function is to *download*
 web pages or data at a web address.

 - `cURL` is a pun, it is supposed to be read as "see URL", and it's basic (original) 
 function is  to *display* webpages or data at a web address. 
 But it downloads files also.

Which command to use mostly depends on your operating system, as most computers will
*only have one or the other* installed by default.

Let's say you want to download some data from [Ensembl](https://uswest.ensembl.org/info/data/ftp/index.html). We're going to download a very small
tab-delimited file that just tells us what data is available on the Ensembl bacteria server.
Before we can start our download, we need to know whether we're using ``curl`` or ``wget``.

To see which program is installed on your operating system you shouold type:
 
~~~
$ which curl
$ which wget
~~~

``which`` is a BASH program that looks through everything you have
installed, and tells you what folder it is installed to. If it can't
find the program you asked for, it returns nothing, i.e. gives you no
results.

On Mac OSX, you'll likely get the following output:

~~~
$ which curl
/usr/bin/curl
$ which wget
$
~~~

This output means that you have ``curl`` installed, but not ``wget``.

Windows users with GitBash installed will likely see this:

```
$ which curl
/mingw64/bin/curl
```

Once you know whether you have ``curl`` or ``wget`` use one of the
following commands to download the file:

~~~
$ cd
$ wget ftp://ftp.ensemblgenomes.org/pub/release-37/bacteria/species_EnsemblBacteria.txt
~~~

or

~~~
$ cd
$ curl -O ftp://ftp.ensemblgenomes.org/pub/release-37/bacteria/species_EnsemblBacteria.txt
~~~

Since we wanted to *download* the file rather than just view it, we used ``wget`` without
any modifiers. With ``curl`` however, we had to use the -O flag, which simultaneously tells ``curl`` to
download the page instead of showing it to us **and** specifies that it should save the
file using the **O**riginal name it had on the server: `species_EnsemblBacteria.txt`

It's important to note that both ``curl`` and ``wget`` download to the computer that the
**command line belongs to**. So, if you are logged into AWS on the command line and execute
the ``curl`` command above in the AWS terminal, the file will be downloaded to your AWS
machine, not your local one.

### Using Multiple Terminal Windows!

Now for something different! Without closing local terminal window, you should open a NEW terminal window. This terminal window will be your LOCAL terminal, and the window connected to Cowboy or the cloud, will be your REMOTE terminal. Opening multiple terminals is very common and is supported on Macs, and Windows GitBash, as well as most Unix-like operating systems. 

### Moving files between your laptop and your supercomputer or cloud instance

What if the data you need is on your local computer, but you need to get it *into* the
cloud? There are also several ways to do this, but it's *always* easier
to start the transfer locally. **Important: The terminal you are typing in
should be your *local computer terminal* (not one on your remote system). If you're
using a transfer program, use the one installed on your local machine, not your instance.**

### Transferring Data Between your Local Machine and the Cloud
### scp

`scp` stands for 'secure copy protocol', and is a widely used UNIX tool for moving files
between computers. The simplest way to use `scp` is to run it in your local terminal,
and use it to copy a single file:

~~~
scp <file I want to move> <where I want to move it>
~~~

Note that you are always running `scp` locally, but that *doesn't* mean that
you can only move files from your local computer. You can move a file:

~~~
$ scp <local file> <remote cloud instance>
~~~

Then move it back by re-ordering the to and from fields:

~~~
$ scp <remote cloud instance> <local file>
~~~

#### Uploading Data to your remote computer with scp

Open the terminal and use the `scp` command to upload a file (e.g. local_file.txt) to the remote home directory. 

1. the cloud instance on AWS or Cyverse:
~~~
$  scp local_file.txt <remote-username>@ip.address:/home/<remote-username>/
~~~

2. For the Cowboy supercomputer
~~~
$  scp local_file.txt <username>@cowboy.hpc.okstate.edu:/home/<username>/
~~~

You may be asked to re-enter your password.  Then you should see the file name printed 
to the screen. When you are back at your command prompt, switch to the Cowboy Terminal 
and use `ls` to make sure the file README.txt is now in your home folder. 

#### Downloading Data from a remote computer with scp

Let's download a text file from our remote machine. You should have a file that contains bad reads called ~/shell_data/scripted_bad_reads.txt.

**Tip:** If you are looking for another (or any) text file in your home directory to use instead try

~~~
$ find ~ -name *.txt
~~~

### Cloud computer instructions are slightly different

When we are on a cloud system like Cyverse, we would download the bad reads file in ~/shell_data/scripted_bad_reads.txt to our home ~/Download directory using the following command **(make sure you substitute your remote login credentials for "<username>@your-instance-number")**:

~~~
$ scp <remote-username>@ip.address:/home/<remote-username>/shell_data/untrimmed_fastq/scripted_bad_reads.txt. ~/Downloads
~~~

Remember that with both commands, they are run from your **local** machine, and 
we can flip the order of the 'to' and 'from' parts of the command.
These directions ***are platform specific*** so please follow the instructions for your system:

<!--
NOTE: (The following selection doesn't work
using the course template instead of the workshop template)
-->

### Windows: Uploading Data to your remote computer with PSCP

If you're using a PC, we recommend you use the *PSCP* program. 
This program is from the same suite of
tools as the putty program we have been using to connect.
(It usually works)

1. If you haven't done so, download pscp from [http://the.earth.li/~sgtatham/putty/latest/x86/pscp.exe](http://the.earth.li/~sgtatham/putty/latest/x86/pscp.exe)
2. Make sure the *PSCP* program is somewhere you know on your computer. In this case,
your Downloads folder is appropriate.
3. Open the windows [PowerShell](https://en.wikipedia.org/wiki/Windows_PowerShell);
go to your start menu/search enter the term **'cmd'**; you will be able to start the shell
(the shell should start from C:\Users\<username>).
4. Change to the download directory

~~~
> cd Downloads
~~~

Locate a file on your computer that you wish to **upload** (be sure you know the path). Then upload it to your remote machine **(you will need to know your ip address, and <remote-username>)**. You will be prompted to enter a password, and then your upload will begin. **(make sure you use substitute '<username>' with your actual computer username)**

1. For the Cyverse cloud

~~~
C:\User\<username>\Downloads> pscp.exe local_file.txt <remote-username>@EC-number-ip.address:/home/<remote-username>/
~~~

2. For Cowboy

~~~
C:\User\username\Downloads> pscp.exe local_file.txt <remote-username>@cowboy.hpc.okstate.edu/scratch/<remote-username>/
~~~

### Downloading Data from your Virtual Machine with PSCP

1. For the Cyverse cloud

~~~
C:\User\<username>\Downloads> pscp.exe <remote-username>@EC-number-ip.address:/home/<remote-username>/shell_data/untrimmed_fastq/scripted_bad_reads.txt.
~~~

2. For Cowboy

~~~
C:\User\<username>\Downloads pscp.exe <remote-username>@cowboy.hpc.okstate.edu/scratch/<remote-username>/shell_data/untrimmed_fastq/scripted_bad_reads.txt
~~~

### Keypoints:
- Scripts are a collection of commands executed together.
- Transferring information to and from virtual and local computers.
