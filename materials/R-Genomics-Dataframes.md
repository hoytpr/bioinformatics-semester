---
layout: page
element: lecture
title: "R Genomics continued - factors and data frames"
language: R
---
This lecture may be split after updating
Subtitle: **Wrangling the Variant Calling Workflow**
### Questions:

- "How do I get started with tabular data (e.g. spreadsheets) in R?"
- "What are some best practices for reading data into R?"
- "How do I save tabular data generated in R?"

### Objectives:
- "Explain the basic principle of tidy datasets"
- "Be able to load a tabular dataset using base R functions"
- "Be able to determine the structure of a data frame including its dimensions
  and the datatypes of variables"
- "Be able to subset/retrieve values from a data frame"
- "Understand how R may coerce data into different modes"
- "Be able to change the mode of an object"
- "Understand that R uses factors to store and manipulate categorical data"
- "Be able to manipulate a factor, including subsetting and reordering"
- "Be able to apply an arithmetic function to a data frame"
- "Be able to coerce the class of an object (including variables in a data frame)"
- "Be able to import data from Excel"
- "Be able to save a data frame as a delimited file"

(Long-term objective lines of code)
```
source("../bin/chunk-options.R")
knitr_fig_path("03-")
```
**(Open or reopen RStudio and locate `combined_tidy_vcf.csv`**
### Working with spreadsheets (tabular data)

A substantial amount of the data we work with in genomics will be tabular data,
this is data arranged in rows and columns - also known as spreadsheets. We could
write a whole lesson on how to work with spreadsheets effectively ([actually we did](https://datacarpentry.org/organization-genomics/)). For our
purposes, we want to remind you of a few important principles before we work with our
first set of example data:

**1) Keep raw data separate from analyzed data**

This is principle number one because if you can't tell which files are the
original raw data, you risk making some serious mistakes (e.g. drawing conclusion
from data which have been manipulated in some unknown way).

**2) Keep spreadsheet data Tidy**

The simplest principle of **Tidy data** is that we have ***one row in our
spreadsheet for each observation or sample, and one column for every variable
that we measure or report on***. As simple as this sounds, it's very easily
violated. Most data scientists agree that significant amounts of their time is
spent tidying data for analysis (sometimes referred to as "Data Wrangling"). 
Read more about data organization in
[our lesson](https://datacarpentry.org/organization-genomics/) and
in [this paper](https://www.jstatsoft.org/article/view/v059i10).

**3) Verify the data**

Finally, while you don't need to be paranoid about data, you should have a plan
for how you will prepare it for analysis. **This a focus of this lesson.**
You probably already have a lot of intuition, expectations, assumptions about
your data - the range of values you expect, how many values should have
been recorded, etc. But as the data get larger our human ability to
keep track will start to fail (and yes, it can fail for small data sets too).
R will help you to examine your data so that you can have greater confidence
in your analysis, and its reproducibility.

> #### Tip: Keep your raw data separate
>
> The way R works allows you to pull data from the original file, while
> not actually changing the original file. 
> This is different than (for example) working with
> a spreadsheet program where changing the value of the cell leaves you one
> "save"-click away from overwriting the original file. You have to purposely
> use a writing function (e.g. `write.csv()`) to save data loaded into R. In
> that case, be sure to save the manipulated data into a new file. More on this
> later in the lesson.  


### Importing tabular data into R
There are several ways to import data into R. But we will
only use the tools provided in every R installation (so called "base" R) to
import a comma-delimited file containing the results of our variant calling workflow.
We will need to load the data using a function called `read.csv()`.

> #### Exercise: Review the arguments of the `read.csv()` function
>
> **Before using the `read.csv()` function, use R's help feature to answer the
> following questions**.
>
> *Hint*: Entering '?' before the function name and then running that line will
> bring up the help documentation. Also, when reading this particular help
> be careful to pay attention to the 'read.csv' expression under the 'Usage'
> heading. Other answers will be in the 'Arguments' heading.
>
> A) What is the default parameter for 'header' in the `read.csv()` function?
>
> B) What argument would you have to change to read a file that was delimited
> by semicolons (;) rather than commas?
>
> C) What argument would you have to change to read file in which numbers
> used commas for decimal separation (i.e. 1,00)?
>
> D) What argument would you have to change to read in only the first 10,000 rows
> of a very large file?
>
>> ## Solution
>>
>> A) The `read.csv()` function has the argument 'header' set to TRUE by default,
>> this means the function always assumes the first row is header information,
>> (i.e. column names)
>>
>> B) The `read.csv()` function has the argument 'sep' set to ",". This means
>> the function assumes commas are used as delimiters, as you would expect.
>> Changing this parameter (e.g. `sep=";"`) would now interpret semicolons as
>> delimiters.
>>
>> C) Although it is not listed in the `read.csv()` usage, `read.csv()` is
>> a "version" of the function `read.table()` and accepts all its arguments.
>> If you set `dec=","` you could change the decimal operator. We'd probably
>> assume the delimiter is some other character.
>>
>> D) You can set `nrow` to a numeric value (e.g. `nrow=10000`) to choose how
>> many rows of a file you read in. This may be useful for very large files
>> where not all the data is needed to test some data cleaning steps you are
>> applying.
>>
>> Hopefully, this exercise gets you thinking about using the provided help
>> documentation in R. There are many arguments that exist, but which we wont
>> have time to cover. Look here to get familiar with functions you use
>> frequently, you may be surprised at what you find they can do.
> 

Now, let's read in the file `combined_tidy_vcf.csv` which on the AWS cloud is 
located in `/home/dcuser/.solutions/R_data/`. Alternatively you can read in
the file directly from FigShare 
("https://ndownloader.figshare.com/files/14632895")
Call this data `variants`. The
first argument to pass to our `read.csv()` function is the file path for our
data. The file path must be in quotes and now is a good time to remember to
use ***tab autocompletion.*** **Using tab autocompletion helps avoid typos and
errors in file paths.** Use it!

```
## read in a CSV file and save it as 'variants'

variants <- read.csv("../r_data/combined_tidy_vcf.csv")
```


```
## silently read in CSV file from FigShare

variants <- read.csv("https://ndownloader.figshare.com/files/14632895")
```

