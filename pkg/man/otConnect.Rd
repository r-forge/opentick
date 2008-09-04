\name{otConnect}
\alias{otConnect}
\title{ Connect to opentick servers }
\description{
  Function to establish connection to opentick servers.
}
\usage{
otConnect(host = "delayed1.opentick.com", port = 10015,
  platform = OT$PLATFORM_OT, platformPassword = "", ...)
}
\arguments{
  \item{host}{ Hostname of server to connect to; must align with \code{port} argument. }
  \item{port}{ Port number of server to connect to; must align with \code{host} argument. }
  \item{platform}{ Platform Code. }
  \item{platformPassword}{ Platform Password. }
  \item{\dots}{ Further arguments to connection object (not currently implemented). }
}
\details{
  This function establishes a connection to the opentick servers.
  It connects to both real-time and delayed servers.
}
\value{
  Returns the number one '1' invisibly.\cr
  Creates \code{.otConnection} in the opentick namespace.
}
%\references{ ~put references to the literature/web site here ~ }
\author{ Josh Ulrich }
%\note{ ~~further notes~~ 
 %~Make other sections like Warning with \section{Warning }{....} ~
%}
%\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
%\examples{
%}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ connection }
