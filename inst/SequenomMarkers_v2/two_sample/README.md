# Genotype Markers With Two Samples

Both of the VCF files must be unzipped before beginning this pipeline.
`````shell
gunzip Sample1.vcf.gz
`````
Make sure the VCF files are in the same folder as the [wrapper](https://github.com/StevisonLab/genotypeR/blob/master/inst/SequenomMarkers_v2/two_sample/Pipeline_rapper_two_sample.sh) and script files. 

To run the entire pipeline, run the wrapper script on the command line and input the two VCF files. An example is below.

Example for GoldenGate:
`````shell
./Pipeline_Rapper_two_sample.sh Sample1.vcf Sample2.vcf gg
`````

Example for Sequenom:
`````shell
./Pipeline_Rapper_two_sample.sh Sample1.vcf Sample2.vcf sq
`````
The test files used are [Sample1.vcf](https://github.com/StevisonLab/genotypeR/blob/master/inst/SequenomMarkers_v2/two_sample/test_files/Sample1.vcf) and [Sample2.vcf](https://github.com/StevisonLab/genotypeR/blob/master/inst/SequenomMarkers_v2/two_sample/test_files/Sample2.vcf). 

<br />
<br />

The following steps are run through the wrapper script, but they could be executed separately.
#### Step 1
The first step is comparing the two samples to each other and to the refrence genome. This step uses VCFtools to find the alternate SNPs in each of the samples.

This line of code is in the file [Pipeline_Rapper_two_sample.sh](https://github.com/StevisonLab/genotypeR/blob/master/inst/SequenomMarkers_v2/two_sample/R_Pipeline_rapper_two_sample.sh), and compares the samples.
`````shell
vcftools --vcf ${vcf_1} --diff ${vcf_2} --diff-site --out ${out_dir}/Sample1_v_Sample2.out
`````
The sample output of step 1 is [Sample1_v_Sample2.out.diff.sites_in_files](https://github.com/StevisonLab/genotypeR/blob/master/inst/SequenomMarkers_v2/two_sample/test_files/Sample1_v_Sample2.out.diff.sites_in_files).

#### Step 2
The [Finding_SNPs_two_sample.pl](https://github.com/StevisonLab/genotypeR/blob/master/inst/SequenomMarkers_v2/two_sample/Finding_SNPs_two_sample.pl) script is used to find the SNPs that are at least 100 or 50 bases apart, depending on the platform. It will create two bed files, Sample1_SNPs.txt and Sample2_SNPs.txt, that contain the chromosome, start position, and end position for each SNP in that sample.

The wrapper script uses the following command to execute step 2.
`````shell
./Finding_SNPs_two_sample.pl Sample1_v_Sample2.out.diff.sites_in_files sq
`````

#### Step 3
The [Grandmaster_SNPs_two_sample.pl](https://github.com/StevisonLab/genotypeR/blob/master/inst/SequenomMarkers_v2/two_sample/Grandmaster_SNPs_two_sample.pl) script is used to make a file containing the chromosome, start position, end position, and the sequence, which contains 100 bases or 50 bases, the SNP, and 100 or 50 more bases on the other side. **The SNP is printed as [REFERNCE/ALTERNATE].**

The wrapper script uses the following command to execte step 3.
`````shell
./Grandmaster_SNPs_two_sample.pl Sample1.vcf Sample2.vcf
`````