One of the first things you should notice is that in the Environment window,
you have the `variants` object, listed as 801 obs. (observations/rows)
of 29 variables (columns). Double-clicking on the name of the object will open
a view of the data in a new tab.

<img src="{{ site.baseurl }}/fig/rstudio_dataframeview.png" alt="rstudio data frame view" style="width: 1000px;"/>

#### Summarizing and determining the structure of a data frame.

A **data frame is the standard way in R to store tabular data**. A data fame
could also be thought of as a collection of vectors, all of which have the same
length. We can learn a lot about out data frame using only ***two functions***,
including some summary statistics as well as well as the "structure" of the data
frame. Let's examine what each of these functions can tell us:

```
## get summary statistics on a data frame

summary(variants)
```

The output summary is at first a little complex, so here's what happened:
Our data frame had 29 variables, so we get 29 fields that summarize the data.
By clicking on the `variants` in the environment window, we can see 
these 29 variables correspond to what might be called the "Header" row.
Notice the `QUAL`, `IMF`, and `VDB` variables (and several others) are
**numerical** data and so you get **summary statistics** on the min and max values for
these columns, as well as mean, median, and interquartile ranges. In contrast, 
many of the other variables
(e.g. `sample_id`) are treated as **categorical data** (which have special
treatment in R - more on this in a bit). 

By default, the most frequent 6 different categories of each variable are shown, 
separated by a colon character from the
number of times they appear (e.g. the sample_id called 'SRR2584863' appeared 25 times)
There was only one value for `CHROM`, "CP000819.1" which appeared
in all 801 observations.

Before we operate on the data, we also need to know a little more about the
data frame **structure**. To do that we use the `str()` function:

```
## get the structure of a data frame

str(variants)
```
```
'data.frame':	801 obs. of  29 variables:
 $ sample_id    : Factor w/ 3 levels "SRR2584863","SRR2584866",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ CHROM        : Factor w/ 1 level "CP000819.1": 1 1 1 1 1 1 1 1 1 1 ...
 $ POS          : int  9972 263235 281923 433359 473901 648692 1331794 1733343 2103887 2333538 ...
 $ ID           : logi  NA NA NA NA NA NA ...
 $ REF          : Factor w/ 59 levels "A","ACAGCCAGCCAGCCAGCCAGCCAGCCAGCCAG",..: 49 33 33 30 24 16 16 33 2 12 ...
 $ ALT          : Factor w/ 57 levels "A","AC","ACAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAG",..: 31 46 46 29 25 46 1 1 4 15 ...
 $ QUAL         : num  91 85 217 64 228 210 178 225 56 167 ...
 $ FILTER       : logi  NA NA NA NA NA NA ...
 $ INDEL        : logi  FALSE FALSE FALSE TRUE TRUE FALSE ...
 $ IDV          : int  NA NA NA 12 9 NA NA NA 2 7 ...
 $ IMF          : num  NA NA NA 1 0.9 ...
 $ DP           : int  4 6 10 12 10 10 8 11 3 7 ...
 $ VDB          : num  0.0257 0.0961 0.7741 0.4777 0.6595 ...
 $ RPB          : num  NA 1 NA NA NA NA NA NA NA NA ...
 $ MQB          : num  NA 1 NA NA NA NA NA NA NA NA ...
 $ BQB          : num  NA 1 NA NA NA NA NA NA NA NA ...
 $ MQSB         : num  NA NA 0.975 1 0.916 ...
 $ SGB          : num  -0.556 -0.591 -0.662 -0.676 -0.662 ...
 $ MQ0F         : num  0 0.167 0 0 0 ...
 $ ICB          : logi  NA NA NA NA NA NA ...
 $ HOB          : logi  NA NA NA NA NA NA ...
 $ AC           : int  1 1 1 1 1 1 1 1 1 1 ...
 $ AN           : int  1 1 1 1 1 1 1 1 1 1 ...
 $ DP4          : Factor w/ 217 levels "0,0,0,2","0,0,0,3",..: 3 132 73 141 176 104 61 74 133 137 ...
 $ MQ           : int  60 33 60 60 60 60 60 60 60 60 ...
 $ Indiv        : Factor w/ 3 levels "/home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ gt_PL        : Factor w/ 206 levels "100,0","103,0",..: 16 10 134 198 142 127 93 142 9 80 ...
 $ gt_GT        : int  1 1 1 1 1 1 1 1 1 1 ...
 $ gt_GT_alleles: Factor w/ 57 levels "A","AC","ACAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAG",..: 31 46 46 29 25 46 1 1 4 15 ...
 ```
Ok, thats a lot up unpack! Here's what to notice.

- the **object type** `data.frame` is displayed in the first row along with its
  **dimensions**, in this case 801 observations (rows) and 29 variables (columns)
- Each variable (column) has a name (e.g. `sample_id`). This is followed
  by the object **mode** (e.g. factor, int, num, etc.). Notice that before each
  variable name there is a `$` - this will be important later.

### Introducing Factors

**Factors** are the final major data structure we will introduce in our R genomics
lessons. Factors can be thought of as vectors which are specialized for
categorical data. Because R is specialized for statistics, it makes 
sense to have a way to deal with categorial data as if they were 
continuous (e.g. numerical) data. 
 
Sometimes you may want to have data treated as a factor, 
but not always! Since some of the data in our data frame are already 
identified as factors, lets see how factors work!
 
First, we'll extract one of the (non-numerical) columns of our data frame 
to a new **object**, so that we don't end up modifying the `variants` 
object by mistake. Here's where we use the **`$`** to represent a specific
vector (e.g. a column) in our data frame:

```
## extract the "REF" column to a new object

REF <- variants$REF
```

The "REF" column had a mode of "chr" or "character". Let's look at the first few items in our object using `head()`:

```
head(REF)
[1] T        G        G        CTTTTTTT CCGC     C       
59 Levels: A ACAGCCAGCCAGCCAGCCAGCCAGCCAGCCAG ... TGGGGGGG
```

What we get back are two lines. The first line represents a shortened form of 
all the items in our object *(think: everything in the column)*. 
The second line is something called "Levels".
**Levels are the different categories that make up a factor** 
*(think: every unique value in the column)*. By default, R
will organize the levels in a factor in alphabetical order. So the first level in this factor is
"A".

