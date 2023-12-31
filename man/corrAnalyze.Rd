% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/corrAnalyze.R
\name{corrAnalyze}
\alias{corrAnalyze}
\title{Analyze Correlations}
\usage{
corrAnalyze(object, force = FALSE)
}
\arguments{
\item{object}{An RLRanges object.}

\item{force}{Force \code{corrAnalyze} to run, even if on Windows. Default: FALSE.}
}
\value{
An RLRanges object with correlation results included as a \code{matrix}.
The correlation matrix is accessed via
\code{rlresults(object, "correlationMat")}.
}
\description{
Finds the pairwise correlation in signal around gold-standard R-Loop sites
between the query sample and the coverage tracks in the
\href{https://gccri.bishop-lab.uthscsa.edu/rlbase/}{RLBase} database.
See \emph{details}.
}
\details{
Currently, this does not work on windows.
\subsection{Method}{

The \code{corrAnalyze} function performs a correlation test that can
be used to assess sample-sample similarity by calculating coverage signal
(from genomic alignments) around “gold standard”
R-loop sites (PMID: \href{https://pubmed.ncbi.nlm.nih.gov/33411340/}{33411340}).
The resulting correlation matrix is useful for determining how well a
supplied sample correlates with previously-published datasets.

During the
\href{https://github.com/Bishop-Laboratory/RLBase-data}{RLBase-data workflow},
the signal for each R-loop mapping sample
within “gold standard” R-loop sites was calculated see \link[RLHub:gs_signal]{RLHub::gs_signal}.

The \code{corrAnalyze} function loads \link[RLHub:gs_signal]{RLHub::gs_signal} and accepts an \link{RLRanges}
object with a valid coverage slot. It then does the following:
\enumerate{
\item The coverage is quantified within the “gold standard”
sites and added as a column to the signal matrix from \link[RLHub:gs_signal]{RLHub::gs_signal}.
\item Then, the \link[stats:cor]{stats::cor} function is used to calculate the Pearson
correlation pairwise between all samples, yielding a correlation matrix
\item Finally, the correlation matrix is stashed in the in the
\code{correlationMat} slot of the \link{RLResults} and returned.
}
}
}
\examples{

# Example RLRanges object
rlr <- readRDS(system.file("extdata", "rlrsmall.rds", package = "RLSeq"))

# corrAnalyze does not work on Windows OS
if (.Platform$OS.type != "windows") {

    # run corrAnalyze
    rlr <- corrAnalyze(rlr)
}
}
