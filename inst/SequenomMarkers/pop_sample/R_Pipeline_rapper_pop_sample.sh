#!/bin/sh
# Uses vcftools to compare samples
# Input the file names in zipped format on the command line.
# Created: April 3, 2017
# Last Updated: April 3, 2017
# Author: Magdalena Castronova; amended for inclusion in R package Stephen A. Sefick (20170417)
# vcftools v0.1.14+

script_dir=$1
out_dir=$2
pop_vcf=$3
which_one=$4

mkdir -p ${out_dir}
cd ${out_dir}
echo "Starting step one..."
if [ ${which_one} == "gg" ]; then

    ${script_dir}/Finding_SNPs_pop_sample.pl $pop_vcf gg
    #echo "I chose gg"
else
    if [ ${which_one} == "sq" ]; then
	    ${script_dir}/Finding_SNPs_pop_sample.pl $pop_vcf sq
	    #echo "I chose sq"
	    fi
fi

echo "Step one complete!\n"
echo "Starting step two..."
${script_dir}/Grandmaster_SNPs_pop_sample.pl ${pop_vcf}
echo "Step three complete!\n"