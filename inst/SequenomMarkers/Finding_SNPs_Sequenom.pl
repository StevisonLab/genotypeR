#! /usr/bin/perl
# Used vcftools --diff --diff-site, specified in step 1, to compare Sample1 and 
# Sample2
# Creates bed files that contain all of the usable SNPs for the sample
# Created to work on one chromosome at a time
# Created: February 29, 2016
# Last Updated: April, 2017
# Author: Magdalena Castronova

use warnings;
use strict;

# Specify the filename on the command line
my $input  = $ARGV[0];

my $output = "Sample2_SNPs.txt";
my $output2 = "Sample1_SNPs.txt";
my $counter = 1;
my $potential_S1 = "";
my $potential_S2 = "";
my @S1_SNPs =();
my @S1_chr_array =();
my @S2_SNPs =();
my @S2_chr_array =();
my $chr = "";
open INPUT, $input or die "Could not open file $input: $!\n";
open OUTPUT, "> $output" or die $!;
open OUTPUT2, "> $output2" or die $!;

my $lineNumber  = 1;
my $in_a_snp_S1 = 0;
my $in_a_snp_S2 = 0;
my $header=<INPUT>;

my $NUM_FLANKING_SITES = 100;

# loops for every line of the file
while (<INPUT>) {
	chomp;
	my @input=split(/\s+/,$_);
	
	# gets chromosome name
 	$chr = $input[0];

	# if the SNP has 100 base pairs before and is in the second sample only
	if ($input[3]=~/B/ && $input[6]!~/\./ && $input[7]=~/\./ && $counter>=$NUM_FLANKING_SITES) {  
		$potential_S2 = $input[1];
		$in_a_snp_S2  = 1;
		$in_a_snp_S1  = 0;
		$counter=1;
	# if the SNP has 100 base pairs before and is in the first sample only
	} elsif ($input[3]=~/B/ && $input[6]=~/\./ && $input[7]!~/\./ && $counter>=$NUM_FLANKING_SITES) { 
		$potential_S1 = $input[1];
		$in_a_snp_S1  = 1;
		$in_a_snp_S2  = 0;
		$counter=1;
	# if the SNP is not in both samples and doesn't have 100 base pairs 
	# before, it is eliminated
	} elsif ($input[6]!~/\./ || $input[7]!~/\./) {
		$in_a_snp_S2 = 0;
		$in_a_snp_S1 = 0;
		$counter=1;
	}
	$counter++;
	$lineNumber++;
	
	# adds potential SNP to the appropriate array if there are 100 base pairs after it
	if ($counter >= 100){
		if ($in_a_snp_S2 == 1) {
		   push @S2_SNPs, $potential_S2;
		   push @S2_chr_array, $chr;
		   $counter = 1;
		   $in_a_snp_S2=0;
		   $in_a_snp_S1=0;
		} elsif ($in_a_snp_S1 == 1) {
		   push @S1_SNPs, $potential_S1;
		   push @S1_chr_array, $chr;
		   $counter = 1;
		   $in_a_snp_S2 = 0;
		   $in_a_snp_S1 = 0;
		}
	}
}

# makes headers for the output files
print OUTPUT "Chrom\tStart\tEnd\n";
print OUTPUT2 "Chrom\tStart\tEnd\n";

# adds good SNPs to the output files
my $i;
for ($i = 0; $i <= $#S2_SNPs; $i++) {
	my $start = $S2_SNPs[$i] - $NUM_FLANKING_SITES;
	my $end = $S2_SNPs[$i] + $NUM_FLANKING_SITES;
	print OUTPUT "$S2_chr_array[$i]\t$start\t$end\n";
}
my $j;
for ($j = 0; $j <= $#S1_SNPs; $j++) {
	my $start = $S1_SNPs[$j] - $NUM_FLANKING_SITES;
	my $end = $S1_SNPs[$j] + $NUM_FLANKING_SITES;
	print OUTPUT2 "$S1_chr_array[$j]\t$start\t$end\n";
}
