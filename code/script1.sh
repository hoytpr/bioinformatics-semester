# bin bash
mkdir ../data/unzip-SR01
cd ../data
for filename in *.fastq.gz
do
  echo $filename
  #  set unzippedname = $filename
  gzip -dN $filename 
  mv *.fastq unzip-SR01/
done
cd unzip-SR01/
for filename2 in *.fastq
do
   echo $filename2
   grep -B1 -A2 NNNNNNNNNN $filename2 >> SR01_S1_bad-reads.txt
done