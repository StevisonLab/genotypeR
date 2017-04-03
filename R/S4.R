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
crossOveRs <- setClass("genotypeR",
                   slots = c(genotypes = "data.frame",
                             impossible_genotype = "vector",
                             binary_genotypes = "data.frame",
                             counted_crossovers = "data.frame"))
####################################################################################################


####################################################################################################
##accessor functions to the SLOTS!!!
##genotypes
#' Method genotypes.
#' @name genotypes
#' @rdname genotypeR-methods
#' @exportMethod genotypes
setGeneric("genotypes", function(object, ...) standardGeneric("genotypes"))
setMethod("genotypes", "genotypeR", function(object)object@genotypes)

##impossible genotype
#' Method impossible_genotypes.
#' @name impossible_genotypes
#' @rdname genotypeR-methods
#' @exportMethod impossible_genotypes
setGeneric("impossible_genotype", function(object, ...) standardGeneric("impossible_genotype"))
setMethod("impossible_genotype", "genotypeR", function(object)object@impossible_genotype)

##binary_genotypes
#' Method binary_genotypes.
#' @name genotypeR-class
#' @rdname genotypeR-class
#' @exportMethod binary_genotypes
setGeneric("binary_genotypes", function(object, ...) standardGeneric("binary_genotypes"))
setMethod("binary_genotypes", "genotypeR", function(object)object@binary_genotypes)

##counted_crossovers
#' Method counted_crossovers.
#' @name counted_crossovers
#' @rdname genotypeR-methods
#' @exportMethod counted_crossovers
setGeneric("counted_crossovers", function(object, ...) standardGeneric("counted_crossovers"))
setMethod("counted_crossovers", "genotypeR", function(object)object@counted_crossovers)
####################################################################################################

####################################################################################################
##replacement
##binary_genotypes
#' Method binary_genotypes<-.
#' @name binary_genotypes<-
#' @rdname genotypeR-methods
#' @exportMethod binary_genotypes<-
setGeneric("binary_genotypes<-",
           function(object, value) standardGeneric("binary_genotypes<-"))

setMethod("binary_genotypes<-", "genotypeR",
          function(object, value) {
              object@binary_genotypes <- value
              ##set Validity method if necessary
              ##if (validObject(object))
                  return(object)
          })

##genotypes
#' Method genotypes<-.
#' @name genotypes<-
#' @rdname genotypeR-methods
#' @exportMethod genotypes<-
setGeneric("genotypes<-",
           function(object, value) standardGeneric("genotypes<-"))

setMethod("genotypes<-", "genotypeR",
          function(object, value) {
              object@genotypes <- value
              ##set Validity method if necessary
              ##if (validObject(object))
                  return(object)
          })

##counted_crossovers
#' Method counted_crossovers<-.
#' @name counted_crossovers<-
#' @rdname genotypeR-methods
#' @exportMethod counted_crossovers<-
setGeneric("counted_crossovers<-",
           function(object, value) standardGeneric("counted_crossovers<-"))

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
#' @name show
#' @rdname genotypeR-methods
#' @exportMethod show
setMethod("show",
          signature = "genotypeR",
          definition = function(object) {
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
