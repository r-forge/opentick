\name{otConnect}
\alias{otConnect}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
otConnect(host = "delayed1.opentick.com", port = 10015, login = FALSE,
  open = TRUE, platform = OT$PLATFORM_OT, platformPassword = "", ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{host}{ ~~Describe \code{host} here~~ }
  \item{port}{ ~~Describe \code{port} here~~ }
  \item{login}{ ~~Describe \code{login} here~~ }
  \item{open}{ ~~Describe \code{open} here~~ }
  \item{platform}{ ~~Describe \code{platform} here~~ }
  \item{platformPassword}{ ~~Describe \code{platformPassword} here~~ }
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
function(host='delayed1.opentick.com', port=10015,
         login=FALSE, open=TRUE,
         platform=OT_PLATFORM_OT, platformPassword='', ...) {

  # Add capability for connection to contain multiple hosts.  Then you can
  # try the other hosts if one fails.
  
  # Open connection
  con <- socketConnection(host[1], port, open='r+b', blocking=TRUE)

  if(login) {
    stop('This feature not currently implemented')
  } else {
    username <- ''
    password <- ''
    requestID <- 0
  }
  
  # Return connection object
  structure(list(connection=con,
                 host=host,
                 port=port,
                 platform=platform,
                 platformPassword=platformPassword,
                 username=username,
                 password=password,
                 loggedIn=login,
                 requestID=requestID),
            class=c('otConnection'))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ utilities }
