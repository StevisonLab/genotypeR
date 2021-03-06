#! /usr/bin/perl
# Creates master.out file that contain SNPs and 100 base pairs on either side
# Created: May 15, 2017
# Last Updated: May 16, 2017
# Author: Laurie Stevison

use warnings;
use strict;

#check OS for sys commands
my $windows=($^O=~/Win/)?1:0;# Are we running on windows?

# Removes the file from the directory using a sys command based on OS
if ($windows==1) {
    unlink "Master_SNPs.txt";
} else {
    system("rm -f Master_SNPs.txt");
} #end if

# Specifies the inputs and outputs
my $input   = "Pop_Sample_SNPs.txt";
my $input2  = $ARGV[0];
my $output  = "Master_SNPs.txt";
open INPUT, $input or die "Could not open file $input: $!\n";
open INPUT2, $input2 or die "Could not open file $input2: $!\n";
open OUTPUT,  ">> $output" or die $!;

# SAMPLE 1
# Loops through the text file
while (<INPUT>) {
    
    # Splits the input into an array so specific elements can be referenced
    chomp;
    my @s1snps = split(/\s+/,$_);
    
    # Gets rid of the header
    if ($s1snps[0] eq "Chrom") {
	next;
    }
    
    # Sets variables from the text file
    my $SNP_start = $s1snps[1]/1;
    my $SNP_end = $s1snps[2]/1;
    my $chrom = $s1snps[0];
    my @temp = ();
    my $is_consecutive = 0;
    my $prev_pos = $SNP_start;
    
    # Loops through the VCF file
    while (<INPUT2>) {
	
	# Splits the input into an array so specific elements can be referenced
	chomp;
	my @sample1 = split(/\s+/,$_);
	
	# Removes the header
	if ($sample1[0] =~ /^#/) {
	    next;
	}
	
	# Finds the positions in the VCF between the start and end values
	my $pos = $sample1[1]/1;
	if (int($pos) < int($SNP_start)) {
	    $prev_pos = $pos;
	    next;
	} elsif (int($pos) > int($SNP_end)) {
	    last;
	}
	
	# Sets variables based on the VCF file
	my $refer = $sample1[3];
	my $alt = $sample1[4];
	
	# Makes an array of the first 100 bases, the SNP, and the last 100 bases 
	if ($alt=~/\./) {
	    push @temp, $refer;
	} else {
	    my $snp = "\[$refer\/$alt\]";
	    push @temp, $snp;
	}
	
	# Makes sure the positions are consecutive and no data is missing
	my $compare = $pos - 1;
	if ($prev_pos == $compare) {
	    $is_consecutive = 1;
	} else {
	    
	    # if data is missing, prints an error
	    print "****Error, non consecutive sites. Skipping $chrom:$SNP_start-$SNP_end****\n";
	    print "****Error Previous position: $prev_pos is not consecutive with current position: $pos****\n";
	    $is_consecutive = 0;
	    last;
	}
	$prev_pos = $pos;
    }
    
    # Prints the chromosome, start, end, and sequence
    if ($is_consecutive == 1) {
	print OUTPUT "$chrom\t$SNP_start\t$SNP_end\t";
	for (my $i = 0; $i < $#temp; $i++) {
	    print OUTPUT $temp[$i];
	}
	print OUTPUT "\n";
    }
}

# Sorts the combined output text file by position
if ($windows==1) {
#windows sort equivalent HERE!!!
} else {
    system("sort -k 2,2 -s Master_SNPs.txt > Master_SNPs.sorted.txt");
} #end if
