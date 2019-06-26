---
layout: page
element: notes
title: Genomics in RStudio
language: R
---
### Questions
- "What will these lessons not cover?"
- "What are the basic features of the R language?"
- "What are the most common objects in R?"

### Objectives
- "Be able to create the most common R objects including vectors"
- "Understand that vectors have modes, which correspond to the type of data they
  contain"
- "Be able to use arithmetic operators on R objects"
- "Be able to retrieve (subset), name, or replace, values from a vector"
- "Be able to use logical operators in a subsetting operation"
- "Understand that lists can hold data of more than one mode and can be indexed"

### The Pot of Gold...
```
source("../bin/chunk-options.R")
knitr_fig_path("02-")
```

#### "The fantastic world of R awaits you" OR "Nobody wants to learn how to use R"

Before we begin this lesson, we want you to be clear on the goal of the workshop
and these lessons. This is not a course that will "teach you R". Instead this course is to "teach you enough to ***use*** R".  We believe that every learner can **achieve competency
with R**. You reach competency when you find that you are able to
**use R to handle common analysis challenges in a reasonable amount of time**
(which includes time needed to look at learning materials, search for answers
online, and ask colleagues for help). As you spend more time using R (there is
no substitute for regular use and practice) you will find yourself gaining
competency and even expertise. The more familiar you get, the more
complex the analyses you will be able to carry out, with less frustration, and
in less time - the fantastic world of R awaits you!

#### What these lessons will not teach you

Nobody wants to learn how to use R. People want to learn how to use R to analyze
their own research questions! Ok, maybe some folks learn R for R's sake, but
these lessons assume that you want to start analyzing genomic data as soon as
possible. Given this, there are many valuable pieces of information about R
that we simply won't have time to cover. Hopefully, we will clear the hurdle of
giving you just enough knowledge to be dangerous, which can be a high bar
in R! We suggest you look into the additional learning materials in the tip box
below.

**Here are some R skills we will *not* cover in these lessons**

