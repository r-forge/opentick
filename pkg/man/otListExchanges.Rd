\name{otListExchanges}
\alias{otListExchanges}
\title{ List opentick exchanges }
\description{
  Function to list all opentick exchanges.
}
\usage{
otListExchanges()
}
%\arguments{
%}
%\details{
%}
\value{
  A data.frame containing the columns below:
  \item{code}{Exchange code}
  \item{available}{Exchange availability flag: 1=available, 2=not available}
  \item{title}{Exchange title}
  \item{description}{Exchange description}
}
\references{
  \url{http://www.opentick.com/dokuwiki/doku.php?id=general:exchange_codes}
}
\author{ Josh Ulrich }
\note{
  The URL in the references section lists available products and
  the exchange codes that are available with them.
}
\seealso{ \code{\link{otListSymbols}} provides symbols codes. }
%\examples{
%}
\keyword{ ts }