Lets look at the contents of a factor in a slightly different way using `str()`:

```
str(REF)
 Factor w/ 59 levels "A","ACAGCCAGCCAGCCAGCCAGCCAGCCAGCCAG",..: 49 33 33 30 24 16 16 33 2 12 ...
```

The `str()` function first shows the contents of the object arranged
in alphabetic order. Those are the **levels**. The second part of 
`str()` tells us the **integer** assigned to each **level** using the 
***original*** order of "REF".  

### Say that again??
For the sake of efficiency, R stores the 
content of a factor as a **vector of integers**. Once the contents 
in the object are arranged in alphabetical order, all 
identical values are merged creating a **"level"**. Each level 
has a *unique* value (and there are 59 of them in "REF") which is 
assigned an **integer**. 

The `head()` function told us the first value in our "REF" object 
is "T", but the second part of the `str()` output tells us that 
"T" in alphabetical order happens to be at the 49th level 
of our factor. According to `head()` the next two values 
from the top are both "G"s, and `str()` tells us that 
"G" is the 33rd level of our factor.

> #### How is this more efficient?
> 
> Think of a column with 10,000 values. If 9,998 of the values are "ABC" 
> and 2 of the values are "XYZ", a computer can store the 
> information in two "levels" as (9998ABC, 2XYZ) rather than having  
> to keep all 10,000 values in memory. If the 2 "XYZ" values were  
> at positions 384 and 1768 in the column, all the information 
> for the column could be stored like (9998ABC, 2XYZ[384,1768]). 
> That's 25 characters instead of 30,000 characters!!!!
> 
> When we call a function like `str()`, R uses stored vectors 
> to re-display the object values. 
 {: .callout}
 
#### Plotting and ordering factors

One of the most common uses for factors will be when you plot categorical
values. For example, suppose we want to know how many of our variants had each possible 
nucleotide (or nucleotide combination) in the reference genome? We could generate a plot:

```
plot(REF)
```

![First Plot]({{ site.baseurl }}/fig/first_plot.png)

This was easy, but isn't a particularly pretty example of a plot. We'll be learning much more about creating nice, publication-quality graphics later in this lesson. 

**(Good time for review and break)**

<!-- For now, let's explore how we can order -->
<!-- the factors in our plot so that the first four values are "A", "C", "G", "T", with multi-nucleotide -->
<!-- combinations listed alphabetically after these four. -->

<!-- We can take our existing `REF` factor, and use the `factor()` -->
<!-- function again. This time we will pass it two new arguments: `levels` will be -->
<!-- assigned to a vector that has the REF values in the order we want them, -->
<!-- and we will set the `ordered` argument to TRUE. -->

<!-- ```{r, purl = FALSE} -->
<!--  # order the 'REF' factor to match our desired set of levels -->
<!-- REF <-  -->
<!-- ```         -->

<!-- We can now see the new ordering: -->

<!-- ```{r, purl = FALSE} -->

<!-- ``` -->

<!-- Although not all levels are shown, notice there are `<` signs indicating an -->
<!-- order. -->

#### Subsetting data frames

Next, we are going to talk about how you can get specific values from data frames, and where necessary, change the mode of a column of values.

The first thing to remember is that a data frame is two-dimensional (rows and
columns). Therefore, to select a specific value we will will once again use
`[]` (bracket) notation, but we will specify more than one value (except in some cases
where we are taking a range).

