---
layout: page
title: Syllabus
catalog: BIOC 6820
credits: 3
semester: Fall 2019
professor: Dr. Peter R. Hoyt
office: Room 110FC in the HBRC Building 
email: Peter.r.hoyt@okstate.edu
phone: 405-744-6206
schedule: ['TBD']
location: Self-paced
office_hours: Tuesdays 10-11am
office_hours_location: 110FC HBRC
---

## {{ site.title }}

{{ page.catalog }}, {{ page.credits }} Credits, {{ page.semester }}

### OSU Spring 2019 Syllabus Attachment
Located at https://github.com/hoytpr/bioinformatics-semester/blob/gh-pages/docs/Spring-2019-Syllabus-Attachment.pdf

### Professor

{{ page.professor }}

Office: {{ page.office }}

Email (best way to contact us):
[{{ page.email }}](mailto:{{ page.email }})

Phone: {{ page.phone }}


### Location

{{location}}


### Times

{% for class in page.schedule %}
  {{ class }}
{% endfor %}


### Office Hours

Times: {{ page.office_hours }}

Location: {{ page.office_hours_location }}

Or by appointment. *Note: my schedule gets very busy during the semester so
please try to schedule appointments as far in advance as possible. In general it
will be very difficult to set up appointments less than 24 hours in advance.*

### Website

The syllabus and other relevant class information and resources will be posted
at [{{ site.url}}]({{ site.baseurl }}/).
Changes to the schedule will be posted to this site so please try to check it
periodically for updates.


### Course Communications

Email: [{{ page.email }}](mailto:{{ page.email }})


### Required Texts

There is no required text book for this class.


### Course Description

Computers are increasingly essential to the study of all aspects of
biology. The course seeks to improve cross-disciplinary understanding and
will be taught using R and SQLite, but the concepts learned will easily apply to
all programming languages and database management systems. No background in
programming or databases is required.


### Prerequisite Knowledge and Skills

Knowledge of basic biology.


### Purpose of Course

By the end of the course you will be able to use bioinformatic tools to import data 
into proper formats for genomics, perform analysis on that data, and export the results to graphs, text files, and
databases. 

### Course Goals and Objectives

Students completing this course will be able to:

* Create well structured databases
* Extract information from databases
* Write simple computer programs in the BASH shell or Python
* Automate data analysis
* Apply these tools to address biological questions


### How this course relates to the Student Learning Outcomes 

This course contributes to the interdisciplinary techniques required to generate, 
analyze, and interpret complex biologically derived datasets as part of genomics and
by providing students the skills and knowledge they need to use bioinformatics tools
used in research.


### Teaching Philosophy

This class is taught using learner-centered approach, because
learning to program and work with data requires actively working on
computers. Self-motivation to learn the coding involved is required
and often produces a better learning outcome. 


## Course Policies


### Attendance Policy

Attendance will not be taken or factor into the grades for this class. However,
experience suggests that students who postpone exercises tend to struggle 
to learn the material.


### Quiz/Exam Policy

There are no quizzes or exams in this course.


### Make-up policy

Life happens and therefore there is an automatic grace period of 48 hours for
the submission of late assignments with no need to request an extension.
However, it is highly recommended that you submit assignments on time when
possible because assignments build on one another and it can be hard to catch up
if you fall behind. Reasonable requests for longer extensions will also be granted.


### Assignment policy

Assignments are due Monday night by 11:59 pm Eastern Time. Assignments should be
submitted via [email](mailto:peter.r.hoyt@okstate.edu). This allows you to be finished with one week's material
before starting the next week's material.


### Course Technology

Students are required to provide their own laptops/desktops and to install free and open
source software on those computers (see [Setup]({{ site.baseurl }}/computer-setup)
for installation instructions). Support will be provided by the instructor in
the installation of required software. If you need but don't have access to a suitable
computer please contact the instructor and they will do their best to provide you with
one.


## OSU Policies


### University Policy on Accommodating Students with Disabilities

Students requesting accommodation for disabilities must first register with the
Student Disability ofice (http://sds.okstate.edu/). The Dean of Students
Office will provide documentation to the student who must then provide this
documentation to the instructor when requesting accommodation. You must submit
this documentation prior to submitting assignments or taking the quizzes or
exams. Accommodations are not retroactive, therefore, students should contact
the office as soon as possible in the term for which they are seeking
accommodations.


### University Policy on Academic Misconduct

Academic honesty and integrity are fundamental values of the University
community. Students should be sure that they understand the OSU Acedemic Integrity
Code at https://academicintegrity.okstate.edu/content/academic-integrity-resources.


### Netiquette and Communication Courtesy

All members of the class are expected to follow rules of common
courtesy in all email messages, threaded discussions and chats.


## Getting Help

* Counseling and Wellness resources
* Disability resources
* Resources for handling student concerns and complaints
* Library Help Desk support

**Most importantly, if you are struggling for any reason please come talk to me
and I will do my best to help.**


## Grading Policies

Grading for this course is tentatively based on 13 equally weighted assignments. 
Some assignments (selected at the instructors discretion after the
assignments have been submitted) will receive a thorough code review and a
detailed grade. Other problems will be graded as follows:

* Produces the correct answer using the requested approach: 100%
* Generally uses the right approach, but a minor mistake results in an incorrect
    answer: 90%
* Attempts to solve the problem and makes some progress using the core concept:
    50%
* Answer demonstrates a lack of understanding of the core concept: 0%

Independent projects may focus on databases, programming, or a combination or
the two.

### Grading scale

- **A 93-100**
- **A- 90-92**
- **B+ 87-89**
- **B 83-86**
- **B- 80-82**
- **C+ 77-79**
- **C 73-76**
- **C- 70-72**
- **D+ 67-69**
- **D 60-66**
- **E <60**


## Course Schedule

The details course schedule is available on the course website at:
[{{ site.url }}/schedule]({{ site.baseurl }}/schedule).


**Disclaimer:** This syllabus represents my current plans and objectives. As we
go through the semester, those plans may need to change to enhance the class
learning opportunity. Such changes will be communicated clearly both on the
website and in class.
