---
layout: page
element: notes
title: Genomics RStudio Data Subsetting
language: R
---

### Objectives
- Be able to subset/retrieve values from a data frame
- Be able to retrieve (subset), name, or replace, values from a vector
- Be able to use logical operators in a subsetting operation
- Be able to manipulate a factor, including subsetting and reordering

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

Using a negative index will return a version of a vector with the index's
value removed:

```
snp_genes[-6]
```

We can remove an index value from our vector by overwriting it with this expression:

```
snp_genes <- snp_genes[-6]
snp_genes
```

We can also explicitly rename or add a value to our index using 
[double bracket](https://rspatial.org/intr/4-indexing.html#list) notation:

```
snp_genes[[7]]<- "APOA5"
snp_genes
```
(Don't worry about the all concepts in the URL above for this lesson)
The important thing to notice in the operation above is that R inserts 
an `NA` value to extend our vector so that the gene "APOA5" 
is at index 7. This may be a good or not-so-good thing depending 
on how you use this.

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


### Subsetting data frames

Next, we are going to talk about how you can get specific values from data frames, and where necessary, change the mode of a column of values.

The first thing to remember is that a data frame is two-dimensional (rows and
columns). Therefore, to select a specific value we will once again use
`[]` (bracket) notation, and can specify more than one value (we also 
can specify a range).

Here are a couple examples:

```
variants[1:4,1]
[1] SRR2584863 SRR2584863 SRR2584863 SRR2584863
Levels: SRR2584863 SRR2584866 SRR2589044
```
```
variants[1:10,c("REF","ALT")]

                                REF                                                ALT
1                                 T                                                  G
2                                 G                                                  T
3                                 G                                                  T
4                          CTTTTTTT                                          CTTTTTTTT
5                              CCGC                                             CCGCGC
6                                 C                                                  T
7                                 C                                                  A
8                                 G                                                  A
9  ACAGCCAGCCAGCCAGCCAGCCAGCCAGCCAG AGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAGCCAG
10                               AT                                                ATT
> 
```

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