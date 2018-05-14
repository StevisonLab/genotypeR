# genotypeR

[![DOI](https://zenodo.org/badge/85131181.svg)](https://zenodo.org/badge/latestdoi/85131181)

This contains the development of the genotypeR R package. genotypeR implements a common genotyping workflow with a standardized software interface. genotypeR designs genotyping markers from vcf files, outputs markers for multiplexing suitability on various platforms (Sequenom and Illumina GoldenGate), and provides various QA/QC and analysis functions. This package can be installed from the github repository using devtools. This package will also be avaliable on [CRAN](https://cran.r-project.org/), and can be installed in the usual way.

``` R
devtools::install_git("https://github.com/StevisonLab/genotypeR", build_vignette=TRUE)

```

If it is desirable to only use the [PERL pipeline](https://github.com/StevisonLab/genotypeR/tree/master/inst/SequenomMarkers_v2) without the rest of the R package that is possible as well.

# Citations
Sefick, S.A., M.A. Castronova, and L.S. Stevison. 2017. GENOTYPER: An integrated R packages for single nuleotide polymorphism genotype marker design and data analysis. Methods in Ecology and Evolution 9: 1318-1323. <DOI: 10.1111/2041-210X.12965>

Package developed to analyze:
Stevison LS, SA Sefick, CA Rushton, and RM Graze. 2017. Invited Review: Recombination rate plasticity: revealing mechanisms by design. Philosophical Transactions Royal Society London B Biol Sci 372:1-14. <DOI: 10.1098/rstb.2016.0459>

