\name{reqExchangeList}
\alias{reqExchangeList}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
reqExchangeList(connection)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{connection}{ ~~Describe \code{connection} here~~ }
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
function(connection) {

  # Build Request header
  reqHeader <- buildHeader(OT_REQUEST_LIST_EXCHANGES, connection$requestID+1)

  # Construct Message Body
  reqBody <- list()
  reqBody$sessionID <- charToRaw(connection$sessionID)
  reqBody <- unlist(reqBody, use.names=FALSE)

  # Send Request to OT Server
  res <- otRequest(connection, reqHeader, reqBody)

  # Parse Server Response Header
  resHeader <- parseHeader(res$header)
  
  # Need Error Handling
  
  # Parse Server Response Body (unpack will do this)
  resBody <- list()
  resBody$urlLen <-   readBin(res$body[1:2]      , integer(),   size=2)               ;loc <- 2
  resBody$url <-      readBin(res$body[-c(1:loc)], character(), size=resBody$urlLen)  ;loc <- loc + resBody$urlLen
  resBody$rows <-     readBin(res$body[-c(1:loc)], integer(),   size=2)               ;loc <- loc + 2
  results <- data.frame(code=rep(NA,resBody$rows), available=rep(NA,resBody$rows),
                        title=rep(NA,resBody$rows), description=rep(NA,resBody$rows))
  for(i in 1:resBody$rows) {
    results$code[i] <-      readBin(res$body[-c(1:loc)], character(), size=15)              ;loc <- loc + 15
    results$available[i] <- readBin(res$body[-c(1:loc)], integer(),   size=1)               ;loc <- loc + 1
    titleLen <-             readBin(res$body[-c(1:loc)], integer(),   size=2)               ;loc <- loc + 2
    results$title[i] <-     readBin(res$body[-c(1:loc)], character(), size=titleLen);loc <- loc + titleLen
    descLen <-              readBin(res$body[-c(1:loc)], integer(),   size=2)               ;loc <- loc + 2
    results$description[i] <- readBin(res$body[-c(1:loc)], character(), size=descLen) ;loc <- loc + descLen
  }
  #resBody$code <-     readBin(res$body[-c(1:loc)], character(), size=15)              ;loc <- loc + 15
  #resBody$flag <-     readBin(res$body[-c(1:loc)], integer(),   size=1)               ;loc <- loc + 1
  #resBody$titleLen <- readBin(res$body[-c(1:loc)], integer(),   size=2)               ;loc <- loc + 2
  #resBody$title <-    readBin(res$body[-c(1:loc)], character(), size=resBody$titleLen);loc <- loc + resBody$titleLen
  #resBody$descLen <-  readBin(res$body[-c(1:loc)], integer(),   size=2)               ;loc <- loc + 2
  #resBody$desc <-     readBin(res$body[-c(1:loc)], character(), size=resBody$descLen) ;loc <- loc + resBody$descLen

  return(c(resBody,list(results=results)))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ utilities }
