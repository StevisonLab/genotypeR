#! /usr/bin/perl
# Input file is a multi-sample VCF file
# Creates bed files that contain all of the usable SNPs for the sample
# Created: May 15, 2017
# Last Updated: May 17, 2017
# Author: Laurie Stevison

use warnings;
use strict;

# Specify the filename on the command line
my $input  = $ARGV[0];
my $platform = $ARGV[1];

#test for user arguments
unless ($#ARGV==1) {
    print STDERR "Please provide input VCF filename on command line and platform desired (e.g. \"gg\" or \"sq\").\n\n";
    die;
} #end unless

my $output = "Pop_Sample_SNPs.txt";
my $counter = 1;
my $potential_S1 = "";
my @S1_SNPs =();
my @S1_chr_array =();
my $chr = "";
my $snp_chr = "";
open INPUT, $input or die "Could not open file $input: $!.\n";
open OUTPUT, "> $output" or die $!;

my $lineNumber  = 1;
my $in_a_snp_S1 = 0;

#assign num flanking sites based on user defined platform or prints error
my $NUM_FLANKING_SITES = 0;
if ($platform eq "gg") {
    $NUM_FLANKING_SITES = 50;
} elsif ($platform eq "sq") {
    $NUM_FLANKING_SITES = 100;
} else {
    print STDERR "Error: please provide platform name as either \"gg\" or \"sq\" for Golden Gate or Sequenom, respectively.\n";
    die;
} #end if

# loops for every line of the file
while (<INPUT>) {
    chomp;

    if ($_=~/^#/) {
	next;
    } #end if

    my @input=split(/\s+/,$_);
    
    # gets chromosome name
    $chr = $input[0];

    # if the SNP has 100 base pairs before
    if ($input[4]!~/\./ && $counter>$NUM_FLANKING_SITES && length($input[4])==1) {  
	$potential_S1 = $input[1];
	$snp_chr = $input[0];
	$in_a_snp_S1=1;
	$counter=0;
	# if the SNP has 100 base pairs before
    } elsif ($input[4]!~/\./ || length($input[3])!=1) { #resets if there is another snp before 100 sites are encountered
	$in_a_snp_S1=0;
	$counter=0;
    } #end if
    $counter++;
    $lineNumber++;
    
    # adds potential SNP to the appropriate array if there are 100 base pairs after it
    if ($counter > $NUM_FLANKING_SITES && $snp_chr eq $chr){
	if ($in_a_snp_S1 == 1) {
	    push @S1_SNPs, $potential_S1;
	    push @S1_chr_array, $chr;
	    $counter = 1;
	    $in_a_snp_S1 = 0;
	} #end if
    } #end if
} #end while

# makes headers for the output files
print OUTPUT "Chrom\tStart\tEnd\n";

# adds good SNPs to the output files
my $j;
for ($j = 0; $j <= $#S1_SNPs; $j++) {
    my $start = $S1_SNPs[$j] - $NUM_FLANKING_SITES;
    my $end = $S1_SNPs[$j] + $NUM_FLANKING_SITES+1;
    print OUTPUT "$S1_chr_array[$j]\t$start\t$end\n";
}
