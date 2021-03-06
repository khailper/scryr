% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/label_tri.R
\name{label_tri}
\alias{label_tri}
\title{Assign shard and/or wedge based on color/color identity}
\usage{
label_tri(color_code, inclusive = FALSE, shard_or_wedge = c("either",
  "shard", "wedge"), convert_to_list = FALSE)
}
\arguments{
\item{color_code}{vector of characters of the card's color/color identity,
using WUBRG notation. Letters must be capital and in alphabetic order. If
using with \code{link{[dplyr]mutate}}, \code{link{[purrr]map_chr}}, and
the results of \code{link{scry_cards}}, use the \code{colors} or
\code{color_identity} column. See\code{vingette("using_label_functions")}.}

\item{inclusive}{if \code{color_code} is just one color, should
\code{label_tri} return all groups that contain that color?}

\item{shard_or_wedge}{Should \code{label_tri} match based on shards and
wedges ("either"), just shards ("shard"), or just wedges ("wedge")?}

\item{convert_to_list}{Should \code{label_tri} a list instead of a vector?
Useful if you're planning on using functions like \code{link[tidyr]unnest}.}
}
\value{
a vector of strings with all group(s) matching the \code{color_code}
}
\description{
Given a card's color (or color identity), return the Alara
and/or Tarkir wedge assoicated with the card. By default, \code{label_tri}
requires the card to be both all the group's colors, but if
\code{inclusive = TRUE}, cards with less than three colors are labeled with
all groups they could belong to.
}
\section{Note}{

cards with hybrid costs are treated
as belonging to both colors, as though they were gold cards.
}

\section{Warning}{

If you're using \code{label_tri} inside
\code{\link{[dplyr]mutate}}, you'll need to pair it with
\code{\link{[purrr]map}}. See\code{vingette("using_label_functions")}.
}

\examples{
label_tri(c("B", "U", "W"))
label_tri(c("B", "U", "W"), shard_or_wedge = "shard")
label_tri(c("B", "U", "W"), shard_or_wedge = "wedge")
label_tri("U")
label_tri("U", inclusive = TRUE)
}
\seealso{
\code{\link{label_guild}}
}
\concept{manipulate}
