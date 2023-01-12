---
layout: page
title: Computer Setup
---

***BIOC 6820 students will need their own laptops or desktops set up with Git Bash before the course begins, R and RStudio need to be installed later. You will need an account on the "Pete" HPC at Oklahoma State, and a personal (free) account on GitHub***

### Shell (most important)

**Windows users** must download the software [Git for Windows](https://gitforwindows.org/) which includes a Shell called "GitBash" (The instructions are shown below under GitHub). GitBash is called an 'emulator' because it simulates a Linux environment, and all the linux commands we will be using are available inside the GitBash terminal window. As a bonus, it installs "Git" which is a command-line interface you will need later in the course when using GitHub for your data. THis
course was developed, maintained, and exists on GitHub.

**Mac users** are fortunate because they only need to use their "Terminal" program for all "windows" or "shells" we use in this class.

### Special Note: 

#### Data Carpentry Genomics Workshop 
Part of this course is designed to follow the [Data Carpentry Genomics Workshop](https://datacarpentry.org/genomics-workshop/), which was FIRST previewed in June 2019. In 2022 and beyond, we will not be using the Amazon Cloud Services. Instead, we will be using the Oklahoma State University "Pete" supercomputer from the OSU HPCC. If you have a powerful enough personal computer\*, you can follow the instructions at Data Carpentry [Option B](https://datacarpentry.org/genomics-workshop/setup.html#option-b-using-the-lessons-on-your-local-machine) to install all the necessary software. However, Windows OS users may not be able to use a single linux emulator (e.g. GitBash, Cygwin) but ***also*** need to use the **Windows 10** (build 14393 or later) Subsystem for Unix-based Applications, to install ["Bash on Ubuntu on Windows10"](https://www.windowscentral.com/how-install-bash-shell-command-line-windows-10).  
 
> \* A 4-8 core processor at > 3.0GHz, at least 16Gb of RAM, at least 500Gb of free disk space on an SSD drive (1 Tb recommended). 


### R

Download and install the most recent [R base system](http://cran.rstudio.com/) and [RStudio](http://www.rstudio.com/products/rstudio/download/). Both are needed. Installing RStudio will not automatically install R.

### GitHub

1. Create an account on GitHub (https://github.com) using the `Sign up for
   GitHub` form on the right side of the page.
2. Email your username to your instructor.
3. Once your instructor adds you to the course's GitHub organization you will
   receive an email asking you to accept the invitation. Click on the link to
   accept.
4. To confirm you are part of the class:
    1. Go to [https://github.com](https://github.com).
    2. Sign in if necessary.
    3. In the upper left corner click on the drop down with your name.
    4. Confirm that the name name of the course GitHub organization is present
    
### Git

#### For Windows

1.  Download the Git for Windows
    [installer](https://git-for-windows.github.io/).
2.  Run the installer and follow the steps bellow:
    1. Click on "Next".
    2. Click on "Next".
    3. **Keep "Use Git from the Windows Command Prompt" selected** and click on
       "Next". If you don't do this, the integration with R will not work
       properly. If this happens rerun the installer and select the appropriate
       option.
    4. Click on "Next".
    5. Keep "Checkout Windows-style, commit Unix-style line endings" selected and click on "Next".
    6. Keep "Use Windows' default console window" selected and click on "Next".
    7. Click on "Install".
    8. Click on "Finish".
3. Check if the installation is working:
    1. Open RStudio
    2. File -> New Project -> Version Control -> Git
    3. If you reach a page called `Clone Git Repository` with some fields to fill out everything is working

#### For Linux

Git is probably already installed. If it is not already available install it via
your distro's package manager. For Debian/Ubuntu run `sudo apt-get install git`
and for Fedora run `sudo yum install git`.

#### For Mac OS X

1. Open up the Terminal, type in "git" and press enter.
2. This should cause a pop-up window to appear. It will have several options;
   click on "Install" (not "Get Xcode").
3. Click "Agree".
4. When the install is finished, click "Done".
5. To make sure this worked, type in "git" in the Terminal and press enter. Some
   information will come up, including a list of common commands. If this
   doesn't work see additional instructions below.
6. Check if git and RStudio are talking to each other:
    1. Open RStudio
    2. File -> New Project -> Version Control -> Git
    3. If you reach a page called `Clone Git Repository` with some fields to
       fill out, everything is working

If the git installation didn't work (i.e., you don't get the expect result from
Step 5), try the following:

For **OS X 10.9 and higher**, install Git for Mac by downloading and running the
most recent "mavericks" installer from
[this list](http://sourceforge.net/projects/git-osx-installer/files/).  After
installing Git, it will not show up in your `/Applications` folder, because
Git is a command line program. For older versions of **OS X (10.5-10.8)**
use the most recent available installer labelled "snow-leopard" [available
here](http://sourceforge.net/projects/git-osx-installer/files/.)

If git and RStudio aren't talking to each other (i.e., you don't get the expect
result from Step 6), try the following:

1. Open RStudio
2. Select the `Tools` menu -> `Global Options` -> `Git/SVN`
3. Next to `Git executable` click `Browse`
4. Navigate to `usr/local/bin/` and double click on `git` (this should change
   the value in `Git executable` from `/usr/bin/git` to `/usr/local/bin/git`)
5. Click `OK`

<!--

### Python

Use [Anaconda](https://www.anaconda.com/download/) to install Python (3.5 or greater) and make sure you 
download the correct version  for your operating system.

### SQL (Optional)

Download and install [DB Browser for SQLite](http://sqlitebrowser.org/)

### Python Notes

*Some Python materials on this site
are no longer under active development. Tell the instructor
if you are having problems*

-->