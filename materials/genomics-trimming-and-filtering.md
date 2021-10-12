---
layout: page
element: notes
title: Genomics Trimming and Filtering
language: Shell
---

### To Learn: 
How can I get rid of sequence data that doesn't meet my quality standards?

### Objectives:
- Clean FASTQ reads using Trimmomatic.
- Select and set multiple options for command-line bioinformatics tools.
- Write `for` loops with two variables.


## Cleaning Reads

In the previous episode, we took a high-level look at the quality
of each of our samples using FastQC. We visualized per-base quality
graphs showing the distribution of read quality at each base across
all reads in a sample and extracted information about which samples
fail which quality checks. Some of our samples failed quite a few quality metrics used by FastQC. This doesn't mean,
though, that our samples should be thrown out! It's very common to have some quality metrics fail, and this may or may not be a problem for your downstream application. For our variant calling workflow, we will be removing some of the low quality sequences to reduce our false positive rate due to sequencing error.

We will use a program called
[Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic) to
filter poor quality reads and trim poor quality bases from our samples.

## Trimmomatic Options

Trimmomatic has a variety of options to trim your reads. If we run the command without flags or arguments, we can see some of our options. But we have to load the java module first.



~~~
module load jre/1.8.0_221
$ java -jar /opt/trimmomatic/0.38/prebuilt/trimmomatic-0.38.jar
~~~

Which will give you the following output:
~~~
Usage: 
       PE [-version] [-threads <threads>] [-phred33|-phred64] [-trimlog <trimLogFile>] [-summary <statsSummaryFile>] [-quiet] [-validatePairs] [-basein <inputBase> | <inputFile1> <inputFile2>] [-baseout <outputBase> | <outputFile1P> <outputFile1U> <outputFile2P> <outputFile2U>] <trimmer1>...
   or: 
       SE [-version] [-threads <threads>] [-phred33|-phred64] [-trimlog <trimLogFile>] [-summary <statsSummaryFile>] [-quiet] <inputFile> <outputFile> <trimmer1>...
   or: 
       -version
~~~

> #### What's that `java -jar` about?
> Software can be written so that it runs using Java. When it is written for Java, it has a `.jar` suffix. 
> To run (or "call") a software written for Java, you have to first type in `java -jar`. This is similar 
> to running a Bash script by first typing in "bash" (e.g. `$ bash run-nelle.sh`). The rest of the command is 
> the exact path to the program `trimmomatic`, version 0.38. The actual program name is `trimmomatic-0.38.jar`. 
> **We aren't going to cover Java programs** but it's not a bad idea to expose you to this command, because lots of 
> software is written for Java. Also, if you don't know already, programs for Java (".jar" files) are not (usually) 
> written in the programming language Javascript. If that seems confusing, you are not alone. 


### Interpreting Usage Instructions

Usage instructions are sometimes hard to read (the lines can wrap around), so careful
inspection is needed to be sure your commands work. When first using software, you should take time to look at all
the usage options. Sometimes it helps to break them down on separate lines where you can assign them
the values you want, before combining them into a single line command. 
Here's an example: For the command `trimmomatic` the next arguments are:

~~~
PE 
[-version] 
[-threads <threads>] 
[-phred33|-phred64] 
[-trimlog <trimLogFile>] 
[-summary <statsSummaryFile>] 
[-quiet] 
[-validatePairs] 
[-basein <inputBase> | <inputFile1> <inputFile2>] 
[-baseout <outputBase> | <outputFile1P> <outputFile1U> <outputFile2P> <outputFile2U>] 
<trimmer1>
...
~~~
 For single-end read files:
~~~
 SE 
 [-version] 
 [-threads <threads>] 
 [-phred33|-phred64] 
 [-trimlog <trimLogFile>] 
 [-summary <statsSummaryFile>] 
 [-quiet] 
 <inputFile> 
 <outputFile> 
 <trimmer1>
 ...
~~~

This output shows us that we must first specify whether we have paired end (`PE`) or single end (`SE`) reads.
After this you can specify a specific version of the Trimmomatic software to use (e.g. `-version 0.36`).
Next, we specify what flag(s) we would like to run. For example, you can specify `threads` to indicate the number
processors on your computer that you want Trimmomatic to use. Flags like `-version` and `-threads` 
are not always necessary, but they can give
you more control over the command. These flags are followed by **positional arguments**, meaning the order in which you 
specify them is important. In **paired end mode**, Trimmomatic expects the two input files, and then the names of the
output files. These files are described below.

