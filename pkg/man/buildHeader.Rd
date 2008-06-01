\name{buildHeader}
\alias{buildHeader}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
buildHeader(commandType, requestID, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{commandType}{ ~~Describe \code{commandType} here~~ }
  \item{requestID}{ ~~Describe \code{requestID} here~~ }
  \item{\dots}{ ~~Describe \code{\dots} here~~ }
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
function(commandType, requestID, ...) {

  # Create Request Message Header
  header <-
    c( packBits(binary(1, 1*8)),            # Message Type
       packBits(binary(1, 1*8)),            # Command Status
       packBits(binary(0, 2*8)),            # Reserved Bytes
       packBits(binary(commandType, 4*8)),  # Command Type
       packBits(binary(requestID, 4*8)) )   # Request ID
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ utilities }
