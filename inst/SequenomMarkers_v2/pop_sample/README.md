# Genotype Markers With Two Samples

The VCF file must be unzipped before beginning this pipeline.
`````shell
gunzip Pop_sample.vcf.gz
`````
Make sure the VCF file is in the same folder as the [wrapper](https://github.com/mcastronova/genotypeR/blob/master/inst/SequenomMarkers_v2/pop_sample/R_Pipeline_rapper_pop_sample.sh) and script files. 

To run the entire pipeline, run the wrapper script on the command line and input the VCF file. An example is below.
`````shell
./R_Pipeline_rapper_pop_sample.sh Pop_sample.vcf
`````
The test file used is [Pop_sample.vcf](https://github.com/mcastronova/genotypeR/blob/master/inst/SequenomMarkers_v2/pop_sample/test_files/Pop_sample.vcf.zip).

<br />
<br />

The following steps are run through the wrapper script, but they could be executed separately.
#### Step 1
The [Finding_SNPs_pop_sample.pl](https://github.com/mcastronova/genotypeR/blob/master/inst/SequenomMarkers_v2/pop_sample/Finding_SNPs_pop_sample.pl) script is used to find the SNPs that are at least 100 or 50 bases apart, depending on the platform. It will create a bed file, Pop_Sample_SNPs.txt, that contain the chromosome, start position, and end position for each SNP in that sample.

The wrapper script uses the following command to execute step 1.
Example for GoldenGate:
`````shell
./Finding_SNPs_pop_sample.pl Pop_sample.vcf gg
`````
Example for Sequenom:
`````shell
./Finding_SNPs_pop_sample.pl Pop_sample.vcf sq
`````

#### Step 2
The [Grandmaster_SNPs_pop_sample.pl](https://github.com/mcastronova/genotypeR/blob/master/inst/SequenomMarkers_v2/pop_sample/Grandmaster_SNPs_pop_sample.pl) script is used to make a file containing the chromosome, start position, end position, and the sequence, which contains 100 bases or 50 bases, the SNP, and 100 or 50 more bases on the other side. **The SNP is printed as [REFERNCE/ALTERNATE].**

The wrapper script uses the following command to execte step 2.
`````shell
./Grandmaster_SNPs_pop_sample.pl Pop_sample_SNPs.txt
`````
