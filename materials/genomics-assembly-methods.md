---
layout: page
element: notes
title: Assembly Tools
language: Shell
---

### Assembly

Learn: Not all assemblers are the same or give the same results.
**Which assembler should I use?**
It is in general a good idea to run several assemblers and compare. We are using VELVET, SOAPdenovo and ABYSS in this study. All of these assemblers are de-bruijn (K-mer) graph based assemblers.

VELVET
`$ cd ../../velvet/`

Understand `velvetk31.pbs` - We will use the text-file editor “nano” to examine our script file, that submits our data to the assemblers. 
$ nano -w velvetk31.pbs
Using nano:  To exit press Ctrl-x (hold down the ctrl key and press x.)  If you have made changes, it will ask if you want to save the changes you made.  Press 'y' to for yes to save. Then just press 'Enter' to accept the filename velvetk31.pbs. 

Be sure to change the line:
export GROUPNUMBER=1
to your group number.  You will need to do this for all the submission scripts today.

The first section of our velvetk31.pbs script sets up the scheduler requests (the queueing system) and environment variables. The  assembler commands are velveth and velvetg. What do these commands do?  See the velvet website here.  

If you understand the script and have changed the groupnumber, press ctrl-x, save the file and submit it to the queue with the ‘qsub’ command as follows.

$ qsub velvetk31.pbs 
What was printed on the screen after you pressed enter? 
<jobidnumber>.mgmt1 

The log file, `velvetk31.pbs.o<jobidnumbmer>` is very useful. 

Options to examine that file:
$ tail velvetk31.pbs.o<jobidnumber>  (HINT: Try using TAB-completion to enter your commands!)
OR
$ less velvetk31.pbs.o<jobidnumber> 
(q to quit)

Find these information from the log file:
Paired end library insert size: _____________   Standard deviation ______________
contig stats: n50 ________  max _______ total __________ reads used ____________ (did it use all the reads?)

Where are the contigs stored? Save the results!
$ cp velvet31/contigs.fa ../results/velvet31.fasta

Does the assembly get better  if I use a different K-mer size? (you can try this later)
To try different kmers, first copy your pbs script:
$ cp velvetk31.pbs velvetk21.pbs
$ nano -w velvetk21.pbs

and change K to a different value, currently 31. Try 21, 25.
then submit this new job:
$ qsub velvetk21.pbs

To see kmer coverage differences in a histogram format, we can use the following Perl script on the velvet stats file in each of your results folders: 

$ module load velvet
$ velvet-estimate-exp_cov.pl velvet31/stats.txt
    10 |      1 | **********
<snip>
Predicted expected coverage: 18
velvetg parameters: -exp_cov 18 -cov_cutoff 0

CONGRATULATIONS on your first assembly!


SOAPdenovo2  (website)
Now we will compare our data using the SOAPdenovo assembler. 

First change to the soap31 subdirectory

$ cd ../soap/soap31
$ ls 
soap.config  soapk31.pbs

SOAPdenovo is different as it uses a configuration file “soap.config”, where we tell SOAP what our data are. We include detailed info below so we can move ahead with the computation step.







[LIB]	Calls the soap denovo command library into action
avg_ins=350	This value indicates the average insert size of this library or the peak value position in the insert size distribution figure.
reverse_seq=0	This option takes value 0 or 1. It tells the assembler if the read sequences need to be complementarily reversed. Illumima GA produces two types of paired-end libraries: a) forward-reverse, generated from fragmented DNA ends with typical insert size less than 500 bp; b) reverse-forward, generated from circularizing libraries with typical insert size greater than 2 Kb. The parameter "reverse_seq" should be set to indicate this: 0, forward-reverse; 1, reverse-forward.
asm_flags=3	This indicator decides in which part(s) the reads are used. It takes value 1(only contig assembly), 2 (only scaffold assembly), 3(both contig and scaffold assembly), or 4 (only gap closure).
rank=1	It takes integer values and decides in which order the reads are used for scaffold assembly. Libraries with the same "rank" are used at the same time during scaffold assembly. 
5.3 How to set library rank?
SOAPdenovo will use the pair-end libraries with insert size from smaller to larger to construct scaffolds. Libraries with the same rank would be used at the same time. For example, in a dataset of a human genome, we set five ranks for five libraries with insert size 200-bp, 500-bp, 2-Kb, 5-Kb and 10-Kb, separately. It is desired that the pairs in each rank provide adequate physical coverage of the genome.
q1=../../data/group1/PE-350.1.fastq	Pair-end file 1 (with quality scores)
q2=../../data/group1/PE-350.2.fastq	Pair-end file 2 (with quality scores)

First edit the soap.config file to the correct data for your group:

$ nano -w soap.config
Change these two lines from group1 to your group:
q1=../../data/group1/PE-350.1.fastq
q2=../../data/group1/PE-350.2.fastq

