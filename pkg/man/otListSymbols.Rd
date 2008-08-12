\name{otListSymbols}
\alias{otListSymbols}
\title{ Historical Price Data }
\description{
  Request historical OHLC and tick price and volume series.
}
\usage{
otListSymbols(exchange)
}
\arguments{
  \item{exchange}{Exchange code.}
}
\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  An xts object containing the columns below:
  \item{Open}{Open price for interval.}
  \item{High}{High price for interval.}
  \item{Low}{Low price for interval.}
  \item{Close}{Close price for interval (not returned for 'today' requests).}
  \item{Volume}{Volume for interval (not returned for 'today' requests).}
}
%\references{ ~put references to the literature/web site here ~ }
\author{ Josh Ulrich }
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ \code{\link{otListExchanges}} provides exchange codes. }
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
}
\keyword{ ts }
