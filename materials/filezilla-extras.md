---
layout: page
title: Using Filezilla for FTP
language: Shell
---

FTP is an acronym for File Transfer Protocol. It allows one to
send and receive files between your desktop/Laptop, and a computer 
on the internet. Filezilla uses a graphical user interface (GUI)
and there are versions for Windows, Macs and Linux... and it's FREE
(although you should consider donating to the developers if you use it often)

Download the correct version of Filezilla for your operating system 
at [this link](https://filezilla-project.org/). Install Filezilla and then launch the software.
You should see something like the image below:

![filezilla first]({{ site.baseurl }}/fig/filezilla-first.png)

Click on "File" then in the dropdown menu click on "Site Manager" (or hit control-S)
to open the site manager window. This window is where you will store all the computers that you access by FTP. In the image below there are many computers already present. If you have never used Filezilla to access Cowboy before, you need to click on the "New" button, and enter "COWBOY" for the New Site name. Then on the right side, enter `cowboy.hpc.okstate.edu` in the box labeled "Host", and change the Protocol using the drop-down menu to `SFTP - SSH File Transfer Protocol`. Leave the "Port" box blank. Change "Logon Type" to `Ask for Password` and then enter your Cowboy username in the "User" box. When this is complete the Site Manger window should like the image below but with your username.

![filezilla site manager]({{ site.baseurl }}/fig/filezilla-site-manager1.png)

Then click on the "Connect" button and the Site Manager window will go away, and you should see a window asking for your Cowboy password. Enter your password and click the "OK" button. You shuld see the main window with "Status:	Connecting to cowboy.hpc.okstate.edu..." in the Remote Message Window, followed by messages saying your home directory listing was successful. There are six windows which are identified below:

![filezilla windows]({{ site.baseurl }}/fig/filezilla-windows.png)

Look carefully at the Remote Directory Window "Remote Site" Title bar. It should say `/panfs/panfs.cluster/home/<username>`. This is your "home" directory on Cowboy. However, you have another "home" directory on Cowboy called your **"scratch"** directory. The "scratch" directory is located at `/panfs/panfs.cluster/scratch/<username>`. To get to this directory, carefully change `/panfs/panfs.cluster/home/<username>` to `/panfs/panfs.cluster/scratch/<username>` and hit <kbd>Enter</kbd>. You should see your Remote Directory Window change to something like the image below:

![filezilla-scratch]({{ site.baseurl }}/fig/filezilla-extra-change-to-scratch.png)

 Your scratch directory is specifically for when you are using large datafiles. Remember that bioinformatics software not only uses large datafiles, but it produces many more, and potentially even larger, datafiles. Your scratch directory allows you to perform bioinformatics analyses without worrying about how much disk space you are using, or how many files you produce. However, once your final files are produced, you must download any data you want to save (or transfer them to your home directory), and then clean up (delete) any remaining files on "scratch". 

With your Local Directory Window set to your "Desktop", scroll through the Local File Window to find the `mcbios.zip` (or `mcbios.tar.gz`) and drag it onto your `/panfs/panfs.cluster/scratch/<username>` Remote File Window. Be careful not to drop the file into any existing folders/directories that may already exist in the Remote file Window. 

That's it! Your `mcbios` file should transfer to your Cowboy `/panfs/panfs.cluster/scratch/<username>` directory in a few seconds 