#!/bin/bash
for esite in *.fastq;
do
echo "grepping "$esite;
grep GAATTC ${esite} >> EcoRI-sites-found.txt;
grep CTTAAG ${esite} >> EcoRI-sites-found.txt;
done
echo "done grepping";
echo "EcoRI-sites-found.txt has "
wc -l < EcoRI-sites-found.txt
echo "lines"