> #### Exercise: Subsetting a data frame
>  **Move to Exercises**
> **Try the following indices and functions and try to figure out what they return**
> 
> a. `variants[1,1]`
>
> b. `variants[2,4]`
>
> c. `variants[801,29]`
>
> d. `variants[2, ]`
>
> e. `variants[-1, ]`
>
> f. `variants[1:4,1]`
>
> g. `variants[1:10,c("REF","ALT")]`
>
> h. `variants[,c("sample_id")]`
>
> i. `head(variants)`
>
> j. `tail(variants)`
>
> k. `variants$sample_id`
>
> l. `variants[variants$REF == "A",]`
>
>> ## Solution (put in solutions)
>> a. 
>> ```
>> variants[1,1]
[1] SRR2584863
Levels: SRR2584863 SRR2584866 SRR2589044
>> ```
>> 
>> b. 
>> ```
>> variants[2,4]
[1] NA
>> ```
>> 
>> c. 
>> ```
>> variants[801,29]
57 Levels: A ... TGGGGGGGGG
>> ```
>> 
>> d. 
>> ```
>> variants[2, ]
   sample_id      CHROM    POS ID REF ALT QUAL
2 SRR2584863 CP000819.1 263235 NA   G   T   85
  FILTER INDEL IDV IMF DP      VDB RPB MQB BQB
2     NA FALSE  NA  NA  6 0.096133   1   1   1
  MQSB       SGB     MQ0F ICB HOB AC AN     DP4
2   NA -0.590765 0.166667  NA  NA  1  1 0,1,0,5
  MQ
2 33
                                                               Indiv
2 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
  gt_PL gt_GT gt_GT_alleles
2 112,0     1             T
>> ```
>>
>> e. 
>> ```
>> variants[-1, ]
     sample_id      CHROM     POS ID
2   SRR2584863 CP000819.1  263235 NA
3   SRR2584863 CP000819.1  281923 NA
4   SRR2584863 CP000819.1  433359 NA
5   SRR2584863 CP000819.1  473901 NA
6   SRR2584863 CP000819.1  648692 NA
7   SRR2584863 CP000819.1 1331794 NA
8   SRR2584863 CP000819.1 1733343 NA
9   SRR2584863 CP000819.1 2103887 NA
10  SRR2584863 CP000819.1 2333538 NA
...
        G
33                                                         G
34                                                         G
35                                                         G
 [ reached getOption("max.print") -- omitted 766 rows ]
>> ```
>> 
>> ```
>> head(variants[-1, ])
   sample_id      CHROM     POS ID      REF       ALT QUAL FILTER
2 SRR2584863 CP000819.1  263235 NA        G         T   85     NA
3 SRR2584863 CP000819.1  281923 NA        G         T  217     NA
4 SRR2584863 CP000819.1  433359 NA CTTTTTTT CTTTTTTTT   64     NA
5 SRR2584863 CP000819.1  473901 NA     CCGC    CCGCGC  228     NA
6 SRR2584863 CP000819.1  648692 NA        C         T  210     NA
7 SRR2584863 CP000819.1 1331794 NA        C         A  178     NA
  INDEL IDV IMF DP      VDB RPB MQB BQB     MQSB       SGB     MQ0F
2 FALSE  NA  NA  6 0.096133   1   1   1       NA -0.590765 0.166667
3 FALSE  NA  NA 10 0.774083  NA  NA  NA 0.974597 -0.662043 0.000000
4  TRUE  12 1.0 12 0.477704  NA  NA  NA 1.000000 -0.676189 0.000000
5  TRUE   9 0.9 10 0.659505  NA  NA  NA 0.916482 -0.662043 0.000000
6 FALSE  NA  NA 10 0.268014  NA  NA  NA 0.916482 -0.670168 0.000000
7 FALSE  NA  NA  8 0.624078  NA  NA  NA 0.900802 -0.651104 0.000000
  ICB HOB AC AN     DP4 MQ
2  NA  NA  1  1 0,1,0,5 33
3  NA  NA  1  1 0,0,4,5 60
4  NA  NA  1  1 0,1,3,8 60
5  NA  NA  1  1 1,0,2,7 60
6  NA  NA  1  1 0,0,7,3 60
7  NA  NA  1  1 0,0,3,5 60
                                                               Indiv
2 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
3 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
4 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
5 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
6 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
7 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
  gt_PL gt_GT gt_GT_alleles
2 112,0     1             T
3 247,0     1             T
4  91,0     1     CTTTTTTTT
5 255,0     1        CCGCGC
6 240,0     1             T
7 208,0     1             A
Using '-1' shows the row numbers
>> ```
>>
>> f. 
>> ```
>> variants[1:4,1]
[1] SRR2584863 SRR2584863 SRR2584863 SRR2584863
Levels: SRR2584863 SRR2584866 SRR2589044
>> ```
>> 
>> g. 
>> ```
>> variants[1:10,c("REF","ALT")]
                                REF
1                                 T
2                                 G
3                                 G
4                          CTTTTTTT
5                              CCGC
6                                 C
7                                 C
8                                 G
9  ACAGCCAGCCAGCCAGCCAGCCAGCCAGCCAG
10                               AT
                                                ALT
1                                                 G
2                                                 T
3                                                 T
4                                         CTTTTTTTT
5                                            CCGCGC
6                                                 T
7                                                 A
8                                                 A
9  CCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAG
10                                              ATT
>> ```
>> 
>> h. 
>> ```
>> variants[,c("sample_id")]
...
[756] SRR2584866 SRR2584866 SRR2584866 SRR2584866 SRR2584866
[761] SRR2584866 SRR2584866 SRR2584866 SRR2584866 SRR2584866
[766] SRR2584866 SRR2584866 SRR2584866 SRR2584866 SRR2584866
[771] SRR2584866 SRR2584866 SRR2584866 SRR2584866 SRR2584866
[776] SRR2584866 SRR2584866 SRR2584866 SRR2584866 SRR2584866
[781] SRR2584866 SRR2584866 SRR2584866 SRR2584866 SRR2584866
[786] SRR2584866 SRR2584866 SRR2584866 SRR2584866 SRR2584866
[791] SRR2584866 SRR2589044 SRR2589044 SRR2589044 SRR2589044
[796] SRR2589044 SRR2589044 SRR2589044 SRR2589044 SRR2589044
[801] SRR2589044
Levels: SRR2584863 SRR2584866 SRR2589044
>> ```
>> 
>> ```
>> head(variants[,c("sample_id")])
[1] SRR2584863 SRR2584863 SRR2584863 SRR2584863 SRR2584863 SRR2584863
Levels: SRR2584863 SRR2584866 SRR2589044
>>```
>>
>> i. 
>> ```
>> head(variants)
   sample_id      CHROM    POS ID      REF       ALT QUAL FILTER
1 SRR2584863 CP000819.1   9972 NA        T         G   91     NA
2 SRR2584863 CP000819.1 263235 NA        G         T   85     NA
3 SRR2584863 CP000819.1 281923 NA        G         T  217     NA
4 SRR2584863 CP000819.1 433359 NA CTTTTTTT CTTTTTTTT   64     NA
5 SRR2584863 CP000819.1 473901 NA     CCGC    CCGCGC  228     NA
6 SRR2584863 CP000819.1 648692 NA        C         T  210     NA
  INDEL IDV IMF DP       VDB RPB MQB BQB     MQSB       SGB     MQ0F
1 FALSE  NA  NA  4 0.0257451  NA  NA  NA       NA -0.556411 0.000000
2 FALSE  NA  NA  6 0.0961330   1   1   1       NA -0.590765 0.166667
3 FALSE  NA  NA 10 0.7740830  NA  NA  NA 0.974597 -0.662043 0.000000
4  TRUE  12 1.0 12 0.4777040  NA  NA  NA 1.000000 -0.676189 0.000000
5  TRUE   9 0.9 10 0.6595050  NA  NA  NA 0.916482 -0.662043 0.000000
6 FALSE  NA  NA 10 0.2680140  NA  NA  NA 0.916482 -0.670168 0.000000
  ICB HOB AC AN     DP4 MQ
1  NA  NA  1  1 0,0,0,4 60
2  NA  NA  1  1 0,1,0,5 33
3  NA  NA  1  1 0,0,4,5 60
4  NA  NA  1  1 0,1,3,8 60
5  NA  NA  1  1 1,0,2,7 60
6  NA  NA  1  1 0,0,7,3 60
                                                               Indiv
1 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
2 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
3 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
4 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
5 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
6 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
  gt_PL gt_GT gt_GT_alleles
1 121,0     1             G
2 112,0     1             T
3 247,0     1             T
4  91,0     1     CTTTTTTTT
5 255,0     1        CCGCGC
6 240,0     1             T
>> ```
>> 
>> j. 
>> ```
>> tail(variants)
     sample_id      CHROM     POS ID REF ALT QUAL FILTER INDEL IDV
796 SRR2589044 CP000819.1 3444175 NA   G   T  184     NA FALSE  NA
797 SRR2589044 CP000819.1 3481820 NA   A   G  225     NA FALSE  NA
798 SRR2589044 CP000819.1 3893550 NA  AG AGG  101     NA  TRUE   4
799 SRR2589044 CP000819.1 3901455 NA   A  AC   70     NA  TRUE   3
800 SRR2589044 CP000819.1 4100183 NA   A   G  177     NA FALSE  NA
801 SRR2589044 CP000819.1 4431393 NA TGG   T  225     NA  TRUE  10
    IMF DP       VDB RPB MQB BQB     MQSB       SGB MQ0F ICB HOB AC
796  NA  9 0.4714620  NA  NA  NA 0.992367 -0.651104    0  NA  NA  1
797  NA 12 0.8707240  NA  NA  NA 1.000000 -0.680642    0  NA  NA  1
798   1  4 0.9182970  NA  NA  NA 1.000000 -0.556411    0  NA  NA  1
799   1  3 0.0221621  NA  NA  NA       NA -0.511536    0  NA  NA  1
800  NA  8 0.9272700  NA  NA  NA 0.900802 -0.651104    0  NA  NA  1
801   1 10 0.7488140  NA  NA  NA 1.007750 -0.670168    0  NA  NA  1
    AN     DP4 MQ
796  1 0,0,4,4 60
797  1 0,0,4,8 60
798  1 0,0,3,1 52
799  1 0,0,3,0 60
800  1 0,0,3,5 60
801  1 0,0,4,6 60
                                                                 Indiv
796 /home/dcuser/dc_workshop/results/bam/SRR2589044.aligned.sorted.bam
797 /home/dcuser/dc_workshop/results/bam/SRR2589044.aligned.sorted.bam
798 /home/dcuser/dc_workshop/results/bam/SRR2589044.aligned.sorted.bam
799 /home/dcuser/dc_workshop/results/bam/SRR2589044.aligned.sorted.bam
800 /home/dcuser/dc_workshop/results/bam/SRR2589044.aligned.sorted.bam
801 /home/dcuser/dc_workshop/results/bam/SRR2589044.aligned.sorted.bam
    gt_PL gt_GT gt_GT_alleles
796 214,0     1             T
797 255,0     1             G
798 131,0     1           AGG
799 100,0     1            AC
800 207,0     1             G
801 255,0     1             T
>> ```
>> 
>> k. 
>> ```
>> variants$sample_id
[776] SRR2584866 SRR2584866 SRR2584866 SRR2584866 SRR2584866
[781] SRR2584866 SRR2584866 SRR2584866 SRR2584866 SRR2584866
[786] SRR2584866 SRR2584866 SRR2584866 SRR2584866 SRR2584866
[791] SRR2584866 SRR2589044 SRR2589044 SRR2589044 SRR2589044
[796] SRR2589044 SRR2589044 SRR2589044 SRR2589044 SRR2589044
[801] SRR2589044
Levels: SRR2584863 SRR2584866 SRR2589044
NOTE that $ is a subsetting symbol that selects a single
element of a list. SO this selects all of column "sample_id"
>> ```
>>
>> ```
>> head(variants$sample_id)
[1] SRR2584863 SRR2584863 SRR2584863 SRR2584863 SRR2584863 SRR2584863
Levels: SRR2584863 SRR2584866 SRR2589044
>> ```
>> 
>> l. 
>> ```
>> variants[variants$REF == "A",]
>> `...`
96  199,0     1             G
104 255,0     1             G
107 255,0     1             G
109 218,0     1             G
110 255,0     1             G
111 252,0     1             G
[ reached getOption("max.print")--omitted 130 rows ]
 The $ selected only REF where REF == "A" 
 as the ROW, then ALL columns. (AKA: all 
 columns of variants where column 
 REF = "A"). The REF column doesn't 
 show so use head below
>> ```
>>
>> ```
>> head(variants[variants$REF == "A",])
    sample_id      CHROM     POS ID REF ALT QUAL FILTER INDEL IDV IMF
11 SRR2584863 CP000819.1 2407766 NA   A   C  104     NA FALSE  NA  NA
12 SRR2584863 CP000819.1 2446984 NA   A   C  225     NA FALSE  NA  NA
14 SRR2584863 CP000819.1 2665639 NA   A   T  225     NA FALSE  NA  NA
16 SRR2584863 CP000819.1 3339313 NA   A   C  211     NA FALSE  NA  NA
18 SRR2584863 CP000819.1 3481820 NA   A   G  200     NA FALSE  NA  NA
19 SRR2584863 CP000819.1 3488669 NA   A   C  225     NA FALSE  NA  NA
   DP       VDB      RPB      MQB      BQB     MQSB       SGB
11  9 0.0230738 0.900802 0.150134 0.750668 0.500000 -0.590765
12 20 0.0714027       NA       NA       NA 1.000000 -0.689466
14 19 0.9960390       NA       NA       NA 1.000000 -0.690438
16 10 0.4059360       NA       NA       NA 1.007750 -0.670168
18  9 0.1070810       NA       NA       NA 0.974597 -0.662043
19 13 0.0162706       NA       NA       NA 1.000000 -0.680642
       MQ0F ICB HOB AC AN      DP4 MQ
11 0.333333  NA  NA  1  1  3,0,3,2 25
12 0.000000  NA  NA  1  1 0,0,10,6 60
14 0.000000  NA  NA  1  1 0,0,12,5 60
16 0.000000  NA  NA  1  1  0,0,4,6 60
18 0.000000  NA  NA  1  1  0,0,4,5 60
19 0.000000  NA  NA  1  1  0,0,8,4 60
                                                                Indiv
11 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
12 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
14 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
16 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
18 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
19 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam
   gt_PL gt_GT gt_GT_alleles
11 131,0     1             C
12 255,0     1             C
14 255,0     1             T
16 241,0     1             C
18 230,0     1             G
19 255,0     1             C
>> ```
>>