Understand `soapk31.pbs`, it is important to know SOAPdenovo has 4 steps: pregraph, contig, map, and scaff are ‘step 1’ and correspond to making K-mer graph, then contigging, map reads back, and scaffolding are steps 2-4 respectively.  These steps can be run separately or all together as we are doing here.  See the command line options section of the manual for more information. 

At this point you don’t need to change the submit script, if you want to look at it:
$ more soapk31.pbs

and to submit the soapdenovo assembly:
$ qsub soapk31.pbs

What printed on the screen? 
ans: <jobid>.mgmt1

The ‘soapk31.pbs.o<jobid>’ is very useful. Use the ‘more’ command to find these information from the log file:
Paired end library insert size: _____________   Standard deviation ______________
contig stats: n50 ________  max length contig _______ total __________ 

Where are the results stored?
FASTA file: soap31.scafSeq

Now SOAP is done. Save the results!
$ cp soap31.scafSeq ../../results/soap31.fasta

Does the assembly get better  if I use a different K-mer size?
To run a different kmer e.g ‘21’, create a new soap directory and copy the submit and config files into it. Notice that we are changing the names of the files while copying them to reflect the new kmer we are testing:
$ cd ..
$ pwd (make sure you’re in the soap directory)
$ mkdir soap21
$ cp soap31/soapk31.pbs soap21/soapk21.pbs
$ cp soap31/soap.config soap21/.      (that dot at the end is necessary)
$ cd soap21
$ nano -w soapk21.pbs 
Now modify `soapk21.pbs` and change K  from 31 to a different value. Try 21,  then 25.  After submitting your job:

qsub soapk21.pbs

Be sure to copy the result to your appropriate results folder.
$ cp soap21.scafSeq ../../results/soap21.fasta

Using what you’ve learned, do the 25 kmer value. 


ABYSS
$ cd ../../abyss/abyss31


We change to a subdirectory because abyss puts all it’s output into the current working directory.

Understand `abyssk31.pbs`. ABYSS is simple as it has just one command to run the entire pipeline. First edit the abyssk31.pbs to change GROUPNUMBER to your group number.

$ nano -w abyssk31.pbs
$ qsub abyssk31.pbs

K-mer coverage
There is one file of interest here: `coverage.hist` as generated by ABYSS. This is the K-mer histogram. It is a two-column file with 1st column (coverage), 2nd column (# of K-mers). Plot this K-mer histogram however you want (EXCEL, R, etc.). Only the first 50 lines are very useful, so we will help you shrink the file to include just the first 50 lines:
To look at the first 50 lines, enter:
$ head -n 50 coverage.hist
To create a new file that only includes these first 50 lines. :
$ head -50 coverage.hist >short.hist

EMAIL the ‘short.hist’ file to yourself to look at it in a spreadsheet.
$ mail -a short.hist -r youremail@wherever.com  youremail@wherever.com

(enter subject, enter, ctrl-d to send)

To determine the final assembled size of the genome, use grep at the command line to extract that information from the output file:

$ grep ^Assembled abyssk31.pbs.o<jobidnumber>
Assembled 563522 k-mer in 245 contigs.

for more information: https://groups.google.com/forum/#!topic/abyss-users/RdR6alqM7e8

To determine the highest K-mer coverage in the histogram use:
$ grep median abyssk31.pbs.o<jobidnumber>

and put your answer in this box ___________

You can estimate genome size just based on this K-mer histogram (why do you want to do that?)
Genome_size = Total_Kmers / peak_Kmer_coverage

(hint: To calculate Total_Kmers, Create a third column by multiplying column 1 and column2, and then sum the numbers of the 3rd column)

Use the formula to estimate the genome size base on K-mer histogram: ______________ bp

The `abyssk31.pbs.o<jobid>` is very useful. Find these information from the log file:
contig stats: n50 ________  max _______ total __________ (compare to the estimate based on K-mer)
scaffold stats: n50 ________  max _______ total __________ 

Where are the results stored?

Now ABYSS is done. Save the results and rename it!
$ cp abyss31-scaffolds.fa ../../results/abyss31.fasta

Does the assembly get better  if I use a different K-mer size? 

Changing the K-mer option for assemblies.  Luckily assemblers run fast, run two different additional K-mer options using Abyss. Why? Because the current value K=31 may not be the best! Try 21, and 25 for most assemblers, they need odd numbers, so 24 won’t work.  

First create a new directory:
$ cd ..
(you should be in the ‘abyss directory now, to check use “print working directory”)
$ pwd  
/scratch/username/mcbios/abyss
$ mkdir abyss21
$ cp abyss31/abyssk31.pbs abyss21/abyssk21.pbs
$ cd abyss21
$ nano -w abyssk21.pbs
 change K to a different value, currently 31. Try 21, 25 and submit:
$ qsub abyssk21.pbs

Whan it’s done, your output files will automatically have the new K-mer in their names. Copy the result to your results folder
$ cp abyss21-scaffolds.fa ../../results/abyss21.fasta

