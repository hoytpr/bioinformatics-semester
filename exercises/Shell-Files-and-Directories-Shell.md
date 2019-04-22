---
layout: exercise
topic: Shell
title: Files and Directories 
language: Shell
---

## Creating Files a Different Way

### Enter your results at: https://docs.google.com/forms/d/1-E8OZ2PjhyiA4nC2xFhZNU-DB8degcnC0X8o9XLIFAM/edit

  We have seen how to create text files using the `nano` editor.
  Now, try the following command in your home directory:
 
  ~~~
  $ cd                  # go to your home directory
  $ touch my_file.txt
  ~~~
  {: .language-bash}
 
  1.  What did the touch command do?
      When you look at your home directory using the GUI file explorer,
      does the file show up?
 
  2.  Use `ls -l` to inspect the files.  How large is `my_file.txt`?
 
  3.  When might you want to create a file this way?
 
  > ## Solution
  > 1.  The touch command generates a new file called 'my_file.txt' in
  >     your home directory.  If you are in your home directory, you
  >     can observe this newly generated file by typing `ls` at the 
  >     command line prompt.  'my_file.txt' can also be viewed in your
  >     GUI file explorer.
  >
  > 2.  When you inspect the file with `ls -l`, note that the size of
  >     'my_file.txt' is 0kb.  In other words, it contains no data.
  >     If you open 'my_file.txt' using your text editor it is blank.
  >
  > 3.  Some programs do not generate output files themselves, but
  >     instead require that empty files have already been generated.
  >     When the program is run, it searches for an existing file to
  >     populate with its output.  The touch command allows you to
  >     efficiently generate a blank text file to be used by such
  >     programs.
  {: .solution}
{: .challenge}


