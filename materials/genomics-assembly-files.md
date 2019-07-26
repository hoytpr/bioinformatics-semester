---
layout: page
element: notes
title: Read Processing
language: Shell
---
### A Genome Assembly Workshop 
This part of the course uses a traditional workshop pedagody with "slides" for readings, and 
"hands-on" exercises that are also lectures (learning while practicing). They are designed to be self-paced. 

### Hands-on Genome Assembly Read Processing

Goal: get familiar with genome assemblers, pre-processing, reporting and validation. 
Exercise will be based on chromosomes of a mutant genotype of bakers’ yeast, as practice 
of *de-novo* genome assembly. Here we have the benefits of a reference genome to validate 
our assembly. We must be sure to [acknowledge]({{ site.baseurl }}/materials/acknowledgments) 
those who helped design these lessons.

### Data and directory structure
This exercise will likely use the local University supercomputing resources. 
(AKA: The HPCC) Normally, we would not be able to perform these assemblies
"interactively" i.e by entering commands at the command prompt. 
Instead we would enter commands by submitting our commands as a "job" in the 
computers "queue". Most of the commands we enter will be identical
to the commands you would place inside your "job submission script"
which we'll discuss later, but there's plenty of information 
on the HPCC site [for new users](https://hpcc.okstate.edu/content/new-user-tutorial)

Depending on which system is available, everyone should [have an account](http://hpcc.okstate.edu/requesting-hpcc-account) 
on the "Cowboy" supercomputer
by now. If you do not, ask for a temporary account before 
proceeding with this lesson. 

Log into the Cowboy Supercomputer:
[Instructions here](https://hpcc.okstate.edu/content/logging-cowboy)

Then open your FTP software, and connect to your account on Cowboy.
You should have been given the file `mcbios.tar.gz`, for you to 
place on your desktop. Alternatively, download the file 
[mcbios.zip]({{ site.baseurl }}/data/mcbios.zip) to your local machine 
and unzip it. Then using FTP, transfer the file `mcbios.tar.gz`  
(or `mcbios.zip`) into your `/scratch/username` directory on Cowboy.
NOTE that you should substitute `username` with your actual 
username for the computer. For example, my username is `phoyt`
and the mcbios.zip file will be uploaded to `/scratch/phoyt`.

Then from your terminal program (Windows users will
use "Putty") type in the following commands:
~~~
$ cd /scratch/username
$ cp /scratch/bioworkshop/mcbios.tar.gz .
$ tar xvf mcbios.tar.gz
$ cd mcbios/
$ ls
~~~
The output should be:

~~~
abyss data  results soap velvet 
~~~

### File Structure 

What you should now have:
~~~
|-- abyss
|   `-- abyss31
|       `-- abyssk31.pbs
|-- data
|   |-- group1
|   |   |-- PE-350.1.fastq
|   |   |-- PE-350.2.fastq
|   |   `-- ref.fasta
|   |-- group2
|   |   |-- PE-350.1.fastq
|   |   |-- PE-350.2.fastq
|   |   `-- ref.fasta
|   |-- group3
|   |   |-- PE-350.1.fastq
|   |   |-- PE-350.2.fastq
|   |   `-- ref.fasta
|   |-- group4
|   |   |-- PE-350.1.fastq
|   |   |-- PE-350.2.fastq
|   |   `-- ref.fasta
|   `-- group5
|       |-- PE-350.1.fastq
|       |-- PE-350.2.fastq
|       `-- ref.fasta
|-- results
|   `-- quast.pbs
|-- soap
|   `-- soap31
|       |-- soap.config
|       `-- soapk31.pbs
`-- velvet
    `-- velvetk31.pbs
~~~

We will dive into each directory for each task:  fastqc, velvet, soap, abyss and nucmer in that order. Most folders contain a submission script which includes the commands that we use for each task. It is always a good idea to use a script so you can modify parameters, and the script also serves as  a note to yourself later.

### Important notes before hands-on
Since we are using the Cowboy cluster, only very small tasks can be done directly on the login nodes.  For each longer activity, we will submit the jobs to the scheduler using “pbs scripts”.  These `.pbs` files are text files that include information for the job scheduler as well as the commands to execute your job.

#### The data:
Move into your `data` directory:

`$ cd /scratch/username/mcbios/data/`  
OR 

`$ cd data`

Use `ls` to see what files or directories are present:
~~~
$ ls
group1  group2  group3  group4  group5
~~~
There are five group directories, so that different groups of students
can work on a different chromosome in yeast. You can then compare your results. 
As an example, everyone should look inside the `group1` directory:

~~~
$ cd group1
$ ls
ref.fasta  PE-350.1.fastq  PE-350.2.fastq
$ head PE-350.1.fastq
~~~

By now, you should all be familiar with `.fastq` sequencer files.
Our assembly will start using one Illumina library, PE-350, which is a paired end reads library, divided into two datasets: `1.fastq` and `2.fastq`,  which are the paired reads very close to 350 bp apart. Every read in the `1.fastq` file should have a corresponding read in the `2.fastq` file. Also, `ref.fasta` is the included reference sequence for comparison with your assembly.

#### Review FASTQ format
>Learn: What information is included? What does each line mean?
>Four consecutive lines define ONE read in the fastq file
>
>~~~
>@READ-ID
>ATAGAGATAGAGAGAG (the sequence: here showing 16 nucleotides)
>+READ-ID (usually empty. Can repeat READ-ID)
>;9;7;;.7;3933334 (**quality** identifiersfor each of the 16 bases shown)
>~~~
>
>Each base has quality identifier called PHRED score, typically between value 0-40 for Illumina.  The FASTQ file converts the numeric value to a character because they use less space (fewer bits). There are also two systems of such conversion, PHRED+33 and PHRED+64. PHRED+33 is used in new Illumina protocols. PHRED+64 is used rarely, but be aware!
> 
>“Phred quality scores   are defined as a property which is logarithmically related to the base-calling error probabilities  .”
> 
>-Wikipedia.

Or you can just use this chart: 

| Quality Score	| Probability of incorrect base call | Base call accuracy |
| ---- | ------------- | -----------|
| 10 | 1 in 10 |90% |
| 20 | 1 in 100 | 99% |
| 30 | 1 in 1000 | 99.9% |
| 40 | 1 in 10000 | 99.99% |
| 50 | 1 in 100000 | 99.999% |

Almost all modern sequence data uses the PHRED+33 (version 1.8 or newer) base call system. 

If a base call has PHRED quality of 20 (i.e. 1% error), PHRED(20)+33=**53**, 
which corresponds to the character 5 using the reference chart below 
(the "S" range). There is an older PHRED+64 system 
(older than version 1.8, the "I" range) that is rarely used anymore, 
but in PHRED+64 20+64=84, which is T. 

Using the table below you can usually determine if sequence quality scores 
are using PHRED+33, or PHRED+64 encoding. (hint: PHRED+33 max score is "J")

![PredScores]({{ site.baseurl }}/fig/PhredScores.png)

Go back to our FASTQ files,  find out answers to these questions
and submit them to [Canvas](https://canvas.okstate.edu/courses/51969/quizzes/108839)

The base quality in my data is encoded in `________` (Phred+33 or Phred+64 ?).

Library PE-350 contains a total of `______` reads. 

(big hint: count # of lines using the terminal shell by typing:    
  `wc -l PE-350.1.fastq`    
and divide by 4 or make the command line do all the arithmetic): 

`$ expr (cat PE-350.1.fastq | wc -l) / 4`

### How good is your sequencing run? Use FASTQC

Fastqc runs very quickly, so we can enter these commands interactively 
without submitting them as a "job".

If you want help with fastqc, you can type:
`$ fastqc -h`

Now perform the fastqc quality control 
```
$ module load fastqc
$ fastqc PE-350.1.fastq
```

(**protip**: do this again to the PE-350.2.fastq file by using the up arrow
to bring up the last command, then use arrow keys to move over to change 
1 to a 2 and press enter.)

fastqc puts the results in the same folder as the data (in this case `data/group1/`)

Instructions to download your fastqc results are at this link.

FASTQC generates a HTML report for each FASTQ file you run.  Use the WINSCP program to find the folder in `/scratch/username/mcbios/data/group1` (if you are in a different group, use that group's number) which holds the results of your analysis.  Use WinSCP transfer the PE-350.1_fastqc folder to your desktop and double-click on  file fastqc_report.html (on your desktop) to open it in a browser. For more information and to see examples of what bad data look like, read the FASTQC manual when you have time. 

#### Exercise

Report on Library PE-350 fastQC stats: 
Read count `_____`, Read length `_____` 
Duplication level `_____`, Adapters? `_____` (hint: look for“over-represented sequences” in report)
Answer the same questions for PE-350.2.fastq


