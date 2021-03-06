% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wubrg_order.R
\name{wubrg_order}
\alias{wubrg_order}
\title{Convert MTG color names into ordered factor}
\usage{
wubrg_order(label_chr)
}
\arguments{
\item{label_chr}{vector of characters that can contain the values
"White", "Blue", "Black", "Red", "Green", "Multicolored", or "Colorless".
The main source is \code{\link{relabel_mtg_color}}.}
}
\value{
vector of ordered factors with the same length and labels as
\code{label_chr}
}
\description{
Turn the outputs of \code{\link{relabel_mtg_color}} into an
ordered factor (WUBRG order, then "Multicolored", followed by "Colorless").
Converting strings into ordered factors is useful for having plot outputs
display in a useful order.
}
\examples{
wubrg_order(c("Blue", "Green", "Black"))

}
\seealso{
\code{\link{relabel_mtg_color}} for the main source of inputs to
this function
}
\concept{manipulate}