The subsetting notation is very similar to what we learned for
vectors. The key differences include:

- Typically provide two values separated by commas: data.frame[row, column]
- In cases where you are taking a continuous range of numbers use a colon
  between the numbers (start:stop, inclusive)
- For a non continuous set of numbers, pass a vector using `c()`
- Index using the name of a column(s) by passing them as vectors using `c()`

Finally, in all of the subsetting exercises above, we printed values to
the screen. You can create a new data frame object by assigning
them to a new object name:

```
# create a new data frame containing only observations from SRR2584863 

SRR2584863_variants <- variants[variants$sample_id == "SRR2584863",]

# check the dimension of the data frame

dim(SRR2584863_variants)
[1] 25 29

# get a summary of the data frame

summary(SRR2584863_variants)
      sample_id         CHROM         POS             ID         
 SRR2584863:25   CP000819.1:25   Min.   :   9972   Mode:logical  
 SRR2584866: 0                   1st Qu.:1331794   NA's:25       
 SRR2589044: 0                   Median :2618472                 
                                 Mean   :2464989                 
                                 3rd Qu.:3488669                 
                                 Max.   :4616538                 
                                                                 
                               REF    
 A                               :10  
 G                               : 6  
 C                               : 3  
 ACAGCCAGCCAGCCAGCCAGCCAGCCAGCCAG: 1  
 AT                              : 1  
 CCGC                            : 1  
 (Other)                         : 3  
                                                       ALT   
 T                                                       :7  
 C                                                       :6  
 A                                                       :4  
 G                                                       :3  
 AC                                                      :1  
 ACAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAG:1  
 (Other)                                                 :3  
      QUAL         FILTER          INDEL              IDV       
 Min.   : 31.89   Mode:logical   Mode :logical   Min.   : 2.00  
 1st Qu.:104.00   NA's:25        FALSE:19        1st Qu.: 3.25  
 Median :211.00                  TRUE :6         Median : 8.00  
 Mean   :172.97                                  Mean   : 7.00  
 3rd Qu.:225.00                                  3rd Qu.: 9.75  
 Max.   :228.00                                  Max.   :12.00  
                                                 NA's   :19     
      IMF               DP            VDB               RPB        
 Min.   :0.6667   Min.   : 2.0   Min.   :0.01627   Min.   :0.9008  
 1st Qu.:0.9250   1st Qu.: 9.0   1st Qu.:0.07140   1st Qu.:0.9275  
 Median :1.0000   Median :10.0   Median :0.37674   Median :0.9542  
 Mean   :0.9278   Mean   :10.4   Mean   :0.40429   Mean   :0.9517  
 3rd Qu.:1.0000   3rd Qu.:12.0   3rd Qu.:0.65951   3rd Qu.:0.9771  
 Max.   :1.0000   Max.   :20.0   Max.   :0.99604   Max.   :1.0000  
 NA's   :19                                        NA's   :22      
      MQB               BQB              MQSB       
 Min.   :0.04979   Min.   :0.7507   Min.   :0.5000  
 1st Qu.:0.09996   1st Qu.:0.7627   1st Qu.:0.9599  
 Median :0.15013   Median :0.7748   Median :0.9962  
 Mean   :0.39997   Mean   :0.8418   Mean   :0.9442  
 3rd Qu.:0.57507   3rd Qu.:0.8874   3rd Qu.:1.0000  
 Max.   :1.00000   Max.   :1.0000   Max.   :1.0128  
 NA's   :22        NA's   :22       NA's   :3       
      SGB               MQ0F           ICB            HOB         
 Min.   :-0.6904   Min.   :0.00000   Mode:logical   Mode:logical  
 1st Qu.:-0.6762   1st Qu.:0.00000   NA's:25        NA's:25       
 Median :-0.6620   Median :0.00000                                
 Mean   :-0.6341   Mean   :0.04667                                
 3rd Qu.:-0.6168   3rd Qu.:0.00000                                
 Max.   :-0.4536   Max.   :0.66667                                
                                                                  
       AC          AN          DP4           MQ       
 Min.   :1   Min.   :1   0,0,4,5 : 3   Min.   :10.00  
 1st Qu.:1   1st Qu.:1   0,0,4,6 : 2   1st Qu.:60.00  
 Median :1   Median :1   0,0,0,4 : 1   Median :60.00  
 Mean   :1   Mean   :1   0,0,10,6: 1   Mean   :55.52  
 3rd Qu.:1   3rd Qu.:1   0,0,12,4: 1   3rd Qu.:60.00  
 Max.   :1   Max.   :1   0,0,12,5: 1   Max.   :60.00  
                         (Other) :16                  
                                                                Indiv   
 /home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam:25  
 /home/dcuser/dc_workshop/results/bam/SRR2584866.aligned.sorted.bam: 0  
 /home/dcuser/dc_workshop/results/bam/SRR2589044.aligned.sorted.bam: 0  
                                                                        
                                                                        
                                                                        
                                                                        
     gt_PL        gt_GT  
 255,0  :11   Min.   :1  
 111,28 : 1   1st Qu.:1  
 112,0  : 1   Median :1  
 121,0  : 1   Mean   :1  
 131,0  : 1   3rd Qu.:1  
 194,0  : 1   Max.   :1  
 (Other): 9              
                                                  gt_GT_alleles
 T                                                       :7    
 C                                                       :6    
 A                                                       :4    
 G                                                       :3    
 AC                                                      :1    
 ACAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAG:1    
 (Other)                                                 :3    
```

