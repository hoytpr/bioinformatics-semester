---
layout: page
title: K-mers and coverage for estimating genomes
---
(This discussion is paraphrased. For the actual online discussion about K-mers and coverage, there is **[this old post](https://groups.google.com/forum/#!topic/abyss-users/RdR6alqM7e8)**; OR: You can see an [archived copy here]({{ site.baseurl }}/materials/extras/kmers-and-coverage-post)

### K-mer coverage and genome size

**How do I estimate the genome size based on the k-mer coverage using Abyss?** I've
seen people do this, but which output from ABySS should be used and how? 
Would appreciate your thoughts on it.

### Answer:

***Look for this message in the log file:***

```
$ grep -B2 -A4 reconstruction abyss.log
Using a coverage threshold of 4...
The median k-mer coverage is 19
The reconstruction is 4641461
The k-mer coverage threshold is 4.36
Setting parameter e (erode) to 4
Setting parameter E (erodeStrand) to 1
Setting parameter c (coverage) to 4.36
```

Here the genome size is estimated to be 4641461 bp based on the k-mer
coverage. 

This number is also close to the number of **distinct** (unique)
k-mers in the assembly, which is also an estimate of the genome size. To find this
use:
```
$ grep ^Assembled abyss.log
Assembled 4548589 k-mer in 1791 contigs
```

### Response:

That preditcion by ABySS is based on kmer coverage but, is there a 
more accurate estimate of coverage to get closer to 100% of the genome?

For example, in Sanger sequencing, the [Lander-Waterman model](https://en.wikipedia.org/wiki/DNA_sequencing_theory#Lander-Waterman_theory) states that with 10x
genomic coverage by capillary reads you should have 100% of the genome represented
(assuming that there is no bias in the sequencing).

So, how exactly does the kmer coverage to calculate this? 
Wouldn't this depend on how people ran their sequencing? Different methods have
different biases and using K-mers seems like it would under-represent
certain regions of genomes. We've been trying to 
predict genome size using K-mers, and it works for simulated reads but not for *real data*.
(The Lander-Waterman model only works for longer reads).

### Also:
 	
Our experience is that k-mer coverage estimates are different from 
actual genome sizes. For example, we have a genome which should be ~600 Mb, 
but using K-mers, the estimates are between 200-500 Mb. This varies depending 
on sequencing methods, datasets, and parameters we use for assembly. 
There are definitely biases in the sampling of our genome. Should the assembly size
be closer to k-mer estimate?

### SJ's definitive answer:	

ABySS uses an iterative algorithm to estimate the k-mer coverage and
genome size. It first finds the median k-mer coverage. The threshold
below which k-mers are ignored is then set to:

`round(sqrt(median_kmer_coverage))`

Those k-mers failing the coverage
threshold are ignored, and the median k-mer coverage is then recalculated.
This iteration is continued until the median k-mer coverage ***converges***.

Other examples of using K-mers to estimate genome sizes are:
The Quake software package (described
in their paper in the section titled `Coverage cutoff').
[Quake software site](http://www.cbcb.umd.edu/software/quake/)

[Manuscript by Kelley, et al. 2010](http://genomebiology.com/2010/11/11/R116#sec4)