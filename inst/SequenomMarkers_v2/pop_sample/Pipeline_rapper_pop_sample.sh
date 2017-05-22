#!/bin/sh
# Uses vcftools to compare samples
# Input the file names in an unzipped format on the command line.
# Created: April 3, 2017
# Last Updated: May 19, 2017
# Author: Magdalena Castronova
# vcftools v0.1.14+

echo "Starting step one..."
if [ $2 == "gg" ]; then
    ./Finding_SNPs_pop_sample.pl $1 gg
    #echo "I chose gg"
else
    if [ $2 == "sq" ]; then
	./Finding_SNPs_pop_sample.pl $1 sq
	#echo "I chose sq"
	fi
fi
echo "Step one complete!"
echo "Starting step two..."
./Grandmaster_SNPs_pop_sample.pl $1
echo "Step two complete!"

