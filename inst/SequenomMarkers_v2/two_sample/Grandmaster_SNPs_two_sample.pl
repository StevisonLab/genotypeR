#! /usr/bin/perl
# Creates master.out file that contain SNPs and 100 base pairs on either side
# Created: May 15, 2017
# Last Updated: May 19, 2017
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
    system("rm -f Master_SNPs.sorted.txt");
} #end if

# Specifies the inputs and outputs
my $input   = "Sample1_SNPs.txt";
my $input2 = "Sample2_SNPs.txt";
my $input3  = $ARGV[1];
my $input4  = $ARGV[0];
my $output  = "Master_SNPs.txt";
my $prev_pos = "";
my $includes_start = 0;

#check command line arguments
unless ($#ARGV==1) {
    print STDERR "Error: Please provide original input VCF filenames for both samples on command line.\n";
    die;
} #end unless

#initialize file contact
open INPUT, $input or die "Could not open file $input: $!\n";
open INPUT2, $input2 or die "Could not open file $input2: $!\n";
open INPUT3, $input3 or die "Could not open file $input3: $!\n";
open INPUT4, $input4 or die "Could not open file $input4: $!\n";
open OUTPUT,  ">> $output" or die $!;

#prints current status 
print STDERR "Program initiated, now extracting genotype sequences for SNPs in \'Sample1_SNPs.txt\' file from original VCF file $input4.\n\n";

# Loops through the text file
while (<INPUT>) {
    
    # Splits the input into an array so specific elements can be referenced
    chomp;
    my @s1snps = split(/\s+/,$_);
    
    # Gets rid of the header
    if ($s1snps[0] eq "Chrom") {
	next;
    } #end if
    
    # Sets variables from the text file
    my $SNP_start = $s1snps[1]/1;
    my $SNP_end = $s1snps[2]/1;
    my $chrom = $s1snps[0];
    my @temp = ();
    my $is_consecutive = 0;
    $prev_pos = $SNP_start;
    $includes_start = 0;
    # Loops through the VCF file
    while (<INPUT4>) {
	
	# Splits the input into an array so specific elements can be referenced
	chomp;
	my @sample1 = split(/\s+/,$_);
	
	# Removes the header
	if ($sample1[0] =~ /^#/) {
	    next;
	} #end if
	
	# Finds the positions in the VCF between the start and end values
	my $pos = $sample1[1]/1;
	if (int($pos) == int($SNP_start) && $sample1[0]=~/^$chrom$/) {
	    $includes_start=1;
	} elsif (int($pos) < int($SNP_start) && $sample1[0]=~/^$chrom$/) {
	    $prev_pos = $pos;
	    next;
	} elsif ($sample1[0]!~/^$chrom$/) {
	    next;
	} elsif (int($pos) > int($SNP_end)) {
	    last;
	} #end if
	
	# Sets variables based on the VCF file
	my $refer = $sample1[3];
	my $alt = $sample1[4];
	
	# Makes an array of the first 100 bases, the SNP, and the last 100 bases 
	if ($alt=~/\./) {
	    push @temp, $refer;
	} else {
	    my $snp = "\[$refer\/$alt\]";
	    push @temp, $snp;
	} #end if
	
	# Makes sure the positions are consecutive and no data is missing
	my $compare = $pos - 1;
	if ($prev_pos == $compare) {
	    $is_consecutive = 1;
	} else {
	    
	    # if data is missing, prints an error; currently turned off, but can be re-enabled by uncommenting next two lines
	    #print "****Error, non consecutive sites. Skipping $chrom:$SNP_start-$SNP_end****\n";
	    #print "****Error Previous position: $prev_pos is not consecutive with current position: $pos****\n";
	    $is_consecutive = 0;
	    last;
	} #end if
	$prev_pos = $pos;
    } #end while loop for VCF file
    
    # Prints the chromosome, start, end, and sequence if sites were consecutive and included Start and End points
    if ($is_consecutive == 1 && $prev_pos==$SNP_end && $includes_start==1) {
	print OUTPUT "$chrom\t$SNP_start\t$SNP_end\t";
	for (my $i = 0; $i < $#temp; $i++) {
	    print OUTPUT $temp[$i];
	} #end for
	print OUTPUT "\n";
	$includes_start=0;
    } #end if
} #end while for BED file

