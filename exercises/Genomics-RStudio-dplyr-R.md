---
layout: exercise
topic: Genomics
title: Genomics RStudio dplyr
language: R
---
Uncomment below to work on exercise
Genomics-RStudio-dplyr-R.md

<!--
## Challenge 1

Create a table that contains all the columns with the letter "i" except for
the columns "Indiv" and "FILTER", and the column "POS". Hint: look at the help
for the function `ends_with()` we've just covered.


## Challenge 2

Select all the mutations that occurred between the positions 1e6 (one million)
and 2e6 (included) that are not indels and have QUAL greater than 200.

## Exercise 1 Pipe and filter

Starting with the `variants` dataframe, use pipes to subset the data
to include only observations from SRR2584863 sample,
where the filtered
depth (DP) is at least 10. Retain only the columns `REF`, `ALT`, 
and `POS`.

## Exercise 2
There are a lot of columns in our dataset, so let's just look at the
`sample_id`, `POS`, `QUAL`, and `POLPROB` columns for now. Add a 
line to the above code to only show those columns. 
 
## Challenge 3
What are the largest insertions and deletions? Hint: the function `abs()`
returns the absolute value.

## Challenge 4
How many mutations are found in each sample? 

## Challenge (optional)
Based on the probability scores we calculated when we first introducted
`mutate()`, classify each mutation in 3 categories: high (> 0.95), medium
(between 0.7 and 0.95), and low (< 0.7), and create a table with `sample_id`
as rows, the 3 levels of quality as columns, and the number of mutations in
the cells.
-->

End of dplyr-1