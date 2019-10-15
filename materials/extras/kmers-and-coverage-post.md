---
layout: page
title: K-mers and coverage post
---

Kmer coverage and genome size
6 posts by 3 authors
	GM 	
5/2/11
How do I estimate the genome size based on the k-mer coverage? I've
seen people do that, but am not quite sure which output from ABySS to
use (coverage.hist?) and how to do it. Would appreciate your thoughts
on it.

Thanks
GM
	Shaun Jackman 	
5/2/11


Hi Gaurav,

Look for this message in the log file:

$ grep -B2 -A4 reconstruction abyss.log
Using a coverage threshold of 4...
The median k-mer coverage is 19
The reconstruction is 4641461
The k-mer coverage threshold is 4.36
Setting parameter e (erode) to 4
Setting parameter E (erodeStrand) to 1
Setting parameter c (coverage) to 4.36

Here the genome size is estimated to be 4641461 bp based on the k-mer
coverage. This number should be pretty close to the number of distinct
k-mer in the assembly, which is likely a better estimate of the actual
genome size:

$ grep ^Assembled abyss.log
Assembled 4548589 k-mer in 1791 contigs

Cheers,
Shaun

Alejandro Sanchez 	
5/2/11
Other recipients: sjac...@bcgsc.ca, gaura...@gmail.com
Hi Shaun and GM,

Sorry for being nosey but the preditcion of the ABySS will be based on
the kmer coverage but, what would be the coverage that will correspond
to something close to 100% of the genome?

In Sanger sequencing, the Lander-Waterman model states that with 10x
coverage of capillary reads you will have the genome represented 100%
assuming that there is no bias in the sequencing.

So, how do you use the kmer coverage to calculate this? Especially
when depending on how people ran their sequencing will have a certain
bias and under-representation of certain regions of their genomes. I'm
just curious because we've been trying to predict genome size using
kmers and it works for simulated reads but not for real data.
Obviously, the Lander-Waterman model didn't work for short reads.

Again, is very honest question and would like to know what other people think.

Cheers.

 	GM 	
5/2/11
Hi Alejandro,

I agree with you. My experience (whatever little bit I have with my
genome) is that k-mer coverage can be significantly off the actual
size. my genome, based on c-value, is ~600 Mb and I'm getting k-mer
estimates between 200-500 Mb, depending on what method, sequencing
dataset and parameters we use for assembly. There are definitely
biases in the sampling of our genome. The assembly size too is not
necessarily close to k-mer estimate (should it be though?).

I know this is not what you asked, maybe Shaun could provide a better
answer.

gaurav
- show quoted text -
	Shaun Jackman 	
5/2/11
Other recipients: arro...@gmail.com, gaura...@gmail.com
Hi Alejandro,

ABySS uses an iterative algorithm to estimate the k-mer coverage and
genome size. It first finds the median k-mer coverage. The threshold
below which k-mer are ignored is then set to
round(sqrt(median_kmer_coverage)). Those k-mer failing the coverage
threshold are ignored, and the median k-mer coverage is recalculated.
This iteration is continued until the median k-mer coverage converges.

The Quake software package uses a different method, which they describe
in their paper in the section titled `Coverage cutoff'.
http://www.cbcb.umd.edu/software/quake/
http://genomebiology.com/2010/11/11/R116#sec4

Cheers,
Shaun