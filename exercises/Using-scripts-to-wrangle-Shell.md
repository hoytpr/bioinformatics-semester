---
layout: exercise
topic: Genomics Data Quality Controls
title: Using Scripts to Wrangle
language: Shell
---

#### These files are being developed
#### Exercise Week4 - Scripts with loops

1. This is a good time to check that our script is assigning the FASTQ filename variables correctly. Save your script and run
it. What output do you see?

2. BWA is a software package for mapping low-divergent sequences 
against a large reference genome, such as the human genome, and 
it's freely available [here](http://bio-bwa.sourceforge.net). It 
consists of three algorithms: BWA-backtrack, BWA-SW and BWA-MEM, 
each being invoked with different sub-commands: `aln + samse + sampe` for BWA-backtrack, `bwasw` for BWA-SW and `mem` for the 
BWA-MEM algorithm. BWA-backtrack is designed for Illumina sequence reads up to 100bp, while the rest two are better fitted for 
longer sequences ranged from 70bp to 1Mbp. A general rule of thumb is to use `bwa mem` for reads longer than 70 bp, whereas 
`bwa aln` has a moderately higher mapping rate and a shorter run 
time for short reads (~36bp). You can find a more indepth discussion in the [bwa doc page](http://bio-bwa.sourceforge.net/bwa.shtml) as well as in this 
[blog post](http://crazyhottommy.blogspot.ca/2017/06/bwa-aln-or-bwa-mem-for-short-reads-36bp.html).
In this lesson we have been using the `aln` for performing the 
alignment, but the same process can be performed with `bwa mem` which doesn't require the creation of the index files. The 
process is modified starting from `mkdir` step, and omitting all directories relevant to the `.sai` index files, i.e.:

Create output paths for various intermediate and result files.

~~~
$ mkdir -p results/sam results/bam results/bcf results/vcf
~~~

Assign file names to variables

~~~
$ fq=data/trimmed_fastq/$base\.fastq
$ sam=results/sam/$base\_aligned.sam
$ bam=results/bam/$base\_aligned.bam
$ sorted_bam=results/bam/$base\_aligned_sorted.bam
$ raw_bcf=results/bcf/$base\_raw.bcf
$ variants=results/bcf/$base\_variants.bcf
$ final_variants=results/vcf/$base\_final_variants.vcf  
~~~

Run the alignment

~~~
$ bwa mem -M $genome $fq $sam
~~~

**As an exercise**, try and change your existing script file, from using the `aln` method to the `mem` method.