### Coercing values in data frames
### New Lecture

> #### What is coercion?
> Changing the mode of an object intentionally.
>
> #### Tip: coercion isn't limited to data frames
>
> While we are going to address coercion in the context of data frames
> most of these methods apply to other data structures, such as vectors


Sometimes, it is possible that R will misinterpret the type of data represented
in a data frame, or store that data in a mode which prevents you from
operating on the data the way you wish. For example, a long list of gene names
isn't usually thought of as a categorical variable, the way that your
experimental condition (e.g. control, treatment) might be. More importantly,
some R packages you use to analyze your data may expect characters as input,
not factors. At other times (such as plotting or some statistical analyses) a
factor may be more appropriate. Ultimately, you should know how to change the
mode of an object.

First, its very important to recognize that coercion happens in R all the time.
This can be a good thing when R gets it right, or a bad thing when the result
is not what you expect. Consider:

```
snp_chromosomes <- c('3', '11', 'X', '6')
typeof(snp_chromosomes)
[1] "character"
```

Although there are several numbers in our vector, they are all in quotes, so
we have explicitly told R to consider them as characters. However, even if we removed
the quotes from the numbers, R would ***coerce*** everything into a character:

```
snp_chromosomes_2 <- c(3, 11, 'X', 6)
typeof(snp_chromosomes_2)
[1] "character"
snp_chromosomes_2
[1] "3"  "11" "X"  "6" 
```

