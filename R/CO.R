
#####################################################################################################
#####################################################################################################
#####################################################################################################
#' Where crossovers occur per individual with 2 ways to deal with
#' missing data
#' 
#' @param indata this is genotype data frame
#' @param naive this takes 2 values: 1) FALSE (default) returns
#' list with COs distributed by marker distance, and 2) TRUE returns a
#' list with COs without regard to marker distance (i.e., at the final
#' non-missing data point in a string of missing gentypes)
#' @keywords count crossovers genotypeR
#' @return list of COs counted per individual
#' @export
#' @examples
#' \dontrun{
#' CO_df <- CO(indata, naive=FALSE)
#' }##subset function
#' 
    CO <- function(indata, naive=FALSE){
        
        ##require(zoo)
        ##set to zero to turn off test
###        test <- 0
        
###        if(test==1){
###            ##test data
###            indata <- data.split[[1]]
###            ##comment out once satisfied
###            ##this is to test the case where 1 is followed by NA TWICE
###            ##works - SAS 20170109
###            ##indata <- c("sample", 0,NA,1,0,NA,1)
###            naive <- FALSE
###        }

        ##removes rubish column

        indata <- grep_df_subset(indata, toMatch = c("SAMPLE_NAME", "WELL"))

##########################################################################################
#interval distances - SAS 20170120
        ##grab_out column names        
        intervals <- data.frame(do.call(rbind, strsplit(names(indata), split="_")))

        ##changed SAS 20170120
        intervals <- intervals[,c(1, length(colnames(intervals))-1, length(intervals))]
        
        colnames(intervals)  <- c("chr", "start", "end")
        intervals$start <- as.numeric(as.character(intervals$start))
        intervals$end <- as.numeric(as.character(intervals$end))
        for_loop_length <- length(intervals[,1])-1
        interval_distances <- vector(length=for_loop_length)
        for(i in 1:for_loop_length){
            interval_distances[i] <- intervals[i+1,"start"]-intervals[i,"end"]
        }
##########################################################################################
        
        ##change to numeric
        indata_num <- as.numeric(indata)
#################################################################
        ##if NA at begining
        if(is.na(indata_num)[1]==TRUE){
            ##set 1st value to 1st non-NA value
            ##this allows the na.locf to work below
            indata_num[1] <- indata_num[grep("TRUE", !is.na(indata_num))[1]]
            
        }
#################################################################    
        ##carry value forward i.e., 1 NA NA 0 == 1 1 1 0
        ##And take the diff (indata_num(i+1)-indata_num(i)
        ##i.e., 1 1 1 0 == 0 0 -1 (diff(c(1,1,1,0))
        diff_geno <- diff(na.locf(indata_num))

        ##change -1 to 1 because it is a crossover
        diff_geno[diff_geno==-1] <- 1
        ##naive output
        diff_geno. <- diff_geno


        ##randomly assign COs to NA runs
        if(naive==FALSE){

            ##test
            runs <- rle(is.na(indata_num))

            ##indices ALL NA runs
            myruns <- which(runs$values == TRUE & runs$lengths >= 1)

######################################################
            ##test if there are any NAs; this needs to be done somewhere!!!
            ##any(myruns)
######################################################

            ##end of runs
            runs.lengths.cumsum <- cumsum(runs$lengths)
            ##indices
            ends <- runs.lengths.cumsum[myruns]

            ##set new index to the previous end
            newindex <- ifelse(myruns>1, myruns-1, 0)
            ##find the previous ending value and then add one for the start
            starts <- runs.lengths.cumsum[newindex] + 1
            ##this corrects the removal of index 1 if it happens
            if (0 %in% newindex) starts = c(1,starts)

            ##remove start and end position
            keep <- ends!=length(indata_num) | starts!=1
            starts <- starts[keep]
            ends <- ends[keep]
            ##starts are always going to be one back
            starts <- starts-1

            ##this finds the index in ends and starts
            ##that have COs counted as 1 in diff_geno
            ##at the end of a NA run
            ends. <- ends[ends%in%grep("1", diff_geno)]
            starts. <- starts[ends%in%grep("1", diff_geno)]

############################################
############################################
############################################
            
            if(length(ends.)>0){

                for(i in 1:length(ends.)){
                    
                    ##i <- 1

                    ##find indices
                    indexes <- starts.[i]:ends.[i]
                    ##assign_1 <- sample(indexes, 1)
                    ##assign_0 <- indexes[indexes!=assign_1]
                    
                    ##assign 1 and 0
                    ##diff_geno[assign_1] <- 1
                    ##diff_geno[assign_0] <- 0
                    ##assign proportional CO to each site
                    ##diff_geno[indexes] <- (1/length(indexes))
                    ##distributed by proportional distance - SAS 20170120
                    diff_geno[indexes] <- interval_distances[indexes]/sum(interval_distances[indexes])
                }
            }
############################################
############################################
############################################
        }
        if(naive==FALSE){
            return(diff_geno)
        }

        if(naive==TRUE){
            return(diff_geno.)
        }
    }
