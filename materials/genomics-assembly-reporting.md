---
layout: page
element: notes
title: Assembly Reporting
language: Shell
---
***This lesson is being taught on the Cowboy supercomputer***

### Hands-on Genome Assembly Reporting

A **contig** is a contiguous length of genomic sequence. A scaffold is composed of ordered contigs and gaps. By far the most widely used statistics for describing the quality of a genome assembly are its scaffold and contig **N50s**. A contig N50 is calculated by first ordering every contig by length from longest to shortest. Next, starting from the longest contig, the lengths of each contig are summed, until this running sum equals one-half of the total length of all contigs in the assembly. The contig N50 of the assembly is the length of the shortest contig in this list. The scaffold N50 is calculated in the same fashion but uses scaffolds rather than contigs. The longer the scaffold N50 is, the better the assembly is. However, it is important to keep in mind that a poor assembly that has forced unrelated reads and contigs into scaffolds can have an erroneously large N50.

N50 statistic is a metric of the length of a set of sequences. N50 is the contig length such that using equal or longer contigs produces half the bases (http://en.wikipedia.org/wiki/N50_statistic).
 
![N50]({{ site.baseurl }}/fig/N50.png)
~~~
$ cd ../../results
$ ls
~~~
This directory contains the results from all the programs. If you have a different assembly (e.g different K-mers) using the same assembler, name them differently, for example: abyss25.fasta   abyss31.fasta  soap31.fasta  velvet31.fasta

Note: Abyss has a command to get the scaffold statistic (N50) of an assembly
Use can use the command `abyss-fac`, which scans the contigs lengths and outputs the N50 for your assembly. We will cover K-mer comparisons later but thought you might like to know:
~~~ 
$ module load abyss
$ abyss-fac velvet31.fasta
~~~
`________________________________________`

### Validation

Make sure that you validate the results before releasing it. Some assemblies may appear to have large contigs and scaffolds, but are wrong. Check the assembly!

Evaluate with [quast.py](https://github.com/ablab/quast)
Make sure you are in results directory (otherwise, `cd results`)

`$ nano -w quast.pbs`

The file looks like this:
~~~
#!/bin/bash
#
#PBS -q express
#PBS -j oe
#PBS -l nodes=1:ppn=12
#PBS -l walltime=1:00:00
cd $PBS_O_WORKDIR

module load quast

export GROUPNUMBER=1
export DATADIR=../data/group${GROUPNUMBER}

quast.py --gene-finding  `ls *.fasta`  -o quastresults  -R ${DATADIR}/ref.fasta
~~~

To run quast, change your groupnumber.  It will analyze all the `*.fasta` files in your `results` directory

Submit the quast.pbs file:

`$ qsub quast.pbs`

when finished look at the output file to check for errors

`$ less quast.pbs.o<jobid>`  (protip: TAB autocomplete so you don’t have to type in the jobid)
press “q” to exit 

**options:**  zip the quast directory and mail the whole thing to yourself
~~~
$ zip -r quast.zip quastresults
$ mail -a quast.zip -r <youremailaddress> <youremailaddress>
~~~
(remember to hit `ctrl-d` to send)

Extract the zip file and just double-click on the report html file.  Note that this html (web page) is interactive.

#### Other useful output from QUAST:

~~~
- report.pdf, contains similar analyses and plots as the html file (double-click to open)
- alignment.svg, contains the contig alignment plot (double-click to open)
~~~

Blue blocks: correctly aligned. Boundaries agree (within 2 kbp on each side, contigs are larger than 10 kbp) in at least half of the assemblies

Green blocks: correctly aligned. Boundaries don’t agree. 

Orange blocks: misassembled. Boundaries agree in at least half of the assemblies.

Red blocks: misassembled. Boundaries don’t agree. 

Which assembly has better length statistics? 
Check out the Quast manual to get answers.
Best assembly: `_________________`
Worst assembly: `_________________`

How does your assembly compare structurally to the reference? 
Align contigs to your best assembly, change the red filename below. 
~~~
$ cd ../
$ mkdir nucmer
$ cd nucmer
$ module load bio_apps
$ nucmer ../results/abyss31.fasta ../data/group1/ref.fasta
~~~
Visualize it in dot plot:
~~~
$ mummerplot out.delta --postscript --layout
$ ps2pdf out.ps
$ mail -a out.pdf -r <youremailaddress> <youremailaddress>
~~~
(remember to hit ctrl-d to send)

Repeat the above procedure on the worst assembly.  How different is it ? `____________________`

`________________________________________`

Background: about the data used in the exercise
The data used in this exercise comes from a mutant yeast, using a novel method to generate the mutant. Our data comes from an individual called MUTATOR4.

Exercise originally presented at OSU by Dr. Haibao Tang, JCVI. Modified by Dr. Dana Brunson, OSU HPCC, and Dr. Peter R. Hoyt

The paper:
http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3364565/
The data (we partitioned the reads to chromosomes so that assembly ran faster in workshop):
http://www.ncbi.nlm.nih.gov/sra/DRX001304

`________________________________________`

### EXTRAS:

http://kmergenie.bx.psu.edu/  “kmergenie”
See some slides here: http://ged.msu.edu/angus/tutorials-2013/files/2013-june-18-msu.pdf

Another *de novo* assembly tutorial: http://www.cbs.dtu.dk/courses/27626/Exercises/denovo_exercise.php
(uses quake & jellyfish)

good outline: http://en.wikibooks.org/wiki/Next_Generation_Sequencing_(NGS)/De_novo_assembly

github repostiory with lots of slides etc: https://github.com/lexnederbragt/denovo-assembly-tutorial
