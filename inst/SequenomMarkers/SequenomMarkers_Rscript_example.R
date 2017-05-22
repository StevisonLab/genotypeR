#!/usr/bin/env Rscript

library(genotypeR)

example_files <- system.file("SequenomMarkers", package = "genotypeR")

vcf1 <- paste(example_files, "FS14_test.vcf", sep="/")
vcf2 <- paste(example_files, "FS16_test.vcf", sep="/")
outdir <- paste(example_files, "test_dir", sep="/")

SequenomMarkers(vcf1, vcf2, outdir)
