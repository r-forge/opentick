\name{binary}
\alias{binary}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
binary(x, dim)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{ ~~Describe \code{x} here~~ }
  \item{dim}{ ~~Describe \code{dim} here~~ }
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
function(x, dim) {

  pos <- ifelse( x==0, 1, floor(log(x,2))+1 )
  
  if(!missing(dim)) {
    if(pos<=dim) {
      pos <- dim
    } else {
      warning("the value of `dim` is too small")
    }  
  }

  bin <- rep(0, pos)
  dicotomy <- rep(FALSE, pos)
  for (i in pos:1) {
    bin[i] <- floor(x/2^(i-1))
    dicotomy[i] <- bin[i]==1
    x <- x-((2^(i-1))*bin[i])
  }
  return(as.integer(bin))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ utilities }
