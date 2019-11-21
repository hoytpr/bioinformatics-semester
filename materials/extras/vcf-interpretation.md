---
layout: page
element: notes
title: VCF Interpretation
language: Shell
---

We are going to start our interpretation of a variant call by using the exact words from the Broad Institute:

Here are the alleles we are describing:
![allele in excel]({{ site.baseurl }}/fig/vcf-from-broad.png)

### Example 1:

The genotype information for NA12878 at 1:899282.

`1   899282  rs28548431  C   T   [CLIPPED] GT:AD:DP:GQ:PL    0/1:1,3:4:26:103,0,26`

(Where it says "clipped" we just omitted a lot of annotation). 
"At this SNP site, the called genotype is `GT = 0/1`, which corresponds to the alleles C/T. This can be confusing, because one might think the "GT" 
is the genotype `G/T`, but it is not. The confidence indicated by `GQ = 26` isn't very good, largely because there were only a total of 4 reads at this site (`DP =4`), 1 of which was REF (=had the reference base) and 3 of which were ALT (=had the alternate base) (indicated by `AD=1,3`). The lack of certainty is evident in the PL field, where `PL(0/1) = 0` (the normalized value that corresponds to a likelihood of 1.0) **as is always the case for the assigned allele**, but the next PL is `PL(1/1) = 26` (which corresponds to 10^(-2.6), or 0.0025). So although we're pretty sure there's a variant at this site, there's a chance that the genotype assignment is incorrect, and that the subject may in fact not be **het** (heterozygous) but be may instead be **hom-var** (homozygous with the variant allele). But either way, it's clear that the subject is definitely not **hom-ref** (homozygous with the reference allele) since `PL(0/0) = 103`, which corresponds to 10^(-10.3), a very small number."

### Example 2:

Now let's try explaining the example from the Broad institutes example at position 873762. 
We'll use our own words:

`1	873762	.	T	G	[CLIPPED]	GT:AD:DP:GQ:PL	0/1:173,141:282:99:255,0,255`

The called genotype is T/G, and the genotype metric (GT) has the value: 0/1 = a heterozygous allele (**het**)

The confidence metric (GQ) has a value of 99 which is the **MAXIMUM** value you can assign (all confidence levels are capped at 99)

The total "raw" reads depth metric (DP) has a value of 282 reads.

The allelic reads metric (AD) shows there were 173 reads from REF genome and 141 reads from the ALT genome.
* Note that of 282 reads, 141 were ALT, for a ratio of exactly 0.5
* This tells us the locus has about a nearly perfect heterozygosity score (141/282 = 50%)
* Also, because 173 + 141 = 314 reads, which is greater than the `DP` "total" reads metric (282), it means some reads were not scored.

The certainty metrics are shown as (PL) values for each type of allele (always shown as 'REF/ALT')
* PL(0/1) "heterozygous at REF allele" or **het** = 0 (the assigned allele is always normalized to zero)
* PL(1/1) "homozygous at ALT allele" or **hom-var** = 255 (this corresponds to 10^(-25.5) a very small number)
* PL(0/0) "homozygous with the REF allele" or **hom-ref**= 255 (this corresponds to 10^(-25.5) a very small number)

CONCLUSIONS: It's definitely not **hom-ref** or **hom-var**, and must be **het**. And the confidence metric GQ is maxxed out at 99 so 
the certainty is as high as it can get!

Therefore:   
 
 1. we're very sure there's a variant at this site, and 
 2. there's not much chance the genotype assignment is incorrect, and 
 3. the sample is **het** (heterozygous) for T/G at this locus.

Note that a GT allele assignment of 1/1 (**hom-ref**) will have a PL score of `<something>,<something>,0` 
because the assigned allele is always normalized to zero. 