| option    | meaning |
| ------- | ---------- |
|  \<inputFile1>  | Input reads to be trimmed. Typically the file name will contain `_1` or `_R1` in the name.|
|  \<inputFile2> | Input reads to be trimmed. Typically the file name will contain `_2` or `_R2` in the name.|
|  \<outputFile1P> | Output file that contains surviving pairs from the `_1` file. |
|  \<outputFile1U> | Output file that contains orphaned reads from the `_1` file. |
|  \<outputFile2P> | Output file that contains surviving pairs from the `_2` file.|
|  \<outputFile2U> | Output file that contains orphaned reads from the `_2` file.|

The last things Trimmomatic expects are the steps of the trimming parameters:

| step   | meaning |
| ------- | ---------- |
| `ILLUMINACLIP` | Perform adapter removal |
| `SLIDINGWINDOW` | Perform sliding window trimming, cutting once the average quality within the window falls below a threshold. |
| `LEADING`  | Cut bases off the start of a read, if below a threshold quality.  |
| `TRAILING` |  Cut bases off the end of a read, if below a threshold quality. |
| `CROP`  |  Cut the read to a specified length from the end. |
| `HEADCROP` |  Cut the specified number of bases from the start of the read. |
| `MINLEN`  |  Drop an entire read if it is below a specified length. |
| `TOPHRED33` | Convert quality scores to Phred-33.  |
| `TOPHRED64` |  Convert quality scores to Phred-64.  |

We will use only a few of these options and trimming steps in our
analysis. ***It is important to understand the steps you are using to
clean your data***. For more information about the Trimmomatic arguments
and options, see [the Trimmomatic manual](http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf).

However, a complete command for Trimmomatic will look something like the command below. **This command is an *example*
and will not work** because we do not have the files it refers to:

~~~
$ java -jar /opt/trimmomatic/0.38/prebuilt/trimmomatic-0.38.jar PE -threads 4 SRR_1056_1.fastq SRR_1056_2.fastq  \
              SRR_1056_1.trimmed.fastq SRR_1056_1un.trimmed.fastq \
              SRR_1056_2.trimmed.fastq SRR_1056_2un.trimmed.fastq \
              ILLUMINACLIP:NexteraPE-PE.fa SLIDINGWINDOW:4:20
~~~

In this example, we've told Trimmomatic:

| code   | meaning |
| ------- | ---------- |
| `PE` | that it will be taking a paired end file as input |
| `-threads 4` | to use four computing threads to run (we can use 32  to speed up our run) |
| `SRR_1056_1.fastq` | the first input file name |
| `SRR_1056_2.fastq` | the second input file name |
| `SRR_1056_1.trimmed.fastq` | the output file for surviving pairs from the `_1` file |
| `SRR_1056_1un.trimmed.fastq` | the output file for orphaned reads from the `_1` file |
| `SRR_1056_2.trimmed.fastq` | the output file for surviving pairs from the `_2` file |
| `SRR_1056_2un.trimmed.fastq` | the output file for orphaned reads from the `_2` file |
| `ILLUMINACLIP:NexteraPE-PE.fa`| to clip the Illumina adapters from the input file using the adapter sequences listed in `NexteraPE-PE.fa` |
|`SLIDINGWINDOW:4:20` | to use a sliding window of size 4bp that will remove bases if their average **phred** score is below 20 |

#### Orphaned vs. Survivor Reads

Remember that in paired-end sequencing, each read in the `_R1` file, must have a corresponding read in 
the `_R2` file. When Trimmomatic trims reads, it will remove (bad) reads as directed, which can 
leave a read in one file without a corresponding read in the other file. When this happens, the *good* read 
that lost it's (bad) corresponding read, will be moved to the orphaned or "un-trimmed" fastq file, with the 
same name prefix. These orphaned reads can sometimes be used as "single-end" reads. 

## Running Trimmomatic

It is time to run Trimmomatic on some of our data! To begin, navigate to your `untrimmed_fastq` data directory:

~~~
$ cd ~/dc_workshop/data/untrimmed_fastq
~~~

