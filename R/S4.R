#################################################################################################################################################
##OOP
##genotypeR Related

####################################################################################################
##constructor fxn
#' Class genotypeR.
#'
#' Class \code{genotypeR} defines a gas sensor device.
#'
#' @name genotypeR-class
#' @rdname genotypeR-class
#' @exportClass genotypeR
#' @slot genotypes is a dataframe of genotypes
#' @slot impossible_genotype is a vector
#' @slot binary_genotypes is a dataframe of numeric coded genotypes
#' @slot counted_crossovers is a dataframe of counted crossovers
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
#' @param object is object
#' @param ... is ...
#' @param value is value
#' @docType methods
#' @rdname genotypeR-methods
#' @exportMethod genotypes
setGeneric("genotypes", function(object, ...) standardGeneric("genotypes"))

#' @rdname genotypeR-methods
#' @aliases genotypes, character,ANY-method
setMethod("genotypes", "genotypeR", function(object)object@genotypes)

##impossible genotype
#' Method impossible_genotype.
#' @docType methods
#' @rdname genotypeR-methods
#' @exportMethod impossible_genotype
setGeneric("impossible_genotype", function(object, ...) standardGeneric("impossible_genotype"))

#' @rdname genotypeR-methods
#' @aliases impossible_genotype, character,ANY-method
setMethod("impossible_genotype", "genotypeR", function(object)object@impossible_genotype)

##binary_genotypes
#' Method binary_genotypes.
#' @docType methods
#' @rdname genotypeR-methods
#' @exportMethod binary_genotypes
setGeneric("binary_genotypes", function(object, ...) standardGeneric("binary_genotypes"))

#' @rdname genotypeR-methods
#' @aliases binary_genotypes, character,ANY-method
setMethod("binary_genotypes", "genotypeR", function(object)object@binary_genotypes)

##counted_crossovers
#' Method counted_crossovers.
#' @docType methods
#' @rdname genotypeR-methods
#' @exportMethod counted_crossovers
setGeneric("counted_crossovers", function(object, ...) standardGeneric("counted_crossovers"))

#' @rdname genotypeR-methods
#' @aliases counted_crossovers, character,ANY-method
setMethod("counted_crossovers", "genotypeR", function(object)object@counted_crossovers)
####################################################################################################

####################################################################################################
##replacement
##binary_genotypes
#' Method binary_genotypes<-.
#' @docType methods
#' @rdname genotypeR-methods
#' @exportMethod binary_genotypes<-
setGeneric("binary_genotypes<-",
           function(object, value) standardGeneric("binary_genotypes<-"))

#' @rdname genotypeR-methods
#' @aliases binary_genotypes<-, character,ANY-method
setMethod("binary_genotypes<-", "genotypeR",
          function(object, value) {
              object@binary_genotypes <- value
              ##set Validity method if necessary
              ##if (validObject(object))
                  return(object)
          })

##genotypes
#' Method genotypes<-.
#' @docType methods
#' @rdname genotypeR-methods
#' @exportMethod genotypes<-
setGeneric("genotypes<-",
           function(object, value) standardGeneric("genotypes<-"))

#' @rdname genotypeR-methods
#' @aliases genotypes<-, character,ANY-method
setMethod("genotypes<-", "genotypeR",
          function(object, value) {
              object@genotypes <- value
              ##set Validity method if necessary
              ##if (validObject(object))
                  return(object)
          })

##counted_crossovers
#' Method counted_crossovers<-.
#' @docType methods
#' @rdname genotypeR-methods
#' @exportMethod counted_crossovers<-
setGeneric("counted_crossovers<-",
           function(object, value) standardGeneric("counted_crossovers<-"))

#' @rdname genotypeR-methods
#' @aliases counted_crossovers<-, character,ANY-method
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
#' @docType methods
#' @rdname genotypeR-methods
#' @exportMethod show
setGeneric("show",
           function(object, value) standardGeneric("show"))

#' @rdname genotypeR-methods
#' @aliases show, character,ANY-method
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
