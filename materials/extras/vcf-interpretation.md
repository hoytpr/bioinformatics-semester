---
layout: page
element: notes
title: VCF Interpretation
language: Shell
---

We are going to start our interpretation of a variant call by using an example from the Broad Institute:

The genotype information for NA12878 at 1:899282.

1   899282  rs28548431  C   T   [CLIPPED] GT:AD:DP:GQ:PL    0/1:1,3:4:26:103,0,26

At this site, the called genotype is `GT = 0/1`, which corresponds to the alleles C/T. The confidence indicated by `GQ = 26` isn't very good, largely because there were only a total of 4 reads at this site (`DP =4`), 1 of which was REF (=had the reference base) and 3 of which were ALT (=had the alternate base) (indicated by `AD=1,3`). The lack of certainty is evident in the PL field, where `PL(0/1) = 0` (the normalized value that corresponds to a likelihood of 1.0) as is always the case for the assigned allele, but the next PL is `PL(1/1) = 26` (which corresponds to 10^(-2.6), or 0.0025). So although we're pretty sure there's a variant at this site, there's a chance that the genotype assignment is incorrect, and that the subject may in fact not be **het** (heterozygous) but be may instead be **hom-var** (homozygous with the variant allele). But either way, it's clear that the subject is definitely not **hom-ref** (homozygous with the reference allele) since `PL(0/0) = 103`, which corresponds to 10^(-10.3), a very small number.

Okay, now let's try the example from the Broad institutes example at position 873762:

1	873762	.	T	G	[CLIPPED]	GT:AD:DP:GQ:PL	0/1:173,141:282:99:255,0,255

Called genotype: 0/1 = T/G a heterozygous allele
Confidence: 99 = MAX
Total Reads: 282
Reads that were from REF: 173
Reads that were from ALT: 141
* Note that of 282 reads 173 were REF and 141 were ALT, for a ratio of 0.61 and 0.5 respectively
* This tells us the locus has about a high a heterozzygosity as can be imagined (50%)
* It also tells us that there were likely a very few instances where the locus was likely **hom-ref**
Certainty metrics 
* PL(0/1) = 0 (the assigned allele)
* PL(1/1) = 255 (corresponds to 10^(-25.5) a very small number)
* PL(0/0) = 255 (corresponds to 10^(-25.5) a very small number)
The GQ is maxxed out at 99 so the certainty is as high as it gets
but it's not **hom-ref** or **hom-var**, and must be **het**

So we're pretty sure there's a variant at this site, and there's not much chance that the genotype assignment is incorrect, and that the subject is **het** (heterozygous).