We are going to run Trimmomatic on one of our paired-end samples. 
We saw using FastQC that Nextera adapters were present in our samples. 
These adapter sequences usually come with the installation of trimmomatic, in a file
named `NexteraPE-PE.fa`. To be sure we have it we will first copy this file into our current directory.
Try this download link first:
`wget https://raw.githubusercontent.com/hoytpr/bioinformatics-semester/gh-pages/materials/NexteraPE-PE.fa`

If that doesn't work 
we can also pull the "trimming" file from The Data Carpentry site into the 
`untrimmed_fastq` folder:

`curl -O https://raw.githubusercontent.com/datacarpentry/wrangling-genomics/gh-pages/files/NexteraPE-PE.fa`


<!--
If you were using the dc-genomics AWS cloud you could use:

~~~
$ cp ~/.miniconda3/pkgs/trimmomatic-0.38-0/share/trimmomatic-0.38-0/adapters/NexteraPE-PE.fa .
~~~

-->

Take a quick look at the Nextera trimming file:

~~~
$ cat NexteraPE-PE.fa
>PrefixNX/1
AGATGTGTATAAGAGACAG
>PrefixNX/2
AGATGTGTATAAGAGACAG
>Trans1
TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG
>Trans1_rc
CTGTCTCTTATACACATCTGACGCTGCCGACGA
>Trans2
GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG
>Trans2_rc
CTGTCTCTTATACACATCTCCGAGCCCACGAGAC
~~~
This is a `.fasta` file that contains the known sequences of adapters used when creating Nextera™
libraries. They are usually trimmed off but in some cases, they might
be accidently missed, or left for an external software like `trimmomatic` to remove as
part of a ***pipeline***. 

We will also use a sliding window of size 4bp that will remove bases if their
average phred score is below 20. We will also
discard any reads that do not have at least 25 bases remaining after
all our trimming steps. If using the Pete computer, use the submission script shown below, or 
make sure you are using a "captured" node to work interactively. This command will take a few minutes to run.

The PBS script looks like this. Open `nano` and copy-paste this into `nano` or type it in:

~~~
#!/bin/bash
#SBATCH -p express
#SBATCH -t 1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mail-user=<your.email.address@univ.edu>
#SBATCH --mail-type=end
module load trimmomatic
module load jre/1.8.0_221
java -jar /opt/trimmomatic/0.38/prebuilt/trimmomatic-0.38.jar PE -threads 2 SRR2589044_1.fastq.gz SRR2589044_2.fastq.gz \
            SRR2589044_1.trim.fastq.gz SRR2589044_1un.trim.fastq.gz \
            SRR2589044_2.trim.fastq.gz SRR2589044_2un.trim.fastq.gz \
            SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15 
~~~

Notice that the command for trimmomatic is one long line. Save this submission script as `trim1.sbatch`, 
and submit it to Pete using
`sbatch trim1.sbatch`. 

<!--

If we were not using submission scripts, we would input the command directly and the **interactive** (one long line) command would look like this:
~~~
$ java -jar /opt/trimmomatic/0.38/prebuilt/trimmomatic-0.38.jar PE -threads 2 SRR2589044_1.fastq.gz SRR2589044_2.fastq.gz \
            SRR2589044_1.trim.fastq.gz SRR2589044_1un.trim.fastq.gz \
            SRR2589044_2.trim.fastq.gz SRR2589044_2un.trim.fastq.gz \
            SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15 
~~~
The interactive output would look like this:

~~~
TrimmomaticPE: Started with arguments:
 SRR2589044_1.fastq.gz SRR2589044_2.fastq.gz SRR2589044_1.trim.fastq.gz SRR2589044_1un.trim.fastq.gz SRR2589044_2.trim.fastq.gz SRR2589044_2un.trim.fastq.gz SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15
Multiple cores found: Using 2 threads
Using PrefixPair: 'AGATGTGTATAAGAGACAG' and 'AGATGTGTATAAGAGACAG'
Using Long Clipping Sequence: 'GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG'
Using Long Clipping Sequence: 'TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG'
Using Long Clipping Sequence: 'CTGTCTCTTATACACATCTCCGAGCCCACGAGAC'
Using Long Clipping Sequence: 'CTGTCTCTTATACACATCTGACGCTGCCGACGA'
ILLUMINACLIP: Using 1 prefix pairs, 4 forward/reverse sequences, 0 forward only sequences, 0 reverse only sequences
Quality encoding detected as phred33
Input Read Pairs: 1107090 Both Surviving: 885220 (79.96%) Forward Only Surviving: 216472 (19.55%) Reverse Only Surviving: 2850 (0.26%) Dropped: 2548 (0.23%)
TrimmomaticPE: Completed successfully
~~~

