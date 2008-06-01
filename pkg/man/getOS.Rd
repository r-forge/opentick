\name{getOS}
\alias{getOS}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
getOS()
}
%- maybe also 'usage' for other objects documented here.
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
function() {
  
  os <- OT_OS_UNKNOWN
  osStr <- sessionInfo()$R.version$os

  # This is probably a bug-prone way to determine the OS...
  if( regexpr('.*(nux|nix|osx).*', osStr, TRUE)>0 ) {
    os <- OT_OS_LINUX
  } else if( regexpr('.*XP.*',   osStr)>0 ) {
    os <- OT_OS_WINXP
  } else if( regexpr('.*2000.*', osStr)>0 ) {
    os <- OT_OS_WIN2000
  } else if( regexpr('.*NT.*',   osStr)>0 ) {
    os <- OT_OS_WINNT
  } else if( regexpr('.*Mill.*', osStr)>0 ) {
    os <- OT_OS_WINME
  } else if( regexpr('.*98SE.*', osStr)>0 ) {
    os <- OT_OS_WIN98SE
  } else if( regexpr('.*98.*',   osStr)>0 ) {
    os <- OT_OS_WIN98
  } else if( regexpr('.*95.*',   osStr)>0 ) {
    os <- OT_OS_WIN95
  }
  return(os)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ utilities }
