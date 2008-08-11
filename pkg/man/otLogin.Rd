\name{otLogin}
\alias{otLogin}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
otLogin(username = NULL, password = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{username}{ ~~Describe \code{username} here~~ }
  \item{password}{ ~~Describe \code{password} here~~ }
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
function(connection, username=NULL, password=NULL) {

  # Get username and password
  if(is.null(username)) username <- readLines(n=1)
  if(is.null(password)) password <- readLines(n=1)
  
  # Build Request header
  reqHeader <- buildHeader(OT_LOGIN, connection$requestID+1)

  # Construct Message Body
  reqBody <- list()
  reqBody$ver <-     packBits(binary(OT_PROTOCOL_VER, 2*8))
  reqBody$osID <-    packBits(binary(getOS(), 1*8))
  reqBody$platid <-  packBits(binary(OT_PLATFORM_OT, 1*8))
  reqBody$platpwd <- raw(16)
  reqBody$mac <-     raw(6)
  reqBody$user <-    raw(64)
  reqBody$passwd <-  raw(64)
  reqBody$user[1:nchar(username)] <- charToRaw(username)
  reqBody$passwd[1:nchar(password)] <- charToRaw(password)
  reqBody <- unlist(reqBody, use.names=FALSE)

  # Send Request to OT Server
  res <- otRequest(connection, reqHeader, reqBody)

  # Parse Server Response Header
  resHeader <- parseHeader(res$header)
  
  # Need Error Handling
  
  # Parse Server Response Body (unpack will do this)
  resBody <- list()
  resBody$sessionID <-    readBin(res$body[1:64]   , character(), size=64)
  resBody$redirect <-     readBin(res$body[65]     , integer(),   size=1)
  resBody$redirectHost <- readBin(res$body[66:130] , character(), size=64)
  resBody$redirectPort <- readBin(res$body[130:132], integer(),   size=2)

  # Add sessionID and loggedIn value to otConnection Object
  #conObj <- unlist(strsplit(deparse(match.call())," = |,"))
  #conObj <- conObj[grep('connection',conObj)+1]
  #assign(paste(conObj,'$loggedIn',sep=''), TRUE, envir=sys.frame())
  #assign(paste(conObj,'$sessionID',sep=''), resBody$sessionID, envir=sys.frame())
  connection$loggedIn <- TRUE
  connection$sessionID <- resBody$sessionID

  # Redirect?
  if( resBody$redirect ) {
    #assign(paste(conObj,'$host',sep=''), resBody$redirectHost, envir=sys.frame())
    #assign(paste(conObj,'$port',sep=''), resBody$redirectPort, envir=sys.frame())
    connection$host <- resBody$redirectHost
    connection$port <- resBody$redirectPort
  }
  return(connection)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ utilities }
