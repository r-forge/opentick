\name{otConnect}
\alias{otConnect}
\title{ Connect to opentick servers }
\description{
  Function to establish connection to opentick servers.
}
\usage{
otConnect(host = "delayed1.opentick.com", port = 10015, ...)
}
\arguments{
  \item{host}{ Hostname of server to connect to; must align with \code{port} argument. }
  \item{port}{ Port number of server to connect to; must align with \code{host} argument. }
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
\references{ \url{http://www.opentick.com/dokuwiki/doku.php?id=general:opentick_servers} }
\author{ Josh Ulrich }
\note{
  The available servers are listed below.  Please see the URL in the
  references section for the most current list of servers.\cr
  \tabular{lll}{
  Hostname \tab Real-time port \tab Delayed port\cr
  feed1.opentick.com \tab 10010 \tab NA\cr
  feed2.opentick.com \tab 10010 \tab NA\cr
  delayed1.opentick.com \tab NA \tab 10015\cr
  delayed2.opentick.com \tab NA \tab 10015\cr
  }
  If connecting to a delayed datafeed, all data is delayed 20 minutes.
}
\seealso{ \code{\link{otLogin}}, \code{\link{otLogout}} }
%\examples{
%}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ connection }
