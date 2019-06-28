---
layout: exercise
topic: Genomics
title: Genomics Automated Run Variant Calling
language: Shell
---
Uncomment below to work on exercise

<!--

### Assignment Exercise 1

#### Remembering shell scripts
Uncomment below to work on this exercise

<!--
### Key objectives:
- "Write a shell script with multiple variables."
- "Incorporate a `for` loop into a shell script."


Write a simple shell script to extract bad reads from the following FASTQ files.  
Put the list of ALL the bad reads from all the files in a file named SR01_S1_bad-reads.txt

*(Change the files to the exercise files)*

[SR01_S1_L001_R1_001.fastq.gz]({{ site.base.url }}/data/SR01_S1_L001_R1_001.fastq.gz)

[SR01_S1_L002_R1_001.fastq.gz]({{ site.base.url }}/data/SR01_S1_L002_R1_001.fastq.gz)

[SR01_S1_L003_R1_001.fastq.gz]({{ site.base.url }}/data/SR01_S1_L003_R1_001.fastq.gz)

[SR01_S1_L001_R4_001.fastq.gz]({{ site.base.url }}/data/SR01_S1_L001_R4_001.fastq.gz)

Use the following EXAMPLE script and change it to using 400 files using `for` loops 
Hint: use `n <- [1:400]`

~~~
$ for filename in *.zip
> do
> unzip $filename
> done
~~~

Use the following EXAMPLE script and change it to using 400 files using `for` loops
~~~
$ for infile in *.fastq
> do
> outfile=$infile\_trim.fastq
> java -jar ~/Trimmomatic-0.32/trimmomatic-0.32.jar SE $infile $outfile SLIDINGWINDOW:4:20 MINLEN:20
> done
~~~

#### Using `echo` statements

Change the script in above to echo the status of the trimmomatic process for each file

Hint: try using:
```
echo "Running FastQC on " $filename
```

#### Reproduce our variant calling workflow 

1. Index the reference genome for use by bwa and samtools
2. Align reads to reference genome
3. Convert the format of the alignment to sorted BAM, with some intermediate steps.
4. Calculate the read coverage of positions in the genome
5. Detect the single nucleotide polymorphisms (SNPs)
6. Filter and report the SNP variants in VCF (variant calling format)


~~~
genome=~/dc_workshop/data/ref_genome/ecoli_rel606.fasta
~~~

#### Creating Variables
Assign any name and the 
value using the assignment operator: '='. AND check the current
definition of your variable (by typing into your script: echo $variable_name) 

#### Index our reference genome for BWA.

~~~
bwa index $genome
~~~

#### How can you check the directory structure ofour results from: 

~~~
mkdir -p sai sam bam bcf vcf
~~~

str()

summary()

#### Indentation
Do statements within your `for` loop need to be indented? 
Run the following loop, then get rid of the indents.
What happens?
(output)

### Assignment Exercise 2

Check if our script is assigning the FASTQ filename variables correctly. 

Write a script that uses the base name "money" from a set of files in a folder
(give a list of five files money1.fastq, etc)

NOTE: These lines extract the base name of the file
(excluding the path and `.fastq` extension) and assign it
to a new variable called `base` variable. Add `done` again at the end so we can test our script.

~~~
    base=$(basename $fq .fastq_trim.fastq)
    echo "base name is $base"
    done
~~~

Use an `echo` statements for the base name of the file
to create output files in the above script and 

store the names of our output files as variables. 

Remember to delete the `done` line from your script before adding these lines.

~~~
    fq=~/dc_workshop/data/trimmed_fastq_small/$base\.fastq_trim.fastq
    sai=~/dc_workshop/results/sai/$base\_aligned.sai
    sam=~/dc_workshop/results/sam/$base\_aligned.sam
    bam=~/dc_workshop/results/bam/$base\_aligned.bam
    sorted_bam=~/dc_workshop/results/bam/$base\_aligned_sorted.bam
    raw_bcf=~/dc_workshop/results/bcf/$base\_raw.bcf
    variants=~/dc_workshop/results/bcf/$base\_variants.bcf
    final_variants=~/dc_workshop/results/vcf/$base\_final_variants.vcf     
~~~

#### Describe the lines above in detail