We can use the `as.` functions to explicitly coerce values from one form into
another. Consider the following vector of characters, which all happen to be
valid numbers:

```
snp_positions_2 <- c("8762685", "66560624", "67545785", "154039662")
typeof(snp_positions_2)
[1] "character"
```

Now we can coerce `snp_positions_2` into a numeric type using `as.numeric()`:

```
snp_positions_2 <- as.numeric(snp_positions_2)
typeof(snp_positions_2)
[1] "double"
snp_positions_2
[1]   8762685  66560624  67545785 154039662
```

Sometimes coercion is straight forward, but what would happen if we tried
using `as.numeric()` on `snp_chromosomes_2`

```
snp_chromosomes_2 <- as.numeric(snp_chromosomes_2)
Warning message:
NAs introduced by coercion
```

If we check, we will see that an `NA` value (R's default value for missing
data) has been introduced.

```
snp_chromosomes_2
[1]  3 11 NA  6
```

Trouble can ***really*** start when we try to coerce a factor. For example, when we
try to coerce the `sample_id` column in our data frame into a numeric mode
look at the result:

```
as.numeric(variants$sample_id)
  [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2
 [33] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
 [65] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
 [97] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[129] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[161] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[193] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[225] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[257] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[289] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[321] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[353] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[385] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[417] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[449] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[481] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[513] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[545] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[577] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[609] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[641] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[673] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[705] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[737] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[769] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3
[801] 3
```

Strangely, ***almost*** it works! Instead of giving an error message, R returns
numeric values. These numeric values are the **integers assigned to the levels in
this factor**. This kind of behavior can lead to hard-to-find bugs, for example
when we expect to have numbers in a factor, and we get additional numbers from a coercion. If
we don't look carefully, we may not notice a problem.

If you need to coerce an entire column you can overwrite it using an expression
like this one:

```
# make the 'REF' column a character type column
 
variants$REF <- as.character(variants$REF)

# check the type of the column
typeof(variants$REF)
[1] "character"
```

#### Using StringsAsFactors = FALSE

Lets summarize this section on coercion with a few take home messages.

- When you explicitly coerce one data type into another (this is known as
  **explicit coercion**), be careful to check the result. Ideally, you should try to see if its possible to avoid steps in your analysis that force you to
  coerce.  
- R will sometimes coerce without you asking for it. This is called
  (appropriately) **implicit coercion**. For example when we tried to create
  a vector with multiple data types, R chose one type through implicit
  coercion.
- Check the structure (`str()`) of your data frames before working with them!

