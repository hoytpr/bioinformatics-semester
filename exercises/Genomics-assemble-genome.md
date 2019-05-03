---
layout: exercise
topic: Genomics
title: Assemble Genome
language: Shell
---

### VELVET
`$ cd ../../velvet/`

Understand `velvetk31.pbs` - Use the text-file editor `nano` to examine our script file, that submits our data to the assemblers. 
`$ nano -w velvetk31.pbs`

Be sure to change the line:
export GROUPNUMBER=1
to *your* group number.  You will need to do this for all the submission scripts today.

Find these information from the log file:

Paired end library insert size: `_____________`   

Standard deviation `______________`

contig stats: n50 `________`  

max `_______` 

total `__________` 

reads used `____________` (did it use all the reads?)

**Does the assembly get better  if I use a different K-mer size?**

To try different K-mers, first copy your pbs script:
~~~
$ cp velvetk31.pbs velvetk21.pbs
$ nano -w velvetk21.pbs
~~~
and change K to a different value, currently 31. Try 21, 25.


### SOAPdenovo2

Now we will compare our data using the SOAPdenovo assembler. 

First change to the soap31 subdirectory
~~~
$ cd ../soap/soap31
$ ls 
soap.config  soapk31.pbs
~~~

The `soapk31.pbs.o<jobid>` is very useful. Use the `more` command to find these information from the log file:

Paired end library insert size: `_____________`   

Standard deviation `______________`

contig stats: n50 `________`  

max length contig `_______` 

total `__________` 

Now SOAP is done. Save the results!

`$ cp soap31.scafSeq ../../results/soap31.fasta`

**Does the assembly get better if I use a different K-mer size like 21?**

Try K-mer 21 then be sure to copy the result to your appropriate results folder.

Using what you’ve learned, do the 25 K-mer value and copy it to the appropriate results folder


### ABYSS

`$ cd ../../abyss/abyss31`

We change to a subdirectory because abyss puts all it’s output into the current working directory.

Understand `abyssk31.pbs`. ABYSS is simple, as it has just one command to run the entire pipeline. First edit the abyssk31.pbs to change GROUPNUMBER to your group number.

EMAIL the ‘short.hist’ file to yourself to look at it in a spreadsheet.
`$ mail -a short.hist -r youremail@wherever.com  youremail@wherever.com`

To determine the highest K-mer coverage in the histogram use:
`$ grep median abyssk31.pbs.o<jobidnumber>`

and put your answer in this box `___________`

Use the formula to estimate the genome size base on K-mer histogram: `______________` bp

The `abyssk31.pbs.o<jobid>` is very useful. Find these information from the log file:

contig stats: n50 `________`  

max `_______` 

total `__________` (compare to the estimate based on K-mer)

scaffold stats: n50 `________`  

max `_______` 

total `__________` 

Now that ABYSS is done. Save the results and rename it!

**Does the assembly get better  if I use a different K-mer size?** 

(Do the different K-mers and save the results)

### Validate

Use [Quast](http://quast.bioinf.spbau.ru/manual.html), plus [nucmer and mummerplot](https://github.com/mummer4/mummer/blob/master/MANUAL.md) to validate and visualize your assemblies. 
Don't worry too much about learning about these software, you can look them up later!

submit quast.pbs

`$ qsub quast.pbs`

Observe the outputs as in the lesson.
Align contigs to your best assembly, change the 'blank' filename below. 
~~~
$ cd ../
$ mkdir nucmer
$ cd nucmer
$ module load bio_apps
$ nucmer ../results/<blank>.fasta ../data/group1/ref.fasta
~~~
Visualize it in dot plot:
~~~
$ mummerplot out.delta --postscript --layout
$ ps2pdf out.ps
$ mail -a out.pdf -r <youremailaddress> <youremailaddress>
~~~
(remember to hit ctrl-d to send)
