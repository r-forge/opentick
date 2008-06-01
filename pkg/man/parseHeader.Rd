\name{parseHeader}
\alias{parseHeader}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
parseHeader(header)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{header}{ ~~Describe \code{header} here~~ }
}
\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  ~Describe the value returned
  If it is a LIST, use
  \item{comp1 }{Description of 'comp1'}
  \item{comp2 }{Description of 'comp2'}
  ...
}
\references{ ~put references to the literature/web site here ~ }
\author{ ~~who you are~~ }
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function(header) {

  # Parse Server Response Header
  header <- list(
    messageType   = readBin(header[1]   , integer(), size=1),
    commandStatus = readBin(header[2]   , integer(), size=1),
    reserved      = readBin(header[3:4] , integer(), size=2),
    commandType   = readBin(header[5:8] , integer(), size=4),
    requestID     = readBin(header[9:12], integer(), size=4) )

  return(header)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ utilities }
