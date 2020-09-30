---
layout: page
title: Instance
---

### What is an "instance"?

An instance is like renting your own little supercomputer. 

Huge computing systems like Amazon's AWS and Microsoft's Azure are 
willing to offer you a piece of their systems, for a price. 
It's pretty simple really. Try thinking about it as if you are building 
your own desktop computer, but a *super big* one. 

If you have a big project, and need a supercomputer, you can
ask these big companies for exactly what you need. You request the **operating system**
(usually based on the software you want to run), request the **memory** (RAM) you'll need
(often one of the more difficult things to calculate), and request the number of
**processors** you think you'll need to complete the calculations as fast as possible. 
Finally, you request the **storage space** for installing the software, the working datafiles, 
and all the outputs files that will be produced.

After determining all those needs, you use your credit card to have AWS 
"start up an instance" (Like pushing the power button on your *super* desktop) 
for you with all those parameters. Sometimes you have to choose 
from a predetermined combination of parameters (e.g. "small", "medium", "large") that 
include the minimum requirements for your project. ***Starting*** up an instance 
means the remote system accumulates those requirements for you, sets them apart for only you to use
and usually installs the operating system. You can give this instance a name (e.g. "Nelles-pipeline")

***Setting*** up an instance means installing everything you need for your project. You will 
access your instance using `ssh` which will put you into a Shell. Once in the 
Shell, you create a file structure, with directories for input files and output 
files as needed. Then install all your software for the analyses. Finally, you 
either upload your working data into the 
correct directories of the instance, 
or you can download the data you want (for example from a big online database) 
into the correct folders of your instance.

AWS will save all this information for you as long as you keep paying them. 
You can come back to your running instance 
whenever you want. It's important to understand that you are being charged money 
while your instance is running. Plan ahead to save money, and when your analyses 
are complete, and you've downloaded (or transferred) your results, do NOT forget
to "terminate" your instance so that charges stop. 

Terminating your instance will essentially delete it, but you can usually return 
to AWS and request your instance **by name** to be re-started. A exact copy of 
your instance will be rebuilt (including the software, but not your datafiles) 
and you can start another analysis. 

Go Back to the [Working with Genomic Data Lesson]({{ site.baseurl }}/materials/genomics-data-and-writing-scripts#Getting)
to begin moving data using clouds and remote systems.

