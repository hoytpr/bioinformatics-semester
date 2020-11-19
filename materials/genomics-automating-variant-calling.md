---
layout: page
element: notes
title: Automating Genomic Variant Calling
language: Shell
---

#### Questions:
- How can I make my workflow more efficient and less error-prone?

#### Objectives:
- Write a shell script with multiple variables.
- Incorporate a `for` loop into a shell script.

### What is a shell script?

You wrote a simple shell script in a [previous lesson]({{ site.baseurl }}/materials/genomics-data-and-writing-scripts) that we used to extract bad reads from our
FASTQ files and put them into a new file. 

Here's the script you wrote:

~~~
grep -B1 -A2 NNNNNNNNNN *.fastq > scripted_bad_reads.txt
echo "Script finished!"
~~~

That script was only two lines long, but shell scripts can be much more sophisticated
and can be used to perform a large number of operations on one 
file. This saves you the effort of having to re-type each of those commands for
each of your data files and makes your work less error-prone and more reproducible. 
For example, the variant calling workflow we just carried out had about eight steps
where we had to type a command into our terminal. Most of these commands were pretty 
long. If we wanted to do this for all six of our data files, that would be forty-eight
steps. If we had 50 samples (a more realistic number), it would be 400 steps! You can
see why we want to automate this.

We've also used `for` loops in previous lessons to iterate one or two commands over multiple input files. 
In these `for` loops you used variables to enable you to run the loop on multiple files. We will be using variable 
assignments like this in our new shell scripts.

Here's the `for` loop you wrote for unzipping `.zip` files: 

~~~
$ for filename in *.zip
> do
> unzip $filename
> done
~~~

And here's the one you wrote for running Trimmomatic on all of our `.fastq` sample files.

~~~
$ for infile in *.fastq
> do
> outfile=$infile\_trim.fastq
> java -jar ~/Trimmomatic-0.32/trimmomatic-0.32.jar SE $infile $outfile SLIDINGWINDOW:4:20 MINLEN:20
> done
~~~

In this lesson, we will create **two shell scripts**. 

### First Script: Analyzing Quality with FastQC

We'll combine each of the commands we used to run FastQC and 
process the output files into a single file with a `.sh` (the Bash script) extension. This script will include creating our summary file. 

Let's create a new directory named `scripts` and then use the command `touch` to create a new file where we will write our shell script. Remember, we used
`nano` to create and open a new file, but the command `touch` allows us to create a new file without opening that file.

~~~
$ cd ~/dc_workshop
$ mkdir scripts
$ cd scripts
$ touch read_qc.sh
$ ls 
read_qc.sh
~~~

We now have an empty file called `read_qc.sh` in our `scripts/` directory. 
Open `read_qc.sh` in `nano` and start building our script.

~~~
$ nano read_qc.sh
~~~

Use `nano` to place the following pieces of code into your shell script (not into your terminal prompt).

Our first line will move us into the `untrimmed_fastq/` directory when we run our script.

~~~
cd ~/dc_workshop/data/untrimmed_fastq/
~~~

These next two lines will give us a status message to tell us that we are currently running FastQC, then will run FastQC
on all of the files in our `~/dc_workshop/data/untrimmed_fastq/` directory 
with a `.fastq.gz` extension. Remember that to run FastQC, we have 
to load the module first. Then we call the program as `fastqc` and give it 
the path and the file names.