#prints current status 
print STDERR "Program initiated, now extracting genotype sequences for SNPs in \'Sample2_SNPs.txt\' file from original VCF file $input3.\n\n";

#re-initialize varialbes
$prev_pos = "";
$includes_start = 0;

# Loops through the text file
while (<INPUT2>) {
    
    # Splits the input into an array so specific elements can be referenced
    chomp;
    my @s2snps = split(/\s+/,$_);
    
    # Gets rid of the header
    if ($s2snps[0] eq "Chrom") {
	next;
    } #end if
    
    # Sets variables from the text file
    my $SNP_start = $s2snps[1]/1;
    my $SNP_end = $s2snps[2]/1;
    my $chrom = $s2snps[0];
    my @temp = ();
    my $is_consecutive = 0;
    $prev_pos = $SNP_start;
    $includes_start = 0;
    
    # Loops through the VCF file
    while (<INPUT3>) {
	
	# Splits the input into an array so specific elements can be referenced
	chomp;
	my @sample2 = split(/\s+/,$_);
	
	# Removes the header
	if ($sample2[0] =~ /^#/) {
	    next;
	} #end if
	
	# Finds the positions in the VCF between the start and end values
	my $pos = $sample2[1]/1;
	if (int($pos) == int($SNP_start) && $sample2[0]=~/^$chrom$/) {
	    $includes_start=1;
	} elsif (int($pos) < int($SNP_start) && $sample2[0]=~/^$chrom$/) {
	    $prev_pos = $pos;
	    next;
	} elsif ($sample2[0]!~/^$chrom$/) {
	    next;
	} elsif (int($pos) > int($SNP_end)) {
	    last;
	} #end if
	
	# Sets variables based on the VCF file
	my $refer = $sample2[3];
	my $alt = $sample2[4];
	
	# Makes an array of the first 100 bases, the SNP, and the last 100 bases 
	if ($alt=~/\./) {
	    push @temp, $refer;
	} else {
	    my $snp = "\[$refer\/$alt\]";
	    push @temp, $snp;
	} #end if
	
	# Makes sure the positions are consecutive and no data is missing
	my $compare = $pos - 1;
	if ($prev_pos == $compare) {
	    $is_consecutive = 1;
	} else {
	    
	    # if data is missing, prints an error; currently turned off, but can be re-enabled by uncommenting next two lines
	    #print "****Error, non consecutive sites. Skipping $chrom:$SNP_start-$SNP_end****\n";
	    #print "****Error Previous position: $prev_pos is not consecutive with current position: $pos****\n";
	    $is_consecutive = 0;
	    last;
	} #end if
	$prev_pos = $pos;
    } #end while loop for VCF file
    
    # Prints the chromosome, start, end, and sequence if sites were consecutive and included Start and End points
    if ($is_consecutive == 1 && $prev_pos==$SNP_end && $includes_start==1) {
	print OUTPUT "$chrom\t$SNP_start\t$SNP_end\t";
	for (my $i = 0; $i < $#temp; $i++) {
	    print OUTPUT $temp[$i];
	} #end for
	print OUTPUT "\n";
	$includes_start=0;
    } #end if
} #end while for BED file

# Sorts the combined output text file by position
if ($windows==1) {
    print STDERR "I'm sorry, you seem to be on a windows machine\n";
    print STDERR "Looks like you will need to manually sort your output file of SNPs\n";
    print STDERR "Good day!";
} else {
    print STDERR "Finished compiling SNPs, now sorting output using sort_by_chr.sh script...\n\n";
    system("awk \'{print \$1}\' Sample1_SNPs.txt | uniq >chr_list.txt");
    system(".\/sort_by_chr.sh chr_list.txt Master_SNPs.txt Master_SNPs.sorted.txt");
} #end if
