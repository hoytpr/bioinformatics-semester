---
layout: exercise
topic: Shell
title: Sorting 
language: Shell
---

Now let's use the `sort` command to sort its contents.

> ## What Does `sort -n` Do?

Run `sort` on a file containing the following lines:

~~~
10
2
19
22
6
~~~
{: .source}

the output is:

~~~
10
19
2
22
6
~~~
{: .output}

If we run `sort -n` on the same input, we get this instead:

~~~
2
6
10
19
22
~~~
{: .output}

Can you explain why `-n` has this effect.
[Click here for the answer]({{ site.baseurl }}/solutions/Shell-Pipes-and-Filters-Shell-1.txt)

We will also use the `-n` flag to specify that the sort is
numerical instead of alphanumerical.
This does *not* change the file;
instead, it sends the sorted result to the screen:

~~~
$ sort -n lengths.txt
~~~
{: .language-bash}

~~~
  9  methane.pdb
 12  ethane.pdb
 15  propane.pdb
 20  cubane.pdb
 21  pentane.pdb
 30  octane.pdb
107  total
~~~
{: .output}

We can put the sorted list of lines in another temporary file called `sorted-lengths.txt`
by putting `> sorted-lengths.txt` after the command,
just as we used `> lengths.txt` to put the output of `wc` into `lengths.txt`.
Once we've done that,
we can run another command called `head` to get the first few lines in `sorted-lengths.txt`:

~~~
$ sort -n lengths.txt > sorted-lengths.txt
$ head -n 1 sorted-lengths.txt
~~~
{: .language-bash}

~~~
  9  methane.pdb
~~~
{: .output}

Using `-n 1` with `head` tells it that
we only want the first line of the file;
`-n 20` would get the first 20,
and so on.
Since `sorted-lengths.txt` contains the lengths of our files ordered from least to greatest,
the output of `head` must be the file with the fewest lines.
