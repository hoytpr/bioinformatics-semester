---
layout: exercise
topic: Genomics
title: Genomics RStudio
language: R
---
Uncomment below to work on exercise 3

<!--
### Working with Dataframes

#### Exercise: Review the arguments of the `read.csv()` function

**Before using the `read.csv()` function, use R's help feature to answer the
following questions**.

*Hint*: Entering '?' before the function name and then running that line will
bring up the help documentation. Also, when reading this particular help
be careful to pay attention to the 'read.csv' expression under the 'Usage'
heading. Other answers will be in the 'Arguments' heading.

A) What is the default parameter for 'header' in the `read.csv()` function?

B) What argument would you have to change to read a file that was delimited
by semicolons (;) rather than commas?

C) What argument would you have to change to read file in which numbers
used commas for decimal separation (i.e. 1,00)?

D) What argument would you have to change to read in only the first 10,000 rows
of a very large file?

#### Exercise: Subsetting a data frame
 **Move to Exercises**
**Try the following indices and functions and try to figure out what they return**

a. `variants[1,1]`

b. `variants[2,4]`

c. `variants[801,29]`

d. `variants[2, ]`

e. `variants[-1, ]`

f. `variants[1:4,1]`

g. `variants[1:10,c("REF","ALT")]`

h. `variants[,c("sample_id")]`

i. `head(variants)`

j. `tail(variants)`

k. `variants$sample_id`

l. `variants[variants$REF == "A",]`

## Solution (put in solutions)
a. 
```
variants[1,1]
[1] SRR2584863
Levels: SRR2584863 SRR2584866 SRR2589044
```

b. 
```
variants[2,4]
 NA
```

c. 
```
variants[801,29]
57 Levels: A ... TGGGGGGGGG
```

d. 
```
variants[2, ]
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
```

e. 
```
variants[-1, ]
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
```

```
head(variants[-1, ])
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

Using '-1' (negative numbers) shows the row numbers
```

f. 
```
variants[1:4,1]
[1] SRR2584863 SRR2584863 SRR2584863 SRR2584863
Levels: SRR2584863 SRR2584866 SRR2589044
```

g. 
```
variants[1:10,c("REF","ALT")]
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
```

h. 
```
variants[,c("sample_id")]
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
```

```
head(variants[,c("sample_id")])
[1] SRR2584863 SRR2584863 SRR2584863 SRR2584863 SRR2584863 SRR2584863
Levels: SRR2584863 SRR2584866 SRR2589044
```

i. 
```
head(variants)
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
```

j. 
```
tail(variants)
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
```

k. 
```
variants$sample_id
[776] SRR2584866 SRR2584866 SRR2584866 SRR2584866 SRR2584866
[781] SRR2584866 SRR2584866 SRR2584866 SRR2584866 SRR2584866
[786] SRR2584866 SRR2584866 SRR2584866 SRR2584866 SRR2584866
[791] SRR2584866 SRR2589044 SRR2589044 SRR2589044 SRR2589044
[796] SRR2589044 SRR2589044 SRR2589044 SRR2589044 SRR2589044
[801] SRR2589044
Levels: SRR2584863 SRR2584866 SRR2589044
NOTE that $ is a subsetting symbol that selects a single
element of a list. SO this selects all of column "sample_id"
```

```
head(variants$sample_id)
[1] SRR2584863 SRR2584863 SRR2584863 SRR2584863 SRR2584863 SRR2584863
Levels: SRR2584863 SRR2584866 SRR2589044
```

l. 
```
variants[variants$REF == "A",]
`...`
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
```

```
head(variants[variants$REF == "A",])
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
```
-->

End of three