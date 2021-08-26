---
layout: page
element: notes
title: Read Processing
language: Shell
---
### A Genome Assembly Workshop 
This part of the course uses a traditional workshop pedagogy with "slides" for readings, and 
"hands-on" exercises that are also lectures (learning while practicing). They are designed to be self-paced but we can work through them in class. 

### Hands-on Genome Assembly Read Processing

Goal: get familiar with genome assemblers, pre-processing, reporting and validation. 
Exercise will be based on chromosomes of a mutant genotype of bakers’ yeast, as practice 
of *reference-based* genome assembly. Here we have the benefits of a reference genome to validate 
our assembly. We must be sure to [acknowledge]({{ site.baseurl }}/materials/acknowledgments) 
those who helped design these lessons.

### Data and directory structure
This exercise will likely use the local University supercomputing resources. 
(AKA: The HPCC) Normally, we would not be able to perform these assemblies
"interactively" *i.e.* by entering commands at the command prompt. 
Instead we would enter commands by submitting our commands as a "job" in the 
computers "queue". Most of the commands we enter will be identical
to the commands you would place inside your "job submission script"
which we'll discuss later, but there's plenty of information 
on the HPCC site [for new users](https://hpcc.okstate.edu/pete-tutorial.html)

Depending on which system is available, everyone should [have an account](http://hpcc.okstate.edu/requesting-hpcc-account) 
on the "Pete" supercomputer
by now. The complete manual for working on the Pete supercomputer is available at [this download link.](https://hpcc.okstate.edu/files/pete-user-manual-v4.pdf) 

> *Special note to curriculum developers:
> This course was reaching the data limit for Github, so files had 
> to be moved. If you are teaching this course, please feel free
> to request any datafiles. This may not be easy to fix.*

Log onto the Pete computer using Putty (Windows users) or your Terminal Program (Mac and Linux users). 
Then open your FTP software, and connect to your account on Pete.
You should have been given the file `mcbios.tar.gz`, for you to 
place on your desktop. **Alternatively, registered students can download the file 
[mcbios.zip](https://canvas.okstate.edu/courses/51969/files/3495395/download?download_frd=1) from Canvas onto the Desktop of your local machine**. 
Use FTP to transfer the file `mcbios.tar.gz`
(or `mcbios.zip`) to Pete. 


<!--
Filezilla FTP software is recommended, and a brief description of how to use Filezilla can be found in the [Filezilla Extra]({{ site.baseurl }}/materials/filezilla-extras) page.
-->


make sure the `mcbios.zip` file will be uploaded into your `/scratch/username` directory on Pete.
NOTE that you should substitute `username` with your actual 
username for the computer. For example, if your username was `phoyt`, upload the file to `/scratch/phoyt`.

Then switch to your REMOTE terminal Window logged in to Cowboy (Windows users can use Putty if they want).

<!--
For `mcbios.tar.gz` use:
~~~
$ cd /scratch/<username>
$ tar xvf mcbios.tar.gz
$ cd mcbios/
$ ls
~~~
-->

For `mcbios.zip` use:
~~~
$ pwd
/home/<username>
$ unzip mcbios.zip
~~~

The output should look similar to:
~~~
Archive:  mcbios.zip
   creating: mcbios/
   creating: mcbios/abyss/
   creating: mcbios/abyss/abyss31/
  inflating: mcbios/abyss/abyss31/abyssk31.pbs
   creating: mcbios/data/
   creating: mcbios/data/group1/
  inflating: mcbios/data/group1/PE-350.1.fastq
  inflating: mcbios/data/group1/PE-350.2.fastq
  inflating: mcbios/data/group1/ref.fasta
   creating: mcbios/data/group2/
  inflating: mcbios/data/group2/PE-350.1.fastq
  inflating: mcbios/data/group2/PE-350.2.fastq
  inflating: mcbios/data/group2/ref.fasta
   creating: mcbios/data/group3/
  inflating: mcbios/data/group3/PE-350.1.fastq
  inflating: mcbios/data/group3/PE-350.2.fastq
  inflating: mcbios/data/group3/ref.fasta
   creating: mcbios/data/group4/
  inflating: mcbios/data/group4/PE-350.1.fastq
  inflating: mcbios/data/group4/PE-350.2.fastq
  inflating: mcbios/data/group4/ref.fasta
   creating: mcbios/data/group5/
  inflating: mcbios/data/group5/PE-350.1.fastq
  inflating: mcbios/data/group5/PE-350.2.fastq
  inflating: mcbios/data/group5/ref.fasta
   creating: mcbios/results/
  inflating: mcbios/results/quast.pbs
   creating: mcbios/soap/
   creating: mcbios/soap/soap31/
  inflating: mcbios/soap/soap31/soap.config
  inflating: mcbios/soap/soap31/soapk31.pbs
   creating: mcbios/velvet/
  inflating: mcbios/velvet/velvetk31.pbs
~~~
Then change into your new `mcbios` directory and see what is there.
~~~
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
To see this file structure, type in the command: `tree | less`.
Notice that the top of the tree starts with a `dot` or `.` meaning the "current working directory".

We will dive into each directory for each task:  fastqc, velvet, soap, abyss etc. Most folders contain a submission script which includes the commands that we use for each task. Using a script allows you to easily modify parameters, and the script also serves as a note to your future self.

### Important notes before hands-on
Since we are using the Pete cluster, only very small tasks can be done directly on the login nodes.  For each longer activity, we will submit the jobs to the scheduler using “pbs scripts”.  These `.pbs` files are text files that include information for the job scheduler as well as the commands to execute your job.

#### The data:
Move into your `data` directory:

`$ cd data`  

Use `ls` to see what files or directories are present:
~~~
$ ls
group1  group2  group3  group4  group5
~~~
There are five group directories, so that up to five different groups of students
can work on a different chromosome in yeast. You can then compare your results. 
As an example, everyone should look inside the `group1` directory:

~~~
$ cd group1
$ ls
ref.fasta  PE-350.1.fastq  PE-350.2.fastq
~~~
To see the first read, remember that each read consists of four lines in a fastq file:
~~~
$ head -n 4 PE-350.1.fastq
@DRR001841.41/1
AAAAGAATGGAAATCTATGTTTTTATTATTACAAGTTTTGAAGATTGCCAAAGAAATCAAGAATTTCGTGAGATTGAAAGTCATCGGGTC
+
CCCCCCBBCCCCCCCCCCCCCCCBBBBBCCCCCCCCCCCCCCCCCCCCCCCCCCCB@CCCCCCCCCCCBCCCCACCCCABA>@CCAB6<B
~~~

By now, you should all be familiar with `.fastq` sequencer files.
Our assembly will start using one Illumina library, PE-350, which is a paired end reads library, divided into two datasets: `1.fastq` and `2.fastq`,  which are the paired reads very close to 350 bp apart. Every read in the `1.fastq` file should have a corresponding read in the `2.fastq` file. Also, `ref.fasta` is the included reference sequence for comparison with your assembly.

#### Review FASTQ format
>Each base has quality identifier called PHRED score, typically between value 0-40 (+33) for Illumina.  The FASTQ file converts the numeric value to a character because they use less space (fewer bits). There is an older scoring system called PHRED+64, but PHRED+33 is used in almost all modern systems including Illumina protocols. PHRED+64 is used ***rarely***, but be aware!
> 
>“Phred quality scores are defined as a property which is logarithmically related to the base-calling error probabilities.”
> 
>-Wikipedia.

The basics of PHRED scores are described in this chart: 

| Quality Score	| Probability of incorrect base call | Base call accuracy |
| ---- | ------------- | -----------|
| 10 | 1 in 10 |90% |
| 20 | 1 in 100 | 99% |
| 30 | 1 in 1000 | 99.9% |
| 40 | 1 in 10000 | 99.99% |
| 50 | 1 in 100000 | 99.999% |

Almost all modern sequence data uses the PHRED+33 (version 1.8 or newer) base call system. 

If a base call has PHRED **quality** score of 20 (i.e. 1% error), 
the PHRED+33 system adds 33 to the quality score: PHRED(20)+33=**53**, 
which corresponds to and is given the **character** 5 using the reference chart below 
(the "S" range) which is what shows up on the fourth line of every read within a fastq file. 

> The older PHRED+64 system 
> is rarely used anymore so ignore it because although it's very, 
> very uncommon to see any sequence data using PHRED+64. 
> The table below shows how you can be sure sequence quality scores 
> are using PHRED+33, because the PHRED+33 max score is "J", 
> and the PHRED+64 minimum score is "@".
> If you ever see any quality scores above "J", contact the person
> who gave you the sequence data for more information!

![PhredScores]({{ site.baseurl }}/fig/PhredScores.png)

### Exercise
The base quality in `PE-350.1.fastq` is encoded in Phred+33 or Phred+64 ?`________` 

The paired end dataset `PE-350.1.fastq` + `PE-350.2.fastq` contains a total of `______` reads. 

(big hint): Count # of lines using the terminal shell by typing:    
  `wc -l PE-350.1.fastq`    
and divide by 4 

or make the command line do all the arithmetic): 

`$ expr $(wc -l < PE-350.1.fastq) / 4`

<!--
Note the difference between 

$ wc -l PE-350.1.fastq
381536 PE-350.1.fastq

and
$ wc -l < PE-350.1.fastq
381536
-->

### How good is your sequencing run? Use FASTQC

Fastqc runs very quickly, so we can enter these commands interactively 
without submitting them as a "job".

If you want help with fastqc, you can type:
`$ fastqc -h`

Now perform the fastqc quality control from within your group's
folder:
```
$ module load fastqc
$ fastqc PE-350.1.fastq
```

(**protip**: do this again to the `PE-350.2.fastq` file by using the up arrow
to bring up the last command, then use arrow keys to move over to change 
1 to a 2 and press enter.)

fastqc puts the results in the same folder as the data (in this case `data/group1/`)

Download your fastqc results using `scp` by reversing the "what you want to move" and "where you want to move it".

```
$ scp phoyt@cowboy.hpc.okstate.edu/home/phoyt/mcbios/data/PE-350.1_fastqc.zip .
$ scp phoyt@cowboy.hpc.okstate.edu/home/phoyt/mcbios/data/PE-350.2_fastqc.zip .
```
Then use your Graphical User Interface to find these "ZIP" files on your Desktop and unzip them. You will find two new folders:
`PE-350.1_fastqc` and `PE-350.2_fastqc`.

FASTQC generates a HTML report for each FASTQ file you run.  In each folder, double-click on the file `fastqc_report.html` to open it in a browser. This shows a lot of summary information about the sequencing files quality (and the data are pretty good). For more information and to see examples of what bad data look like, read the [FASTQC manual](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) when you have time. 

#### Assignment

Find the assignment and submit answers to [Canvas](https://canvas.okstate.edu/courses/51969/quizzes/108839) 





