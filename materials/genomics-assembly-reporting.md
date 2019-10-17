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

Think of it as the contig in the middle when all contigs are lined up by size. The size of that contig, is the N50 size.

Maybe a figure will help. 
 
![N50]({{ site.baseurl }}/fig/N50.png)

> We are using several pre-made `.pbs` submission scripts, so let's briefly review 
> the structure of a submission script using the `velvetk21.pbs` we'll use later in 
> this lesson as an example:
>
> ![Submission Scripts]({{ site.baseurl }}/fig/PBS-script-details.png)


Now that we have completed several assemblies, let's look at our results. Change to the `results` directory and list the files. The output should look similar to the file list below: 
~~~
$ cd ../../results
$ ls
abyss21.fasta  abyss31.fasta  soap21.fasta  soap41.fasta    velvet31.fasta
abyss25.fasta  quast.pbs      soap31.fasta  velvet21.fasta  velvet41.fasta
~~~

These files are the results from all the programs using different K-mer parameters. 
If you have a different assembly (*e.g.* different K-mers) using the same assembler, 
make sure you name them differently, but **consistently**. For example: `abyss29.fasta`   `abyss33.fasta`  `soap33.fasta`  `velvet39.fasta`

> Note: Abyss has a command to get the scaffold statistic (N50) of any assembly in 
> fasta format. Use can use the command `abyss-fac`, which scans the contigs lengths 
> and outputs the N50 for your assembly. We will cover K-mer comparisons later but 
> thought you might like to know:
> ~~~ 
> $ module load abyss
> $ abyss-fac velvet31.fasta
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

You may see some warnings that quast could not find genes, or that some images 
could not be created. That's okay. Quast can do a lot of things we aren't 
validating today. If there are no fatal errors, send everything to yourself. 
Press `q` to exit the `less` command.
  
Before we send everything, we will zip the entire `quast` directory. It's good 
practice to compress files when transferring them because they transfer faster, 
and the use less bandwidth. After the zip command is complete, mail the file to 
yourself. If you have questions about the commands we are using, *you should 
be able to use the `man` pages or `--help` to figure things out*. 
~~~
$ zip -r quast.zip quastresults
$ mail -a quast.zip -r <youremailaddress> <youremailaddress>
~~~
(remember to hit `ctrl-d` to send)

Check your email, and place the attached `quast.zip` file on your Desktop, 
extract the file, and double-click on the `report.html` file to open it in 
your browser. If the file doesn't open, your browser may need Javascript 
to be enabled. Note that this `html` web page is interactive! You should 
see something like the image shown below for Group2:

![Quast Report html]({{ site.baseurl }}/fig/quast-report-html.png)

Before we cover everything in the web page, notice that the report results are 
also available as `report.pdf`, and the file `report.tsv` (and `report.txt`) are 
tab-delimited text files that will open in a spreadsheet as shown below for Group2. 
Quast is useful software! 

![Quast Report tsv]({{ site.baseurl }}/fig/quast-report-tsv.png)

<!--

These lines were for an older version of quast. 

Blue blocks: Show contigs/scaffolds that are correctly aligned. The boundaries will agree (within 2 kbp on each side, contigs are larger than 10 kbp) in at least half of the assemblies.

Green blocks: Show contigs/scaffolds that are correctly aligned, but the boundaries don’t agree. 

Orange blocks: Show contigs/scaffolds that are misassembled. Notice that the boundaries still agree in at least half of the assemblies.

Red blocks: Show contigs/scaffolds that are (badly) misassembled, and the boundaries don’t agree. 

--> 

We are going to look at the quast `report.html` file because it contains almost all 
the data that you'll find in the other files. This web page shows you the analysis of each 
assembly you made. You can now compare the assemblies based on good or bad qualities of 
the assembly statistics. *This is an important moment for you as a bioinformatician, 
because it's up to you to determine which assembly is the **best***, and ***why***.

And there is a problem: it isn't always a clear which assembly is the best. It may depend on 
***how you set up the experiment, and what you were trying to identify in the assemblies***.

But there are some rules we can use:
1. Misassembled genomes are very bad. 
2. Indels (Insertions or Deletions) are very bad.
3. Runs of `N` or lots of `N`s are bad.
4. Genome sizes that are close to the reference genome size are good.
5. Large N50 scores are good.
6. Combinations of bad things make the assembly worse.
7. Combinations of good things make the assembly better.

