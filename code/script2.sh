# bin bash
mkdir ../data/unzip-SR01
cd ../data
for filename in *.fastq.gz
do
  echo $filename
  # set unzippedname = $filename
  gzip -dN $filename 
  cp *.fastq unzip-SR01/
done
#  cd unzip-SR01
grep -B1 -A2 NNNNNNNNNN ../data/unzip-SR01/*.fastq >> ../data/unzip-SR01/SR01_S1_bad-reads.txt