One way to avoid needless coercion when
importing a data frame using any one of the `read.table()` functions (e.g. `read.csv()`) is to use the argument `StringsAsFactors` set to FALSE 
(`StringsAsFactors = FALSE`). By default,
this argument is TRUE. Setting it to FALSE will treat any non-numeric column as
"character" type. 
#### Example 
```
variantsStr <- read.csv("https://ndownloader.figshare.com/files/14632895", stringsAsFactors = FALSE)
```
```
typeof(variantsStr)
[1] "list"
```
```
str(variantsStr)
'data.frame':	801 obs. of  29 variables:
 $ sample_id    : chr  "SRR2584863" "SRR2584863" "SRR2584863" "SRR2584863" ...
 $ CHROM        : chr  "CP000819.1" "CP000819.1" "CP000819.1" "CP000819.1" ...
 $ POS          : int  9972 263235 281923 433359 473901 648692 1331794 1733343 2103887 2333538 ...
 $ ID           : logi  NA NA NA NA NA NA ...
 $ REF          : chr  "T" "G" "G" "CTTTTTTT" ...
 $ ALT          : chr  "G" "T" "T" "CTTTTTTTT" ...
 $ QUAL         : num  91 85 217 64 228 210 178 225 56 167 ...
 $ FILTER       : logi  NA NA NA NA NA NA ...
 $ INDEL        : logi  FALSE FALSE FALSE TRUE TRUE FALSE ...
 $ IDV          : int  NA NA NA 12 9 NA NA NA 2 7 ...
 $ IMF          : num  NA NA NA 1 0.9 ...
 $ DP           : int  4 6 10 12 10 10 8 11 3 7 ...
 $ VDB          : num  0.0257 0.0961 0.7741 0.4777 0.6595 ...
 $ RPB          : num  NA 1 NA NA NA NA NA NA NA NA ...
 $ MQB          : num  NA 1 NA NA NA NA NA NA NA NA ...
 $ BQB          : num  NA 1 NA NA NA NA NA NA NA NA ...
 $ MQSB         : num  NA NA 0.975 1 0.916 ...
 $ SGB          : num  -0.556 -0.591 -0.662 -0.676 -0.662 ...
 $ MQ0F         : num  0 0.167 0 0 0 ...
 $ ICB          : logi  NA NA NA NA NA NA ...
 $ HOB          : logi  NA NA NA NA NA NA ...
 $ AC           : int  1 1 1 1 1 1 1 1 1 1 ...
 $ AN           : int  1 1 1 1 1 1 1 1 1 1 ...
 $ DP4          : chr  "0,0,0,4" "0,1,0,5" "0,0,4,5" "0,1,3,8" ...
 $ MQ           : int  60 33 60 60 60 60 60 60 60 60 ...
 $ Indiv        : chr  "/home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam" "/home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam" "/home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam" "/home/dcuser/dc_workshop/results/bam/SRR2584863.aligned.sorted.bam" ...
 $ gt_PL        : chr  "121,0" "112,0" "247,0" "91,0" ...
 $ gt_GT        : int  1 1 1 1 1 1 1 1 1 1 ...
 $ gt_GT_alleles: chr  "G" "T" "T" "CTTTTTTTT" ...
 ```
 Notice that there are no "factor" coulmns in our data frame. Most coulmns that showed up as "factors" mode in the dataframe `variants` are now `chr` or "character" mode in `variantsStr` (and don't have assigned "levels"). 


The `read.csv()` documentation, also shows you how to
explicitly set your columns to a specific type using the `colClasses` argument. Other R packages
(such as the Tidyverse "readr") don't have this particular conversion issue,
but many packages will still try to guess a data type.

#### Data frame bonus material: math, sorting, renaming

Here are a few operations that don't need much explanation, but which are good
to know.

There are lots of arithmetic functions you may want to apply to your data
frame, covering those would be a course in itself (there is some starting
material [here](https://swcarpentry.github.io/r-novice-inflammation/15-supp-loops-in-depth/)). Our lessons will cover some additional summary statistical functions in
a subsequent lesson, but overall we will focus on data cleaning and
visualization.

You can use functions like `mean()`, `min()`, `max()` on an
individual column. Let's look at the "DP" or filtered depth. This value shows the number of filtered
reads that support each of the reported variants.

```
max(variants$DP)
```

You can sort a data frame using the `order()` function:

```
sorted_by_DP <- variants[order(variants$DP), ]
head(sorted_by_DP$DP)
```

> #### Exercise
> The `order()` function lists values in increasing order by default. Look at the documentation
> for this function and change `sorted_by_DP` to start with variants with the greatest filtered
> depth ("DP").
> 
> > #### Solution
> > ```
> > sorted_by_DP <- variants[order(variants$DP, decreasing = TRUE), ]
> > head(sorted_by_DP$DP)
> >```
> {: .solution}
{: .challenge}

<!-- You can selectively replace values in a data frame based on their value: -->

<!-- ```{r} -->
<!-- ``` -->

You can rename columns:

```
colnames(variants)[colnames(variants) == "sample_id"] <- "strain"

# check the column name (hint names are returned as a vector)
colnames(variants)
```

### Saving your data frame to a file

We can save data to a file. We will save our `SRR2584863_variants` object
to a .csv file using the `write.csv()` function:

```
write.csv(SRR2584863_variants, file = "../data/SRR2584863_variants.csv")
```

The `write.csv()` function has some additional arguments listed in the help, but
at a minimum you need to tell it what data frame to write to file, and give a
path to a file name in quotes (if you only provide a file name, the file will
be written in the current working directory).

### Importing data from Excel

Excel is one of the most common formats, so we need to discuss how to make
these files play nicely with R. The simplest way to import data from Excel is
to **save your Excel file in .csv format***. You can then import into R right
away. Sometimes you may not be able to do this (imagine you have data in 300
Excel files, are you going to open and export all of them?).

One common R package (a set of code with features you can download and add to
your R installation) is the [readxl package](https://CRAN.R-project.org/package=readxl) which can open and import Excel
files. Rather than addressing package installation this second (we'll discuss this soon!), we can take
advantage of RStudio's import feature which integrates this package. (Note:
this feature is available only in the latest versions of RStudio such as is
installed on our cloud instance).

First, in the RStudio menu go to **File**, select **Import Dataset**, and
choose **From Excel...** (notice there are several other options you can
explore).

<img src="{{ site.baseurl }}/fig/rstudio_import_menu.png " alt="rstudio import menu" style="width: 600px;"/>

Next, under **File/Url:** click the <KBD>Browse</KBD> button and navigate to the **Ecoli_metadata.xlsx** file located at `/home/dcuser/dc_sample_data/R`.
You should now see a preview of the data to be imported:

<img src="{{ site.baseurl }}/fig/rstudio_import_screen.png " alt="rstudio import screen" style="width: 1200px;"/>

Notice that you have the option to change the data type of each variable by
clicking arrow (drop-down menu) next to each column title. Under **Import
Options** you may also rename the data, choose a different sheet to import, and
choose how you will handle headers and skipped rows. Under **Code Preview** you
can see the code that will be used to import this file. We could have written
this code and imported the Excel file without the RStudio import function, but
now you can choose your preference.

In this exercise, we will leave the title of the data frame as
**Ecoli_metadata**, and there are no other options we need to adjust. Click the
<KBD>Import</KBD> button to import the data.

Finally, let's check the first few lines of the `Ecoli_metadata` data
frame:

```
## read the file so the rest of the episode works, but don't show the code
Ecoli_metadata <-  readxl::read_xlsx("../data/Ecoli_metadata.xlsx")
```

```
head(Ecoli_metadata)
```

The type of this object is 'tibble', a type of data
frame we will talk more about in the 'dplyr' section. If you needed
a true R data frame you could coerce with `as.data.frame()`.

> #### Exercise: Putting it all together - data frames
>
> **Using the `Ecoli_metadata` data frame created above, answer the following questions**
>
> A) What are the dimensions (# rows, # columns) of the data frame?
>
> B) What are categories are there in the `cit` column? *hint*: treat column as factor
>
> C) How many of each of the `cit` categories are there?
>
> D) What is the genome size for the 7th observation in this data set?
>
> E) What is the median value of the variable `genome_size`
>
> F) Rename the column `sample` to `sample_id`
>
> G) Create a new column (name genome_size_bp) and set it equal to the genome_size multiplied by 1,000,000
>
> H) Save the edited Ecoli_metadata data frame as "exercise_solution.csv" in your current working directory.
>
>> ## Solution
>> ```
>> dim(Ecoli_metadata)
>> levels(as.factor(Ecoli_metadata$cit))
>> table(as.factor(Ecoli_metadata$cit))
>> Ecoli_metadata[7,7]
>> median(Ecoli_metadata$genome_size)
>> colnames(Ecoli_metadata)[colnames(Ecoli_metadata) == "sample"] <- "sample_id"
>> Ecoli_metadata$genome_size_bp <- Ecoli_metadata$genome_size * 1000000
>> write.csv(Ecoli_metadata, file = "exercise_solution.csv")
>> ```
> 

### Keypoints:
- It is easy to import data into R from tabular formats including Excel.
  However, you still need to check that R has imported and interpreted your
  data correctly
- There are best practices for organizing your data (keeping it tidy) and R
  is great for this
- Base R has many useful functions for manipulating your data, but all of R's
  capabilities are greatly enhanced by software packages developed by the
  community