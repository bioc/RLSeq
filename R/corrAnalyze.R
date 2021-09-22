#' Analyze Correlations
#'
#' Finds the pairwise correlation in signal around gold-standard R-Loop sites
#' between the query sample and the RLBase database.
#'
#' @param object An RLRanges object.
#' @return An RLRanges object with correlation results included.
#' @examples
#'
#' # Example RLRanges object
#' rlr <- readRDS(system.file("ext-data", "rlrsmall.rds", package = "RLSeq"))
#'
#' # run corrAnalyze
#' rlr <- corrAnalyze(rlr)
#' @importFrom dplyr %>%
#' @importFrom dplyr .data
#' @export
corrAnalyze <- function(object) {

    # Get genome
    genome <- GenomeInfoDb::genome(object)[1]
    stopifnot(genome == "hg38")

    # Get coverage
    coverage <- object@metadata$coverage
    if (coverage == "" || (!file.exists(coverage) && !urlExists(coverage))) {
        stop(
            "No coverage found. Content of 'coverage' slot: ",
            coverage, ". Set coverage with object@metadata$coverage <-"
        )
    }

    # TODO: This MUST go through RLHub
    rlbase <- "https://rlbase-data.s3.amazonaws.com"
    gsSignalRLBase <- file.path(rlbase, "RLHub", "gsSignalRLBase.rda")
    tmp <- tempfile()
    utils::download.file(gsSignalRLBase, destfile = tmp, quiet = TRUE)
    load(tmp)

    # Get the signal around GS R-loop sites
    bw <- getGSSignal(coverage, gssignal = gsSignalRLBase)

    # Wrangle BW into tibble
    bw <- bw %>%
        as.data.frame() %>%
        dplyr::as_tibble() %>%
        dplyr::rename(chrom = .data$seqnames) %>%
        dplyr::mutate(chrom = as.character(.data$chrom))

    # Get positions
    positions <- gsSignalRLBase %>%
        dplyr::select(.data$location) %>%
        dplyr::mutate(
            chrom = gsub(.data$location,
                pattern = "(.+)_(.+)_(.+)",
                replacement = "\\1"
            ),
            start = gsub(.data$location,
                pattern = "(.+)_(.+)_(.+)",
                replacement = "\\2"
            ),
            end = gsub(.data$location,
                pattern = "(.+)_(.+)_(.+)",
                replacement = "\\3"
            )
        ) %>%
        dplyr::select(-.data$location) %>%
        dplyr::mutate(dplyr::across(c("start", "end"), as.integer))

    # Summarize across gs intervals with valr
    bwMap <- valr::bed_map(x = positions, y = bw, value = sum(.data$score))

    # Combine with the original matrix
    combinedMat <- gsSignalRLBase %>%
        dplyr::inner_join(
            bwMap %>%
                dplyr::mutate(location = paste0(
                    .data$chrom, "_",
                    .data$start, "_",
                    .data$end
                )) %>%
                dplyr::select(.data$location, a_ = .data$value),
            by = "location"
        ) %>%
        dplyr::distinct(.data$location, .keep_all = TRUE)
    combinedMat <- as.data.frame(combinedMat)
    rownames(combinedMat) <- combinedMat$location
    combinedMat <- combinedMat[, -which(colnames(combinedMat) == "location")]
    combinedMat <- as.matrix(combinedMat)

    # Rename column
    colnames(combinedMat)[
        colnames(combinedMat) == "a_"
    ] <- object@metadata$sampleName

    # Find the correlation
    corMat <- stats::cor(combinedMat)

    # Add back to object
    methods::slot(object@metadata$results, "correlationMat") <- corMat

    return(object)
}