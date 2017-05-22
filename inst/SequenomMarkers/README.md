# Genotype Markers

Pipeline to design genotype markers. This was built to design markers for the Sequenom platform, but can be adapted for others. This pipeline requires VCFtools v0.1.14+.

Both of the VCF files must be unzipped before beginning this pipeline.
`````shell
gunzip FS14_test.vcf
`````
Make sure the VCF files are in the same folder as the wrapper and script files. 

To run the entire pipeline, run the wrapper script on the command line and input the two VCF files. An example is below.
`````shell
./Pipeline_Rapper.sh FS14_test.vcf F16_test.vcf
`````
The test files used are [FS14_test.vcf](https://github.com/mcastronova/SequenomMarkers/blob/master/FS14_test.vcf) and [FS16_test.vcf](https://github.com/mcastronova/SequenomMarkers/blob/master/FS16_test.vcf). 

#### Step 1
The first step is comparing the two samples to each other and to the refrence genome. This step uses VCFtools to find the alternate SNPs in each of the samples.

This line of code is in the file [Pipeline_Rapper.sh](https://github.com/mcastronova/SequenomMarkers/blob/master/Pipeline_Rapper.sh), and compares the samples.
`````shell
vcftools --vcf $1 --diff $2 --diff-site --out Sample1_v_Sample2.out
`````
The sample output of step 1 is [Sample1_v_Sample2.out.diff.sites](https://github.com/mcastronova/SequenomMarkers/blob/master/Sample1_v_Sample2.out.diff.sites_in_files).

#### Step 2
The [Finding_SNPs.pl](https://github.com/mcastronova/SequenomMarkers/blob/master/Finding_SNPs.pl) script is used to find the SNPs that are at least 100 bases apart. It will create two bed files, Sample1_SNPs.txt and Sample2_SNPs.txt, that contain the chromosome, start position, and end position for each SNP in that sample.

The wrapper script uses the following command to execute step 2.
`````shell
./Finding_SNPs.pl Sample1_v_Sample2.out.diff.sites_in_files
`````
The sample output files for step 2 are [Sample1_SNPs.txt](https://github.com/mcastronova/SequenomMarkers/blob/master/Sample1_SNPs.txt) and [Sample2_SNPs.txt](https://github.com/mcastronova/SequenomMarkers/blob/master/Sample2_SNPs.txt).

#### Step 3
The [Grandmaster_SNPs.pl](https://github.com/mcastronova/SequenomMarkers/blob/master/Grandmaster_SNPs.pl) script is used to make a file containing the chromosome, start position, end position, and the sequence, which contains 100 bases, the SNP, and 100 more bases on the other side. **The SNP is printed as [REFERNCE/ALTERNATE].**

The wrapper script uses the following command to execte step 3.
`````shell
./Grandmaster_SNPs.pl FS14_test.vcf F16_test.vcf
`````

The sample outputs of step 3 are [Master_SNPs.txt](https://github.com/mcastronova/SequenomMarkers/blob/master/Master_SNPs.txt) and [Master_SNPs.sorted.txt](https://github.com/mcastronova/SequenomMarkers/blob/master/Master_SNPs.sorted.txt).