-->

#### Checking your Trimmomatic outputs

You can see in the output above that Trimmomatic automatically detected the
quality encoding of our sample is `phred33`. It is always a good idea to
double-check this or to enter the quality encoding manually.

Also notice that `trimmomatic` is telling us that we input 1,107,090 paired-end reads! Of those reads, 
**both** paired end reads survived our trimming 79.96% of the time, leaving us with 885,220 cleaned paired-end reads!
The output also tells us that 216,472 and 2,850 reads survived as "orphaned" reads. Finally, we see that 2,548 
paired-end reads (0.23%) were completly dropped. 

> Why are the surviving reads labelled as "Forward Only" and "Reverse Only"?
> 
> If we have time we can discuss more about ["Strand-specific" sequencing](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3664467/) library preparations.

We can confirm that we have our output files:

~~~
$ ls SRR2589044*

SRR2589044_1.fastq.gz       SRR2589044_1un.trim.fastq.gz  
SRR2589044_2.trim.fastq.gz  SRR2589044_1.trim.fastq.gz  
SRR2589044_2.fastq.gz       SRR2589044_2un.trim.fastq.gz
~~~
Looks like we've just successfully run Trimmomatic on one sample of our FASTQ files!
Let's check some things to be sure everything worked!

Notice the `trim1.sbatch.o<job_number>` file. It should have the same or similar output as shown 
for the interactive output above.
The output files are also `fastq.gz` (g-zipped) files. But `SRR2589044_1.trim.fastq.gz`
should be smaller than `SRR2589044_1.fastq.gz` because we've removed reads. We can confirm this:

~~~
$ ls SRR2589044* -l -h

-rw-rw-r-- 1 dcuser dcuser 124M Jul  6 20:22 SRR2589044_1.fastq.gz
-rw-rw-r-- 1 dcuser dcuser  94M Jul  6 22:33 SRR2589044_1.trim.fastq.gz
-rw-rw-r-- 1 dcuser dcuser  18M Jul  6 22:33 SRR2589044_1un.trim.fastq.gz
-rw-rw-r-- 1 dcuser dcuser 128M Jul  6 20:24 SRR2589044_2.fastq.gz
-rw-rw-r-- 1 dcuser dcuser  91M Jul  6 22:33 SRR2589044_2.trim.fastq.gz
-rw-rw-r-- 1 dcuser dcuser 271K Jul  6 22:33 SRR2589044_2un.trim.fastq.gz
~~~

The other thing to check (before you decide to trim ***hundreds*** of files) is that the output files
of surviving paired-end reads, are exactly the same number of lines. Remember
for each read in the `Read_1` file, there should be a corresponding read in
the `Read_2` file. To check this we will unzip the `SRR2589044` files, and use `wc -l`
to count the number of lines.

~~~
$ gunzip SRR2589044_1.trim.fastq.gz
$ gunzip SRR2589044_2.trim.fastq.gz
$ wc -l SRR2589044_1.trim.fastq
3540880 SRR2589044_1.trim.fastq
$ wc -l SRR2589044_2.trim.fastq
3540880 SRR2589044_2.trim.fastq
~~~

That looks really good!

*However, there is some bad news.* Trimmomatic can only operate on
one sample (one set of paired ends) at a time and we have more than one sample. The *good* news
is that we can use a `for` loop to iterate through our sample files
quickly! 

We unzipped two of our files before to count lines so let's compress them again before we run our `for` loop.

~~~
$ gzip SRR2589044_1.trim.fastq
$ gzip SRR2589044_2.trim.fastq
~~~

In this `for` loop we are going to use two variables which will
make our loop **flexible** enough to use the same loop over again
when we want to trim our next set of sequencing sample files.


<!--

With a captured node on Pete, or if we are working in our own "instance" on a cloud
based system, the `for` loop would look like this:
~~~
$ for infile in *_1.fastq.gz
> do
>   base=$(basename ${infile} _1.fastq.gz)
>   java -jar /opt/trimmomatic/0.38/prebuilt/trimmomatic-0.38.jar PE ${infile} ${base}_2.fastq.gz \
>            ${base}_1.trim.fastq.gz ${base}_1un.trim.fastq.gz \
>            ${base}_2.trim.fastq.gz ${base}_2un.trim.fastq.gz \
>            SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15 
> done
~~~

