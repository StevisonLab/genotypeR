#################################################################################################################################################
##OOP
##genotypeR Related

####################################################################################################
##constructor fxn
#' Class genotypeR.
#'
#' Class \code{genotypeR} Defines a class and data structure for working with genotyping data.
#'
#' @name genotypeR-class
#' @rdname genotypeR-class
#' @exportClass genotypeR
#' @param object is a genotypeR object
#' @param value is a value
#' @param ... is ...
#' @slot genotypes is a data frame of genotypes
#' @slot impossible_genotype is a vector with Ref/Alt that is the impossible genotype in a back cross design
#' @slot binary_genotypes is a data frame of numeric coded genotypes
#' @slot counted_crossovers is a data frame of counted crossovers
#' @import zoo
#' @import reshape2
#' @import doBy
#' @import plyr
#' @import utils
#' @importFrom methods new
genotypeR <- setClass("genotypeR",
                   slots = c(genotypes = "data.frame",
                             impossible_genotype = "vector",
                             binary_genotypes = "data.frame",
                             counted_crossovers = "data.frame"))
####################################################################################################


####################################################################################################
##accessor functions to the SLOTS!!!
##genotypes
#' Generic genotypes.
#' @rdname genotypeR-class
#' @exportMethod genotypes
setGeneric("genotypes", function(object, ...) standardGeneric("genotypes"))

#' @rdname genotypeR-class
setMethod("genotypes", "genotypeR", function(object)object@genotypes)

##impossible genotype
#' Method impossible_genotype.
#' @rdname genotypeR-class
#' @exportMethod impossible_genotype
setGeneric("impossible_genotype", function(object, ...) standardGeneric("impossible_genotype"))

#' @rdname genotypeR-class
setMethod("impossible_genotype", "genotypeR", function(object)object@impossible_genotype)

##binary_genotypes
#' Method binary_genotypes.
#' @rdname genotypeR-class
#' @exportMethod binary_genotypes
setGeneric("binary_genotypes", function(object, ...) standardGeneric("binary_genotypes"))

#' @rdname genotypeR-class
setMethod("binary_genotypes", "genotypeR", function(object)object@binary_genotypes)

##counted_crossovers
#' Method counted_crossovers.
#' @rdname genotypeR-class
#' @exportMethod counted_crossovers
setGeneric("counted_crossovers", function(object, ...) standardGeneric("counted_crossovers"))

#' @rdname genotypeR-class
setMethod("counted_crossovers", "genotypeR", function(object)object@counted_crossovers)
####################################################################################################

####################################################################################################
##replacement
##binary_genotypes
#' Method binary_genotypes<-.
#' @rdname genotypeR-class
#' @exportMethod binary_genotypes<-
setGeneric("binary_genotypes<-",
           function(object, value) standardGeneric("binary_genotypes<-"))

#' @rdname genotypeR-class
setMethod("binary_genotypes<-", "genotypeR",
          function(object, value) {
              object@binary_genotypes <- value
              ##set Validity method if necessary
              ##if (validObject(object))
                  return(object)
          })

##genotypes
#' Method genotypes<-.
#' @rdname genotypeR-class
#' @exportMethod genotypes<-
setGeneric("genotypes<-",
           function(object, value) standardGeneric("genotypes<-"))

#' @rdname genotypeR-class
setMethod("genotypes<-", "genotypeR",
          function(object, value) {
              object@genotypes <- value
              ##set Validity method if necessary
              ##if (validObject(object))
                  return(object)
          })

##counted_crossovers
#' Method counted_crossovers<-.
#' @rdname genotypeR-class
#' @exportMethod counted_crossovers<-
setGeneric("counted_crossovers<-",
           function(object, value) standardGeneric("counted_crossovers<-"))

#' @rdname genotypeR-class
setMethod("counted_crossovers<-", "genotypeR",
          function(object, value) {
              object@counted_crossovers <- value
              ##set Validity method if necessary
              ##if (validObject(object))
                  return(object)
          })
####################################################################################################

####################################################################################################
##methods
##genotypes
#' Method show.
#' @rdname genotypeR-class
#' @exportMethod show
setGeneric("show",
           function(object, value) standardGeneric("show"))

#' @rdname genotypeR-class
setMethod("show", "genotypeR", function(object, value) {
              cat("An object of class ", class(object), "\n", sep = "")
              cat(" ", length(unique(genotypes(object)$SAMPLE_NAME)), " samples by ",
                  length(unique(genotypes(object)$MARKER)), " markers.\n", sep = "")
              invisible(NULL)
          })

#####################################################################################
##not general enough; maybe bring back later
##subset
##setMethod("[", "genotypeR",
##          function(x,i,j,drop=FALSE) {
##              .genotypes <- genotypes(x)[i, j, drop=drop]
##              .impossible_genotype <- impossible_genotype(x)
##              .binary_genotypes <- binary_genotypes(x)[i, j, drop=drop]
##              crossOvers(genotypes = .genotypes,
##                         impossible_genotype = .impossible_genotype,
##                         binary_genotypes = .binary_genotypes)
##          })
#####################################################################################