~~~
echo "Running FastQC ..."
module load fastqc
fastqc ~/dc_workshop/data/untrimmed_fastq/*.fastq.gz
~~~
{: .output}

Our next line will create a new directory to hold our FastQC output files. Here we are using the `-p` option for `mkdir`. This 
option forces `mkdir` to create the new directory, even if one of the parent directories doesn't already exist. It is a good
idea to use this option in your shell scripts to avoid running into errors if you don't have the directory structure you think
you do.

~~~
mkdir -p ~/dc_workshop/results/fastqc_untrimmed_reads
~~~

Our next three lines first give us a status message to tell us we are saving the results from FastQC, then moves all of the files
with a `.zip` or a `.html` extension to the directory we just created for storing our FastQC results. 

~~~
echo "Saving FastQC results..."
mv *.zip ~/dc_workshop/results/fastqc_untrimmed_reads/
mv *.html ~/dc_workshop/results/fastqc_untrimmed_reads/
~~~
{: .output}

The next line moves us to the results directory where we've stored our output.

~~~
cd ~/dc_workshop/results/fastqc_untrimmed_reads/
~~~
{: .output}

The next five lines should look very familiar. First we give ourselves a status message to tell us that we're unzipping our `.zip`
files. Then we run our `for` loop to unzip all of the `.zip` files in this directory. 
Remember that in a script it is extremely important to use **four spaces** to indent the `for` loop's
internal lines!!

~~~
echo "Unzipping..."
for filename in *.zip
    do
    unzip $filename
    done
~~~
{: .output}

Next we concatenate all of our summary files into a single output file, with a status message to remind ourselves that this is 
what we're doing.

~~~
echo "Saving summary..."
cat */summary.txt > ~/dc_workshop/docs/fastqc_summaries.txt
~~~
{: .output}

Finally, let's add one more line to let us know the script completed the last steps
successfully"

~~~
echo "Summary file completed"
~~~

> ### Using `echo` statements
> 
> We've used `echo` commands to add ***progress statements*** to our script. Our script will print these statements
> as it is running and therefore we will be able to see how far our script has progressed.
> When using a `.pbs` file to submit jobs, the outputs will go to the job output
> file (e.g. `read-test.o<job-number>`). If our script fails, we will use the `echo` outputs 
> to track how far the script got before an error message is displayed (if any). 
> We can then check for
> error messages in this file by opening it in `nano` or displaying it to the screen
> using the command `cat read-test.o<job-number> | less`. We will ***always*** want to check
> this output file!
{: .callout}

Your full shell script should now look like this (extra blank lines are used for clarity):

~~~
cd ~/dc_workshop/data/untrimmed_fastq/

echo "Running FastQC ..."
module load fastqc
fastqc ~/dc_workshop/data/untrimmed_fastq/*.fastq.gz

mkdir -p ~/dc_workshop/results/fastqc_untrimmed_reads

echo "Saving FastQC results..."
mv *.zip ~/dc_workshop/results/fastqc_untrimmed_reads/
mv *.html ~/dc_workshop/results/fastqc_untrimmed_reads/

cd ~/dc_workshop/results/fastqc_untrimmed_reads/

echo "Unzipping..."
for filename in *.zip
    do
    unzip $filename
    done

echo "Saving summary..."
cat */summary.txt > ~/dc_workshop/docs/fastqc_summaries.txt

echo "Summary file completed"
~~~

Save your file and exit `nano`. We can now create a `.pbs` file that
will run our script. If we were operating "interactively" (not using `.pbs` files)
we could run the script by typing:

~~~
$ bash read_qc.sh
~~~

So our `.pbs` file will be similar. First we use `nano` to create the `.pbs` file that 
contains the following:

~~~
#!/bin/bash
#PBS -q express
#PBS -l nodes=1:ppn=1
#PBS -l walltime=1:00:00
#PBS -j oe
cd $PBS_O_WORKDIR
bash ~/dc_workshop/scripts/read_qc.sh
~~~

save this file as **`read-test.pbs`** and exit `nano`

Now submit the `.pbs` (Yes we are using a submission script, to run our script)

~~~
qsub read-test.pbs
~~~

Make a note of the job number and check to see when you script completes.
After the script completes, open the job output file using `cat read-test.o<job-number> | less`. You should see something similar to this:

~~~
Running FastQC ...
Started analysis of SRR097977.fastq
Approx 5% complete for SRR097977.fastq
Approx 10% complete for SRR097977.fastq
Approx 15% complete for SRR097977.fastq
Approx 20% complete for SRR097977.fastq
Approx 25% complete for SRR097977.fastq
. 
. 
. 
~~~

Because we have already run FastQC on these samples files and generated all of the outputs 
our older files will be overwritten (if they are generated in the same directory). That is
okay. 

<!--

If we were working interactively on a cloud, we could use the same commands, but we would be
prompted to decide to overwrite the old files. You can choose `A` to overwrite "all" the 
old files. 
~~~
replace SRR097977_fastqc/Icons/fastqc_icon.png? [y]es, [n]o, [A]ll, [N]one, [r]ename:
~~~

