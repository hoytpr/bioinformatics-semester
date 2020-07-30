---
layout: page
title: Paired End Reads
---

### What are "Paired end reads"?

Most sequencers (Illumina) work by breaking up nucleic acids into small fragments, denature them into single strands, and sequence the fragments by generating the opposite strand using polymerases and a signaling reaction (e.g. fluorescence). This is called "Sequencing by synthesis".

In addition, most sequencers can sequence from BOTH ENDs of a single fragment. When this is used, each resulting read from one end, has a corresponding read from the other end. These are paired end reads. Usually, the reads are of similar if not identical lengths and quality. The most common way to present these reads are to store all reads from one end in a file of reads designated "Read-1" and all the reads from the other end in a second file designated "Read-2". When this is done, there should be at least two files for each sample sequenced, each with the exact same number of reads. 

The distance between the reads can vary, but the *linkage* between the reads is used by many assemblers to create more accurate assemblies. For example, on fragment 1234, we know that Read-1 is ***about*** 400bp from Read-2. We can be sure that Read-1 is **not** 4000bp from Read-2. This helps prevent mis-assemblies from occurring. 

![Paired-end Reads]({{ site.baseurl }}/fig/paired-end-reads.png)
(Image credit: Illumina, Inc.)

Be aware that this is very different from "Mate-Pair" libraries, where the distance between Reads of fragment ends are usually **exact** because of different library preparation methods.