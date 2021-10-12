---
layout: page
title: Loop Extra
---

### Details of the loop with your submission script

```
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
```
#### The submission script part

By now we should know the following lines set up the submission as an express queue, on one node, 
with 1 processor, for one hour:
```
#!/bin/bash
#SBATCH -p express
#SBATCH -t 1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mail-user=<your.email.address@univ.edu>
#SBATCH --mail-type=end
```

The line `module load trimmomatic` sets up the default parameters for `trimmomatic`

#### Now the loop!

```
for infile in *_1.fastq.gz 
    do base=$(basename ${infile} _1.fastq.gz) 
    java -jar /opt/trimmomatic/0.38/prebuilt/trimmomatic-0.38.jar PE -threads 2 ${infile} ${base}_2.fastq.gz ${base}_1.trim.fastq.gz ${base}_1un.trim.fastq.gz ${base}_2.trim.fastq.gz ${base}_2un.trim.fastq.gz SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15 
    done
```



1. First we setup the variable `${infile}` as we iterate through the folder looking for
all files ending in `_1.fastq.gz`. So `${infile}` represents all the COMPLETE filenames that have 
`_1.fastq.gz` in them (e.g. `SRR2589044_1.fastq.gz`). Remember that for every `_1.fastq.gz`
file, there is a corresponding `_2.fastq.gz` file.

2. The command `do base=$(basename ${infile} _1.fastq.gz)` does a couple things. We've seen the use of `basename`
before, so we know that the basename of the variable `${infile}` is removing the `_1.fastq.gz` from the variable value
and as a result leaves only the **names of the SAMPLES** (e.g. SRR2589044, SRR2584863, SRR2584866, etc.) 
which are given the variable name `${base}`.

3. The trimmomatic command combines the `${infile}` variable for the complete name of the `_1.fastq.gz` filenames with 
the `${base}` variable to fill in the names for the other filenames for example; `${base}_2.fastq.gz`, and `${base}_1.trim.fastq.gz`, 
or `${base}_2.trim.fastq.gz`. Below is a detailed description of the variable, values, and resulting filenames for our loop.  

#### Broken down:

*First time through loop:*

| VARIABLE | VARIABLE VALUE | RESULT |
|----------|---------|--------------|
|${infile}   | *SRR2589044_1.fastq.gz* | SRR2589044_1.fastq.gz |
| ${base}_2.fastq.gz | *SRR2589044* | SRR2589044_2.fastq.gz |
| ${base}_1.trim.fastq.gz | *SRR2589044* | SRR2589044_1.trim.fastq.gz |
| ${base}_1un.trim.fastq.gz | *SRR2589044* | SRR2589044_1.untrim.fastq.gz |
| ${base}_2.trim.fastq.gz | *SRR2589044* | SRR2589044_2.trim.fastq.gz |
| ${base}_2un.trim.fastq.gz | *SRR2589044* | SRR2589044_1.untrim.fastq.gz |

*Second time through loop:*

| VARIABLE | VARIABLE VALUE | RESULT |
|----------|---------| --------------|
|${infile}   | *SRR2584863_1.fastq.gz* | SRR2584863_1.fastq.gz |
| ${base}_2.fastq.gz | *SRR2584863* | SRR2584863_2.fastq.gz |
| ${base}_1.trim.fastq.gz | *SRR2584863* | SRR2584863_1.trim.fastq.gz |
| ${base}_1un.trim.fastq.gz | *SRR2584863* | SRR2584863_1.untrim.fastq.gz |
| ${base}_2.trim.fastq.gz | *SRR2584863* | SRR2584863_2.trim.fastq.gz |
| ${base}_2un.trim.fastq.gz | *SRR2584863* | SRR2584863_1.untrim.fastq.gz |

etc. (This could go on for hundreds of files!)















Go Back to the [Genomics Trimming and Filtering Lesson]({{ site.baseurl }}/materials/genomics-trimming-and-filtering#trimout)
to look at your Trimmomatic outputs.