-->

### Automating the Rest of our Variant Calling Workflow

Now we will create a second shell script to complete the other steps of our variant calling
workflow. To do this, we will take all of the individual commands that we wrote before, put them into a single file, 
add variables so that
the script knows to iterate through our input files and do a few other formatting that
we'll explain as we go. This is very similar to what we did with our `read_qc.sh` script, but will be a bit more complex.

Our variant calling workflow will do the following steps

1. Index the reference genome for use by bwa and samtools
2. Align reads to reference genome
3. Convert the format of the alignment to sorted BAM, with some intermediate steps.
4. Calculate the read coverage of positions in the genome
5. Detect the single nucleotide polymorphisms (SNPs)
6. Filter and report the SNP variants in VCF (variant calling format)

We will be creating a script together to do all of these steps. 

First, we will create a new script in our `scripts/` directory using `touch`. 

~~~
$ cd ~/dc_workshop/scripts
$ touch run_variant_calling.sh
$ ls 
~~~

~~~
read_qc.sh  run_variant_calling.sh
~~~

We now have a new empty file called `run_variant_calling.sh` in our `scripts/` directory. We will open this file in `nano` and start
building our script, like we did before.

~~~
$ nano run_variant_calling.sh
~~~

Enter the following pieces of code into your shell script (not into your terminal prompt).

First we start with a little trick: `set -e` which tells our script to exit immediately if there is an error. This does two things: When we fail, we fail FAST, and second it will let us know where the problem was in our script. 
We follow this by changing our working directory so that we can create new results subdirectories
in the right location. 

~~~
set -e
cd ~/dc_workshop/results
~~~

Next we tell our script where to find the reference genome by assigning the `genome` variable to 
the path to our reference genome: 

~~~
genome=~/dc_workshop/data/ref_genome/ecoli_rel606.fasta
~~~
{: .output}

> #### Creating Variables
> Within the Bash shell you can create variables at any time (as we did
> above, and during the 'for' loop lesson). Assign any name and the 
> value using the assignment operator: '='. You can check the current
> definition of your variable by typing into your script: echo $variable_name. 
{: .callout}

Next we index our reference genome for BWA. Note on Cowboy, and other HPCs with modules, the command is:

~~~
module load bwa
bwa index $genome
~~~
{: .output}

Without modules, or on a cloud instance, the command is:
~~~
bwa index $genome
~~~
{: .output}
We will now create the directory structure to store our results: 

~~~
mkdir -p sai sam bam bcf vcf
~~~
{: .output}

Then we use a **loop** to run the variant calling workflow on each of our FASTQ files. We've already used Trimmomatic to trim these files, and we could re-do that here, but to save time, we will use the smaller files we've already trimmed in the `data/trimmed_fastq_small/` directory. (You might want to try this later on the bigger files in the `data/trimmed_fastq/` directory.) We will use absolute paths so that all these commands
within the loop will be executed once for each of the FASTQ files in the `data/trimmed_fastq_small/` directory.
We will include a few `echo` statements to give us status updates on our progress.

The first thing we do is assign the name of the FASTQ files we're currently working with to a variable called `fq` and
tell the script to `echo` the filename back to us so we can check which file we're on.

