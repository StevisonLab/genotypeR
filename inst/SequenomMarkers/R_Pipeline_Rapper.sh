#!/bin/sh
# Uses vcftools to compare samples
# Input the file names in zipped format on the command line.
# Created: April 3, 2017
# Last Updated: April 3, 2017
# Author: Magdalena Castronova
# vcftools v0.1.14+

##module load vcftools

script_dir=$1
out_dir=$2
vcf_1=$3
vcf_2=$4
which_one=$5

mkdir -p ${out_dir}

echo "Starting step one..."
vcftools --vcf ${vcf_1} --diff ${vcf_2} --diff-site --out ${out_dir}/Sample1_v_Sample2.out
cd ${out_dir}
echo "Step one complete!\n"
echo "Starting step two..."

if [ ${which_one} == "gg" ]; then

    ${script_dir}/Finding_SNPsGolden_Gate.pl Sample1_v_Sample2.out.diff.sites_in_files
	#echo "I chose gg"
else
    if [ ${which_one} == "sq" ]; then
	    ${script_dir}/Finding_SNPs_Sequenom.pl Sample1_v_Sample2.out.diff.sites_in_files
		#echo "I chose sq"
	fi
fi

${script_dir}/Grandmaster_SNPs.pl ${vcf_1} ${vcf_2}
echo "Step three complete!\n"
