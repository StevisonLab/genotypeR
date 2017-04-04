#!/bin/sh
# Uses vcftools to compare samples
# Input the file names in zipped format on the command line.
# Created: April 3, 2017
# Last Updated: April 3, 2017
# Author: Magdalena Castronova
# vcftools v0.1.14+

module load vcftools

echo "Starting step one..."
vcftools --gzvcf $1 --gzdiff $2 --diff-site --out Sample1_v_Sample2.out
echo "Step one complete!\n"
echo "Starting step two..."
./Finding_SNPs.pl Sample1_v_Sample2.out.diff.sites_in_files
echo "Step two complete!\n"
echo "Starting step three..."
./Grandmaster_SNPs.pl $1 $2
echo "Step three complete!\n"
