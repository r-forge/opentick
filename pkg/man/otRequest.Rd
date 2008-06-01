\name{otRequest}
\alias{otRequest}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
otRequest(connection, messageHeader, messageBody)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{connection}{ ~~Describe \code{connection} here~~ }
  \item{messageHeader}{ ~~Describe \code{messageHeader} here~~ }
  \item{messageBody}{ ~~Describe \code{messageBody} here~~ }
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
function(connection, messageHeader, messageBody) {

  # Construct Client Request
  reqLen <- packBits(binary(NROW(c(messageHeader,messageBody)),4*8))
  writeBin(c(reqLen,messageHeader,messageBody), connection$connection)

  # Retrieve Server Response
  resLen <- readBin(connection$connection, integer(), size=4)
  message <- readBin(connection$connection, raw(), resLen)

  # Parse Server Response
  header <- readBin(message, raw(), 12)
  body <- readBin(message[13:resLen], raw(), resLen-12)

  return(list(length=resLen,header=header,body=body))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ utilities }
