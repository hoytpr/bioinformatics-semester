---
layout: page
element: notes
title: Genomics Shell Intro
language: Shell
---

### Starting Genomics

In previous lessons, you learned how to use the bash shell to interact with your computer through a command line interface. In this lesson, you will be applying this new knowledge to a more genomics oriented shell, located on a remote supercomputer (or even a remote cloud service). We will spend most of our time learning about the basics of the shell by manipulating some experimental data. Some of the data we’re going to be working with is quite large, and we’re also going to be using several bioinformatics packages in later lessons to work with this data. To avoid having to spend time downloading the data and downloading and installing all of the software, we’re going to be working with data on a remote server.

### Objectives

* Review Shell usage
* Describe key reasons for learning shell.
* Navigate your file system using the command line.
* Access and read help files for bash programs and use help files to identify useful command options.
* Demonstrate the use of tab completion, and explain its advantages.

#### What is a shell and why should I care?

* Many bioinformatics tools can only be used through a command line interface, or have extra capabilities in the command line version that are not available in the GUI. This is true, for example, of BLAST, which offers many advanced functions only accessible to users who know how to use a shell.
* The shell makes your work less boring. In bioinformatics you often need to do the same set of tasks with a large number of files. Learning the shell will allow you to automate those repetitive tasks and leave you free to do more exciting things.
* The shell makes your work less error-prone. When humans do the same thing a hundred different times (or even ten times), they’re likely to make a mistake. Your computer can do the same thing a thousand times with no mistakes.
* The shell makes your work more reproducible. When you carry out your work in the command-line (rather than a GUI), your computer keeps a record of every step that you’ve carried out, which you can use to re-do your work when you need to. It also gives you a way to communicate unambiguously what you’ve done, so that others can check your work or apply your process to new data.
* Many bioinformatic tasks require large amounts of computing power and can’t realistically be run on your own machine. These tasks are best performed using remote computers or cloud computing, which can only be accessed through a shell.

As you progress through this lesson, keep in mind that, even if you aren’t going to be doing this exact same workflow in your research, you will be learning some very important lessons about using command-line bioinformatics tools. What you learn here will enable you to use a variety of bioinformatic tools with confidence and greatly enhance your research efficiency and productivity.

This lesson assumes no prior experience with the tools covered in the workshop. However, learners are expected to have some familiarity with biological concepts, including the concept of genomic variation within a population. This lesson is originally part of a workshop that uses data hosted on an Amazon Machine Instance (AMI). We will be working with the Cowboy supercomputer at Oklahoma State University. The access to the required data is provided on the Data Carpentry [Genomics Workshop setup](http://www.datacarpentry.org/genomics-workshop/setup.html) page.

### Setup Prerequisites

* You will need an account on the Cowboy supercomputer in the HPCC of Oklahoma State University. 
* You will need to [install "Putty"](https://hpcc.okstate.edu/content/logging-cowboy) if you are using a Windows machine.

#### Logging onto a Remote server

##### Connecting using PC

1. Open Putty
2. Paste in the ‘Host Name (or IP address)’ section the IP address provided by your instructor (or the IP address of an instance you have provisioned yourself e.g. cowboy.hpc.okstate.edu)

 *Keep the default selection ‘SSH’ and Port (22)*

 ![Putty Configuration](/fig/putty_screenshot_1.png)
 
 ### Review the File System
 
 The part of the operating system responsible for managing files and directories is called the file system. It organizes our data into files, which hold information, and directories (also called “folders”), which hold files or other directories. Several commands are frequently used to create, inspect, rename, and delete files and directories. 

3. Click ‘Open’ (You will be presented with a security warning)

![Putty warning](https://datacarpentry.org/cloud-genomics/fig/putty_screenshot_2.png)

4. Select ‘Yes’ to continue to connect

5. In the final step, you will be asked to provide a login and password
	Note: When typing your password, it is common in Unix/Linux not see any asterisks (e.g. `**) or moving cursors. Just continue typing
	
  ![Putty login](/fig/Putty-logon1.png)

If you type the command: PS1='$ ' into your shell, followed by pressing the <kbd>Enter</kbd> key, your prompt should change to look like `$`. This isn’t necessary to follow along (in fact, your prompt may have other helpful information you want to know about). This is up to you! The dollar sign is a prompt, which shows us that the shell is waiting for input; your shell may use a different character as a prompt and may add information before the prompt. When typing commands, either from these lessons or from other sources, do not type the prompt, only the commands that follow it.

Let’s find out where we are by running the command `pwd` (remember this stands for “print working directory”). At any moment, our current working directory is our current default directory, i.e., the directory that the computer assumes we want to run commands in unless we explicitly specify something else. Here, the computer’s response is `/home/<username>`, which is the home directory within system.


