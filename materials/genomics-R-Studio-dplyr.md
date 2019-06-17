---
layout: page
element: lecture
title: "Genomics R Studio dplyr"
language: R
---

### Questions:
- How can I manipulate dataframes without repeating myself?

## Objectives:
- Describe what the `dplyr` package in R is used for.
- Apply common `dplyr` functions to manipulate data in R.
- Employ the ‘pipe’ operator to link together a sequence of functions.
- Employ the ‘mutate’ function to apply other chosen functions to existing columns and create new columns of data.
- Employ the ‘split-apply-combine’ concept to split the data into groups, apply analysis to each group, and combine the results.

Using brackets to identify subsets (Bracket subsetting) is handy, but it can be cumbersome and difficult to read, especially for complicated operations. 

Luckily, the [`dplyr`](https://cran.r-project.org/package=dplyr)
package provides a number of very useful functions for manipulating dataframes
in a way that will reduce repetition, reduce the probability of making
errors, and probably even save you some typing. As an added bonus, you might
even find the `dplyr` grammar easier to read.

Here we're going to cover 6 of the most commonly used functions as well as using
pipes (`%>%`) to combine them. The first five are:

1. `select()`
2. `filter()`
3. `group_by()`
4. `summarize()`
5. `mutate()`

Packages in R are sets of additional functions that let you do more
stuff in R. The functions we've been using, like `str()`, come built into R;
packages give you access to more functions. You need to install a package and
then load it to be able to use it.

```
install.packages("dplyr") ## install
```

You might get asked to choose a CRAN mirror -- this is asking you to
choose a site to download the package from. The choice doesn't matter too much; I'd recommend choosing the RStudio mirror.

```
library("dplyr")          ## load
```

You only need to install a package once per computer, but you need to load it
every time you open a new R session and want to use that package.

## What is dplyr? (Dee-ply-er)

The package `dplyr` is a fairly new (2014) package that tries to provide easy
tools for the most common data manipulation tasks. It is built to work directly
with data frames. The thinking behind it was largely inspired by the package
`plyr` which has been in use for some time but suffered from being slow in some
cases.` dplyr` addresses this by porting much of the computation to C++. An
additional feature is the ability to work with data stored directly in an
external database. The benefits of doing this are that the data can be managed
natively in a relational database, queries can be conducted on that database,
and only the results of the query returned.

This addresses a common problem with R in that all operations are conducted in
memory and thus the amount of data you can work with is limited by available
memory. The database connections essentially remove that limitation in that you
can have a database of many 100s GB, conduct queries on it directly and pull
back just what you need for analysis in R.

### Selecting columns and filtering rows

To select columns of a
data frame, use `select()`. The first argument to this function is the data
frame (`variants`), and the subsequent arguments are the columns to keep.

```
select(variants, sample_id, REF, ALT, DP)
```

To select all columns *except* certain ones, put a "-" in front of
the variable to exclude it.

```
select(variants, -CHROM)
```

`dplyr` also provides useful functions to select columns based on their names. For instance, `ends_with()` allows you to select columns that ends with specific letters. For instance, if you wanted to select columns that end with the letter "B":

```
select(variants, ends_with("B"))
```

To choose rows, we can use `filter()`. For instance, to keep the rows for the sample `SRR2584863`:

```
filter(variants, sample_id == "SRR2584863")
```

Note that this is equivalent to the base R code below, 
but is easier to read!

```
variants[variants$sample_id == "SRR2584863",]
```
`filter()` will keep all the rows that match the conditions that are provided. Here are a few examples:


```
# rows for which the reference genome has T or G 
filter(variants, REF %in% c("T", "G"))
# rows with QUAL values greater than or equal to 100
filter(variants, QUAL >= 100)
# rows that have TRUE in the column INDEL
filter(variants, INDEL)
# rows that don't have missing data in the IDV column
filter(variants, !is.na(IDV))
```

`filter()` allows you to combine multiple conditions. You can separate them using a `,` as arguments to the function, they will be combined using the `&` (AND) logical operator. If you need to use the `|` (OR) logical operator, you can specify it explicitly:

```
## this is equivalent to:
##   filter(variants, sample_id == "SRR2584863" & QUAL >= 100)
filter(variants, sample_id == "SRR2584863", QUAL >= 100)
## using `|` logical operator
filter(variants, sample_id == "SRR2584863", (INDEL | QUAL >= 100))
```

Note that the keyboard character `|` is seen in Bash scripting as a "pipe" character, that ties commands together, however  in dplyr, `|` really just means "OR". But we can use pipes in dplyer, just with a different character as shown below.

### Pipes

What if you wanted to select **and** filter? We can do this with pipes. Pipes, 
are a fairly recent addition to R. Pipes let you
take the output of one function and send it directly to the next, which is
useful when you need to do many things with the same data set. Pipes in R look like
`%>%` and are made available via the `magrittr` package, which is installed as
part of `dplyr`. If you use RStudio, you can type the pipe with
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>M</kbd> if you're using a PC,
or <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>M</kbd> if you're using a Mac.
Here's an example:

```
variants %>%
  filter(sample_id == "SRR2584863") %>%
  select(REF, ALT, DP) %>%
  head(6)
```

In the above code, we use the pipe to send the `variants` dataset first through
`filter()`, keeping rows where `sample_id` matches a particular sample. Then 
we pipe that output through `select()` to
keep only the `REF`, `ALT`, and `DP` columns. Because `%>%` takes
the object on its left and passes it as the first argument to the function on
its right, we don't need to explicitly include the data frame `variant` argument
to the `filter()` and `select()` functions any more. We then pipe the results
to the `head()` function so that we only see the first six rows of data.

Some may find it helpful to read the pipe like the word "then". For instance,
in the above example, we took the data frame `variants`, *then* we `filter`ed
for rows where `sample_id` was SRR2584863, *then* we `select` out the `REF`, `ALT`, and `DP` columns, *then* we showed only the first six rows. 
The **`dplyr`** functions by themselves are somewhat simple,
but by combining them into linear workflows with the pipe, we can accomplish
more complex manipulations of data frames.

If we want to create a new object with this smaller version of the data we
can do so by assigning it a new name:

```
SRR2584863_variants <- variants %>%
  filter(sample_id == "SRR2584863") %>%
  select(REF, ALT, DP)
```

This new object includes all of the data from this sample. Let's look at it to confirm it's what we want:

```
SRR2584863_variants
```
Exercise 1 here

### Mutate

Frequently you'll want to create new columns based on the values in existing
columns, for example to do unit conversions or find the ratio of values in two
columns. For this we'll use the `dplyr` function `mutate()`.

We have a column titled "QUAL". This is a Phred-scaled confidence
score that a polymorphism exists at this position given the sequencing
data. Lower QUAL scores indicate low probability of a polymorphism
existing at that site. We can convert the confidence value QUAL
to a probability value according to the formula:

Probability = 1- 10 ^ -(QUAL/10)

Let's add a column (`POLPROB`) to our `variants` dataframe that shows 
the probability of a polymorphism at that site given the data. We'll show 
only the first six rows of data.

```
variants %>%
  mutate(POLPROB = 1 - (10 ^ -(QUAL/10)))
  head(6)
```

exercise 2 goes here

We are interested in knowing the most common size for the indels. Let's create a
new column, called "indel\_size" that contains the size difference between the
our sequences and the reference genome. The function, `nchar()` returns the
number of letters in a string.
 
```
variants %>%
  mutate(indel_size = nchar(ALT) - nchar(REF))
```

When you want to create a new variable that depends on multiple conditions, the function `case_when()` in combination with `mutate()` is very useful. Our current dataset has a column that tells us whether each mutation is an indel, but we don't know if it's an insertion or a deletion. Let's create a new variable, called `mutation_type` that will take the values: `insertion`, `deletion`, or `point` depending on the value found in the `indel_size` column. We will first save our original data frame in a new variable, called `variants_indel`.

```
variants_indel <- variants %>%
  mutate(
    indel_size = nchar(ALT) - nchar(REF),
    mutation_type = case_when(
      indel_size > 0 ~ "insertion",
      indel_size < 0 ~ "deletion",
      indel_size == 0 ~ "point"
    ))
```

When `case_when()` is used within `mutate()`, each row is evaluated for the condition in the order listed. The first condition that returns `TRUE` will by used to fill the content of the new column (here `mutation_type`) with the value listed on the right side of the `~` is used. The `~` essentially means "modeled by". If none of the conditions are met, the function returns `NA` (missing data).

We can check that we captured all possibilities by looking for missing data in the new `mutation_type` column, and confirm that no row matches this condition:

```
variants_indel %>%
  filter(is.na(mutation_type))
```


### Split-apply-combine data analysis and the summarize() function

Many data analysis tasks can be approached using the "split-apply-combine"
paradigm: split the data into groups, apply some analysis to each group, and
then combine the results. `dplyr` makes this very easy through the use of the
`group_by()` function, which splits the data into groups. When the data is
grouped in this way `summarize()` can be used to collapse each group into
a single-row summary. `summarize()` does this by applying an aggregating
or summary function to each group.

For example, if we wanted to group by `mutation_type` and find the average size for the insertions and deletions:

```
variants_indel  %>%
  group_by(mutation_type) %>%
  summarize(
    mean_size = mean(indel_size)
  )    
```

We can have additional columns by adding arguments to the `summarize()` function. For instance, if we also wanted to know the median indel size:

```
variants_indel %>%
  group_by(mutation_type) %>%
  summarize(
    mean_size = mean(indel_size),
    median_size = median(indel_size)
  )
```


So to view the highest filtered depth (`DP`) for each sample:

```
variants_indel %>%
  group_by(sample_id) %>%
  summarize(max(DP))
```

Challenge 3 goes here

> ## Callout: missing data and built-in functions
>
> R has many built-in functions like `mean()`, `median()`, `min()`, and `max()`
> that are useful to compute summary statistics. These are called "built-in
> functions" because they come with R and don't require that you install any
> additional packages. By default, all **R functions operating on vectors that
> contains missing data will return NA**. It's a way to make sure that users
> know they have missing data, and make a conscious decision on how to deal with
> it. When dealing with simple statistics like the mean, the easiest way to
> ignore `NA` (the missing data) is to use `na.rm = TRUE` (`rm` stands for
> remove).

It is often useful to calculate how many observations are present in each group. The function `n()` helps you do that. For example:

```
variants_indel %>%
  group_by(mutation_type) %>%
  summarize(
    n = n()
  )
```

Because `group_by` and `summarize` are very common operations, the `dplyr` verb, `count()` was provided as a "shortcut" that combines these 2 commands:

```
variants_indel %>%
  count(mutation_type)
```

`group_by()` can take multiple column names, and therfore `count()` can also take multiple column names.


Challenge 4 goes here

## (Optional) Reshaping data frames with 'spread'

We have learned the tidy format is useful to analyze and plot data in R, but sometimes we want to transform the "long" tidy format, into the wide format. This transformation can be done with the `spread()` function provided by the `tidyr` package (also part of the `tidyverse`).

`spread()` takes a data frame as the first argument, and then additional two arguments: the column name that will become the **columns**  and the column name that will become the **cells** in the wide data.

To demonstrate this, let's first create a new dataframe from `variants_indel` called `variants_wide`:

```
variants_wide <- variants_indel %>%
  count(sample_id, mutation_type) %>%
  spread(mutation_type, n)
variants_wide
```
This is similar to "inverting" a table". We are inverting the coluns 
`sample_id` and `mutation_type` such that `mutation_type` values are used like column headers, 
with the underneath cells having the values of `count(sample_id)`. Any positions for the new dataframe 
`variants_wide` without values, are given a `NA`.

The opposite operation of `spread()` is taken care by `gather()`. The `gather()` command in this example extends the column `mutation_type` vertically so that each value of `n` is evaluated. We specify the names of the new columns, and here add `-sample_id` as this column shouldn't be affected by the reshaping:

```
variants_wide %>%
  gather(mutation_type, n, -sample_id)
```

Optional challenge goes here

## Exporting

We can export almost all new datasets using `write_csv()`:

```
write_csv(variants_indel, "variants_indel.csv")
```

## Keypoints
- Use the `dplyr` package to manipulate dataframes.
- Use `select()` to choose variables from a dataframe.
- Use `filter()` to choose data based on values.
- Use `group_by()` and `summarize()` to work with subsets of data.
- Use `mutate()` to create new variables.

## Resources

* [Handy dplyr cheatsheet](https://github.com/rstudio/cheatsheets/raw/master/data-transformation.pdf)

*Much of this lesson was copied or adapted from Jeff Hollister's [materials](http://usepa.github.io/introR/2015/01/14/03-Clean/)*



