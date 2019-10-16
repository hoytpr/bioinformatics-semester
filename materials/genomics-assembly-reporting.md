---
layout: page
element: notes
title: Assembly Reporting
language: Shell
---
(This workshop-style lesson is being taught on the Cowboy supercomputer at OSU)

### Hands-on Genome Assembly Reporting

A **contig** is a contiguous length of genomic sequence (an individual piece of a genome). A **scaffold** is composed of **ordered contigs and gaps**. Scaffolding generally relies on a reference genome, that can be used to "map" the location of each contig, placing them in the correct order (and by definition creating "scaffolds"). 

By far the most widely used statistics for describing the quality of a genome assembly are its scaffold and contig **N50s**. A contig N50 is calculated by first ordering every contig by length from longest to shortest. Next, starting from the longest contig, the lengths of each contig are summed, until this running sum equals one-half of the total length of all contigs in the assembly. The contig N50 of the assembly is the length of the shortest contig in this list. The scaffold N50 is calculated in the same fashion but uses scaffolds rather than contigs. The longer the contig or scaffold N50 is, the better the assembly is. However, it is important to keep in mind that a poor assembly may have forced unrelated reads and contigs into scaffolds creating an erroneously large N50.

Another way to say this is the [N50 statistic](http://en.wikipedia.org/wiki/N50_statistic) is a metric of the length of a set of sequences. N50 is the contig length such that using equal or longer contigs produces half the bases.

Maybe a figure will help. 
 
![N50]({{ site.baseurl }}/fig/N50.png)

Now that we have completed several assemblies, let's look at our results. 
~~~
$ cd ../../results
$ ls
~~~
This directory contains the results from all the programs. If you have a different assembly (*e.g.* different K-mers) using the same assembler, name them differently, for example: `abyss25.fasta`   `abyss31.fasta`  `soap31.fasta`  `velvet31.fasta`

Note: Abyss has a command to get the scaffold statistic (N50) of an assembly
Use can use the command `abyss-fac`, which scans the contigs lengths and outputs the N50 for your assembly. We will cover K-mer comparisons later but thought you might like to know:
~~~ 
$ module load abyss
$ abyss-fac velvet31.fasta
~~~
`________________________________________`

### Validation

Make sure that you validate the results before releasing it. Some assemblies may appear to have large contigs and scaffolds, but are wrong. Check the assembly!

We are going to evaluate our assemblies with [quast.py](https://github.com/ablab/quast).
First, make sure you are in `results` directory below the `mcbios` directory. Use
`nano` to look at the quast PBS submission script.

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

When you are ready to run quast, remember to change your groupnumber.  It will analyze all the `*.fasta` files in your `results` directory.

Submit the quast.pbs file:

`$ qsub quast.pbs`

When quast is finished look at the output file to check for obvious errors

`$ less quast.pbs.o<jobid>`  (protip: use TAB autocomplete so you don’t have to type in the jobid)
press `q` to exit the `less` command. 

If everything looks good, send it to yourself.
  
1) You can zip the `quast` directory and mail the whole thing to yourself:
~~~
$ zip -r quast.zip quastresults
$ mail -a quast.zip -r <youremailaddress> <youremailaddress>
~~~
(remember to hit `ctrl-d` to send)

Check your email, and place the attached `.zip` file on your Desktop, extract the file, and double-click on the `report.html` file to open it in your browser.  Note that this `html` web page is interactive.

2) We can also look at the report on `.pdf` format, and the alignment image `alignment.svg` will open in our web browser.

~~~
- report.pdf, contains similar analyses and plots as the html file (double-click to open)
- alignment.svg, contains the contig alignment plot (double-click to open)
~~~

Blue blocks: Show contigs/scaffolds that are correctly aligned. The boundaries will agree (within 2 kbp on each side, contigs are larger than 10 kbp) in at least half of the assemblies.

Green blocks: Show contigs/scaffolds that are correctly aligned, but the boundaries don’t agree. 

Orange blocks: Show contigs/scaffolds that are misassembled. Notice that the boundaries still agree in at least half of the assemblies.

Red blocks: Show contigs/scaffolds that are (badly) misassembled, and the boundaries don’t agree. 

Which assembly has better length statistics? 
Check out the [Quast manual](https://github.com/ablab/quast) to get answers.

Best assembly: `_________________`

Worst assembly: `_________________`

How does your assembly compare structurally to the reference genome? 

Some bioinformaticians prefer to align contigs to their own best assembly. To try this
and to show you quickly some additional bioinformatics software, change the filename (`abyss31.fasta`) below and run `nucmer`.

(Note: make sure module `bio_apps` is available)
~~~
$ cd ../
$ mkdir nucmer
$ cd nucmer
$ module load bio_apps
$ nucmer ../results/abyss31.fasta ../data/group1/ref.fasta
~~~
Visualize your `nucmer` assembly in dot plot using the software `mummer`.
~~~
$ mummerplot out.delta --postscript --layout
$ ps2pdf out.ps
$ mail -a out.pdf -r <youremailaddress> <youremailaddress>
~~~
(remember to hit `ctrl-d` to send)


Repeat the above procedure on the **worst** assembly.  How different is it from your best assembly? 

N50: `____________________`

Assembly quality metadata: `________________________________________`

#### Background:

The data used in this exercise comes from a mutant yeast, where a novel method was used to generate the mutant. Our data comes from an individual called "MUTATOR4".

The paper about MUTATOR4 is here:

[http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3364565/](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3364565/)

The data we used were partitioned such that the reads were actually chromosomes not whole genomes!
We did this so that assembly ran faster in workshop. Here is a link to the data on the NCBI databse:

[http://www.ncbi.nlm.nih.gov/sra/DRX001304](http://www.ncbi.nlm.nih.gov/sra/DRX001304)

(This exercise was originally presented at OSU by Dr. Haibao Tang, JCVI (now an independent consultant). It was modified by Dr. Dana Brunson, OSU HPCC (now at Internet2), and Dr. Peter R. Hoyt, OSU Biochemistry and Molecular Biology)
`________________________________________`

### EXTRAS:

Congratulations! 

You have learned a lot about genome assembly and are using your skills in the bash shell
to run real data. It's always good to appreciate these small victories in science.

Below we present some additional bioinformatics software that you might want to try. 
Although the commands are not exactly the same as those used in our lesson,
you should be able to read the manuals, and figure out the commands to run these
software on our example files. Some of these software are pipelines that 
include the software we have experiomented with today. 

http://kmergenie.bx.psu.edu/  [“kmergenie”](http://kmergenie.bx.psu.edu/)
See some slides here: http://ged.msu.edu/angus/tutorials-2013/files/2013-june-18-msu.pdf

Another *de novo* assembly tutorial: [http://www.cbs.dtu.dk/courses/27626/Exercises/denovo_exercise.php](http://www.cbs.dtu.dk/courses/27626/Exercises/denovo_exercise.php)
(uses quake & jellyfish)

good outline: [http://en.wikibooks.org/wiki/Next_Generation_Sequencing_(NGS)/De_novo_assembly](http://en.wikibooks.org/wiki/Next_Generation_Sequencing_(NGS)/De_novo_assembly)

github repostiory with lots of slides etc: [https://github.com/lexnederbragt/denovo-assembly-tutorial](https://github.com/lexnederbragt/denovo-assembly-tutorial
)