Before you make a decision, click on the blue letters that say `Extended report`.
Now you have a **lot** more information! Notice you can hover your mouse over the row 
identifiers (column1) and a description will pop up. Spend about 5 minutes 
(or more if you are doing this at home) and check out all the information
Quast has given you to help you decide if your assemblies are good. When you
are done, use the [Quast manual](https://github.com/ablab/quast) to get answers 
to the following question:

Which assembly has better length statistics? 

Best assembly: `_________________`

Worst assembly: `_________________`

How does your assembly compare structurally to the reference genome? 

### Icarus Browser

There's even more data to explore! Click on the "View in Icarus contig browser" link
under the date near the top of the Quast web page. You should now see a graphical 
rendetion of your aligned genomes. This is a lot of information!

![Icarus report from Quast]({{ site.baseurl }}/fig/quast-icarus-view.png)

Additionally, if you click on the button at the top left that says "Main menu" 
you'll be able to choose between the **"Quast report"**, or the **"Contig alignment viewer"** 
(the previous page) or the **"Contig size viewer"** (which should make it easier 
to eliminate some of the assemblies).

***WE ARE SORRY!***

Because we don't have time to go over all these data with you. We are only 
showing you that *you can do this*! Spend some time going over everything 
revealed in these charts. Make new assemblies and put them into your results 
directory and re-run Quast. *You should be curious*, and that's *good*. 

#### Re-aligning

It is very common that figuring out which is the best assembly is **hard**. 
But you can eliminate some of the assemblies based on misassemblies or indels. Once 
you have eliminated some assemblies you can go back and try more K-mer values! 
This is probably a good idea 
when you are first starting to assemble genomes. Some bioinformaticians prefer to 
re-align their own best assemblies using even more (different) software. To try this
and to show you quickly some additional bioinformatics software, enter the 
commands below, but change the filename (`abyss31.fasta`) to your **best** assembly
and run **`nucmer`**.

(Note: make sure module `bio_apps` is available)
~~~
$ cd ../
$ mkdir nucmer
$ cd nucmer
$ module load bio_apps
$ nucmer ../results/abyss31.fasta ../data/group1/ref.fasta
~~~
Visualize your `nucmer` assembly in dot plot using the software `mummerplot`.
~~~
$ mummerplot out.delta --postscript --layout
~~~
When `mmummerplot` is done, convert the plot from "postscript" to "PDF":
~~~
$ ps2pdf out.ps
~~~
Then mail the file `out.pdf` to yourself!
~~~
$ mail -a out.pdf -r <youremailaddress> <youremailaddress>
~~~
(remember to hit `ctrl-d` to send)

Repeat the above procedure on the **worst** assembly.  How different is it from your best assembly? 

- best assembly N50 from `nucmer`: `____________________`
- worst assembly N50 from `nucmer`: `____________________`

#### Background:

The data used in this exercise comes from a mutant yeast, where a novel method was used to generate the mutant. Our data comes from an individual called "MUTATOR4".

The paper about MUTATOR4 is here:

[http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3364565/](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3364565/)

The data we used were partitioned such that the reads were actually chromosomes not whole genomes!
We did this so that assembly ran faster in workshop. Here is a link to the data on the NCBI databse:

[http://www.ncbi.nlm.nih.gov/sra/DRX001304](http://www.ncbi.nlm.nih.gov/sra/DRX001304)

`________________________________________`

### EXTRAS:

Congratulations! 

You have learned a lot about genome assembly and are using your skills in the bash shell
to run real data. *It's always good to appreciate these small victories in science*.

Below we present some additional bioinformatics software on Cowboy that you 
might want to try. Although the commands are not exactly the same as those 
used in our lesson, you should be able to read the manuals, and figure out 
the commands to run these software on our example files. Some of these 
software are pipelines that include the software we have experimented with today. 

http://kmergenie.bx.psu.edu/  [“kmergenie”](http://kmergenie.bx.psu.edu/)

Another *de novo* assembly tutorial: [http://www.cbs.dtu.dk/courses/27626/Exercises/denovo_exercise.php](http://www.cbs.dtu.dk/courses/27626/Exercises/denovo_exercise.php)
(uses quake & jellyfish)

good outline: [http://en.wikibooks.org/wiki/Next_Generation_Sequencing_(NGS)/De_novo_assembly](http://en.wikibooks.org/wiki/Next_Generation_Sequencing_(NGS)/De_novo_assembly)

github repostiory with lots of slides etc: [https://github.com/lexnederbragt/denovo-assembly-tutorial](https://github.com/lexnederbragt/denovo-assembly-tutorial
)

(Acknowledgment: This exercise was originally presented at OSU by Dr. Haibao Tang, JCVI (now an independent consultant). It was modified by Dr. Dana Brunson, OSU HPCC (now at Internet2), and Dr. Peter R. Hoyt, OSU Biochemistry and Molecular Biology)