Now that we've created our variables, we can start doing the steps of our workflow. Remove the `done` line from the end of
your script and add the following lines. 

### Assignment Exercise 3

1) align the reads to the reference genome and output a `.sai` file:

~~~
    bwa aln $genome $fq > $sai
~~~

2) convert the output to SAM format:

~~~
    bwa samse $genome $sai $fq > $sam
~~~

3) convert the SAM file to BAM format:

~~~
    samtools view -S -b $sam > $bam
~~~

4) sort the BAM file:

~~~
    samtools sort -f $bam $sorted_bam
~~~

5) index the BAM file for display purposes:

~~~
    samtools index $sorted_bam
~~~

6) do the first pass on variant calling by counting
read coverage

~~~
    samtools mpileup -g -f $genome $sorted_bam > $raw_bcf
~~~

7) call SNPs with bcftools:

~~~
    bcftools view -bvcg $raw_bcf > $variants
~~~

8) filter the SNPs for the final output:

~~~
    bcftools view $variants | /usr/share/samtools/vcfutils.pl varFilter - > $final_variants
    done
~~~

We added a `done` line after the SNP filtering step because this is the last step in our `for` loop.

Your script should now look like this:

~~~
cd ~/dc_workshop/results

genome=~/dc_workshop/data/ref_genome/ecoli_rel606.fasta

bwa index $genome

mkdir -p sai sam bam bcf vcf

for fq in ~/dc_workshop/data/trimmed_fastq_small/*.fastq
    do
    echo "working with file $fq"

    base=$(basename $fq .fastq_trim.fastq)
    echo "base name is $base"

    fq=~/dc_workshop/data/trimmed_fastq_small/$base\.fastq_trim.fastq
    sai=~/dc_workshop/results/sai/$base\_aligned.sai
    sam=~/dc_workshop/results/sam/$base\_aligned.sam
    bam=~/dc_workshop/results/bam/$base\_aligned.bam
    sorted_bam=~/dc_workshop/results/bam/$base\_aligned_sorted.bam
    raw_bcf=~/dc_workshop/results/bcf/$base\_raw.bcf
    variants=~/dc_workshop/results/bcf/$base\_variants.bcf
    final_variants=~/dc_workshop/results/vcf/$base\_final_variants.vcf 

    bwa aln $genome $fq > $sai
    bwa samse $genome $sai $fq > $sam
    samtools view -S -b $sam > $bam
    samtools sort -f $bam $sorted_bam
    samtools index $sorted_bam
    samtools mpileup -g -f $genome $sorted_bam > $raw_bcf
    bcftools view -bvcg $raw_bcf > $variants
    bcftools view $variants | /usr/share/samtools/vcfutils.pl varFilter - > $final_variants
    done
~~~
{: .output}

Add comments to your code so that you (or a collaborator) can make sense of what you did later. 

Now we can run our script:

~~~
$ bash run_variant_calling.sh
~~~

### Exercise 4
#### BWA variations

BWA-backtrack, `aln + samse + sampe` 

BWA-SW `bwasw` 

BWA-MEM, `mem`

*Trick question:*

 BWA-backtrack is designed for Illumina sequence reads up to 100bp, while the rest two are better fitted for 
longer sequences ranged from 70bp to 1Mbp. A general rule of thumb is to use `bwa mem` for reads longer than 70 bp, whereas 
`bwa aln` has a moderately higher mapping rate and a shorter run 
time for short reads (~36bp). 

Read the indepth discussion in the [bwa doc page](http://bio-bwa.sourceforge.net/bwa.shtml) as well as in this 
[blog post](http://crazyhottommy.blogspot.ca/2017/06/bwa-aln-or-bwa-mem-for-short-reads-36bp.html).

### Important NOTES:

In this lesson we have been using the `aln` for performing the 
alignment, but the same process can be performed with `bwa mem` 
which doesn't require the creation of the index files. The 
process is modified starting from `mkdir` step, and omitting all 
directories relevant to the `.sai` index files, *i.e.*:

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
 

#### As an exercise, try and change your existing script file, from using the `aln` method to the `mem` method.

### Keypoints:
- "We can combine multiple commands into a shell script to automate a workflow."
- "Use `echo` statements within your scripts to get an automated progress update."
-->



