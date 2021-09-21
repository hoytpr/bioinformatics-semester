---
layout: page
element: notes
title: Assembly Tools
language: Shell
---
### Hands-on Genome Assembly Tools 
(This workshop-style-lesson is taught on the Pete supercomputer at OSU)

#### DISCLAIMER: Some of these software (not all) nearly obsolete.

We are using them to demonstrate some processes used in 
bioinformatics. We want you to know you can do this!
But be aware that open source software 
stops working eventually if is not actively maintained. The software used in this 
beginner's introduction are already suffering from ["Software collapse"](https://hal.archives-ouvertes.fr/hal-02117588) 
a term introduced in 2019.  

#### Why are we using older software?

**Bioinformatics** is rapidly developing and most software used for 
many important bioinformatics processes like assembly, 
**could be updated multiple times before the semester completed!** 
(This is also why we don't use a textbook) 

**Online learning repositories** 
such as [The Carpentries](https://carpentries.org/), including [Software Carpentry](https://software-carpentry.org/) and [Data Carpentry](https://datacarpentry.org/) 
(which this course [uses](https://datacarpentry.org/shell-genomics/)) are needed for their carefully curated lessons, 
and also for their ability to remain current! Also consider free resources like [Cyverse](https://cyverse.org/). 

**Do some research and find the best software for your project** 
if you plan to perform assembly or RNA-Seq in your own experiments.
There are many online tutorials but only ***some*** are well-maintained. In 
particular the [Galaxy Project](https://galaxyproject.org/) is a great place to find [current bioinformatics software](https://docs.galaxyproject.org/en/master/releases/index.html) and
[tutorials](https://galaxyproject.org/tutorials/g101/).

For an interesting discussion about scientists using outdated software see this 
2018 article [Scientists Continue to Use Outdated Methods](https://www.the-scientist.com/news-opinion/scientists-continue-to-use-outdated-methods-30438), 

### Assembly

**Main Point!**: Not all [assemblers](https://en.wikipedia.org/wiki/Sequence_assembly#Notable_assemblers) are the same or give the same results.
Also note that there are assemblers that use a reference genome to assist in assembly (reference-guided assembly) as opposed to *de novo* assembly which does not use a genome as a reference. 

**Which genome assembler should I use?**

1. As inefficient as it seems, it's generally good to run several assemblers and compare results 
to find the one best for your data! Also, if there is a good-quality reference genome, you should use it. We are using reference-guided assembly with VELVET, and 
SPAdes in this lesson. All of these assemblers use [de-bruijn](https://en.wikipedia.org/wiki/De_Bruijn_graph) (K-mer) 
graph assembly methods.
2. Some assembly software are optimized for specific organisms or types of data outputs. In these cases you can safely use the recommended assembler

##### Genome_size = Total_Kmers / peak_Kmer_coverage

For more information about K-mers and coverage, there is this [EXTRA Page]({{ site.baseurl }}/materials/extras/kmers-and-coverage-discussion)
that explains why we want to estimate genome sizes. Briefly,
K-mers represent a copy of all your sequencing data, broken into small fragments of an exact size.

> This is useful because: 
> 1. Assemblers can be confused by repeated sequences and end up very inaccurate. This gives you a second opinion.
> 2. You might not know anything about your genome size!
> 
> Imagine you had 30-billion base pairs of sequencing data, and you ***knew*** your coverage 
> was "10-fold", you could then estimate the size of your genome being sequenced 
> was 3-billion base-pairs long (30,000,000,000 ÷ 10 = 3,000,000,000)

> We are using several pre-made `.sbatch` submission scripts, so let's briefly review 
> the structure of a submission script using the `velvetk29.sbatch` we'll use later in 
> this lesson as an example.
>
> ![Submission Scripts]({{ site.baseurl }}/fig/sbatch-image.png)

### VELVET

`$ cd ../../velvet/`

Understand `velvetk31.sbatch` - We will use the text-file editor `nano` to examine our script file, that submits our data to the assemblers. 
`$ nano -w velvetk31.sbatch`

Be sure to change the line:

`export GROUPNUMBER=1`

to ***your*** group number.  You will need to do this for all the submission scripts today.

The first section of our `velvetk31.sbatch` script sets up the scheduler requests (the queueing system) and environment variables. The  assembler commands are `velveth` and `velvetg`. What do these commands do?  See the [velvet website here](https://github.com/dzerbino/velvet).  

If you understand the script and have changed the group number, press ctrl-x, save the file and submit it to the queue with the `sbatch` command as follows.

`$ sbatch velvetk31.sbatch`
 
What was printed on the screen after you pressed enter? 

`Submitted batch job <jobidnumber>` 

After the job is finished, the log file, your results will be in the `velvet31` folder.
`velvetk31.sbatch.o<jobidnumbmer>` is very useful. 

Options to examine that file:

`$ tail velvetk31.sbatch.o<jobidnumber>`  (HINT: Try using TAB-completion to enter your commands!)

OR

`$ less velvetk31.sbatch.o<jobidnumber>`
 
You can scroll through the `less` interface by pressing the `enter` key 
on your keyboard. Also, remember to press `q` to quit the `less` interface.
But here's a trick to using `less` for searching:
At the bottom of the `less` interface, there is a "colon" character `:` to the left of your cursor.
If you press the forward slash button **`/`** on your keyboard, you will see the line is now blank. 
It is waiting for a search pattern! Try entering something like "Paired end library" and press the `Enter` key.

Now use `less` tind these information from the log file:
Paired end library insert size: `_____________`   

Standard deviation `______________`

contig stats: 

n50 `________`  

max contig length `_______`

total number of contigs `__________` 

reads used `____________` (did it use all the reads?)

Where are the contigs stored? Save the results!

`$ cp velvet31/contigs.fa ../results/velvet31.fasta`

**Does the assembly get better  if I use a different K-mer size?**

To try different kmers, first copy your `.pbs` script with a new name:
~~~
$ cp velvetk31.sbatch velvetk21.sbatch
$ nano -w velvetk21.sbatch
~~~
and change K to a different value, currently 31. Try 21 first, and then 25.
then submit this new job:

`$ sbatch velvetk21.sbatch`

Your results will be in the `velvet31` subfolder.

To see kmer coverage differences in a histogram format, we can use the included Perl script on the velvet `stats.txt` file in each of your results folders: 
```
$ module load velvet
$ velvet-estimate-exp_cov.pl velvet31/stats.txt
    10 |      1 | **********
<snip>
Predicted expected coverage: 18
velvetg parameters: -exp_cov 18 -cov_cutoff 0
```

This is 
a K-mer histogram. 

![K-mer histogram from slides]({{ site.baseurl }}/fig/kmer-hist.png)

You should learn that when using 
K-mer based assembly methods, "good" K-mers show a peak where coverage 
is the most accurate. K-mers at low coverage tend to be those with many errors, 
and so they are ignored (we're going to ignore them too!). The coverage histogram 
displays "coverage" vs. the "Number of K-mers". 
The number of K-mers at every useful level of coverage are shown.

Here's another trick: You can use this K-mer histogram to estimate the size of
the genome you sequenced using the following formula:

##### Genome_size = Total_Kmers / peak_Kmer_coverage

For more information about K-mers and coverage, there is this [EXTRA Page]({{ site.baseurl }}/materials/extras/kmers-and-coverage-discussion)
that explains why we want to estimate genome sizes. Briefly,
K-mers represent a copy of all your sequencing data, broken into small fragments of an exact size.
Software can **estimate** your coverage of the genome based on the number of "good" K-mers.

> This is useful because: 
> 1. Assemblers can be confused by repeated sequences and end up very inaccurate. This gives you a second opinion.
> 2. You might not know anything about your genome size!
> 
> Imagine you had 30-billion base pairs of sequencing data, and you ***knew*** your coverage 
> was "10-fold", you could then estimate the size of your genome being sequenced 
> was 3-billion base-pairs long (30,000,000,000 ÷ 10 = 3,000,000,000)
  
To calculate "Total_Kmers", sum 
all the numbers of all your K-mers. This is 
(approximately) the **total number** of all your "good" K-mers.

The formula above estimates the genome size based on K-mer histogram. What is your Group's 
genome size estimate? `________` bp.
 


***CONGRATULATIONS*** on your first assembly!



<!--

### SOAPdenovo2

Now we will compare our data using the SOAPdenovo assembler. 

First change to the soap31 subdirectory
~~~
$ cd ../soap/soap31
$ ls 
soap.config  soapk31.sbatch
~~~
SOAPdenovo is different as it uses a configuration file `soap.config`, where we tell SOAP what our data are. We include detailed info below so we can move ahead with the computation step.

#### SOAPdenovo options and arguments

`[LIB]`:	Calls the soap denovo command library into action

`avg_ins=350`:	This value indicates the average insert size of this library or the peak value position in the insert size distribution figure.

`reverse_seq=0`:	This option takes value 0 or 1. It tells the assembler if the read sequences need to be complementarily reversed. Illumima GA produces two types of paired-end libraries: a) forward-reverse, generated from fragmented DNA ends with typical insert size less than 500 bp; b) reverse-forward, generated from circularizing libraries with typical insert size greater than 2 Kb. The parameter "reverse_seq" should be set to indicate this: 0, forward-reverse; 1, reverse-forward.

`asm_flags=3`:	This indicator decides in which part(s) the reads are used. It takes value 1(only contig assembly), 2 (only scaffold assembly), 3(both contig and scaffold assembly), or 4 (only gap closure).

`rank=1`:	It takes integer values and decides in which order the reads are used for scaffold assembly. Libraries with the same "rank" are used at the same time during scaffold assembly. 

How do you set library rank?
SOAPdenovo will use the pair-end libraries with insert size from smaller to larger to construct scaffolds. Libraries with the same rank would be used at the same time. For example, in a dataset of a human genome, we set five ranks for five libraries with insert size 200-bp, 500-bp, 2-Kb, 5-Kb and 10-Kb, separately. It is desired that the pairs in each rank provide adequate physical coverage of the genome.

`q1=../../data/group1/PE-350.1.fastq`	Pair-end file 1 (with quality scores)

`q2=../../data/group1/PE-350.2.fastq`	Pair-end file 2 (with quality scores)

#### Running SOAPdenovo
First edit the soap.config file to the correct data for your group:

`$ nano -w soap.config`

Change these two lines from group1 to your group:

```
q1=../../data/group1/PE-350.1.fastq
q2=../../data/group1/PE-350.2.fastq
```

Understand `soapk31.sbatch`, it is important to know SOAPdenovo has 4 steps: **pregraph, contig, map, and scaff** are ‘step 1’ and correspond to making a K-mer graph, then **contigging, map reads back, and scaffolding** are steps 2-4 respectively.  These steps can be run separately or all together as we are doing here.  See the command line options section of the manual for more information. 

At this point you don’t need to change the submit script, if you want to look at it:

`$ more soapk31.sbatch`

and to submit the soapdenovo assembly:

`$ sbatch soapk31.sbatch`

What printed on the screen? 
ans: `<jobid>.mgmt1`

The `soapk31.sbatch.o<jobid>` is very useful. Use the `more` command to find these information from the log file:
Paired end library insert size: `_____________`   

Standard deviation `______________`

contig stats: n50 `________`  

max length contig `_______` 

total `__________` 

Where are the results stored? 
FASTA file: `soap31.scafSeq`

Now SOAP is done. Save the results!

`$ cp soap31.scafSeq ../../results/soap31.fasta`

**Does the assembly get better if I use a different K-mer size?**

To run a different kmer e.g ‘21’, create a new soap directory and copy the submit and config files into it. Notice that we are changing the names of the files while copying them to reflect the new kmer we are testing:
~~~
$ cd ..
$ pwd (make sure you’re in the soap directory)
$ mkdir soap21
$ cp soap31/soapk31.sbatch soap21/soapk21.sbatch
$ cp soap31/soap.config soap21/.      (that dot at the end is necessary)
$ cd soap21
$ nano -w soapk21.sbatch 
~~~
Now modify `soapk21.sbatch` and change K from 31 to **21**, and submit your job:

`sbatch soapk21.sbatch`

Be sure to copy the result to your appropriate results folder.

`$ cp soap21.scafSeq ../../results/soap21.fasta`

Using what you’ve learned, do the **25** K-mer value. 

-->

### SPAdes


SPAdes (SPAdes – St. Petersburg genome Assembler) – is a **MODERN** assembly toolkit. It is one of the most 
powerful asssembly software because it has several built-in pipelines.
SPAdes works with Illumina or IonTorrent reads and is capable of providing hybrid assemblies using PacBio, Oxford Nanopore and Sanger reads. You can also provide additional contigs that will be used as long reads.
SPAdes supports paired-end reads, mate-pairs and unpaired reads. SPAdes can take as input several paired-end and mate-pair libraries simultaneously. Note, that SPAdes was initially designed for small genomes, but is used for many larger genomes when computation power is available.
In addition to genome asembly,  SPAdes 3.12.0 includes the following additional pipelines:

- metaSPAdes – a pipeline for metagenomic data sets (see metaSPAdes options).
- plasmidSPAdes – a pipeline for extracting and assembling plasmids from WGS data sets (see plasmidSPAdes options).
- rnaSPAdes – a de novo transcriptome assembler from RNA-Seq data (see rnaSPAdes manual).
- truSPAdes – a module for TruSeq barcode assembly (see truSPAdes manual). 

SPAdes also provides stand-alone programs with relatively simple command-line interfaces for: k-mer 
counting (`spades-kmercounter`), assembly graph construction (`spades-gbuilder`) and a 
long read to graph aligner (`spades-gmapper`). So let's begin:

`$ cd ../../spades/`

Learn how we run SPAdes by viewing `spadesk31.sbatch`
 
`$ nano -w spadesk31.sbatch`

Be sure to change the line:
`export GROUPNUMBER=1` 
to ***your*** group number. 

SPAdes has too many capabilities built-in to cover everything today, but be sure to read the [SPAdes manual](https://cab.spbu.ru/files/release3.12.0/manual.html)!

If you understand the script and have changed the group number, press ctrl-x, save the file and submit it to the queue with the `sbatch` command as follows.

`$ sbatch spadesk31.sbatch`
 
What was printed on the screen after you pressed enter? 

`Submitted batch job <jobidnumber>` 

When the job is complete, the log file, `spades.log` is found in the output directory named "K31" and is very useful. 
At the top it shows you the command you used. It then shows the software versions 
you loaded. This is very important for making your results reproducible. 
Spades will even give you recommendations if it thinks you could get 
better results using different settings.

To examine the output file:

`less spades.log`

Find these information from the log file (and remember press `q` to quit):

Paired end library insert size: `_____________`   

Standard deviation `______________`

K-mer maximum  `_________________`

To find contig stats you need to use `less` to look at the `contigs.paths` file

max contig length ("NODE_1" in `contigs.paths`) `_______`

**Does the assembly get better  if I use a different K-mer size?**

To try different kmers, first copy your `.pbs` script with a new name:
~~~
$ cp spadesk31.sbatch spadesk21.sbatch
$ nano -w velvetk21.sbatch
~~~
and change K to a different value, currently 31. Try 21 first, and then 25.
then submit this new job:

`$ sbatch velvetk21.sbatch`


Now **remember to copy your output files to the results folder:**
`$ cp spades31/contigs.fasta ../../results/spades31.fasta`

SPAdes doesn't output an N50 score but it outputs lots of other information. We will see the N50 of the SPAdes output later in this Workshop lesson.


<!--

STOPPED HERE
(All the outputs from SPAdes would require an extra lesson to show you, and we are working on that.)
















**Abyss no longer available when using Pete**
LOTS OF GOOD STUFF IS NOW GONE FROM THE LESSON
### ABYSS

`$ cd ../../abyss/abyss31`

We change to a subdirectory because abyss puts all its output into the **current working directory**.

Use `cat` to display the `abyssk31.sbatch` submission script to your terminal, and look 
through the file so that you understand the parts. ABYSS is simple to run as it has 
just one command to run
an entire pipeline of software. Because it runs several software packages, it 
takes a few minutes to complete. First edit the `abyssk31.sbatch` to change 
GROUPNUMBER to your group number.
~~~
$ nano -w abyssk31.sbatch
$ sbatch abyssk31.sbatch
~~~

#### K-mer coverage:

There is a file of interest here: `coverage.hist` as generated by ABYSS. This is 
the K-mer histogram. 

![K-mer histogram from slides]({{ site.baseurl }}/fig/kmer-hist.png)

From the slides (from Kelley et al., 2010) you should remember that when using 
K-mer based assembly methods, "good" K-mers should show a peak where coverage 
is the most accurate. K-mers at low coverage tend to be those with many errors, 
and so they are ignored (we're going to ignore them too!). The `coverage.hist` 
file is a two-column tab-delimited file where the first column equals
"coverage", and the 2nd column equals "Number of K-mers". 
You can plot this K-mer histogram with any software 
you want (Excel, R, etc.) but only the first 50 lines are very useful. 
To look at the first 50 lines, enter:

`$ head -n 50 coverage.hist`

The number of K-mers at every possible level of coverage are shown. 
Shrink the file by creating a new file that only includes these first 50 lines:

`$ head -50 coverage.hist > short.hist.txt`

Here is a new trick: You can use the shell to **E-mail** the `short.hist.txt` file to 
yourself then look at it in a spreadsheet. The command (below) includes entering 
your email address ***twice*** because you are both the recipient, and the sender.

`$ mail -a short.hist.txt -r youremail@wherever.com  youremail@wherever.com`

After entering the command, you will be prompted for a "Subject". Enter a short subject, 
hit the **<kbd>Enter</kbd>** key (there will be no prompt after 
hitting <kbd>Enter</Kbd>), and then use **`ctrl-d`** to send the message. 
After emailing the file to yourself, open your email and place the attached file 
on your Desktop. 

Open `short.hist.txt` using Excel or another spreadsheet program and create
a plot from these data. In Excel, you would highlight all 50 values in both 
columns and then select "Insert" then "Recommended Charts", and pick the top 
chart. In general, it should be similar to this plot for Group1.

![group1 kmer31 plot]({{ site.baseurl }}/fig/kmers-short-hist-graph.png)

Keep your spreadsheet software open while you return to the terminal window on Pete. 
To determine the final **assembled size** of the genome, use `grep` at the command 
line to extract that information from the output file:

~~~
$ grep ^Assembled abyssk31.sbatch.o<jobidnumber>
Assembled 563522 k-mer in 245 contigs.
~~~
(Remember this is for "Group 1" and your output may be different). Notice that 
we have a "caret" symbol **`^`** in front of our search pattern: "Assembled". 
The `^` is a special character that tells `grep` to only match the pattern 
*if it is at the beginning of a line*. 

To determine the ***highest*** K-mer coverage in the histogram use:

`$ grep median abyssk31.sbatch.o<jobidnumber>`

and put your answer in this box `___________`

Here's another trick: You can use this K-mer histogram to estimate the size of
the genome you sequenced using the following formula:

##### Genome_size = Total_Kmers / peak_Kmer_coverage

For more information about K-mers and coverage, there is **[this old post](https://groups.google.com/forum/#!topic/abyss-users/RdR6alqM7e8)**; or this [EXTRA Page]({{ site.baseurl }}/materials/extras/kmers-and-coverage-discussion)
that explain why we want to estimate genome sizes. Briefly,
K-mers represent a copy of all your sequencing data, broken into small fragments of an exact size.
Abyss is able to **estimate** your coverage of the genome based on the number of "good" K-mers.

> This is useful because: 
> 1. Assemblers can be confused by repeated sequences and end up very inaccurate. This gives you a second opinion.
> 2. You might not know anything about your genome size!
> 
> Imagine you had 30-billion base pairs of sequencing data, and you ***knew*** your coverage 
> was "10-fold", you could then estimate the size of your genome being sequenced 
> was 3-billion base-pairs long (30,000,000,000 ÷ 10 = 3,000,000,000)
  
To calculate "Total_Kmers", create a third column in your spreadsheet that multiplies 
column 1 (position of K-mers) and column 2 (number of K-mers), and then sum 
all the numbers of the 3rd column. This is 
(approximately) the **total number** of all your "good" K-mers.

The formula estimates the genome size based on K-mer histogram: to be `________` bp.

The log file `abyssk31.sbatch.o<jobid>` is very useful. Use the `less` command and search 
through `abyssk31.sbatch.o<jobid>` for "N50" to locate these information:

**contig** stats: n50 `________` 

max `_______`

total `__________` (compare to the estimate based on K-mer)

**scaffold** stats: n50 `________`  

max `_______` 

total `__________` 

The results are always stored in the **current working directory** when using Abyss.
When the output from Abyss is complete, save the results and rename the scaffold output 
fasta file as we did for the other assemblers.

`$ cp abyss31-scaffolds.fa ../../results/abyss31.fasta`

**Does the assembly get better if I use a different K-mer size?**

Luckily assemblers run fast. We will now run two different additional K-mer 
options using Abyss. Remember that the current value (K=31) may not be the 
best! Try 21, and 25, for most assemblers. Most assemblers only use K-mer 
sizes that are odd numbers, so 24 won’t work. 

Remember that Abyss outputs to the current working directory, so when 
changing K-mer number in Abyss, you should first create a new directory 
to work within.

Start by going up into the `abyss` directory using `$ cd ..` and then 
create new directories for each K-mer you will use. Then copy and simultaneously 
rename the `abyssk31.sbatch` submission script. To use a K-mer of 21 do this:

~~~
$ pwd  
/scratch/<username>/mcbios/abyss
$ mkdir abyss21
$ cp abyss31/abyssk31.sbatch abyss21/abyssk21.sbatch
$ cd abyss21
$ nano -w abyssk21.sbatch
~~~
Use `nano` to change K from 31 to **21**. Then save the file and submit.
~~~
$ sbatch abyssk21.sbatch
~~~
Then, go the the same process to use a K-mer value of **25**.
~~~
$ cd ..
$ pwd  
/scratch/<username>/mcbios/abyss
$ mkdir abyss25
$ cp abyss31/abyssk31.sbatch abyss25/abyssk25.sbatch
$ cd abyss25
$ nano -w abyssk25.sbatch
~~~ 
Remember to change the K-mer value to **25**. Save the file and submit.
~~~
$ sbatch abyssk25.sbatch
~~~
When the jobs are done, your output files will automatically have the new K-mer in their names! 
Copy the results to your results folder.
~~~
$ cd ..
$ pwd  
/scratch/<username>/mcbios/abyss
$ cp abyss21/abyss21-scaffolds.fa ../results/abyss21.fasta
$ cp abyss25/abyss25-scaffolds.fa ../results/abyss25.fasta
~~~
-->




**Congratulations!** This lesson has shown you how you can assemble genomes using 
different software, and using different parameters (K-mers, in this lesson). 
Now we should check our assemblies in a process called "validation" 
before sending the best assembly to our collaborators! We will learn how to compare the 
overall assembly of all our assemblers in our [NEXT LESSON]({{ site.baseurl }}/materials/genomics-assembly-reporting)
