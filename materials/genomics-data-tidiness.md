---
layout: page
element: notes
title: Data Tidiness
language: Shell
---
### Questions:

- How to collect and structure the data about your sequencing data

### Objectives:

- Think about and understand the types of metadata a sequencing experiment will generate.
- Understand the importance of metadata and potential metadata standards
- Explore common formatting challenges in spreadsheet data

### Introduction

When we think about the data for a sequencing project, we often start by thinking about the sequencing data that we get back from the sequencing center, but just as important, if not more so, is the data you've generated about the sequences before it ever goes to the sequencing center. This is the ***data about the data***, often called the **metadata**. Without the information about what you sequenced, the sequence data itself is useless.  

> #### Discussion
> With the person next to you, discuss:
>
> What kinds of data and information have you generated before you send your DNA/RNA off for sequencing?
>

[Click here for some answers]({{ site.baseurl }}/exercises/Genomics-sequence-file-metadata-Shell)

All of the data and information just discussed can be considered metadata ("data about the data"). There are a few guidelines for metadata that are important to follow.

### Notes

Notes about your experiment, including how you prepared your samples for sequencing, should be in your lab notebook, whether that's a physical lab notebook or electronic lab notebook. For guidelines on good lab notebooks, see the Howard Hughes Medical Institute "Making the Right Moves: A Practical Guide to Scientifıc Management for Postdocs and New Faculty" section on
[Data Management and Laboratory Notebooks](http://www.hhmi.org/sites/default/files/Educational%20Materials/Lab%20Management/Making%20the%20Right%20Moves/moves2_ch8.pdf).


Including dates on your lab notebook pages, the samples themselves and in
any records about those samples helps you keep everything associated 
together properly. Using dates also helps create unique identifiers, 
because even
if you process the same sample twice, you don't usually do it on the same
day, or if you do, you're aware of it and give them names like A and B.

> ### Unique identifiers
> Unique identifiers are a unique name for a sample or set of sequencing data.
> They are names for that sample (or data) that *only exist* 
> for that sample or data. Having these
> unique names makes them much easier to track later.

### Data about the experiment

Data about the experiment is usually collected in spreadsheets, like Excel.

What type of data to collect depends on your experiment and 
you should always check to see if guidelines for metadata standards
with your type of experiment.

> ### Metadata standards
> Many disciplines have specific ways to structure their metadata 
> so it's consistent and can be used by others in the same discipline.
>
> The Digital Curation Center maintains [a list of metadata  standards](http://www.dcc.ac.uk/resources/metadata-standards/list) and include standards that are particularly relevant for genomics data. These are available from the [Genomics Standards Consortium](http://gensc.org/projects/).
>
> If there aren't metadata standards already, you should consider what 
> is the minimum amount of information needed for someone to understand 
> and work with your data, without talking to you.

### Structuring data in spreadsheets

Independent of the type of data you're collecting, there are standard ways to enter data into any spreadsheet, making it easier to analyze later. We often enter data that makes it easy for us as humans to read and work with it, because we're human! 

But ***computers*** need data structured in a way that they can use it, so to use our data in a computational workflow, we need to think like computers when we use spreadsheets.

**The cardinal rules of using spreadsheet programs for data:**

- Leave the raw data raw - don’t change it! Make a backup **first!**
- Put each *observation* or *sample* in its own row.
- Put all your *variables* in columns - the thing that varies between samples, like ‘strain’ or ‘DNA-concentration’.
- Have column names be explanatory, but **without spaces**. Use dashes " - ", or underscores " _ " or [camel case](https://en.wikipedia.org/wiki/Camel_case) instead of a space. For instance "library-prep-method" or "LibraryPrep" is better than "prep" because "prep" isn't very informative, and you should not use "library preparation method" because computers recognize and interpret spaces in specific ways.
- Don’t combine multiple pieces of information in one cell. Sometimes it just seems like one piece of information, but think if there is more than one way 
you’ll want to be able to use, or sort, that data. For example, you might want to use sample information from "Group1_Area3" as "G1A3", but it would be better to separate out columns "sample_group" and "sample_area" so you can sort by those values independently.
- Export the **cleaned** data to a text-based format like CSV (comma-separated values) format. This ensures that anyone can use the data, and CSV is the format required by most data repositories.

> ### Exercise
> This is some potential spreadsheet data generated about a sequencing experiment. With the person next to you, for about 2 minutes, discuss some of the problems with the spreadsheet data shown above. You can look at the image, or [download the file to your computer via this link](https://github.com/datacarpentry/organization-genomics/raw/gh-pages/files/Ecoli_metadata_composite_messy.xlsx) and open it in a spreadsheet reader like Excel. 

[![Messy spreadsheet]({{ site.baseurl }}/fig/01_tidiness_datasheet_example_messy.png)](https://github.com/datacarpentry/organization-genomics/raw/gh-pages/files/Ecoli_metadata_composite_messy.xlsx)

After discussing this, **[click here for some solutions]({{ site.baseurl }}/exercises/Genomics-messy-data-Shell)**.

### Further notes on data tidiness

Data organization at the earliest point of your experiment will help 
facilitate your analysis later, as well as prepare your data 
and notes for data deposition now often required by journals 
and funding agencies. If this is a collaborative project, as 
most projects are now, it's also information that collaborators 
will need to interpret. "Tidy" data are very useful 
for communication and efficiency.

Fear not! If you have already started your project, and it's 
not set up this way, there are still opportunities to make 
updates. One of the biggest and most common challenges 
in genomics is tabular data (tables of data) that 
aren't formatted so computers can use them, or have inconsistencies 
that make them hard to analyze.

More practice on how to structure data is outlined in our [Data Carpentry Ecology spreadsheet lesson](http://www.datacarpentry.org/spreadsheet-ecology-lesson/02-common-mistakes/)

Tools like [OpenRefine](http://www.datacarpentry.org/OpenRefine-ecology-lesson/) are VERY POWERFUL tools that can help you clean your tabular data.

### Keypoints:

- Metadata is essential for you and others to be able to work with your data
- Tabular data needs to be structured to work with it effectively. 



