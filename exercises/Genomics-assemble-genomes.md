---
layout: exercise
topic: Genomics
title: Assemble Genomes
language: Shell
---

### Genomics VELVET Exercises

In the lectures we ran the `velvetk31.pbs` job, and analyzed some output using `nano`.

**Does the assembly get better  if I use a different K-mer size?**

To try different K-mers, first copy your pbs script:
~~~
$ cp velvetk31.pbs velvetk21.pbs
$ nano -w velvetk21.pbs
~~~
and change K to a different value, currently 31. Use 21, and 25.
Use the text-file editor `nano` to 
examine information from the velvet21 and velvet25 log files. Report the following information:

Paired end library insert size: 21:`_____________`   25:`______________`

Standard deviation 21:`_____________`   25:`______________`

contig stats: 

n50 21:`_____________`   25:`______________`  

max contig length 21:`_____________`   25:`______________` 

total number of contigs 21:`_____________`   25:`______________` 

reads used 21:`_____________`   25:`______________` (did it use all the reads?)

### SOAPdenovo2

**Does the assembly get better if I use a different K-mer size like 21?**

Compare our data using the SOAPdenovo assembler exactly the same 
way we compared new k-mers using velvet. Remember to start by copying the 
submission scripts:
~~~
$ cp soap31.pbs soap21.pbs
$ nano -w soapk21.pbs
~~~

Use the `more` command to find these information from the log file:

Paired end library insert size: 21:`_____________`   25:`______________`

Standard deviation 21:`_____________`   25:`______________`

contig stats: 

n50 21:`_____________`   25:`______________`  

max contig length 21:`_____________`   25:`______________` 

total number of contigs 21:`_____________`   25:`______________` 

reads used 21:`_____________`   25:`______________` (did it use all the reads?)

Save the new soap results!

`$ cp soap21.scafSeq ../../results/soap21.fasta` and `$ cp soap25.scafSeq ../../results/soap25.fasta`

### ABYSS

**Does the assembly get better if I use a different K-mer sizes?**

Compare our data using the ABYSS assembler exactly the same 
way we compared new k-mers using velvet. Remember to start by copying the 
submission scripts:

`$ cd ../../abyss/abyss31`
~~~
$ cp abyss31.pbs abyss21.pbs
$ nano -w soapk21.pbs
~~~

When the 21 k-mer and 25 k-mer jobs are completed, EMAIL the ‘short.hist’ file to yourself to look at it in a spreadsheet.
`$ mail -a short.hist -r youremail@wherever.com  youremail@wherever.com`

To determine the highest K-mer coverage in the histogram use:
`$ grep median abyssk21.pbs.o<jobidnumber>`
`$ grep median abyssk25.pbs.o<jobidnumber>`

and put your answers here 21:`_____________`   25:`______________`  

Use the formula from the lecture to estimate the genome size 
based on K-mer histogram: 21:`_____________`   25:`______________`   bp

Find the following information from the abyss log files:

contig stats: n50 21:`_____________`   25:`______________`  

max 21:`_____________`   25:`______________` 

total 21:`_____________`   25:`______________` (compare to the estimate based on K-mer)

scaffold stats: n50 21:`_____________`   25:`______________`  

max 21:`_____________`   25:`______________` 

total 21:`_____________`   25:`______________` 

Now that ABYSS is done. Save the results and rename them as with SOAP!

### Validate

Use [Quast](http://quast.bioinf.spbau.ru/manual.html), plus [nucmer and mummerplot](https://github.com/mummer4/mummer/blob/master/MANUAL.md) to validate and visualize all your assemblies. 

submit quast.pbs

`$ qsub quast.pbs`

Observe the outputs as in the lecture.
Align contigs to your **best** assembly. 
Use nucmer, and mummerplot to create PDF files of the best assembly 
and email the best assembly to yourself, and to the instructor. 