~~~
for fq in ~/dc_workshop/data/trimmed_fastq_small/*.fastq
    do
    echo "working with file $fq"
    done
~~~
{: .bash}


> #### Indentation
> 
> All of the statements within your `for` loop (i.e. everything after the `for` line and including the `done` line) 
> need to be indented with four spaces. This indicates to the shell interpretor that these statements are all part of the `for` loop
> and should be done for each line in the `for` loop.
> 
{: .callout}

This is a good time to check that our script is assigning the FASTQ filename variables correctly. Save your script and run it on a captured node.

~~~
$ bash run_variant_calling.sh
~~~
{: .bash}

~~~
[bwa_index] Pack FASTA... 0.04 sec
[bwa_index] Construct BWT for the packed sequence...
[bwa_index] 1.10 seconds elapse.
[bwa_index] Update BWT... 0.03 sec
[bwa_index] Pack forward-only FASTA... 0.02 sec
[bwa_index] Construct SA from BWT and Occ... 0.64 sec
[main] Version: 0.7.5a-r405
[main] CMD: bwa index /home/dcuser/dc_workshop/data/ref_genome/ecoli_rel606.fasta
[main] Real time: 1.892 sec; CPU: 1.829 sec
working with file /home/dcuser/dc_workshop/data/trimmed_fastq_small/SRR2584863_1.trim.sub.fastq
working with file /home/dcuser/dc_workshop/data/trimmed_fastq_small/SRR2584863_2.trim.sub.fastq
working with file /home/dcuser/dc_workshop/data/trimmed_fastq_small/SRR2584866_1.trim.sub.fastq
working with file /home/dcuser/dc_workshop/data/trimmed_fastq_small/SRR2584866_2.trim.sub.fastq
working with file /home/dcuser/dc_workshop/data/trimmed_fastq_small/SRR2589044_1.trim.sub.fastq
working with file /home/dcuser/dc_workshop/data/trimmed_fastq_small/SRR2589044_2.trim.sub.fastq
~~~

You should see "working with file . . . " for each of the six FASTQ files in our `trimmed_fastq_small/` directory.
If you don't see this output, then you'll need to troubleshoot your script. A common problem is that your directory might not
be specified correctly. Ask for help if you get stuck here! 

Now that we've tested the components of our loops so far, we will add our next few steps. Open the script with `nano`, remove the line `done` from the end of
your script, and add the next two (indented) lines. These lines extract the **base name** of the file
(excluding the path and `.trim.sub.fastq` extension) and assign it
to a new variable called `base`. Add `done` again at the end so we can test our script.

~~~
    base=$(basename $fq .trim.sub.fastq)
    echo "base name is $base"
    done
~~~
{: .output}

Now if you save and run your script, the final lines of your output should look like this: 

~~~
working with file /home/dcuser/dc_workshop/data/trimmed_fastq_small/SRR2584863_1.trim.sub.fastq
base name is SRR2584863_1
working with file /home/dcuser/dc_workshop/data/trimmed_fastq_small/SRR2584863_2.trim.sub.fastq
base name is SRR2584863_2
working with file /home/dcuser/dc_workshop/data/trimmed_fastq_small/SRR2584866_1.trim.sub.fastq
base name is SRR2584866_1
working with file /home/dcuser/dc_workshop/data/trimmed_fastq_small/SRR2584866_2.trim.sub.fastq
base name is SRR2584866_2
working with file /home/dcuser/dc_workshop/data/trimmed_fastq_small/SRR2589044_1.trim.sub.fastq
base name is SRR2589044_1
working with file /home/dcuser/dc_workshop/data/trimmed_fastq_small/SRR2589044_2.trim.sub.fastq
base name is SRR2589044_2
~~~
{: .output}

For each file, you see two statements printed to the terminal window. This is because we have two `echo` statements. The first
tells you which file the loop is currently working with. The second tells you the base name of the file. This base name is going
to be used to create our output files.

Next we will create variables to store the names of our output files as paired-end read files. This will make your script easier
to read because you won't need to type out the full name of each of the files. We're using the `base` variable that we just
defined, and ***adding different file name extensions*** to represent the files. 
We can use the `base` variable to access both the `base_1.fastq` and `base_2.fastq` input files, and create variables to store the names of our output files. 
Remember to delete the `done` line from your script before adding these (indented) lines.

~~~
    # input files
    fq1=~/dc_workshop/data/trimmed_fastq_small/${base}_1.trim.sub.fastq
    fq2=~/dc_workshop/data/trimmed_fastq_small/${base}_2.trim.sub.fastq
    
    # output files
    sam=~/dc_workshop/results/sam/${base}.aligned.sam
    bam=~/dc_workshop/results/bam/${base}.aligned.bam
    sorted_bam=~/dc_workshop/results/bam/${base}.aligned.sorted.bam
    raw_bcf=~/dc_workshop/results/bcf/${base}_raw.bcf
    variants=~/dc_workshop/results/bcf/${base}_variants.vcf
    final_variants=~/dc_workshop/results/vcf/${base}_final_variants.vcf    
~~~
{: .output}

Now that we've created our variables, we can start running the steps of our workflow. Remember that on Cowboy, or an HPC with modules, you need to load the module each time. If you are on a cloud instance, you can ignore the `module load..` commands.

1) align the reads to the reference genome and output a `.sam` file:

~~~
    module load bwa
    bwa mem $genome $fq1 $fq2 > $sam
~~~
{: .output}

2) convert the SAM file to BAM format:

~~~
    module load samtools/1.9
    samtools view -S -b $sam > $bam
~~~
{: .output}

3) sort the BAM file:

~~~
    samtools sort -o $sorted_bam $bam 
~~~
{: .output}

4) index the BAM file for display purposes:

~~~
    samtools index $sorted_bam
~~~
{: .output}

5) calculate the read coverage of positions in the genome:

~~~
    module load bcftools/1.9
    bcftools mpileup -O b -o $raw_bcf -f $genome $sorted_bam 
~~~
{: .output}

6) call SNPs with bcftools:

~~~
    bcftools call --ploidy 1 -m -v -o $variants $raw_bcf 
~~~
{: .output}

7) filter and report the SNP variants in variant calling format (VCF):

~~~
    vcfutils.pl varFilter $variants  > $final_variants
~~~
{: .output}

**Your final script should look like this:**

~~~
set -e
cd ~/dc_workshop/results

genome=~/dc_workshop/data/ref_genome/ecoli_rel606.fasta

module load bwa
bwa index $genome

mkdir -p sam bam bcf vcf

for fq1 in ~/dc_workshop/data/trimmed_fastq_small/*_1.trim.sub.fastq
    do
    echo "working with file $fq1"

    base=$(basename $fq1 _1.trim.sub.fastq)
    echo "base name is $base"

    fq1=~/dc_workshop/data/trimmed_fastq_small/${base}_1.trim.sub.fastq
    fq2=~/dc_workshop/data/trimmed_fastq_small/${base}_2.trim.sub.fastq
    sam=~/dc_workshop/results/sam/${base}.aligned.sam
    bam=~/dc_workshop/results/bam/${base}.aligned.bam
    sorted_bam=~/dc_workshop/results/bam/${base}.aligned.sorted.bam
    raw_bcf=~/dc_workshop/results/bcf/${base}_raw.bcf
    variants=~/dc_workshop/results/bcf/${base}_variants.vcf
    final_variants=~/dc_workshop/results/vcf/${base}_final_variants.vcf 

    module load bwa
    bwa mem $genome $fq1 $fq2 > $sam
    module load samtools/1.9
    samtools view -S -b $sam > $bam
    samtools sort -o $sorted_bam $bam
    samtools index $sorted_bam
    module load bcftools/1.9
    bcftools mpileup -O b -o $raw_bcf -f $genome $sorted_bam
    bcftools call --ploidy 1 -m -v -o $variants $raw_bcf 
    vcfutils.pl varFilter $variants > $final_variants
   
    done
~~~
{: .output}

> ### Exercise
> It's a good idea to add comments to your code so that you (or a collaborator) can make sense of what you did later. 
> Look through your existing script. Discuss with a neighbor where you should add comments. Add comments (anything following
> a `#` character will be interpreted as a comment, bash will not try to run these comments as code). 
{: .challenge}

Now we can run our script:
With Cowboy, we will create a submission script (below). On a cloud instance the simple command is:
~~~
$ bash run_variant_calling.sh
~~~
{: .bash}

Here is a submissions script made with `nano` named `bigscript.pbs`
```
#!/bin/bash 
#PBS -q express 
#PBS -l nodes=1:ppn=1 
#PBS -l walltime=1:00:00 
#PBS -j oe
cd $PBS_O_WORKDIR 
bash run_variant_calling.sh
```
submit: `qsub bigscript.pbs`

**CONGRATULATIONS!** You have created a powerful pipeline taking raw fastq data, and generating 
a file with all the sequence variations mapped to a reference genome! You can use this pipeline over and over again by swapping out the fastq files and the reference genome. 

***Nelle would be proud!***

### Keypoints:
- We can combine multiple commands into a shell script to automate a workflow.
- Use `echo` statements within your scripts to get an automated progress update.


