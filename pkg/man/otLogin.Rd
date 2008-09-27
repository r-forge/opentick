\name{otLogin}
\alias{otLogin}
\title{ Login to opentick servers }
\description{
  Function to login to opentick servers
}
\usage{
otLogin(username = NULL, password = NULL)
}
\arguments{
  \item{username}{ opentick account username }
  \item{password}{ opentick account password }
}
\details{
  If \code{username} and/or \code{password} are not supplied, the user
  will be prompted to enter them on the command line.
}
\value{
  Returns the number one '1' invisibly.\cr
  Modifies \code{.otConnection} in the opentick namespace.
}
%\references{ ~put references to the literature/web site here ~ }
\author{ Josh Ulrich }
%\note{
%~Make other sections like Warning with \section{Warning }{....} ~
%}
\section{Warning}{
  Your account password will not be encrypted as it is sent to
  the opentick server, since the server does not accept encrypted
  passwords.
}
\seealso{ \code{\link{otLogout}}, \code{\link{otConnect}} }
%\examples{
%}
\keyword{ utilities }
