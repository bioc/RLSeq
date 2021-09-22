#' Run RLSeq
#'
#' Runs the full RLSeq pipeline.
#'
#' @param object An RLRanges object.
#' @param quiet If TRUE, messages are suppressed. Default: FALSE.
#' @return An RLRanges object with all results available.
#' @examples
#'
#' # Example RLRanges
#' rlr <- readRDS(system.file("ext-data", "rlrsmall.rds", package = "RLSeq"))
#'
#' # Run RLSeq
#' rlr <- RLSeq(rlr)
#' 
#' @export
RLSeq <- function(object, quiet = FALSE) {
    if (!quiet) message("[1/6] RLFS Perm Test")
    object <- analyzeRLFS(object, quiet = TRUE)

    if (!quiet) message("[2/6] Predict Condition")
    object <- predictCondition(object)

    if (!quiet) message("[3/6] Feature Enrichment Test")
    if (GenomeInfoDb::genome(object)[1] %in% c("hg38", "mm10")) {
        object <- featureEnrich(object, quiet = TRUE)
    } else {
        warning(
            "RLSeq only contains built-in annotations for 'hg38' and 'mm10'",
            " genomes. Please lift-over or run featureEnrich() separately ",
            "with custom annotations. Skipping."
        )
        Sys.sleep(2)
    }


    if (!quiet) message("[4/6] Correlation Analysis")
    if (object@metadata$coverage != "") {
        if (GenomeInfoDb::genome(object)[1] == "hg38") {
            object <- corrAnalyze(object)
        } else {
            warning(
                "Only 'hg38' genome ranges are available",
                " for correlation analysis. Skipping."
            )
            Sys.sleep(2)
        }
    } else {
        message("No coverage provided... skipping.")
        corrRes <- NA
    }

    if (!quiet) message("[5/6] Gene Annotation")
    object <- geneAnnotation(object, quiet = TRUE)

    if (!quiet) message("[6/6] R-loop Region Analysis")
    if (GenomeInfoDb::genome(object)[1] == "hg38") {
        object <- rlRegionTest(object)
    } else {
        warning(
            "Only 'hg38' genome ranges",
            " are available for RL-region analysis. Skipping."
        )
        Sys.sleep(1)
    }

    return(object)
}