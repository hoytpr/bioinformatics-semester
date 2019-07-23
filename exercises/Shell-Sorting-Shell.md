---
layout: exercise
topic: Shell
title: Sorting 
language: Shell
---
Uncomment below to work on exercise

<!--

### Review the `sort` command in more detail

**What Does `sort -n` Do?**

Create a file called `numbers.txt` using `nano` and
enter the following lines:

~~~
10
2
19
22
6
~~~

**Question 6**: Run `sort` on the file `numbers.txt` and submit the output as 
part of your homework. 

**Question 7**: Run `sort -n` on the same input file and report the output as 
part of your homework.

**Question 8**: In one sentence, explain breifly what `-n` is doing for the sort command. 
Use the help function if you need it.

Remember, that the `sort` command does **not** change the file!
Instead, it sends the sorted result as an output to the screen. 
Run the command `cat numbers.txt` to prove this.

**Change** your directory to  `/datashell/molecules/`

(By now you should be able to do this!)

There are six datafiles in this directory. Using the wildcard `*` 
run the command `wc -l *.pdb`

The output should be:
```
  20 cubane.pdb
  12 ethane.pdb
   9 methane.pdb
  30 octane.pdb
  21 pentane.pdb
  15 propane.pdb
 107 total
 ```

This is showing us the number of lines or lengths of each file, but what if we 
wanted the lengths to be in numerical order? One way to do that is by first 
sending the output of `wc -l *.pdb` to a file
instead of to the terminal. We can do this using 

`wc -l *.pdb > lengths.txt`

Run the command `wc -l *.pdb > lengths.txt` and use `ls` to show that 
a new file named `lengths.txt` is in the `/datashell/molecules/` directory.
Then use the `cat` command to display `lengths.txt` in the terminal window.
It should look like the output from the command `wc -l *.pdb` above.

Now run the command:

~~~
$ sort -n lengths.txt
~~~

**Question9**: What is the output of `sort -n lengths.txt`?

Remember we said that the `sort` command does not change the file? 
Convince yourself this is true by running 
```
cat lengths.txt
```
We can put the sorted list of lines in another file called `sorted-lengths.txt`
by putting `> sorted-lengths.txt` after the command,
just as we used `> lengths.txt` to put the output of `wc` into `lengths.txt`.

**Question10**: Create a file named `sorted-lengths.txt` by 
directing the output to a file for the command `sort -n lengths.txt`
and sumbit the command itself and also the output of 

`cat sorted-lengths.txt`

as part of your homework.

**Important Note #1**: After creating `sorted-lengths.txt`, we can run another command called `head` 
to get the first line in `sorted-lengths.txt`:
~~~
$ head -n 1 sorted-lengths.txt
  9  methane.pdb
~~~

Using `-n 1` with `head` tells `head` that
we only want the first line of the file;
`-n 20` would get the first 20,
and so on. The default value for the number of lines using `head`
is 10 lines.

**Important Note#2**: Because `sorted-lengths.txt` contains the lengths of our files 
ordered from least to greatest,
the output of `head` ***must*** be the file with the **fewest lines**.
-->

Shell-Pipes-and-Filters-1-Shell.md