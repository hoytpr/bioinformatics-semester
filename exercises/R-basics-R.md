---
layout: exercise
topic: Genomics
title: R-studio  
language: R
---


> ## Exercise: Create some objects in R
>
> Create the following objects; give each object an appropriate name
> (your best guess at what name to use is fine):
>
> 1. Create an object that has the value of number of pairs of human chromosomes
> 2. Create an object that has a value of your favorite gene name
> 3. Create an object that has this URL as its value: "ftp://ftp.ensemblgenomes.org/pub/bacteria/release-39/fasta/bacteria_5_collection/escherichia_coli_b_str_rel606/"
> 4. Create an object that has the value of the number of chromosomes in a
> diploid human cell
>
>> ## Solution
>>
>> Here as some possible answers to the challenge:
>> ```
>> human_chr_number <- 23
>> gene_name <- 'pten'
>> ensemble_url <- 'ftp://ftp.ensemblgenomes.org/pub/bacteria/release-39/fasta/bacteria_5_collection/escherichia_coli_b_str_rel606/'
>> human_diploid_chr_num <-  2 * human_chr_number
>> ```
> {: .solution}
{: .challenge}

> ## Exercise: Create objects and check their modes
>
> Create the following objects in R, then use the `mode()` function to verify
> their modes. Try to guess what the mode will be before you look at the solution
>
> 1. `chromosome_name <- 'chr02'`
> 2. `od_600_value <- 0.47`
> 3. `chr_position <- '1001701'`
> 4. `spock <- TRUE`
> 5. `pilot <- Earhart`
>
>> ## Solution
>> ```
>> chromosome_name <- 'chr02'
>> od_600_value <- 0.47
>> chr_position <- '1001701'
>> spock <- TRUE
>> pilot <- Earhart
>> ```
>> 
>> ```
>> mode(chromosome_name)
>> mode(od_600_value)
>> mode(chr_position)
>> mode(spock)
>> mode(pilot)
>> ```
> {: .solution}
{: .challenge}


> ## Exercise: Compute the golden ratio
>
> One approximation of the golden ratio (φ) can be found by taking the sum of 1
> and the square root of 5, and dividing by 2 as in the example above. Compute
> the golden ratio to 3 digits of precision using the `sqrt()` and `round()`
> functions. Hint: remember the `round()` function can take 2 arguments.
>
>> ## Solution
>> ```
>> round((1 + sqrt(5))/2, digits = 3)
>> ```
>> Notice that you can place one function inside of another.
> {: .solution}
{: .challenge}



> ## Exercise: Examining and subsetting vectors
> Answer the following questions to test your knowledge of vectors
>
> Which of the following are true of vectors in R?
> A) All vectors have a mode **or** a length  
> B) All vectors have a mode **and** a length  
> C) Vectors may have different lengths  
> D) Items within a vector may be of different modes  
> E) You can use the `c()` to one or more items to an existing vector  
> F) You can use the `c()` to add a vector to an exiting vector  
>>
>> ## Solution
>>
>> A) False - Vectors have both of these properties  
>> B) True  
>> C) True  
>> D) False - Vectors have only one mode (e.g. numeric, character); all items in  
>> a vector must be of this mode.
>> E) True  
>> F) True  
> {: .solution}
{: .challenge}

> ## Review Exercise 1
>
> What data types/modes are the following vectors?
>    a. `snps`  
>    b. `snp_chromosomes`  
>    c. `snp_positions`  
> 
>> ## Solution
>> 
>> ```
>> typeof(snps)
>> typeof(snp_chromosomes)
>> typeof(snp_positions)
>> ```
> {: .solution}
{: .challenge}

> ## Review Exercise 2
>
> Add the following values to the specified vectors:
>    a. To the `snps` vector add: 'rs662799'  
>    b. To the `snp_chromosomes` vector add: 11  
>    c. To the `snp_positions` vector add: 	116792991  
> 
>> ## Solution
>> 
>> ```
>> snps <- c(snps, 'rs662799')
>> snps
>> snp_chromosomes <- c(snp_chromosomes, "11") # did you use quotes?
>> snp_chromosomes
>> snp_positions <- c(snp_positions, 116792991)
>> snp_positions
>> ```
> {: .solution}
{: .challenge}

> ## Review Exercise 3
> Make the following change to the `snp_genes` vector:
> 
> Hint: Your vector should look like this in 'Environment':
> `chr [1:7] "OXTR" "ACTN3" "AR" "OPRM1" "CYP1A1" NA "APOA5"`. If not
> recreate the vector by running this expression:
> `snp_genes <- c("OXTR", "ACTN3", "AR", "OPRM1", "CYP1A1", NA, "APOA5")`
>
>    a. Create a new version of `snp_genes` that does not contain CYP1A1 and then  
>    b. Add 2 NA values to the end of `snp_genes`  
> 
>> ## Solution
>> 
>> ```
>> snp_genes <- snp_genes[-5]
>> snp_genes <- c(snp_genes, NA, NA)
>> snp_genes
>> ```
> {: .solution}
{: .challenge}

> ## Review Exercise 4
> 
> Using indexing, create a new vector named `combined` that contains:
>    - The the 1st value in `snp_genes`
>    - The 1st value in `snps`
>    - The 1st value in `snp_chromosomes`
>    - The 1st value in `snp_positions`
> 
>> ## Solution
>> 
>> ```
>> combined <- c(snp_genes[1], snps[1], snp_chromosomes[1], snp_positions[1])
>> combined
>> ```
> {: .solution}
{: .challenge}


> ## Review Exercise 5
> What type of data is `combined`?
> 
>> ## Solution
>> 
>> ```
>> typeof(combined)
>> ```
> {: .solution}
{: .challenge}

## Bonus material: Lists

Lists are quite useful in R, but we won't be using them in the genomics lessons.
That said, you may come across lists in the way that some bioinformatics
programs may store and/or return data to you. One of the key attributes of a
list is that, unlike a vector, a list may contain data of more than one mode.
Learn more about creating and using lists using this [nice
tutorial](https://r4ds.had.co.nz/vectors.html#lists). In this one example, we will create
a named list and show you how to retrieve items from the list.

```
# Create a named list using the 'list' function and our SNP examples
# Note, for easy reading we have placed each item in the list on a separate line
# Nothing special about this, you can do this for any multiline commands
# To run this command, make sure the entire command (all 4 lines) are highlighted
# before running
# Note also, as we are doing all this inside the list() function use of the
# '=' sign is good style
snp_data <- list(genes = snp_genes,
                 refference_snp = snps,
                 chromosome = snp_chromosomes,
                 position = snp_positions)
# Examine the structure of the list
str(snp_data)
```


To get all the values for the `position` object in the list, we use the `$` notation:

```
# return all the values of position object

snp_data$position
```

To get the first value in the `position` object, use the `[]` notation to index:

```
# return first value of the position object

snp_data$position[1]
```

Fill in the blank:

"Effectively using R is a journey of ______ __ _____"