- How to create and work with R matrices and R lists
- How to create and work with loops and conditional statements, and the "apply"
  family of functions (which are super useful, read more [here](https://www.r-bloggers.com/r-tutorial-on-the-apply-family-of-functions/))
- How to do basic string manipulations (e.g. finding patterns in text using grep, replacing text)
- How to plot using the default R graphic tools (we *will* cover plot creation, but will do so using the popular plotting package `ggplot2`)
- How to use advanced R statistical functions

> #### Tip: Where to learn more
> The following are good resources for learning more about R. Some of them
> can be quite technical, but if you are a regular R user you may ultimately
> need this technical knowledge.
> - [R for Beginners](https://cran.r-project.org/doc/contrib/Paradis-rdebuts_en.pdf):
    By Emmanuel Paradis and a great starting point
> - [The R Manuals](https://cran.r-project.org/manuals.html): Maintained by the
    R project
> - [R contributed documentation](https://cran.r-project.org/other-docs.html):
    Also linked to the R project; importantly there are materials available in
    several languages
> - [R for Data Science](http://r4ds.had.co.nz/): A wonderful collection by
    noted R educators and developers Garrett Grolemund and Hadley Wickham
> - [Practical Data Science for Stats](https://peerj.com/collections/50-practicaldatascistats/):
    Not exclusively about R usage, but a nice collection of pre-prints on data science
    and applications for R
> - [Programming in R Software Carpentry lesson](https://software-carpentry.org/lessons/):
    There are several Software Carpentry lessons in R to choose from
{: .callout}

#### Creating objects in R

> #### Reminder
>
> At this point you should be coding along in R-studio, using the "**genomics_r_basics.R**"
> script we created in the last episode. Writing your commands in the script
> (and commenting it) will make it easier to record what you did and why.
>
> What might be called a ***variable*** in other computer languages is called an **object**
> in R.
{: .prereq}

**To create an object you need:**

- a name (e.g. 'a')
- a value (e.g. '1')
- the assignment operator ('<-')

In your script, "**genomics_r_basics.R**", using the R assignment operator '<-',
assign '1' to the object 'a' as shown. Remember to leave a comment in the line
above (using the '#') to explain what you are doing:

```
# this line creates the object 'a' and assigns it the value '1'

a <- 1
```

Next, run this line of code in your script. You can run a line of code
by hitting the <KBD>Run</KBD> button that is just above the first line of your
script in the header of the Source pane or you can use the appropriate shortcut:

<img src="/fig/Rstudio-runbutton.png" alt="rstudio run button" style="width: 600px;"/>

- **Windows execution shortcut: <KBD>Ctrl</KBD>+<KBD>Enter</KBD>**
- **Mac execution shortcut: <KBD>Cmd(⌘)</KBD>+<KBD>Enter</KBD>**

To run multiple lines of code, you should highlight **all** the lines you wish to run
and then hit <KBD>Run</KBD> or use the shortcut key combo listed above.

In the RStudio 'Console' you should see:

~~~
a <- 1
>
~~~
{: .output}

The 'Console' will display lines of code run from a script and any outputs or
status/warning/error messages (usually in red).

In the 'Environment' window you will also get a table:

|Values||
|------|-|
|a|1|

The 'Environment' window allows you to keep track of the objects you have
created in R. This is very helpful!!!!!

#### Naming objects in R

Here are some important details about naming objects in R.

- **Avoid spaces and special characters**: Object names cannot contain spaces 
  or the minus sign (`-`). You can use '_' to make names more readable. You should avoid
  using special characters in your object name (e.g. ! @ # . , etc.). Also,
  object names cannot begin with a number.
- **Use short, easy-to-understand names**: You should avoid naming your objects
  using single letters (e.g. 'n', 'p', etc.). This is mostly to encourage you
  to use names that would make sense to anyone reading your code (a colleague,
  or even yourself a year from now). Also, avoiding excessively long names will
  make your code more readable.
- **Avoid commonly used names**: There are several names that may already have a
  definition in the R language (e.g. 'mean', 'min', 'max'). One clue that a name
  already has meaning is that if you start typing a name in RStudio and it gets
  a colored highlight or RStudio gives you a suggested autocompletion you have
  chosen a name that has a reserved meaning.
- **Use the recommended assignment operator**: In R, we use '<- ' as the
  preferred assignment operator. '=' works too, but is most commonly used in
  passing arguments to functions (more on functions later). There is a shortcut
  for the R assignment operator:
  - Windows execution shortcut: <KBD>Alt</KBD>+<KBD>-</KBD>
  - Mac execution shortcut: <KBD>Option</KBD>+<KBD>-</KBD>

There are a few more suggestions about naming and style you may want to learn
more about as you write more R code. There are several "style guides" that
have advice, and one to start with is the [tidyverse R style guide](http://style.tidyverse.org/index.html).

> #### Tip: Pay attention to warnings in the script console
>
> If you enter a line of code in your script that contains an error, RStudio
> may give you an error message and underline this mistake. Sometimes these
> messages are easy to understand, but often the messages may need some figuring
> out. Paying attention to these warnings will help you avoid mistakes. 
> In the example below, our object name includes a 'space' character, which
> is not allowed in R. The error message does not say this directly,
> but R is "not sure"
> about how to assign the name to "human_  chr_number" when the object name we
> want is "human_chr_number".
>
> <img src="/fig/rstudio_script_warning.png" alt="rstudio script warning" style="width: 600px;"/>
{: .callout}

#### Reassigning object names or deleting objects

Once an object has a value, you can change that value by overwriting it. R will
not give you a warning or error if you overwriting an object, which
may or may not be a good thing
depending on how you look at it.

```
# gene_name has the value 'pten' or the value used in the exercise.
# We will now assign the new value 'tp53'
gene_name <- 'tp53'
```

Now you can see we have 
You can also remove an object from R's memory entirely. The `rm()` function
will delete the object.

```
# delete the object 'gene_name'
rm(gene_name)
```

If you run a line of code that has only an object name, R will normally display
the contents of that object. In this case, we are told the object no
longer exists.

~~~
Error: object 'gene_name' not found
~~~
{: .error}

#### Understanding object data types

In R, **every object has two properties**:

- **Length**: How many distinct values are held in that object
- **Mode**: What is the classification (type) of that object.

### Mode

We will get to the "length" property later in the lesson. The **"mode" property**
**corresponds to the type of data an object represents**. The most common modes
you will encounter in R are:

|Mode (abbreviation)|Type of data|
|----|------------|
|Numeric (num)| Numbers such floating point/decimals (1.0, 0.5, 3.14), there are also more specific numeric (sub)types (e.g. dbl - Double, int - Integer). These differences are not relevant for most beginners and pertain to how these values are stored in memory |
|Character (chr)|A sequence of letters/numbers in single '' or double " " quotes|
|Logical| Boolean values - TRUE or FALSE|

There are a few other modes (i.e. "complex", "raw" etc.) but "num", "chr", 
and "boolean" are the three we will work with in this lesson.

Data types are common in many programming languages, but also in natural
language where we refer to them as the **parts of speech**, e.g. nouns, verbs,
adverbs, etc. Once you know if a word - perhaps an unfamiliar one - is a noun,
you can probably make it plural if there is more than
one (e.g. 1 [Tuatara](https://en.wikipedia.org/wiki/Tuatara), or 2 Tuataras). If
something is a adjective, you can usually change it into an adverb by adding
"-ly" (e.g. [jejune](https://www.merriam-webster.com/dictionary/jejune) vs.
jejunely). But **context matters**, you may need to decide if a word is in one
category or another (e.g "cut" may be a noun when it's on your finger, or a verb
when you are preparing vegetables). **These concepts have important analogies when
working with R objects**.

Importantly, even if a series of numbers are given as a value
R will consider them to be in the "character" mode if they are enclosed as
single or double quotes. Also, notice that you cannot take a string of alphanumeric
characters (e.g. Earhart) and assign as a value for an object. If you try to assign
characters as a value (e.g. pilot <- Earnhart), it creates an error because
R looks for an **object** named `Earnhart` but since there isn't an object
currently called `Earnhart`, no assignment can
be made. If an object called `Earnhart` did exist, then the mode of `pilot` would 
become the same mode as the object `Earnhart`. If we want to create an object
called `pilot` that has the **name** "Earnhart", we need to enclose
`Earnhart` in quotation marks. 

Try this yourself before we move on:
```
> pilot <- Earnhart
Error: object 'Earnhart' not found
> Earnhart <- "Ameleia"
> mode (Earnhart)
[1] "character"
> pilot <- Earnhart
> mode(pilot)
[1] "character"
> pilot <- "Earnhart"
> mode(pilot)
[1] "character"
```
Did you notice what the object "pilot" represents now?

#### Mathematical and functional operations on objects in genomics

Once an object exists (which by definition also means it has a mode), R can
appropriately manipulate that object. For example, objects of the numeric modes
can be added, multiplied, divided, etc. R provides several mathematical
(arithmetic) operators including:

|Operator|Description|
|--------|-----------|
|+|addition|
|-|subtraction|
|*|multiplication|
|/|division|
|^ or **|exponentiation|
|a%%b|modulus (returns the remainder after division)|

These can be used with literal numbers:

```
(1 + (5 ** 0.5))/2
```

and importantly, can be used on any object that evaluates to (i.e. interpreted
by R) a numeric object:

```
human_chr_number <- 23
```

```
# multiply the object 'human_chr_number' by 2

human_chr_number * 2
```

### Vectors

Vectors are probably the
most used commonly used object type in R. 
**A vector is a collection of values that are all of the same type (numbers, characters, etc.)**. 
One of the most common
ways to create a vector is to use the `c()` function - the "concatenate" or
"combine" function. Inside the function you may enter one or more values; for
multiple values, separate each value with a comma:

```
# Create the SNP gene name vector

snp_genes <- c("OXTR", "ACTN3", "AR", "OPRM1")
```

Vectors always have a **mode** and a **length**.
You can check these with the `mode()` and `length()` functions respectively.
Another useful function that gives both of these pieces of information is the
`str()` (structure) function.

```
# Check the mode, length, and structure of 'snp_genes'
mode(snp_genes)
length(snp_genes)
str(snp_genes)
```

Vectors are quite important in R. Another data type that we will
work with later in this lesson, data frames, are collections of
vectors. What we learn here about vectors will pay off even more
when we start working with data frames. 

#### Creating and subsetting vectors

Let's create a few more vectors to play around with:

```
# Some interesting human SNPs
# while accuracy is important, typos in the data won't hurt you here

snps <- c('rs53576', 'rs1815739', 'rs6152', 'rs1799971')
snp_chromosomes <- c('3', '11', 'X', '6')
snp_positions <- c(8762685, 66560624, 67545785, 154039662)
```

Once we have vectors, one thing we may want to do is specifically retrieve one
or more values from our vector. To do so, we use **bracket notation**. We type
the name of the vector followed by square brackets. In those square brackets
we place the index (e.g. a number) in that bracket as follows:

```
# get the 3rd value in the snp_genes vector
snp_genes[3]
```

In R, every item your vector is indexed, starting from the first item (1)
through to the final number of items in your vector. You can also retrieve a
range of numbers:

```
# get the 1st through 3rd value in the snp_genes vector

snp_genes[1:3]
```

If you want to retrieve several (but not necessarily sequential) items from
a vector, you pass a **vector of indices**; a vector that has the numbered
positions you wish to retrieve.

```
# get the 1st, 3rd, and 4th value in the snp_genes vector

snp_genes[c(1, 3, 4)]
```

There are additional (and perhaps less commonly used) ways of subsetting a
vector (see [these
examples](https://thomasleeper.com/Rcourse/Tutorials/vectorindexing.html)).
Also, several of these subsetting expressions can be combined:

```
# get the 1st through the 3rd value, and 4th value in the snp_genes vector
# yes, this is a little silly in a vector of only 4 values.
snp_genes[c(1:3,4)]
```

#### Adding to, removing, or replacing values in existing vectors

Once you have an existing vector, you may want to add a new item to it. To do
so, you can use the `c()` function again to add your new value:

```
# add the gene 'CYP1A1' and 'APOA5' to our list of snp genes
# this overwrites our existing vector
snp_genes <- c(snp_genes, "CYP1A1", "APOA5")
```

We can verify that "snp_genes" contains the new gene entry

```
snp_genes
```

Using a negative index will return a version a vector with that index's
value removed:

```
snp_genes[-6]
```

We can remove that value from our vector by overwriting it with this expression:

```
snp_genes <- snp_genes[-6]
snp_genes
```

We can also explicitly rename or add a value to our index using double bracket notation:

```
snp_genes[7]<- "APOA5"
snp_genes
```

Notice in the operation above that R inserts an `NA` value to extend our vector so that the gene "APOA5" is an index 7. This may be a good or not-so-good thing depending on how you use this.

### Logical Subsetting

There is one last set of cool subsetting capabilities we want to introduce. It is possible within R to retrieve items in a vector based on a logical evaluation or numerical comparison. For example, let's say we wanted get all of the SNPs in our vector of SNP positions that were greater than 100,000,000. We could index using the '>' (greater than) logical operator:

```
snp_positions[snp_positions > 100000000]
```

In the square brackets you place the name of the vector followed by the comparison operator and (in this case) a numeric value. Some of the most common logical operators you will use in R are:

  | Operator | Description              |
  |----------|--------------------------|
  | <        | less than                |
  | <=       | less than or equal to    |
  | >        | greater than             |
  | >=       | greater than or equal to |
  | ==       | exactly equal to         |
  | !=       | not equal to             |
  | !x       | not x                    |
  | a \| b   | a or b                   |
  | a & b    | a and b                  |


> #### The magic of programming
>
> The reason why the expression `snp_positions[snp_positions > 100000000]` works
> can be better understood if you examine what the expression "snp_positions > 100000000"
> evaluates to:
>
> ```
> snp_positions > 100000000
> ```
>
> The output above is a logical vector, the 4th element of which is TRUE. When
> you pass a logical vector as an index, R will return the true values:
>
> ```
> snp_positions[c(FALSE, FALSE, FALSE, TRUE)]
> ```
>
> If you have never coded before, this type of situation starts to expose the
> "magic" of programming. We mentioned before that in the bracket notation you
> take your named vector followed by brackets which contain an index:
> **named_vector[index]**. The "magic" is that the index needs to *evaluate to*
> a number. So, even if it does not appear to be an integer (e.g. 1, 2, 3), as
> long as R can evaluate it, we will get a result. That our expression
> `snp_positions[snp_positions > 100000000]` evaluates to a number can be seen
> in the following situation. If you wanted to know which **index** (1, 2, 3, or
> 4) in our vector of SNP positions was the one that was greater than
> 100,000,000?
>
> We can use the `which()` function to return the indices of any item that
> evaluates as TRUE in our comparison:
>
> ```
> which(snp_positions > 100000000)
> ```
>
> **Why this is important**
>
> Often in programming we will not know what inputs
> and values will be used when our code is executed. Rather than put in a
> pre-determined value (e.g 100000000) we can use an object that can take on
> whatever value we need. So for example:
>
> ```
> snp_marker_cutoff <- 100000000
> snp_positions[snp_positions > snp_marker_cutoff]
> # So ANY SNP positions greater than 100000000 are now 
> # the value!!!!!
> ```
>
> Ultimately, it's putting together flexible, reusable code like this that gets
> at the "magic" of programming!
{: .callout}

#### A few final vector tricks

Finally, there are a few other common retrieve or replace operations you may
want to know about. First, you can check to see if any of the values of your
vector are missing (i.e. are `NA`). Missing data will get a more detailed treatment later,
but the `is.NA()` function will return a logical vector, with TRUE for any NA
value:

```
# current value of 'snp_genes': 
# chr [1:7] "OXTR" "ACTN3" "AR" "OPRM1" "CYP1A1" NA "APOA5"

is.na(snp_genes)
```

Sometimes, you may wish to find out if a specific value (or several values) is
present a vector. You can do this using the comparison operator `%in%`, which
will return TRUE for any value in your collection that is in
the vector you are searching:

```
# current value of 'snp_genes':
# chr [1:7] "OXTR" "ACTN3" "AR" "OPRM1" "CYP1A1" NA "APOA5"

# test to see if "ACTN3" or "APO5A" is in the snp_genes vector
# if you are looking for more than one value, you must pass this as a vector

c("ACTN3","APOA5") %in% snp_genes
```

### Keypoints
- **"Effectively using R is a journey of months or years."**\* Still *you don't have to
  be an expert to use R* and you can start using and analyzing your data with
  with about a day's worth of training. Review this lesson whenever starting an R analysis.
- It is important to understand how data are organized by R in a given object
  type and how the mode of that type (e.g. numeric, character, logical, etc.) will
  determine how R will operate on that data.
- Working with vectors effectively prepares you for understanding how data are
  organized in R.
  
     
	    
		
\* François Michonneau, May, 2019, Genomics Workshop Bug BBQ, Univ. of Arizona, Phoenix, AZ		