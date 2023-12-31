% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllClasses.R
\docType{class}
\name{RLRanges-class}
\alias{RLRanges-class}
\alias{RLRanges}
\title{Construct RLRanges Dataset}
\usage{
RLRanges(
  peaks = GenomicRanges::GRanges(),
  coverage = character(1),
  genome = character(1),
  mode = character(1),
  label = character(1),
  sampleName = "User-selected sample",
  qcol = NULL
)
}
\arguments{
\item{peaks}{Path/URL to peak file or a GRanges object. This file should be
in "broadPeak" format if possible. If not, then \code{qcol} should be specified.}

\item{coverage}{Path/URL to the coresponding coverage file
(in "bigWig" format). If not supplied, correlation tests will be skipped.}

\item{genome}{UCSC genome ID. Acceptable types are listed in
\link{auxdata} (\code{available_genomes} entry).}

\item{mode}{Type of R-loop mapping from which peaks and coverage were
derived. Acceptable types are listed in
\link{auxdata} (\code{available_modes} entry). Can be unspecified.}

\item{label}{"POS" (positive R-loop-mapping sample; e.g., DRIP-Seq S9.6 -RNH1)
or "NEG" (negative control sample; e.g., DRIP-Seq S9.6 +RNH1 or Input).
Can be unspecified.}

\item{sampleName}{A unique name for identifying this sample.
Can be unspecified.}

\item{qcol}{The name of the metadata column which contains the score or
significance of each peak. For broadPeak (preferred), this is the
qvalue (column 11 after accounting for extra columns created during
peakset building).
If not specified, the last column will be chosen by default. \strong{NOTE}:
if supplying narrowPeak form peaks, the last column will NOT be appropriate
and QCol should be specified as \code{11}.
If FALSE or if no metadata columns exist, it will be left blank and some
operations in \code{report()} will not fully run.}
}
\value{
An object of class \code{RLRanges}. These objects are an extension of
\code{GRanges} with the addition of sample metadata entries and \link{RLResults}.
}
\description{
\code{RLRanges} is a subclass of \code{GRanges}, which stores R-loop peaks
and metadata about the R-loop-mapping experiment, along with results from
the analyses in \link{RLSeq}.
}
\examples{

# Example dataset
rlbase <- "https://rlbase-data.s3.amazonaws.com"
cvg <- file.path(rlbase, "coverage", "SRX7671349_hg38.bw")
pks <- system.file("extdata", "SRX7671349_hg38.broadPeak", package = "RLSeq")

# Get RLRanges object
rlr <- RLRanges(pks,
    coverage = cvg, genome = "hg38", label = "NEG",
    mode = "RDIP", sampleName = "RDIP-Seq +RNH1", qcol = 9
)

}
