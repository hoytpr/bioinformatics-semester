---
layout: exercise
topic: Shell
title: Nelles Last Bash
language: Shell
---

(uncomment below to work on exercise)

<!--

### Limiting Sets of Files

What would be the output of running the following loop in the `data-shell/molecules` directory?

~~~
$ for filename in c*
> do
>    ls $filename 
> done
~~~
{: .language-bash}

1.  No files are listed.
2.  All files are listed.
3.  Only `cubane.pdb`, `octane.pdb` and `pentane.pdb` are listed.
4.  Only `cubane.pdb` is listed.

> ### Solution
> 4 is the correct answer. `*` matches zero or more characters, so any file name starting with 
> the letter c, followed by zero or more other characters will be matched.
{: .solution}

How would the output differ from using this command instead?

~~~
$ for filename in *c*
> do
>    ls $filename 
> done
~~~
{: .language-bash}

1.  The same files would be listed.
2.  All the files are listed this time.
3.  No files are listed this time.
4.  The files `cubane.pdb` and `octane.pdb` will be listed.
5.  Only the file `octane.pdb` will be listed.

> ### Solution
> 4 is the correct answer. `*` matches zero or more characters, so a file name with zero or more
> characters before a letter c and zero or more characters after the letter c will be matched.
{: .solution}
 .challenge}

### Saving to a File in a Loop - Part One

In the `data-shell/molecules` directory, what is the effect of this loop?

~~~
for alkanes in *.pdb
do
    echo $alkanes
    cat $alkanes > alkanes.pdb
done
~~~
{: .language-bash}

1.  Prints `cubane.pdb`, `ethane.pdb`, `methane.pdb`, `octane.pdb`, `pentane.pdb` and `propane.pdb`,
    and the text from `propane.pdb` will be saved to a file called `alkanes.pdb`.
2.  Prints `cubane.pdb`, `ethane.pdb`, and `methane.pdb`, and the text from all three files would be
    concatenated and saved to a file called `alkanes.pdb`.
3.  Prints `cubane.pdb`, `ethane.pdb`, `methane.pdb`, `octane.pdb`, and `pentane.pdb`, and the text
    from `propane.pdb` will be saved to a file called `alkanes.pdb`.
4.  None of the above.

> ### Solution
> 1. The text from each file in turn gets written to the `alkanes.pdb` file.
> However, the file gets overwritten on each loop interation, so the final content of `alkanes.pdb`
> is the text from the `propane.pdb` file.
{: .solution}
 .challenge}

> ### Saving to a File in a Loop - Part Two
>
> Also in the `data-shell/molecules` directory, what would be the output of the following loop?
>
> ~~~
> for datafile in *.pdb
> do
>     cat $datafile >> all.pdb
> done
> ~~~
> {: .language-bash}
>
> 1.  All of the text from `cubane.pdb`, `ethane.pdb`, `methane.pdb`, `octane.pdb`, and
>     `pentane.pdb` would be concatenated and saved to a file called `all.pdb`.
> 2.  The text from `ethane.pdb` will be saved to a file called `all.pdb`.
> 3.  All of the text from `cubane.pdb`, `ethane.pdb`, `methane.pdb`, `octane.pdb`, `pentane.pdb`
>     and `propane.pdb` would be concatenated and saved to a file called `all.pdb`.
> 4.  All of the text from `cubane.pdb`, `ethane.pdb`, `methane.pdb`, `octane.pdb`, `pentane.pdb`
>     and `propane.pdb` would be printed to the screen and saved to a file called `all.pdb`.
>
> > ### Solution
> > 3 is the correct answer. `>>` appends to a file, rather than overwriting it with the redirected
> > output from a command.
> > Given the output from the `cat` command has been redirected, nothing is printed to the screen.
> {: .solution}
{: .challenge}

> ### Doing a Dry Run
>
> A loop is a way to do many things at once --- or to make many mistakes at
> once if it does the wrong thing. One way to check what a loop *would* do
> is to `echo` the commands it would run instead of actually running them.
> 
> Suppose we want to preview the commands the following loop will execute
> without actually running those commands:
>
> ~~~
> $ for file in *.pdb
> > do
> >   analyze $file > analyzed-$file
> > done
> ~~~
> {: .language-bash}
>
> What is the difference between the two loops below, and which one would we
> want to run?
>
> ~~~
> # Version 1
> $ for file in *.pdb
> > do
> >   echo analyze $file > analyzed-$file
> > done
> ~~~
> {: .language-bash}
>
> ~~~
> # Version 2
> $ for file in *.pdb
> > do
> >   echo "analyze $file > analyzed-$file"
> > done
> ~~~
> {: .language-bash}
>
> > ### Solution
> > The second version is the one we want to run.
> > This prints to screen everything enclosed in the quote marks, expanding the
> > loop variable name because we have prefixed it with a dollar sign.
> >
> > The first version redirects the output from the command `echo analyze $file` to
> > a file, `analyzed-$file`. A series of files is generated: `analyzed-cubane.pdb`,
> > `analyzed-ethane.pdb` etc.
> > 
> > Try both versions for yourself to see the output! Be sure to open the 
> > `analyzed-*.pdb` files to view their contents.
> 

> ### Nested Loops
>
> Suppose we want to set up up a directory structure to organize
> some experiments measuring reaction rate constants with different compounds
> *and* different temperatures.  What would be the
> result of the following code:
>
> ~~~
> $ for species in cubane ethane methane
> > do
> >     for temperature in 25 30 37 40
> >     do
> >         mkdir $species-$temperature
> >     done
> > done
> ~~~
>
> > ### Solution
> > We have a nested loop, i.e. contained within another loop, so for each species
> > in the outer loop, the inner loop (the nested loop) iterates over the list of
> > temperatures, and creates a new directory for each combination.
> >
> > Try running the code for yourself to see which directories are created!
> 
-->
nelles-last-bash-Shell.md