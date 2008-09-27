\name{otListSymbols}
\alias{otListSymbols}
\title{ List opentick symbols }
\description{
  Function to list all opentick symbols for a given exchange.
}
\usage{
otListSymbols(exchange)
}
\arguments{
  \item{exchange}{ Exchange code }
}
%\details{
%}
\value{
  A data.frame containing the columns below:
  \item{cyrrencyID}{The currency the symbol is denominated in}
  \item{symbolCode}{The code for the symbol}
  \item{type}{Instrument Type: 1=Equity, 2=Index, 3=Option, 4=Future}
  \item{company}{The company name}
}
\references{
  \url{http://www.opentick.com/dokuwiki/doku.php?id=general:symbol_formats}
  \url{http://www.opentick.com/dokuwiki/doku.php?id=general:common_symbols}
  \url{http://www.opentick.com/index.php?app=search&event=symbols}
}
\author{ Josh Ulrich }
\note{
  The URL in below lists all the available products and
  the exchange codes that are available with them.\cr
  \url{http://www.opentick.com/dokuwiki/doku.php?id=general:exchange_codes}
}
\seealso{ \code{\link{otListExchanges}} provides exchange codes. }
%\examples{
%}
\keyword{ ts }
