---
layout: page
element: notes
title: Variant Calling Workflow
language: Shell
---

### Questions:
- How do I find sequence variants between my sample and a reference genome?

### Objectives:
- Understand the steps involved in variant calling.
- Describe the types of data formats encountered during variant calling.
- Use command line tools to perform variant calling.

It's always good to acknowledge the people who create these great lessons.
This one is adapted from [Data Carpentry "Wrangling Genomics"](https://github.com/datacarpentry/wrangling-genomics/blob/gh-pages/_episodes/04-variant_calling.md)
We mentioned before that we are working with files from a long-term evolution study of an *E. coli* population (designated Ara-3). The basic concept is to understand how genomes can evolve over time, in particular to understand if evolution happens in "jumps" or if it is essentially a consitent force (that might be measured!). Now that we have looked at our data to make sure that it is high quality, and removed low-quality base calls, we can perform ***variant calling*** to see how the population changed over time. We care how this population changed relative to the original population, *E. coli* strain REL606. Therefore, we will align each of our samples to the *E. coli* REL606 reference genome, and see what differences exist in our reads versus the genome.

#### What are variants?

The [NCI Dictionary of Genetics Terms](https://www.cancer.gov/publications/dictionaries/genetics-dictionary/def/genetic-variant) defines a genetic variant as "An alteration in the most common DNA nucleotide sequence. The term variant can be used to describe an alteration that may be benign, pathogenic, or of unknown significance. The term variant is increasingly being used in place of the term mutation." 

Genetic variation and mutations are related, but not the same. The three primary causes for genetic variation are horizontal gene transfer, recombination during sexual reproduction, and mutations. For mutations, there are three primary types: Insertions, Deletions, and Base Substitutions. The common term for these mutation types is "indels". Most software that claims to measure "variants", actually measure "indels". Also, to define an indel as a "variant", one must compare the indels to a "reference" sequence. We don't need to know all the technical details of evolution, but it's good to understand that this experiment is measuring changes in the genome over time, using the REL606 genome as the reference.

### Alignment to a reference genome

![workflow_align]({{ site.baseurl }}/fig/variant_calling_workflow_align.png)

We perform **read alignment** or mapping to determine where in the genome our reads originated from. There are a number of tools to
choose from and, while there is no gold standard, there are some tools that are better suited for particular NGS analyses. We will be
using the [Burrows Wheeler Aligner (BWA)](http://bio-bwa.sourceforge.net/), which is a software package for mapping low-divergent
sequences against a large reference genome. 

The alignment process consists of two steps:

1. Indexing the reference genome
2. Aligning the reads to the reference genome


### Setting up

First we download the reference genome for *E. coli* REL606. Although we could copy or move the file with `cp` or `mv`, most genomics workflows begin with a download step, so we will practice that here. We will start in our `dc_workshop` directory.

~~~
$ cd ~/dc_workshop
$ mkdir -p data/ref_genome
$ curl -L -o data/ref_genome/ecoli_rel606.fasta.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/017/985/GCA_000017985.1_ASM1798v1/GCA_000017985.1_ASM1798v1_genomic.fna.gz
$ gunzip data/ref_genome/ecoli_rel606.fasta.gz
~~~

**[Do the In-class Exercise 1 by clicking on this link.]({{site.baseurl}}/exercises/Genomics-variant-calling-workflow-1-Shell)**

We will also download a set of trimmed FASTQ files to work with. These are small subsets of our real trimmed data, 
and will enable us to run our variant calling workflow quite quickly. 

~~~
$ curl -L -o sub.tar.gz https://ndownloader.figshare.com/files/14418248
$ tar xvf sub.tar.gz
$ mv sub/ ~/dc_workshop/data/trimmed_fastq_small
~~~

You will also need to create directories for the results that will be generated as part of this workflow. We can do this in a single
line of code because `mkdir` can accept multiple new directory
names as input.

```
$ mkdir -p results/sam results/bam results/bcf results/vcf
```

### Index the reference genome

Our first step is to index the reference genome for use by BWA. Indexing allows the aligner to quickly find potential 
alignment sites for our query sequences in a genome, which saves time during alignment. Indexing the reference only has 
to be run once. The only reason you would want to create a new index is if you are working with a different reference 
genome or you are using a different tool for alignment.

Cowboy: make a submission script file named `index.pbs`

~~~
#!/bin/bash
#PBS -q express
#PBS -l nodes=1:ppn=1
#PBS -l walltime=1:00:00
#PBS -j oe
cd $PBS_O_WORKDIR
module load bwa
bwa index data/ref_genome/ecoli_rel606.fasta
~~~

<!--
Cloud instance:
~~~
$ bwa index data/ref_genome/ecoli_rel606.fasta
~~~

While the index is created, you will see output something like this:

~~~
[bwa_index] Pack FASTA... 0.04 sec
[bwa_index] Construct BWT for the packed sequence...
[bwa_index] 1.05 seconds elapse.
[bwa_index] Update BWT... 0.03 sec
[bwa_index] Pack forward-only FASTA... 0.02 sec
[bwa_index] Construct SA from BWT and Occ... 0.57 sec
[main] Version: 0.7.17-r1188
[main] CMD: bwa index data/ref_genome/ecoli_rel606.fasta
[main] Real time: 1.765 sec; CPU: 1.715 sec
~~~

-->

### Align reads to reference genome

The alignment process consists of choosing an appropriate reference genome to map our reads against and then 
***deciding on an aligner***. We will use the **BWA-MEM** algorithm, which is the latest and is generally recommended 
for high-quality queries as it is faster and more accurate. Unlike our previous lessons using older software, this is 
the state-of-the-art! BWA-MEM does a lot of same things, but does them automatically. 

An **example** of what a `bwa` command looks like is below. This command will not run, as we do not have the files `ref_genome.fa`, `input_file_R1.fastq`, or `input_file_R2.fastq`.

~~~
$ bwa mem ref_genome.fasta input_file_R1.fastq input_file_R2.fastq > output.sam
~~~

Using this example, take a look at the [bwa options page](http://bio-bwa.sourceforge.net/bwa.shtml). While we are running bwa with the default 
parameters here, your use case might require a change of parameters. *NOTE: Always read the manual page for any tool before use,
and make sure the options you choose are appropriate for your data.*

We're going to start by aligning the reads from only ***one*** of the 
samples in our dataset (`SRR2584866`). Later, we'll be 
iterating this whole process on all of our sample files with loops.

On Cowboy, make a submission script named align.pbs

~~~
#!/bin/bash
#PBS -q express
#PBS -l nodes=1:ppn=1
#PBS -l walltime=1:00:00
#PBS -j oe
cd $PBS_O_WORKDIR
module load bwa
bwa mem data/ref_genome/ecoli_rel606.fasta data/trimmed_fastq_small/sub/SRR2584866_1.trim.sub.fastq data/trimmed_fastq_small/sub/SRR2584866_2.trim.sub.fastq > results/sam/SRR2584866.aligned.sam

~~~

On a cloud instance the command is:

~~~
$ bwa mem data/ref_genome/ecoli_rel606.fasta data/trimmed_fastq_small/SRR2584866_1.trim.sub.fastq data/trimmed_fastq_small/SRR2584866_2.trim.sub.fastq > results/sam/SRR2584866.aligned.sam
~~~

You will see output that starts like this:
or it will be in the submission script output file: `align.oxxxxxx` 

~~~
[M::bwa_idx_load_from_disk] read 0 ALT contigs
[M::process] read 77446 sequences (10000033 bp)...
[M::process] read 77296 sequences (10000182 bp)...
[M::mem_pestat] # candidate unique pairs for (FF, FR, RF, RR): (48, 36728, 21, 61)
[M::mem_pestat] analyzing insert size distribution for orientation FF...
[M::mem_pestat] (25, 50, 75) percentile: (420, 660, 1774)
[M::mem_pestat] low and high boundaries for computing mean and std.dev: (1, 4482)
[M::mem_pestat] mean and std.dev: (784.68, 700.87)
[M::mem_pestat] low and high boundaries for proper pairs: (1, 5836)
[M::mem_pestat] analyzing insert size distribution for orientation FR...
~~~

#### SAM/BAM format
The [SAM file](https://genome.sph.umich.edu/wiki/SAM),
is a tab-delimited text file that contains information for each individual read and its alignment to the genome. While we do not 
have time to go in detail of the features of the SAM format, the paper by 
[Heng Li et al.](http://bioinformatics.oxfordjournals.org/content/25/16/2078.full) provides a lot more detail on the specification.

**The compressed binary version of SAM is called a BAM file.** We use the BAM file version to reduce size and to allow for *indexing*, which enables efficient random access of the data contained within the file.

We can open and look at a SAM file because it is text, but once we start working with the BAM formatted files, we won't be able to look at them with any text editor. 
So let's go ahead and look at the formatting of a SAM file now. 
The SAM file begins with a **header**, which is optional. The header is used to describe the source of the data, the reference sequence, the method of
alignment, etc., this will change depending on the aligner being used. Following the header is the **alignment section**. Each line
that follows corresponds to alignment information for a single read. Each alignment line has **11 mandatory fields** for essential
mapping information and a **variable** number of other fields for aligner specific information. An example entry from a SAM file is 
displayed below with the different fields highlighted.

![sam_bam1]({{ site.baseurl }}/fig/sam_bam.png)


![sam_bam2]({{ site.baseurl }}/fig/sam_bam3.png)

We will convert the SAM file to BAM format using the `samtools` program with the `view` command and tell this command that the input is in SAM format (`-S`) and to output BAM format (`-b`): 

~~~
$ samtools view -S -b results/sam/SRR2584866.aligned.sam > results/bam/SRR2584866.aligned.bam

[samopen] SAM header is present: 1 sequences.
~~~

### Sorting BAM files by coordinates

To manipulate the BAM files, we need to use the `samtools` toolset. Our next step is to sort the BAM file using the `sort` command from `samtools`. `-o` tells the command where to write the output (only works on samtools after version 1.2).

On Cowboy create a submission script called `bamsort.pbs`:

~~~
#!/bin/bash
#PBS -q express
#PBS -l nodes=1:ppn=1
#PBS -l walltime=1:00:00
#PBS -j oe
cd $PBS_O_WORKDIR
module load samtools/1.9
samtools sort results/bam/SRR2584866.aligned.bam -o results/bam/SRR2584866.aligned.sorted.bam
~~~

<!--
On a cloud instance:
~~~
$ samtools sort -o results/bam/SRR2584866.aligned.sorted.bam results/bam/SRR2584866.aligned.bam 
~~~

> Our files are pretty small, so we may not see any output. If you run the workflow with larger files, you will see something like this:
> ~~~
> [bam_sort_core] merging from 2 files...
> ~~~

-->

Why do we sort these files? Because basically, DNA is linear, and putting reads in the same order as the genome, makes the rest of the mapping process run faster! But, SAM/BAM files can be sorted in multiple ways, e.g. by location of alignment on the chromosome, by read name, etc. **It is important to be aware that different alignment tools will output differently sorted SAM/BAM, and different downstream tools require differently sorted alignment files as input**.

You can use other tools in samtools to learn more about `SRR2584866.aligned.bam`, e.g. `flagstat`.
On Cowboy, using `nano`, create a submission script named `flagstst.pbs` 

~~~
#!/bin/bash
#PBS -q express
#PBS -l nodes=1:ppn=1
#PBS -l walltime=1:00:00
#PBS -j oe
cd $PBS_O_WORKDIR
module load samtools/1.9
samtools flagstat results/bam/SRR2584866.aligned.sorted.bam
~~~
Save this file, and submit it. When it's finished
the output will give you the following statistics about your sorted bam file:

~~~
351169 + 0 in total (QC-passed reads + QC-failed reads)
0 + 0 secondary
1169 + 0 supplementary
0 + 0 duplicates
351103 + 0 mapped (99.98% : N/A)
350000 + 0 paired in sequencing
175000 + 0 read1
175000 + 0 read2
346688 + 0 properly paired (99.05% : N/A)
349876 + 0 with itself and mate mapped
58 + 0 singletons (0.02% : N/A)
0 + 0 with mate mapped to a different chr
0 + 0 with mate mapped to a different chr (mapQ>=5)
~~~

We can't go over all the information provided, but notice that 99.98% of the reads were mapped, and 99.05% were properly mapped as pairs.
Also notice that when we saved the "unpaired" files during our quality control steps, those will show up as 
"singletons", and a few of them could be used (which is better than throwing them away!).
 
### Variant calling with bcftools

A variant call in our experiment is a conclusion that there is a **nucleotide difference vs. some reference at a given position** in an individual genome
or transcriptome. This type of variant is often referred to as a **Single Nucleotide Polymorphism (SNP)**. Any variant call is usually accompanied by an estimate of 
variant frequency (counts, or sometimes coverage) and some measure of confidence (can be a Phred-like score, or even a p-value). 
Similar to other steps in this workflow, there are number of tools available for 
variant calling. In this workshop we will be using `bcftools`, but there are a few things we need to do before actually calling the 
variants.

![workflow]({{ site.baseurl }}/fig/variant_calling_workflow.png)

#### Step 1: Calculate the read coverage of positions in the genome

Coverage, is the number of times any position (a specific nucleotide) in the reference genome can be found in the sequence data. This is different than an "average" coverage of a genome, which is used in high-throughput sequencing. We can perform the first pass on variant calling by counting read coverage of any position in the genome with [bcftools](https://samtools.github.io/bcftools/bcftools.html). We will use the command `mpileup`. The flag `-O b` tells samtools to generate a `.bcf` format output file, `-o` specifies where to write the output file, and `-f` gives the path to the reference genome file. Note that the `mpileup` command expects the output file path and name to immediately follow the `-o` flag. The input file is the last part of the command. 

On Cowboy, create a submission script called pileup.pbs:

~~~
#!/bin/bash
#PBS -q express
#PBS -l nodes=1:ppn=1
#PBS -l walltime=1:00:00
#PBS -j oe
cd $PBS_O_WORKDIR
module load bcftools
bcftools mpileup -O b -o results/bcf/SRR2584866_raw.bcf -f data/ref_genome/ecoli_rel606.fasta results/bam/SRR2584866.aligned.sorted.bam
~~~

<!-- 
On a cloud instance:
~~~
$ bcftools mpileup -O b -o results/bcf/SRR2584866_raw.bcf \
-f data/ref_genome/ecoli_rel606.fasta results/bam/SRR2584866.aligned.sorted.bam 

[mpileup] 1 samples in 1 input files
~~~

-->
The output  file should say:
`[mpileup] 1 samples in 1 input files`


We have now generated a file with coverage information for **every base**.

Here's a visual summary of what we are identifying:

![vcf-visual]({{ site.baseurl }}/fig/vcf-visual.png)


#### Step 2: Detect the single nucleotide polymorphisms (SNPs)

To identify SNPs we'll use the bcftools `call` function. Because we are identifying SNPs in a genome, we have to pay attention to the genome "ploidy". We specify ploidy with the flag `--ploidy`, which is **one (1)** for the haploid *E. coli*. The `-m` flag allows for **m**ultiallelic and rare-variant calling, while the `-v` flag tells the program to output **v**ariant sites only (not every site in the genome), and `-o` specifies where to write the **o**utput file. Note that `bcftools call` expects the path to the output file to immediately follow the `-o` flag. The input file is the last part of the command. 

The `ploidy.pbs` submission script on Cowboy should be:
~~~
#!/bin/bash
#PBS -q express
#PBS -l nodes=1:ppn=1
#PBS -l walltime=1:00:00
#PBS -j oe
cd $PBS_O_WORKDIR
module load bcftools
bcftools call --ploidy 1 -m -v -o results/bcf/SRR2584866_variants.vcf results/bcf/SRR2584866_raw.bcf
~~~

<!--

On a cloud instance:
~~~
$ bcftools call --ploidy 1 -m -v -o results/bcf/SRR2584866_variants.vcf results/bcf/SRR2584866_raw.bcf 
~~~

-->

For more details on the options and flags of bcftools, make sure you [read the manual](https://samtools.github.io/bcftools/bcftools.html). After this step, we should have a lot of information about our variants, compared to the reference genome, but we need to pull out the most important information.

#### Step 3: Filter and report the SNP variants in variant calling format (VCF)

The `VCF` format is one of the most famous formats in bioinformatics! Unfortunately there are multiple versions of this format, making it difficult to work with consistently. Fortunately the `bcftools` package gives us a Perl script we can use to convert (or "parse") the original `.vcf` file into a more standard `.vcf` (final) format. 

Filter the SNPs for the final output in VCF format, using `vcfutils.pl`:

On Cowboy make a submission script named finalvcf.pbs:
~~~
#!/bin/bash
#PBS -q express
#PBS -l nodes=1:ppn=1
#PBS -l walltime=1:00:00
#PBS -j oe
cd $PBS_O_WORKDIR
module load bcftools
vcfutils.pl varFilter results/bcf/SRR2584866_variants.vcf  > results/vcf/SRR2584866_final_variants.vcf
~~~
<!--
On a cloud instance:
~~~
$ vcfutils.pl varFilter results/bcf/SRR2584866_variants.vcf  > results/vcf/SRR2584866_final_variants.vcf
~~~
-->
The `vcfutils.pl` script outputs a well-formatted `.vcf` file we can now explore using a text editor. But this is a big and complex file. 

### Explore the VCF format:

![VCF File Parts]({{ site.baseurl }}/fig/vcf-file-basic-parts.png)
(image credit: The Broad Institute)

The basic parts of a `.vcf` file are the "Header", followed by the "Records". Both parts have important and 
highly specific information.  Let's look at the file using `less`.

~~~
$ less -S results/vcf/SRR2584866_final_variants.vcf
~~~

You will see the header (which describes the format), the time and date the file was
created, the version of bcftools that was used, the command line parameters used, and 
lots of additional information:

~~~
##fileformat=VCFv4.2
##FILTER=<ID=PASS,Description="All filters passed">
##bcftoolsVersion=1.8+htslib-1.8
##bcftoolsCommand=mpileup -O b -o results/bcf/SRR2584866_raw.bcf -f data/ref_genome/ecoli_rel606.fasta results/bam/SRR2584866.aligned.sorted.bam
##reference=file://data/ref_genome/ecoli_rel606.fasta
##contig=<ID=CP000819.1,length=4629812>
##ALT=<ID=*,Description="Represents allele(s) other than observed.">
##INFO=<ID=INDEL,Number=0,Type=Flag,Description="Indicates that the variant is an INDEL.">
##INFO=<ID=IDV,Number=1,Type=Integer,Description="Maximum number of reads supporting an indel">
##INFO=<ID=IMF,Number=1,Type=Float,Description="Maximum fraction of reads supporting an indel">
##INFO=<ID=DP,Number=1,Type=Integer,Description="Raw read depth">
##INFO=<ID=VDB,Number=1,Type=Float,Description="Variant Distance Bias for filtering splice-site artefacts in RNA-seq data (bigger is better)",Version=
##INFO=<ID=RPB,Number=1,Type=Float,Description="Mann-Whitney U test of Read Position Bias (bigger is better)">
##INFO=<ID=MQB,Number=1,Type=Float,Description="Mann-Whitney U test of Mapping Quality Bias (bigger is better)">
##INFO=<ID=BQB,Number=1,Type=Float,Description="Mann-Whitney U test of Base Quality Bias (bigger is better)">
##INFO=<ID=MQSB,Number=1,Type=Float,Description="Mann-Whitney U test of Mapping Quality vs Strand Bias (bigger is better)">
##INFO=<ID=SGB,Number=1,Type=Float,Description="Segregation based metric.">
##INFO=<ID=MQ0F,Number=1,Type=Float,Description="Fraction of MQ0 reads (smaller is better)">
##FORMAT=<ID=PL,Number=G,Type=Integer,Description="List of Phred-scaled genotype likelihoods">
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##INFO=<ID=ICB,Number=1,Type=Float,Description="Inbreeding Coefficient Binomial test (bigger is better)">
##INFO=<ID=HOB,Number=1,Type=Float,Description="Bias in the number of HOMs number (smaller is better)">
##INFO=<ID=AC,Number=A,Type=Integer,Description="Allele count in genotypes for each ALT allele, in the same order as listed">
##INFO=<ID=AN,Number=1,Type=Integer,Description="Total number of alleles in called genotypes">
##INFO=<ID=DP4,Number=4,Type=Integer,Description="Number of high-quality ref-forward , ref-reverse, alt-forward and alt-reverse bases">
##INFO=<ID=MQ,Number=1,Type=Integer,Description="Average mapping quality">
##bcftools_callVersion=1.8+htslib-1.8
##bcftools_callCommand=call --ploidy 1 -m -v -o results/bcf/SRR2584866_variants.vcf results/bcf/SRR2584866_raw.bcf; Date=Tue Oct  9 18:48:10 2018
~~~
We should mention that although our output does not have an `ID=AD` metric in the header, but `ID=AD` is common in HEADER 
lines and `.vcf` files. 

Many of the metrics can be optionally output using the command line. For example:
~~~
##FORMAT=<ID=AD,Number=.,Type=Integer,Description="Allelic depths for the ref and alt alleles in the order listed">
~~~
This forces `ID=AD` to be output.

**It is important to know that there are variations in `.vcf` files!**

The image below is just another example of the HEADER region of a `.vcf` file but is an image 
to prevent the header lines from wrapping on your terminal screen. We don't have time to cover all these outputs, but hopefully some will look familiar to you and useful.

![vcf header]({{ site.baseurl }}/fig/vcf-file-header.png)

All of the header information, and configuration details are
followed by RECORDS information for **each of the variations observed**: 

~~~
#CHROM  POS  ID  REF  ALT  QUAL  FILTER  INFO  FORMAT  results/bam/SRR2584866.aligned.sorted.bam
CP000819.1  1521  .  C  T  207  .  DP=9;VDB=0.993024;SGB=-0.662043;MQSB=0.974597;MQ0F=0;AC=1;AN=1;DP4=0,0,4,5;MQ=60  GT:PL  1:237,0
CP000819.1  1612  .  A  G  225  .  DP=13;VDB=0.52194;SGB=-0.676189;MQSB=0.950952;MQ0F=0;AC=1;AN=1;DP4=0,0,6,5;MQ=60  GT:PL  1:255,0
CP000819.1  9092  .  A  G  225  .  DP=14;VDB=0.717543;SGB=-0.670168;MQSB=0.916482;MQ0F=0;AC=1;AN=1;DP4=0,0,7,3;MQ=60  GT:PL  1:255,0
CP000819.1  9972  .  T  G  214  .  DP=10;VDB=0.022095;SGB=-0.670168;MQSB=1;MQ0F=0;AC=1;AN=1;DP4=0,0,2,8;MQ=60  GT:PL  1:244,0
CP000819.1  10563  .  G  A  225  .  DP=11;VDB=0.958658;SGB=-0.670168;MQSB=0.952347;MQ0F=0;AC=1;AN=1;DP4=0,0,5,5;MQ=60  GT:PL  1:255,0
CP000819.1  22257  .  C  T  127  .  DP=5;VDB=0.0765947;SGB=-0.590765;MQSB=1;MQ0F=0;AC=1;AN=1;DP4=0,0,2,3;MQ=60  GT:PL  1:157,0
CP000819.1  38971  .  A  G  225  .  DP=14;VDB=0.872139;SGB=-0.680642;MQSB=1;MQ0F=0;AC=1;AN=1;DP4=0,0,4,8;MQ=60  GT:PL  1:255,0
CP000819.1  42306  .  A  G  225  .  DP=15;VDB=0.969686;SGB=-0.686358;MQSB=1;MQ0F=0;AC=1;AN=1;DP4=0,0,5,9;MQ=60  GT:PL  1:255,0
CP000819.1  45277  .  A  G  225  .  DP=15;VDB=0.470998;SGB=-0.680642;MQSB=0.95494;MQ0F=0;AC=1;AN=1;DP4=0,0,7,5;MQ=60  GT:PL  1:255,0
CP000819.1  56613  .  C  G  183  .  DP=12;VDB=0.879703;SGB=-0.676189;MQSB=1;MQ0F=0;AC=1;AN=1;DP4=0,0,8,3;MQ=60  GT:PL  1:213,0
CP000819.1  62118  .  A  G  225  .  DP=19;VDB=0.414981;SGB=-0.691153;MQSB=0.906029;MQ0F=0;AC=1;AN=1;DP4=0,0,8,10;MQ=59  GT:PL  1:255,0
CP000819.1  64042  .  G  A  225  .  DP=18;VDB=0.451328;SGB=-0.689466;MQSB=1;MQ0F=0;AC=1;AN=1;DP4=0,0,7,9;MQ=60  GT:PL  1:255,0
~~~

**This is a lot of information**, so let's take some time to make sure we understand our output.

Here's what the top of the RECORDS might look like if you opened it in a spreadsheet
![VCF File top]({{ site.baseurl }}/fig/vcf-file-spreadsheet.png)

The first few columns represent the information we have about a ***predicted variation***. 

| Column | Description |
| ------- | ---------- |
| CHROM | contig location where the variation occurs | 
| POS | position within the contig where the variation occurs | 
| ID | a **`.`** until we add **annotation** information | 
| REF | reference genotype (forward strand) | 
| ALT | sample genotype (forward strand) | 
| QUAL | Phred-scaled probability that the observed variant exists at this site (higher is better) |
| FILTER | a **`.`** if no quality filters have been applied, PASS if a quality filter is passed, OR the name of the filters this variant ***failed*** | 
| INFO | annotations contained in the INFO field are represented as "tag-value pairs" (TAG=00) separated by colon characters. These typically summarize information from the sample. The header has the definitions of the tag-value pairs. |

You can also find additional information on how tag-value pairs are calculated and how they should be interpreted in the "Variant Annotations" 
section of the [Broad GATK Tool Documentation](https://www.broadinstitute.org/gatk/guide/tooldocs/). 

In an ***ideal*** world, the information in the **`QUAL`** column would be all we needed to filter out bad variant calls.
However, in reality we will need to continue filtering on multiple other metrics. 

The last two columns contain the ***genotypes*** and can be tricky to decode.


| column | definition |
| ------- | ---------- |
| FORMAT | The **metrics** (short names) of the sample-level annotations presented *in order* | 
| "Results" (usually a sample name) | lists the values corresponding to those metrics *in order* | 

These last two columns are important for determining if the variant call is "real" or not. 
For the file in this lesson, the metrics presented are **GT:PL** which (according to the header) stand for 
"**G**eno**t**ype", and "Normalized, **P**hred-scaled **l**ikelihoods for genotypes as defined in the VCF specification".
Each of these metrics will have a value, in the "results" column. The values are in the same order as the metric short names, and 
are also separated by colon characters. These and a few other metrics and definitions are shown below:

| Metric | Definition | 
| ------- | ---------- |
| GT | The ***genotype*** of this sample; which for a *diploid* genome is encoded with a **0 for the REFERENCE genome allele (REF)**. Then, 1 is for the first **Alternate Genome allele (ALT)**, 2 is for the second ALT allele and so on. So 0/0 means homozygous reference, 0/1 (or 0/2...) is heterozygous, and also notice that 1/1 is **homozygous for the alternate allele**. |
| AD | the unfiltered **a**llele **d**epth, i.e. the number of reads that match each of the reported alleles shown as **`REF/ALT`**|
| DP | the filtered sequencing **d**e**p**th (AKA:`number of reads`), at the sample level for this allele |
| GQ | the **g**enotype's Phred-scaled **q**uality score (confidence) for the genotype | 
| PL | the "Normalized" **P**hred-scaled **likelihoods** of the given genotypes |

To be very clear, below is another example of the RECORDS part of a `.vcf` file borrowed from the [Broad Institute website](https://software.broadinstitute.org/gatk/documentation/article.php?id=1268).
It has been opened in a spreadsheet, and **shows some very significant differences between our `bcftools` created `.vcf` file
and the GATK-produced `.vcf` file**. We don't want to be confusing, but we want you to see they can be different. 
Notice there can be several short-name metrics under the "FORMAT" column, 
each with a corresponding value under the "Results" column, named `NA12878` in this example. Remember that the default 
metric values always put the `REF` value before the `ALT` value.
![VCF File Results Example]({{ site.baseurl }}/fig/vcf-from-broad.png)
In this example, at position 873762 the metrics are:

| FORMAT | NA12878 |
| ------ | ------- |
| GT | 0/1 |
| AD | 173,141 |
| DP | 282 |
| GQ | 99 |
| PL | 255,0,255 |

Now you should notice that the `PL` metric has ***three*** values (`255,0,255`), rather than the ***two*** values
we have in our bcftools-produced `.vcf` file. For a detailed breakdown of the variant call at this SNP, using the Broad format,
we have created this **[extra page on VCF interpretation]({{ site.baseurl }}/materials/extras/vcf-interpretation)**.

#### The Broad Institute's [VCF guide](https://www.broadinstitute.org/gatk/guide/article?id=1268) is an excellent place to learn more about VCF file format.

**[Do the In-class Exercise 2 by clicking on this link.]({{site.baseurl}}/exercises/Genomics-variant-calling-workflow-2-Shell)**

### Assess the alignment (visualization) - optional step

It is often instructive to look at your data in a genome browser. Visualization will allow you to get a "feel" for 
the data, as well as detecting abnormalities and problems. Also, exploring the data in such a way may give you 
ideas for further analyses.  As such, visualization tools are useful for exploratory analysis. In this lesson we 
will describe two different tools for visualization; a light-weight command-line based one and the Broad
Institute's Integrative Genomics Viewer (IGV) which requires
software installation and transfer of files.

In order for us to visualize the alignment files, we first need to **index the BAM file** using `samtools`:
On Cowboy, create a submission script called samindex.pbd:
```
#!/bin/bash
#PBS -q express
#PBS -l nodes=1:ppn=1
#PBS -l walltime=1:00:00
#PBS -j oe
cd $PBS_O_WORKDIR
module load bcftools
samtools index results/bam/SRR2584866.aligned.sorted.bam
```
On a cloud instance just use:
~~~
$ samtools index results/bam/SRR2584866.aligned.sorted.bam
~~~

#### Viewing with `tview`

[Samtools](http://www.htslib.org/) implements a very simple text alignment viewer based on the GNU
`ncurses` library, called `tview`. This alignment viewer works with short indels and shows [MAQ](http://maq.sourceforge.net/) consensus. 
It can use colors to display mapping quality or base quality, subjected to users' choice (but we won't specifiy colors for now). 
Samtools viewer is fast enough to work with an 130 GB alignment and because it uses a text interface, you can even 
display alignments over a network.

In order to visualize our mapped reads with `tview`, we give it the sorted bam file and the reference file: 
NOTE: We can't do this on Cowboy, unless we capture a node. So on Cowboy try:

`qsub -I`

and you should see something like: 
`job waiting to start`
When your prompt changes to something like: `[phoyt@n217]` you will be back in your "home" directory, and 
need to change into your `dc_workshop` directory again. Then type the command:

```
S cd dc_workshop
$ samtools tview results/bam/SRR2584866.aligned.sorted.bam data/ref_genome/ecoli_rel606.fasta
```

This is the same command as when using a cloud instance:

~~~
$ samtools tview results/bam/SRR2584866.aligned.sorted.bam data/ref_genome/ecoli_rel606.fasta
~~~
You should see an output similar to this:
~~~
1         11        21        31        41        51        61        71        81        91        101       111       121
AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGCTTCTGAACTGGTTACCTGCCGTGAGTAAATTAAAATTTTATTGACTTAGGTCACTAAATAC
..................................................................................................................................
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, ..................N................. ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,........................
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, ..................N................. ,,,,,,,,,,,,,,,,,,,,,,,,,,,.............................
...................................,g,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,  ....................................   ................
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,....................................   ....................................      ,,,,,,,,,,
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,  ....................................  ,,a,,,,,,,,,,,,,,,,,,,,,,,,,,,,,     .......
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, .............................  ,,,,,,,,,,,,,,,,,g,,,,,    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,  ...........................T.......   ,,,,,,,,,,,,,,,,,,,,,,,c,          ......

~~~

(If the output isn't exactly the same, that's okay). The ***first*** line of output shows the genome 
coordinates in our reference genome. The ***second*** line shows the reference
genome sequence. The ***third*** line shows the consensus sequence determined from the sequence reads. A **`.`** (dot) indicates
a match to the reference sequence, and we can see that the *consensus* from our sample matches the reference in most
locations. That is good! If that wasn't the case, we should probably reconsider our choice of reference. 
You can use the arrow keys on your keyboard
to scroll or type `?` for a help menu.

Below the horizontal line, we can see all of the reads in our sample aligned with this region of the reference genome. Only 
positions where the called base differs from the reference are the nucleotides shown. 
**To navigate to a specific position**, type `g` (for "goto"). A dialogue box will appear. In
this box, type the name of the "chromosome" followed by a colon and the position of the variant you would like to view
(*e.g.* for this sample, type `CP000819.1:50` to view the 50th base. 

> ### In Class Exercise
> 
> Visualize the alignment of the reads for our `SRR2584866` sample. What variant is present at 
> position 4377265? What is the consensus (AKA "canonical") nucleotide in that position? 
> 
>> #### Solution
>> 
>> Type `g`. In the dialogue box, then type `CP000819.1:4377265`. 
>> `A` is canonical (reference) base call, but all the sequences show `G` is the variant. So this looks
>> like a **hom-alt** or "homozygous-variant" position. After some research, you would find
>> that this variant possibly changes the phenotype of this sample to hypermutable. Because it occurs
>> in the gene *mutL*, which controls DNA mismatch repair.
> 
> Does this match what we know about our `VCF` file? Let's open our `SRR2584866_final_variants.vcf`
> file and check out this variant!
> 
>> Use `nano` to open your file 
>> `nano ~/dc_workshop/results/vcf/SRR2584866_final_variants.vcf`
>> in the bottom right, you will see `^_ Go To Line`. This means "control-underline" is the keystroke to give you a "go to line" command.
>> To accomplish this, you'll need to use a combination of <kbd>CONTROL-SHIFT-Underline</kbd> because <kbd> SHIFT-Underline</kbd> 
>> is the only way to get a `_` character. We already know that this position is on line 761 of the `VCF` file, so
>> enter "761" when asked to "Enter line number, column number:".
>> It should look like this, then you hit the <kbd> ENTER</kbd> key:
>> ![nano goto]({{site.baseurl}}/fig/nanogoto.png)
>> 

The line 761 will probably be too long to fit on your screen, but should look like this:
`CP000819.1	4377265	.	A	G	225	.	DP=16;VDB=0.921692;SGB=-0.683931;MQSB=1;MQ0F=0;AC=1;AN=1;DP4=0,0,4,9;MQ=60	GT:PL	1:255,0`
This tells us that in the chromosome CP000819.1, at position 4377265, we see a genotype call (`GT`) of `1` which is 
homozygous variant (**hom-alt**) for **A/G**. We also see that `DP=16` so there are 16 reads that map to this nucleotide 
(coverage of 16) and that the `PL` values are `255,0`, meaning there's no chance it's heterozygous (10^-25.5 is very unlikely), but the sequenced
sample is a homozygous variant! Our `VCF` file matches our `TVIEW` output!

Type `Ctrl^C` or `q` to exit `tview`

### Viewing with IGV

[IGV](http://www.broadinstitute.org/igv/) is a stand-alone genome browser, which has the advantage of being installed 
locally and providing fast access. Web-based genome browsers, like [Ensembl](http://www.ensembl.org/index.html) or 
the [UCSC browser](https://genome.ucsc.edu/), are slower, but provide more functionality. They not only allow 
for more polished and flexible visualization, but also provide easy access to a wealth of annotations and 
external data sources. This makes it straightforward to relate your data with information about repeat 
regions, known genes, epigenetic features or areas of cross-species conservation, to name just a few.

In order to use IGV, we will need to transfer some files to our local machine. We learned how to do this with `scp`. 
Open a **new** tab in your LOCAL terminal window **(not the one connected to a remote computer)** and 
create a new folder named `dc_workshop` on our `Desktop`.
Then we'll make the directory `files_for_igv` to store the files:

~~~
$ mkdir ~/Desktop/dc_workshop
$ mkdir ~/Desktop/dc_workshop/files_for_igv
$ cd ~/Desktop/dc_workshop/files_for_igv
~~~

Now we will transfer our files to that new directory using `scp`. 

When using a remote system, remember to replace put your `<username>` before the `@` symbol, 
and the `<ip-address>`, or your AWS (or CyVerse) instance number between the text between the `@` and the `:`.
The commands to `scp` are always entered in the terminal window that is connected to your
**local** computer (not your remote/AWS instance).

For Cowboy:
~~~
$ scp <username>@cowboy.hpc.okstate.edu:~/dc_workshop/results/bam/SRR2584866.aligned.sorted.bam ~/Desktop/dc_workshop/files_for_igv
$ scp <username>@cowboy.hpc.okstate.edu:~/dc_workshop/results/bam/SRR2584866.aligned.sorted.bam.bai ~/Desktop/dc_workshop/files_for_igv
$ scp <username>@cowboy.hpc.okstate.edu:~/dc_workshop/data/ref_genome/ecoli_rel606.fasta ~/Desktop/dc_workshop/files_for_igv
$ scp <username>@cowboy.hpc.okstate.edu:~/dc_workshop/results/vcf/SRR2584866_final_variants.vcf ~/Desktop/dc_workshop/files_for_igv
~~~
For an AWS cloud instance:
~~~
$ scp dcuser@ec2-34-203-203-131.compute-1.amazonaws.com:~/dc_workshop/results/bam/SRR2584866.aligned.sorted.bam ~/dc_workshop/files_for_igv
$ scp dcuser@ec2-34-203-203-131.compute-1.amazonaws.com:~/dc_workshop/results/bam/SRR2584866.aligned.sorted.bam.bai ~/dc_workshop/files_for_igv
$ scp dcuser@ec2-34-203-203-131.compute-1.amazonaws.com:~/dc_workshop/data/ref_genome/ecoli_rel606.fasta ~/dc_workshop/files_for_igv
$ scp dcuser@ec2-34-203-203-131.compute-1.amazonaws.com:~/dc_workshop/results/vcf/SRR2584866_final_variants.vcf ~/dc_workshop/files_for_igv
~~~

You will need to type the password for your remote/AWS instance each time you call `scp`. 

Next we need to open the IGV software. If you haven't done so already, you can download IGV from the [Broad Institute's software page](https://www.broadinstitute.org/software/igv/download), double-click the `.zip` file
to unzip it, and then drag the program into your Applications folder. Windows users will find that IGV installs into 
their `C:Programs Files/IGV_2.7.2` folder
and also places a link to the application on their Desktop. You can copy the application link into the `~/Desktop/files_for_igv` 
folder you just created, or just open IGV from the Desktop 

1. Open IGV (double-click on the icon/link).
2. Load our reference genome file (`ecoli_rel606.fasta`) into IGV using the **"Load Genomes from File..."** option under the **"Genomes"** pull-down menu.
3. Load our BAM file (`SRR2584866.aligned.sorted.bam`) using the **"Load from File..."** option under the **"File"** pull-down menu. 
4.  Do the same with our VCF file (`SRR2584866_final_variants.vcf`).

Your IGV browser might look different than the screenshot below:

![IGV]({{ site.baseurl }}/fig/igv-screenshot2.png)

There should be two tracks: one corresponding to our BAM file and the other for our VCF file. 

In the **VCF track**, each bar across the top of the plot shows the allele fraction for a single locus. The second bar shows
the genotypes for each locus in each *sample*. We only have one sample called here so we only see a single line. 
Cyan = homozygous variant, Grey = reference. Most of what we see are homozygous variants, because E. coli is 
a haploid organism. But we can see some heterozygous calls, if we know where to look. They will show up as dark-blue. 
Filtered entries are transparent. There might be variations in 
the colors for different operating systems.

We can zoom in to inspect variants you see in your filtered VCF file to become more familiar with IGV. 
But first, let's check out our **hom-alt** allele in the *mutL* gene. At the top of IGV, there is a white box 
with "CP000819.1" (the chromosome number) already entered. Let's go to position 4377265 again. Just click after 
the CP000819.1 and enter a colon character then the position: `:4377265` and click on "Go".
Suddenly a lot of information is visible. It should look like this:
![igv-at-mutL]({{ site.baseurl }}/fig/igv-screenshot-mutl.png)

Now we can see that at position 4377265, the reference genome sequence (at the bottom) has an "A", 
but all the reads (16 of them) have a "G" at that position. We also see some reads are in the forward direction, 
and some are in the reverse direction. We see the call is cyan colored or **hom-alt**. 
Take some time to explore this output to see how quality information 
corresponds to alignment information at those loci.
Use [this Broad Institute website](http://software.broadinstitute.org/software/igv/AlignmentData) and the links 
therein to understand how IGV colors the alignments.

**Congratulations again!** You have mapped over a million sequence reads to a full bacterial genome, and everything looks correct!

Now that we've run through our workflow for a single sample, we want to repeat this workflow for our other five
samples. However, as usual, we don't want to type each of these individual steps again five more times. That would be very
time consuming and error-prone, and would become impossible as we gathered more and more samples. Luckily, we
already know the tools we need to use to automate this workflow and run it on as many files as we want using a
single line of code. Those tools are: **wildcards**, **`for` loops**, and **bash scripts**. We'll use all three 
in [the next lesson]({{ site.baseurl }}/materials/genomics-data-and-writing-scripts). 

> ### Installing Software
> 
> It's worth noting that all of the software we are using for
> this workshop has been pre-installed on our remote computer. 
> This saves us a lot of time - installing software can be a 
> time-consuming and frustrating task - however, this does mean that
> you won't be able to walk out the door and start doing these
> analyses on your own computer. You'll need to install 
> the software first. Look at the [setup instructions](http://www.datacarpentry.org/wrangling-genomics/setup.html) for more information 
> on installing these software packages.


> ### BWA Alignment options
> BWA consists ***currently*** of three algorithms: BWA-backtrack, BWA-SW and BWA-MEM. The BWA-backtrack algorithm is designed only for Illumina sequence 
> reads up to 100bp, while the other two are for sequences ranging from 70bp to 1Mbp. BWA-MEM and BWA-SW share similar features such 
> as long-read support and split alignment, but BWA-MEM, which is the latest, is generally recommended for high-quality queries as it 
> is faster and more accurate. We mention again that we used older software earlier to 
> show you certain aspects of bioinformatics like being able to compare
> outputs, and how different software (algorithms) can produce different results. 
> Here you can see ONE software package that has three different packages built-in!

> ### Multi-line commands 
> Some of the commands we ran in this lesson are long! When typing a long 
> command into your terminal, you can use the `\` character
> to separate code chunks onto separate lines. This can make your code more readable.

#### Keypoints:
- Bioinformatics command line tools are collections of commands that can be used to carry out bioinformatics analyses.
- To use most powerful bioinformatics tools, you'll need to use the command line.
- There are many different file formats for storing genomics data. It's important to understand what type of information is contained in each file, and how it was derived.