Notice again that the trimmomatic command is one long line. The `\` indicators 
tell the shell to "continue on the next line".
--> 

Without a captured node, we should write a submission script named `trim-loop.sbatch` that looks like this:

~~~
#!/bin/bash
#SBATCH -p express
#SBATCH -t 1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mail-user=<your.email.address@univ.edu>
#SBATCH --mail-type=end
module load trimmomatic
module load jre/1.8.0_221
for infile in *_1.fastq.gz; do base=$(basename ${infile} _1.fastq.gz); java -jar /opt/trimmomatic/0.38/prebuilt/trimmomatic-0.38.jar PE -threads 2 ${infile} ${base}_2.fastq.gz ${base}_1.trim.fastq.gz ${base}_1un.trim.fastq.gz ${base}_2.trim.fastq.gz ${base}_2un.trim.fastq.gz SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15; done
~~~
By now, you should be able to understand the variables and commands in this `for` loop, but *this isn't easy*
and so there is a detailed description of the loop and how it works on this **["Loop-extra" page]({{ site.baseurl }}/materials/loop-extra)**.
We can go through this if we have time.

submit `trim-loop.sbatch` and it should take a few minutes for
Trimmomatic to run for each of our six input files. Once it's done
running, take a look at your directory contents. You'll notice that even though we ran Trimmomatic 
on the paired end files named `SRR2589044` before running the for loop, we 
matched the ending `_1.fastq.gz`, and we re-ran Trimmomatic on this file, overwriting our first results. 
That's OK, but it's good to be aware that it happened.

<!--

> #### Bonus: Running a loop submission script
>
>What if we don't have a "captured" node on our supercomputer, and need to use submission script? How would we run a loop in a submission script? 
>An answer is on the bonus page: [Running Loops for submissions]({{ site.baseurl }}/materials/extras/loops-and-submissions)

<a name="trimout"></a>

-->
<a name="trimout"></a>
Now let's look at our Trimmomatic outputs.

~~~
$ ls
~~~

~~~
NexteraPE-PE.fa               SRR2584866_1.fastq.gz         
SRR2589044_1.trim.fastq.gz    SRR2584863_1.fastq.gz         
SRR2584866_1.trim.fastq.gz    SRR2589044_1un.trim.fastq.gz
SRR2584863_1.trim.fastq.gz    SRR2584866_1un.trim.fastq.gz  
SRR2589044_2.fastq.gz         SRR2584863_1un.trim.fastq.gz  
SRR2584866_2.fastq.gz         SRR2589044_2.trim.fastq.gz
SRR2584863_2.fastq.gz         SRR2584866_2.trim.fastq.gz    
SRR2589044_2un.trim.fastq.gz  SRR2584863_2.trim.fastq.gz    
SRR2584866_2un.trim.fastq.gz  SRR2584863_2un.trim.fastq.gz  
SRR2589044_1.fastq.gz
~~~


We've now completed the trimming and filtering steps of our quality
control process! **Before we move on, let's move our trimmed FASTQ files
to a new subdirectory within our `data/` directory.**

~~~
$ cd ~/dc_workshop/data/untrimmed_fastq
$ mkdir ../trimmed_fastq
$ mv *.trim* ../trimmed_fastq
$ cd ../trimmed_fastq
$ ls
~~~

~~~
SRR2584863_1.trim.fastq.gz    SRR2584866_1.trim.fastq.gz    
SRR2589044_1.trim.fastq.gz    SRR2584863_1un.trim.fastq.gz  
SRR2584866_1un.trim.fastq.gz  SRR2589044_1un.trim.fastq.gz
SRR2584863_2.trim.fastq.gz    SRR2584866_2.trim.fastq.gz    
SRR2589044_2.trim.fastq.gz    SRR2584863_2un.trim.fastq.gz  
SRR2584866_2un.trim.fastq.gz  SRR2589044_2un.trim.fastq.gz
~~~


## Keypoints:
- The options you set for the command-line tools you use are important!
- Data cleaning is an essential step in a genomics workflow.
