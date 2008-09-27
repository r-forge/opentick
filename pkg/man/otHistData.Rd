\name{otHistData}
\alias{otHistData}
\title{ Historical Price Data }
\description{
  Request historical OHLC and tick price and volume series.
}
\usage{
otHistData(exchange='Q', symbol='MSFT', dates=NULL,
  dataType='day', interval=1)
}
\arguments{
  \item{exchange}{Exchange code.}
  \item{symbol}{Symbol code.}
  \item{dates}{A vector containing start and end dates (order does not matter).}
  \item{dataType}{'raw.tick' = raw ticks\cr
                  'tick' = tick-based OHLC\cr
                  'min' = minutely OHLC\cr
                  'hour' = hourly OHLC\cr
                  'day' = daily OHLC\cr
                  'week' = weekly OHLC\cr
                  'month' = monthly OHLC\cr
                  'year' = yearly OHLC\cr
                  'today' = daily OHL for current day}
  \item{interval}{Interval value, with a default of one.}
}
%\details{
%  ~~ If necessary, more details than the description above ~~
%}
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
%\note{ ~~further notes~~ 
% ~Make other sections like Warning with \section{Warning }{....} ~
%}
\seealso{ \code{\link{otListExchanges}} and \code{\link{otListSymbols}} 
  provide exchange and symbols codes, respectively. }
%\examples{
%}
\keyword{ ts }
