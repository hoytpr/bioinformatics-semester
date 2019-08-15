---
layout: exercise
topic: Shell
title: Scripts With Loops Genomics 
language: Shell
---
(Advanced loops) 
below has been commented out.

<!--

> 
> This is a good time to check that our script is assigning the FASTQ filename variables correctly. Save your script and run
> it. What output do you see?
>
>> ## Solution 
>> 
>> ~~~
>> $ bash run_variant_calling.sh
>> ~~~
>> 

>> ~~~
>> [bwa_index] Pack FASTA... 0.04 sec
>> [bwa_index] Construct BWT for the packed sequence...
>> [bwa_index] 1.10 seconds elapse.
>> [bwa_index] Update BWT... 0.03 sec
>> [bwa_index] Pack forward-only FASTA... 0.02 sec
>> [bwa_index] Construct SA from BWT and Occ... 0.64 sec
>> [main] Version: 0.7.5a-r405
>> [main] CMD: bwa index /home/dcuser/dc_workshop/data/ref_genome/ecoli_rel606.fasta
>> [main] Real time: 1.892 sec; CPU: 1.829 sec
>> working with file /home/dcuser/dc_workshop/data/trimmed_fastq_small/SRR097977.fastq_trim.fastq
>> working with file /home/dcuser/dc_workshop/data/trimmed_fastq_small/SRR098026.fastq_trim.fastq
>> working with file /home/dcuser/dc_workshop/data/trimmed_fastq_small/SRR098027.fastq_trim.fastq
>> working with file /home/dcuser/dc_workshop/data/trimmed_fastq_small/SRR098028.fastq_trim.fastq
>> working with file /home/dcuser/dc_workshop/data/trimmed_fastq_small/SRR098281.fastq_trim.fastq
>> working with file /home/dcuser/dc_workshop/data/trimmed_fastq_small/SRR098283.fastq_trim.fastq
>> ~~~
>> {: .output}
>> 

>> You should see "working with file . . . " for each of the six FASTQ files in our `trimmed_fastq/` directory.
>> If you don't see this output, then you'll need to troubleshoot your script. A common problem is that your directory might not
>> be specified correctly. Ask for help if you get stuck here! 

> ## BWA variations
> BWA is a software package for mapping low-divergent sequences 
> against a large reference genome, such as the human genome, and 
> it's freely available [here](http://bio-bwa.sourceforge.net). It 
> consists of three algorithms: BWA-backtrack, BWA-SW and BWA-MEM, 
> each being invoked with different sub-commands: `aln + samse + sampe` for BWA-backtrack, `bwasw` for BWA-SW and `mem` for the 
> BWA-MEM algorithm. BWA-backtrack is designed for Illumina sequence reads up to 100bp, while the rest two are better fitted for 
> longer sequences ranged from 70bp to 1Mbp. A general rule of thumb is to use `bwa mem` for reads longer than 70 bp, whereas 
> `bwa aln` has a moderately higher mapping rate and a shorter run 
> time for short reads (~36bp). You can find a more indepth discussion in the [bwa doc page](http://bio-bwa.sourceforge.net/bwa.shtml) as well as in this 
> [blog post](http://crazyhottommy.blogspot.ca/2017/06/bwa-aln-or-bwa-mem-for-short-reads-36bp.html).
> In this lesson we have been using the `aln` for performing the 
> alignment, but the same process can be performed with `bwa mem` which doesn't require the creation of the index files. The 
> process is modified starting from `mkdir` step, and omitting all directories relevant to the `.sai` index files, i.e.:
> 
> Create output paths for various intermediate and result files.
>
> ~~~
> $ mkdir -p results/sam results/bam results/bcf results/vcf
> ~~~
> {: .bash}
>
> Assign file names to variables
>
> ~~~
> $ fq=data/trimmed_fastq/$base\.fastq
> $ sam=results/sam/$base\_aligned.sam
> $ bam=results/bam/$base\_aligned.bam
> $ sorted_bam=results/bam/$base\_aligned_sorted.bam
> $ raw_bcf=results/bcf/$base\_raw.bcf
> $ variants=results/bcf/$base\_variants.bcf
> $ final_variants=results/vcf/$base\_final_variants.vcf  
> ~~~
> {: .bash}
>
> Run the alignment
> 
> ~~~
> $ bwa mem -M $genome $fq > $sam
> ~~~
> {: .bash}
> 
> As an exercise, try and change your existing script file, from using the `aln` method to the `mem` method.
{: .callout}

-->

Shell-scripts-with-loops-genomics-Shell.md